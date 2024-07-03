#include <comm.h>

struct xsk_umem_info *s_umem;
struct xsk_socket_info * createXDPSocket(char *itf,int queue){
        
        struct config cfg = {
                        .ifindex   = -1,
                        .filename = "",
                        .progsec = "xdp_sock",
                        .xsk_poll_mode=true
                };

        cfg.xsk_if_queue = queue;
        cfg.xsk_bind_flags &= XDP_COPY;
        //cfg.xsk_bind_flags |= XDP_ZEROCOPY;
        cfg.xsk_poll_mode=false;

        struct xsk_socket_info * s;
        
        cfg.ifname =malloc(IFNAMSIZ*sizeof(uint8_t));
        if (cfg.ifname==NULL){
                return NULL;

        }
                
        strcpy(cfg.ifname,itf);
        cfg.ifindex = if_nametoindex(cfg.ifname);
        if (cfg.ifindex == 0) {
                printf("Error interfaz\n");
                return NULL;
        }
        s=create_init_xdp_sock(cfg,&s_umem,NULL);
        if(s==NULL){
                return NULL;
        }       
        return s;
}



void destroyXDPSocket(struct xsk_socket_info *s){
        struct config cfg = {
                .ifindex   = -1,
                .filename = "",
                .progsec = "xdp_sock",
                .xsk_poll_mode=true
        };
        
        close_xdp_sock(s,cfg,s_umem);
}


