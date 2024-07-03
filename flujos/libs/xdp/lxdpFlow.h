/* SPDX-License-Identifier: GPL-2.0 */
#ifndef LXDPFLOW__H
#define LXDPFLOW__H

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
#include "common/common_defines.h"


#define NUM_FRAMES         4096
#define FRAME_SIZE         XSK_UMEM__DEFAULT_FRAME_SIZE
#define RX_BATCH_SIZE      64
#define INVALID_UMEM_FRAME UINT64_MAX




struct pkt_info {
	struct timeval ts;
	uint32_t caplen;
	uint32_t len;
};
typedef void (*packet_processor)(uint8_t * pkt,struct pkt_info *h,void *aux_data);

struct xsk_umem_info {
	struct xsk_ring_prod fq;
	struct xsk_ring_cons cq;
	struct xsk_umem *umem;
	void *buffer;
};



struct xsk_socket_info {
	struct xsk_ring_cons rx;
	struct xsk_ring_prod tx;
	struct xsk_umem_info *umem;
	struct xsk_socket *xsk;

	uint64_t umem_frame_addr[NUM_FRAMES];
	uint32_t umem_frame_free;

	uint32_t outstanding_tx;


};

void stop_rx_and_process();
struct timespec gettime2(void);
void rx_and_process(bool poll_mode,
struct xsk_socket_info *xsk_socket,int ntimeouts,int timeout,packet_processor fn,void *aux_data);
void close_xdp_sock(struct xsk_socket_info *xsk_socket,struct config cfg,struct xsk_umem_info *umem);
struct xsk_socket_info *create_init_xdp_sock(struct config cfg,struct xsk_umem_info **umem, char *bpf_program_path);
int unload_xdp_program(struct config cfg);
int load_bpf_xdp_program(struct config cfg);
#endif
