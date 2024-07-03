#pragma once
#ifndef DP_H
#define DP_H
  #define _NET_BPF_H_

//#include <dp_config.h>
//#include <pcap.h>
#include <IPflow.h>
#include <log.h>


#include <pcap.h>
#include <numa.h>
#include <sys/socket.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <signal.h>
#include <features.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <sys/poll.h>
#include <sys/mman.h>
//#include <linux/ip.h>
#include <asm/types.h>
#include <limits.h>
#include <sys/un.h>
#include <unistd.h>
#include <pthread.h>
#include <sched.h>
#include <pwd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
 #include <sys/ioctl.h>
       #include <net/if.h>

#include <sys/socket.h>
       #include <linux/if_packet.h>
       #include <net/ethernet.h> 

#define likely(x)      __builtin_expect(!!(x), 1) 
#define unlikely(x)    __builtin_expect(!!(x), 0) 

#define DP_OK 0
#define DP_ERR -1

/**Número máximo de caracteres en una línea*/
#define MAX_LINE 10000
/**Número máximo de caracteres para nombre de fichero*/
#define MAX_LINE_FILE (MAX_LINE*2)
#define MAX_FLOW_TABLE_SIZE 60000

/** Esta macro indica que un hilo no tiene prioridad para ser asignado a un core*/
#define DP_NO_THREAD_PRIO -1

/** Esta macro indica la posición (desde el principio de la cabecera IP) de la dirección IP origen*/
#define IP_SIP 12
/** Esta macro indica la posición (desde el principio de la cabecera IP) de la dirección IP destino*/
#define IP_DIP 16
/** Esta macro indica la longitud (en bytes) de una dirección IPv4*/
#define IP_ALEN 4
/** Esta macro indica la longitud (en bytes) de una dirección MAC*/
#define ETH_ALEN 6
/** Esta macro indica la longitud (en bytes) de la cabecera IP (sin opciones)*/
#define IP_HLEN 20


/** Esta macro alamcena el ethertype (en hexadecimal) para el tráfico 802.1q*/
#define QINQ_ETYPE 0x8100
/** Esta macro alamcena el ethertype (en hexadecimal) para el tráfico IP*/
#define IP_ETYPE 0x0800


/** Esta macro alamcena el protocolo (a nivel IP y en hexadecimal) para el tráfico UDP. Se usan 16 bits para que las comparaciones sean estándar con los Ethertype dentro de la máquina de estados de parsing del paquete*/
#define UDP_16B 0x0011
/** Esta macro alamcena el protocolo (a nivel IP y en hexadecimal) para el tráfico TCP. Se usan 16 bits para que las comparaciones sean estándar con los Ethertype dentro de la máquina de estados de parsing del paquete*/
#define TCP_16B 0x0006
/** Esta macro alamcena el protocolo (a nivel IP y en hexadecimal) para el tráfico ICMP. Se usan 16 bits para que las comparaciones sean estándar con los Ethertype dentro de la máquina de estados de parsing del paquete*/
#define ICMP_16B 0x0001
/** Esta macro alamcena el protocolo (a nivel IP y en hexadecimal) para el tráfico Ethernet over IP. Se usan 16 bits para que las comparaciones sean estándar con los Ethertype dentro de la máquina de estados de parsing del paquete*/
#define ETHERIP_16B 0x0061
/**Esta macro contiene el valor mínimo de tamaño para un frame Ethernet*/
#define ETH_HLEN_MIN 60

/** Esta macro define el máximo número de filtros MAC que pueden aplicarse*/
#define MAX_MAC_FILTERS 10

/** Define para indicar cada cuánto tiempo, en segundos, se muestra la ocupación de nodos de flujos **/
#define NODE_SHOW_SECONDS 10

/** Define para indicar cuántos ms hay en un segundo**/
#define MS_IN_SEC 1000
/** Define para indicar cuántos us hay en un segundo**/
#define US_IN_SEC 1000000
/** Define para indicar cuántos us hay en un segundo con formato de unsigned long long**/
#define US_IN_SEC_ULL 1000000ULL






void capturaSenial (int nSenial);




#endif
