/* SPDX-License-Identifier: GPL-2.0 */

#include <assert.h>
#include <errno.h>
#include <getopt.h>
#include <locale.h>
#include <poll.h>
#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
 #include <stdio.h>
#include "lxdpFlow.h"

#include <sys/resource.h>

#include <bpf/bpf.h>
#include <bpf/xsk.h>

#include <arpa/inet.h>
#include <net/if.h>
#include <linux/if_link.h>
#include <linux/if_ether.h>
#include <linux/ipv6.h>
#include <linux/icmpv6.h>


#include "common/common_user_bpf_xdp.h"


#define NUM_FRAMES         4096
#define FRAME_SIZE         XSK_UMEM__DEFAULT_FRAME_SIZE
#define RX_BATCH_SIZE      64
#define INVALID_UMEM_FRAME UINT64_MAX

uint8_t stop_capture=0;

#define NANOSEC_PER_SEC 1000000000 /* 10^9 */

struct timespec gettime2(void)
{
	struct timespec t;
	int res;

	res = clock_gettime(CLOCK_REALTIME, &t);
	if (res < 0) {
		fprintf(stderr, "Error with gettimeofday! (%i)\n", res);
		exit(EXIT_FAIL);
	}
        printf("Timespec: %lu %lu\n",t.tv_sec,t.tv_nsec);
	return t;
}


static inline __u32 xsk_ring_prod__free(struct xsk_ring_prod *r)
{
	r->cached_cons = *r->consumer + r->size;
	return r->cached_cons - r->cached_prod;
}


static struct xsk_umem_info *configure_xsk_umem(void *buffer, uint64_t size)
{
	struct xsk_umem_info *umem;
	int ret;

	umem = calloc(1, sizeof(*umem));
	if (!umem)
		return NULL;

	ret = xsk_umem__create(&umem->umem, buffer, size, &umem->fq, &umem->cq,
			       NULL);
	if (ret) {
		errno = -ret;
		return NULL;
	}

	umem->buffer = buffer;
	return umem;
}

static uint64_t xsk_alloc_umem_frame(struct xsk_socket_info *xsk)
{
	uint64_t frame;
	if (xsk->umem_frame_free == 0)
		return INVALID_UMEM_FRAME;

	frame = xsk->umem_frame_addr[--xsk->umem_frame_free];
	xsk->umem_frame_addr[xsk->umem_frame_free] = INVALID_UMEM_FRAME;
	return frame;
}

static void xsk_free_umem_frame(struct xsk_socket_info *xsk, uint64_t frame)
{
	assert(xsk->umem_frame_free < NUM_FRAMES);

	xsk->umem_frame_addr[xsk->umem_frame_free++] = frame;
}

static uint64_t xsk_umem_free_frames(struct xsk_socket_info *xsk)
{
	return xsk->umem_frame_free;
}

static struct xsk_socket_info *xsk_configure_socket(struct config *cfg,
						    struct xsk_umem_info *umem)
{
	struct xsk_socket_config xsk_cfg;
	struct xsk_socket_info *xsk_info;
	uint32_t idx;
	uint32_t prog_id = 0;
	int i;
	int ret;

	xsk_info = calloc(1, sizeof(*xsk_info));
	if (!xsk_info)
		return NULL;

	xsk_info->umem = umem;
	xsk_cfg.rx_size = XSK_RING_CONS__DEFAULT_NUM_DESCS;
	xsk_cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
	xsk_cfg.libbpf_flags = 0;
	xsk_cfg.xdp_flags = cfg->xdp_flags;
	xsk_cfg.bind_flags = cfg->xsk_bind_flags;
	ret = xsk_socket__create(&xsk_info->xsk, cfg->ifname,
				 cfg->xsk_if_queue, umem->umem, &xsk_info->rx,
				 &xsk_info->tx, &xsk_cfg);

	if (ret)
		goto error_exit;

	ret = bpf_get_link_xdp_id(cfg->ifindex, &prog_id, cfg->xdp_flags);
	if (ret)
		goto error_exit;

	/* Initialize umem frame allocation */

	for (i = 0; i < NUM_FRAMES; i++)
		xsk_info->umem_frame_addr[i] = i * FRAME_SIZE;

	xsk_info->umem_frame_free = NUM_FRAMES;

	/* Stuff the receive path with buffers, we assume we have enough */
	ret = xsk_ring_prod__reserve(&xsk_info->umem->fq,
				     XSK_RING_PROD__DEFAULT_NUM_DESCS,
				     &idx);

	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
		goto error_exit;

	for (i = 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS; i ++)
		*xsk_ring_prod__fill_addr(&xsk_info->umem->fq, idx++) =
			xsk_alloc_umem_frame(xsk_info);

	xsk_ring_prod__submit(&xsk_info->umem->fq,
			      XSK_RING_PROD__DEFAULT_NUM_DESCS);

	return xsk_info;

error_exit:
	errno = -ret;
	return NULL;
}

static int handle_receive_packets(struct xsk_socket_info *xsk,packet_processor fn,void *aux_data)
{
	unsigned int rcvd=0, stock_frames, i;
	uint32_t idx_rx = 0, idx_fq = 0;
	int ret;
	
	rcvd = xsk_ring_cons__peek(&xsk->rx, RX_BATCH_SIZE, &idx_rx);
	
	if (!rcvd)
		return 0;
	
	/* Stuff the ring with as much frames as possible */
	stock_frames = xsk_prod_nb_free(&xsk->umem->fq,
					xsk_umem_free_frames(xsk));

	if (stock_frames > 0) {

		ret = xsk_ring_prod__reserve(&xsk->umem->fq, stock_frames,
					     &idx_fq);

		// This should not happen, but just in case 
		while (ret != stock_frames)
			ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd,&idx_fq);

		for (i = 0; i < stock_frames; i++)
			*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) =
				xsk_alloc_umem_frame(xsk);

		xsk_ring_prod__submit(&xsk->umem->fq, stock_frames);
	}

	/* Process received packets */
	for (i = 0; i < rcvd; i++) {
		uint64_t addr = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx)->addr;
		uint32_t len = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx++)->len;

		uint8_t *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);
		struct timespec t=gettime2();
		struct pkt_info h;
		h.len=len;
		h.caplen=len;
		h.ts.tv_sec=t.tv_sec;
		h.ts.tv_usec=t.tv_nsec/1000;
		fn(pkt,&h,aux_data);
		xsk_free_umem_frame(xsk, addr);
		

		
	}

	xsk_ring_cons__release(&xsk->rx, rcvd);

	return 1;
  }




void rx_and_process(bool poll_mode,
			   struct xsk_socket_info *xsk_socket,int ntimeouts,int timeout,packet_processor fn,void *aux_data)
{
	struct pollfd fds[2];
	int ret, nfds = 1;
	int i=0;
	memset(fds, 0, sizeof(fds));
	fds[0].fd = xsk_socket__fd(xsk_socket->xsk);
	fds[0].events = POLLIN;
	stop_capture=1;
	while((i<ntimeouts)&&(stop_capture==1)) {
		if (poll_mode==true) {
			ret = poll(fds, nfds, timeout);
			if (ret <= 0 || ret > 1){
				i+=1;
				continue;
			}
			else{
				i=0;
			}
		}
		ret= handle_receive_packets(xsk_socket,fn,aux_data);

	}
}

void stop_rx_and_process(){
	stop_capture=0;
}

int unload_bpf_xdp_program(struct config cfg){
	
	return xdp_link_detach(cfg.ifindex, cfg.xdp_flags, 0);

}

int load_bpf_xdp_program(struct config cfg)
{
	struct bpf_object *bpf_obj = NULL;
	int xsks_map_fd;
	/* Load custom program if configured */
	if(cfg.filename[0]!=0){
		struct bpf_map *map;
		bpf_obj = load_bpf_and_xdp_attach(&cfg);
		if (!bpf_obj) {
			fprintf(stderr, "ERROR: loading BPD prog %s: %s\n",
				cfg.filename,strerror(errno));
			return -1;
		}

		/* We also need to load the xsks_map */
		map = bpf_object__find_map_by_name(bpf_obj, "xsks_map");
		xsks_map_fd = bpf_map__fd(map);
		if (xsks_map_fd < 0) {
			fprintf(stderr, "ERROR: no xsks map found: %s\n",
				strerror(xsks_map_fd));
			return -1;
		}
	}
	return 0;
}

struct xsk_socket_info *create_init_xdp_sock(struct config cfg,struct xsk_umem_info **umem, char *bpf_program_path)
{
	
	
	struct xsk_socket_info *xsk_socket;
	struct rlimit rlim = {RLIM_INFINITY, RLIM_INFINITY};
	void *packet_buffer;
	uint64_t packet_buffer_size;
	

	if(bpf_program_path!=NULL){
		strcpy(cfg.filename,bpf_program_path);
		if(load_bpf_xdp_program(cfg)!=0)
		{
			fprintf(stderr, "ERROR: Can't load BPF program \"%s\"\n",
			strerror(errno));
			exit(EXIT_FAILURE);
		}

	}
	

	/* Allow unlimited locking of memory, so all memory needed for packet
	 * buffers can be locked.
	 */
	if (setrlimit(RLIMIT_MEMLOCK, &rlim)) {
		fprintf(stderr, "ERROR: setrlimit(RLIMIT_MEMLOCK) \"%s\"\n",
			strerror(errno));
		exit(EXIT_FAILURE);
	}

	/* Allocate memory for NUM_FRAMES of the default XDP frame size */
	packet_buffer_size = NUM_FRAMES * FRAME_SIZE;
	if (posix_memalign(&packet_buffer,
			   getpagesize(), /* PAGE_SIZE aligned */
			   packet_buffer_size)) {
		fprintf(stderr, "ERROR: Can't allocate buffer memory \"%s\"\n",
			strerror(errno));
		exit(EXIT_FAILURE);
	}
	bzero(packet_buffer,packet_buffer_size);
	/* Initialize shared packet_buffer for umem usage */
	*umem = configure_xsk_umem(packet_buffer, packet_buffer_size);
	if (*umem == NULL) {
		fprintf(stderr, "ERROR: Can't create umem \"%s\"\n",
			strerror(errno));
		exit(EXIT_FAILURE);
	}

	/* Open and configure the AF_XDP (xsk) socket */
	xsk_socket = xsk_configure_socket(&cfg, *umem);
	if (xsk_socket == NULL) {
		fprintf(stderr, "ERROR: Can't setup AF_XDP socket \"%s\"\n",
			strerror(errno));
		exit(EXIT_FAILURE);
	}
		
	return xsk_socket;

}


void close_xdp_sock(struct xsk_socket_info *xsk_socket,struct config cfg,struct xsk_umem_info *umem){
	/* Cleanup */
	xsk_socket__delete(xsk_socket->xsk);
	xsk_umem__delete(umem->umem);
	unload_bpf_xdp_program(cfg);

	xdp_link_detach(cfg.ifindex, cfg.xdp_flags, 0);
	if(xsk_socket)
		free(xsk_socket);
	if(umem)
		free(umem);
	
}





