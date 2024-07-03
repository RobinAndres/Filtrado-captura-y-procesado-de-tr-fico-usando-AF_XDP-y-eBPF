#include<stdio.h>
#include<lxdp.h>
#include <signal.h>

void process_signal(int nsig){
    stop_rx_and_process();
}

void process_packet(uint8_t *pkt,struct pkt_info *h, void *extaInfo){
    printf("%u\n",h->len);

}

int main(int argc,char * argv[]){
if(argc!=2){
    return -1;
}

      

signal(SIGINT,process_signal);

struct xsk_umem_info *umem;

struct config cfg = {
		.ifindex   = -1,
		.filename = "",
		.progsec = "xdp_sock",
        .xsk_poll_mode=true

      
	};

cfg.xsk_if_queue = 0;
cfg.xsk_bind_flags &= XDP_COPY;
//cfg.xsk_bind_flags |= XDP_ZEROCOPY;
cfg.xsk_poll_mode=true;

struct xsk_socket_info * s;

cfg.ifname=argv[1];

printf("AAA:%s\n",argv[1]);
cfg.ifindex = if_nametoindex(cfg.ifname);
if (cfg.ifindex == 0) {
  printf("Error interfaz\n");
  return -1;
}
s=create_init_xdp_sock(cfg,&umem);
if(s==NULL){
    return -1;
}	
load_NIC_rules(cfg.ifname);
unload_NIC_rules(cfg.ifname);
load_NIC_rules(cfg.ifname);
rx_and_process(true, s,10,1000,process_packet,NULL);
printf("FIN\n");
close_xdp_sock(s, cfg,umem);

return 0;
}
