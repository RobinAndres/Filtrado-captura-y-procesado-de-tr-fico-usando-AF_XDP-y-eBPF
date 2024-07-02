/* SPDX-License-Identifier: GPL-2.0 */

#include <linux/bpf.h>

#include <bpf/bpf_helpers.h>
#include <bpf/bpf_endian.h>

#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/in.h>
#include <linux/udp.h>
#include <linux/tcp.h>
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <stddef.h>
struct hdr_cursor {
	void *pos;
};

static __always_inline void swap_src_dst_mac(void *data)
{
	unsigned short *p = data;
	unsigned short dst[3];

	dst[0] = p[0];
	dst[1] = p[1];
	dst[2] = p[2];
	p[0] = p[3];
	p[1] = p[4];
	p[2] = p[5];
	p[3] = dst[0];
	p[4] = dst[1];
	p[5] = dst[2];
}

static __always_inline int parse_ethhdr(struct hdr_cursor *nh, void *data_end, struct ethhdr **ethhdr)
{
	struct ethhdr *eth = nh->pos;
	int hdrsize = sizeof(*eth);
	if (nh->pos + 14 > data_end)
		return -1;

	nh->pos += hdrsize;
	*ethhdr = eth;

	return eth->h_proto; 
}

static __always_inline int parse_iphdr(struct hdr_cursor *nh, void *data_end, struct iphdr **iphdr)
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

	nh->pos += hdrsize; //Avanzo el puntero para apuntar al inicio del encabezado TCP o UDP
	*iphdr = iph;

	return iph->protocol;
}

static __always_inline int parse_udphdr(struct hdr_cursor *nh, void *data_end, struct udphdr **udphdr)
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

static __always_inline int parse_tcphdr(struct hdr_cursor *nh, void *data_end, struct tcphdr **tcphdr)
{
	int len;
	struct tcphdr *h = nh->pos;

	if (h + 1 > data_end)
		return -1;

	len = h->doff * 4;

	if(len < sizeof(h))
		return -1;

	if (nh->pos + len > data_end)
		return -1;

	nh->pos += len;
	*tcphdr = h;
	return len;
}

struct bpf_map_def SEC("maps") xsks_map = {
	.type = BPF_MAP_TYPE_XSKMAP,
	.key_size = sizeof(int), //número de cola
	.value_size = sizeof(int),
	.max_entries = 64, 
};

struct bpf_map_def SEC("maps") xdp_puerto_map = {
	.type = BPF_MAP_TYPE_ARRAY,
	.key_size = sizeof(int),
	.value_size = sizeof(int),
	.max_entries = 2,
};

SEC("xdp_echo")
int xdp_echo_prog(struct xdp_md *ctx)
{	
	int index = ctx->rx_queue_index;
	struct hdr_cursor nh;
 	void *data_end = (void *)(long)ctx->data_end;
	void *data = (void *)(long)ctx->data;
	struct ethhdr *eth = data; 
   	struct iphdr *iph;
	struct udphdr *udph;
	struct tcphdr *tcph;
	__u32 action = XDP_PASS;
   	int nh_type;
	nh.pos = data;
	nh_type = parse_ethhdr(&nh, data_end, &eth);
	if (nh_type != bpf_htons(0x0800)) //tipo ipv4
		return action;

	int nh_proto;
	nh_proto=parse_iphdr(&nh,data_end,&iph);
	int *puerto1=NULL;
	int key_puerto = 1;
	puerto1 = bpf_map_lookup_elem(&xdp_puerto_map,&key_puerto);
	int valor_puerto=-1;
	if(puerto1!=NULL)
		valor_puerto = *puerto1;
	
	if (nh_proto == IPPROTO_TCP) {
		int l;
		l = parse_tcphdr(&nh, data_end, &tcph);
		if (l == -1)
			return XDP_PASS;
		if (tcph->dest == bpf_htons(valor_puerto)) {
			return XDP_DROP;
		}
	return XDP_PASS;
	}

	if (nh_proto == IPPROTO_UDP) { 
		int l;
		l= parse_udphdr(&nh, data_end, &udph);
		if(l==-1)
			return XDP_PASS;
		
		if(udph->dest==bpf_htons(valor_puerto)){
		swap_src_dst_mac(data);
		__u32 aux=iph->saddr;
		iph->saddr=iph->daddr;
		iph->daddr=aux;
		__u16 aux2=udph->source;
	        udph->source=udph->dest;
        	udph->dest=aux2;
		return XDP_TX;
		}

	return bpf_redirect_map(&xsks_map, index, 0);
	}
	return XDP_PASS;
  
   
}

char _license[] SEC("license") = "GPL";
