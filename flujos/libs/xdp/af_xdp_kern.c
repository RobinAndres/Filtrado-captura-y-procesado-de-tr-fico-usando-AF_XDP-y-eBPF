/* SPDX-License-Identifier: GPL-2.0 */

#include <linux/bpf.h>

#include <bpf/bpf_helpers.h>
#include <bpf/bpf_endian.h>

#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/in.h>
#include <linux/udp.h>



struct bpf_map_def SEC("maps") xsks_map = {
	.type = BPF_MAP_TYPE_XSKMAP,
	.key_size = sizeof(int),
	.value_size = sizeof(int),
	.max_entries = 64,  /* Assume netdev has no more than 64 queues */
};

struct bpf_map_def SEC("maps") xdp_stats_map = {
	.type        = BPF_MAP_TYPE_PERCPU_ARRAY,
	.key_size    = sizeof(int),
	.value_size  = sizeof(__u32),
	.max_entries = 64,
};


struct hdr_cursor {
	void *pos;
};


struct pktgen_hdr {
        /*@{*/
        __be32 pgh_magic; /**< Identificador de la cabecera de los paquetes pktgen*/
        __be32 seq_num;/**< Número de secuencia del paquete pktgen*/
        __be32 tv_sec;/**< Timestamp en tiempo Unix de salida del paquete pktgen (s)*/
        __be32 tv_usec;/**< Timestamp en tiempo Unix de salida del paquete pktgen (us)*/
        /*@}*/
};



static __always_inline int parse_ethhdr(struct hdr_cursor *nh,
					void *data_end,
					struct ethhdr **ethhdr)
{
	struct ethhdr *eth = nh->pos;
	int hdrsize = sizeof(*eth);
	if (nh->pos + 14 > data_end)
		return -1;

	nh->pos += hdrsize;
	*ethhdr = eth;

	return eth->h_proto; 
}

static __always_inline int parse_iphdr(struct hdr_cursor *nh,
				       void *data_end,
				       struct iphdr **iphdr)
{
	struct iphdr *iph = nh->pos;
	int hdrsize;

	if (iph + 1 > data_end)
		return -1;

	hdrsize = iph->ihl * 4;

	if(hdrsize < sizeof(*iph))
		return -1;

	
	if (nh->pos + hdrsize > data_end)
		return -1;

	nh->pos += hdrsize;
	*iphdr = iph;

	return iph->protocol;
}


static __always_inline int parse_pktgenhdr(struct hdr_cursor *nh,
					void *data_end,
					struct pktgen_hdr **pkthdr)
{
	
	struct pktgen_hdr *h = nh->pos;

	if (h + 1 > data_end)
		return -1;

	nh->pos  = h + 1;
	*pkthdr = h;

	if (h->pgh_magic==0x55E99BBE)
		return 1;
	return 0;
}

static __always_inline int parse_udphdr(struct hdr_cursor *nh,
					void *data_end,
					struct udphdr **udphdr)
{
	int len;
	struct udphdr *h = nh->pos;

	if (h + 1 > data_end)
		return -1;

	nh->pos  = h + 1;
	*udphdr = h;

	len = bpf_ntohs(h->len) - sizeof(struct udphdr);
	if (len < 0)
		return -1;

	return len;
}

SEC("xdp_sock")
int xdp_sock_prog(struct xdp_md *ctx)
{

   
    	int index = ctx->rx_queue_index;

	struct hdr_cursor nh;
 	void *data_end = (void *)(long)ctx->data_end;
	void *data = (void *)(long)ctx->data;
	struct ethhdr *eth = data; 
   	struct iphdr *iph;
	struct udphdr *udph;
	struct pktgen_hdr *pkth;

	__u32 action = XDP_PASS;
   	int nh_type;

	bpf_printk("AAAAAAAAAAAAAAAAAA\n");
	nh.pos = data;
	nh_type = parse_ethhdr(&nh, data_end, &eth);
	if (nh_type != bpf_htons(0x0800))
		return action;

	int nh_proto;
	nh_proto=parse_iphdr(&nh,
				       data_end,
				       &iph);


	

	if (nh_proto == IPPROTO_UDP) { 
	//	bpf_printk("UDP\n");
		int l;
		l= parse_udphdr(&nh,
					data_end,
					&udph);
		(void)l;

		l=parse_pktgenhdr(&nh,
					data_end,
					&pkth);
		if(l==1){
		//bpf_printk("PKTGEN %d\n",index);

			//int index=0;
			if (bpf_map_lookup_elem(&xsks_map, &index)){

			//bpf_printk("PKTGEN2 %u\n",index);
			const int ret_val = bpf_redirect_map(&xsks_map, index, 0);
                        //        bpf_printk("RET-VAL: %d %d\n", ret_val,index);
        		//return bpf_redirect_map(&xsks_map, index, 0);
        		return ret_val;
			}
			/*else
			 		bpf_printk("PKTGEN2222 %d\n",index);*/

			 
	
		}
		else{
			
		//bpf_printk("NOT PKTGEN\n");

			return XDP_PASS;
		}
	}
	else
		return XDP_PASS;
	//return bpf_redirect_map(&xsks_map, index, 0);
	return XDP_PASS;

  
   
}

char _license[] SEC("license") = "GPL";
