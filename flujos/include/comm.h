
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <pthread.h>
#include <netinet/ip.h>
#include <netinet/udp.h>
//#include <linux/if_packet.h>
//#include <linux/if_ether.h>
//#include <linux/if_arp.h>
#include <sys/ioctl.h>
#include <limits.h>
#include <float.h>
#include <math.h>
#include <sys/poll.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
 #include <sys/poll.h>
       #include <errno.h>

#include <lxdpFlow.h>


   struct xsk_socket_info *createXDPSocket(char *itf,int queue);
      void destroyXDPSocket(struct xsk_socket_info *s);
 int receiveMeasurementTrainXDP(struct xsk_socket_info * xdp_sd);
