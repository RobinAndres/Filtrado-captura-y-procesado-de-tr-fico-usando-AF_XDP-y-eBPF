/* SPDX-License-Identifier: GPL-2.0 */

#include <linux/bpf.h>
#include <stddef.h>
#include <bpf/bpf_helpers.h>

struct bpf_map_def SEC("maps") xsks_map = {
	.type = BPF_MAP_TYPE_XSKMAP,
	.key_size = sizeof(int),
	.value_size = sizeof(int),
	.max_entries = 64,
};

struct bpf_map_def SEC("maps") xdp_puerto_map = {
	.type        = BPF_MAP_TYPE_PERCPU_ARRAY,
	.key_size    = sizeof(int),
	.value_size  = sizeof(int),
	.max_entries = 2,
};

SEC("xdp_sock")
int xdp_sock_prog(struct xdp_md *ctx)
{
    int index = ctx->rx_queue_index;
	if (index==1){
		return bpf_redirect_map(&xsks_map, index, 0);
	}
	if (index==2){
		return XDP_DROP;
	}
	
    return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
