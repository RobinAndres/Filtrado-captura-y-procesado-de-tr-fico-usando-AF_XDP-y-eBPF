/* Common BPF/XDP functions used by userspace side programs */
#ifndef __COMMON_USER_BPF_XDP_H
#define __COMMON_USER_BPF_XDP_H
#include "common_defines.h"


struct bpf_pinned_map {
	const char *name;
	const char *filename;
	int map_fd;
};

struct bpf_prog_load_attr_maps {
	const char *file;
	enum bpf_prog_type prog_type;
	enum bpf_attach_type expected_attach_type;
	int ifindex;
	int nr_pinned_maps;
	struct bpf_pinned_map *pinned_maps;
};

int bpf_prog_load_xattr_maps(const struct bpf_prog_load_attr_maps *attr,
			     struct bpf_object **pobj, int *prog_fd);


int xdp_link_attach(int ifindex, __u32 xdp_flags, int prog_fd);
int xdp_link_detach(int ifindex, __u32 xdp_flags, __u32 expected_prog_id);

struct bpf_object *load_bpf_object_file(const char *filename, int ifindex);
struct bpf_object *load_bpf_and_xdp_attach(struct config *cfg);

const char *action2str(__u32 action);

int check_map_fd_info(const struct bpf_map_info *info,
                      const struct bpf_map_info *exp);

int open_bpf_map_file(const char *pin_dir,
		      const char *mapname,
		      struct bpf_map_info *info);

#endif /* __COMMON_USER_BPF_XDP_H */
