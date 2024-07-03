#pragma once
#ifndef __IPflow_H__
#define __IPflow_H__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <math.h>
#include <pcap.h>
#include <signal.h>
#include <pthread.h>
#include <list.h>
//#include <monitor.h>
#include <log.h>
#include <dp.h>

#define CACHE_LINE_SIZE 64

/**Tiempo de expiración de flujos por defecto.90 s.*/
#define EXPIRATION_FLOW_TIME 90000000
/**Tamaño máximo en bytes de una trama Jumbo de Ethernet*/
#define MAX_JUMBO_SIZE 9200
/**Número máximo de paquetes a guardar cuando se generan ficheros de payload*/
#define MAX_PACK 10
/**Número máximo de bytes a guardar cuando se generan ficheros de payload*/
#define MAX_PAYLOAD 400
/**Tamaño en bytes de las etiquetas 802.1q*/
#define TAG_SIZE 4
/**Tamaño en bytes de la cabecera Ethernet*/
#define ETH_HLEN 14
/**Tamaño mínimo en bytes de la cabecera IP*/
#define IP_HLEN_MIN 20
/**Offset sobre el inicio de la cabecera IP donde empieza el campo IP origen*/
#define IP_SIP 12
/**Offset sobre el inicio de la cabecera IP donde empieza el campo offset de IP*/
#define IP_OFFSET 6
/**Offset sobre el inicio de la cabecera IP donde empieza el campo longitud de IP*/
#define IP_LEN 2
/**Máscara de bits necesaria para obtener el offset*/
#define OFFSET_MASK 0xff1f
/**Máscara de bits necesaria para obtener las banderas*/
#define OFFSET_FLAGS_MASK 0x0020
/**Offset sobre el inicio de la cabecera IP donde empieza el campo IP destino*/
#define IP_DIP 16
/**Longitud en bytes de las direcciones IPv4*/
#define IP_ALEN 4
/**Longitud en bytes de las direcciones Ethernet*/
#define ETH_ALEN 6
/**Offset sobre el inicio de la cabecera IP donde empieza el campo protocolo de IP*/
#define IP_PROTO 9
/**Offset sobre el inicio de la cabecera IP donde empieza el campo identificador de IP*/
#define IP_ID 4
/**Offset sobre el inicio de la cabecera IP donde empieza el campo versión/header length de IP*/
#define IP_HL_V 0
/**Offset sobre el inicio de la cabecera IP donde empieza el campo DSCP de IP*/
#define IP_DSCP 1
/**Máscara de bits necesaria para obtener el campo DSCP a partir del campo ToS*/
#define IP_DSCP_MASK 0xFF
/**Rotación necesaria para obtener el campo DSCP a partir del campo ToS*/
#define IP_DSCP_SHIFT 2
/**Máscara de bits necesaria para obtener la longitud de la cabecera IP*/
#define IP_HL_MASK 0x0F
/**Offset sobre el inicio de la cabecera IP donde empieza el campo TTL de IP*/
#define TTL 8

/**Número de protocolo IP para ICMP*/
#define ICMP_PROTO 1
/**Número de protocolo IP para TCP*/
#define TCP_PROTO 6
/**Número de protocolo IP para UDP*/
#define UDP_PROTO 17
/**Longitud en bytes de la cabecera UDP*/
#define UDP_HLEN 8
/**Longitud en bytes de la cabecera ICMP*/
#define ICMP_HLEN 8

/**Tamaño mínimo en bytes de la cabecera IP*/
#define IP_MIN_HLEN 20
/**Tamaño máximo en bytes de la cabecera IP*/
#define IP_MAX_HLEN 60
/**Tamaño mínimo en bytes de la cabecera TCP*/
#define TCP_MIN_HLEN 20
/**Tamaño máximo en bytes de la cabecera IP*/
#define TCP_MAX_HLEN 60

/**Offset sobre el inicio de la cabecera TCP donde empieza el campo data offset*/
#define TCP_HLEN_OFFSET 12

/**Offset sobre el inicio de la cabecera ICMP donde empieza el campo tipo*/
#define ICMP_TYPE_OFF 0
/**Offset sobre el inicio de la cabecera ICMP donde empieza el campo código*/
#define ICMP_CODE_OFF 1


/**Macro que calcula el mínimo de 2 números*/
#define MIN(X,Y) ((X) < (Y) ? (X) : (Y))
/**Macro que calcula el máximo de 2 números*/
#define MAX(X,Y) ((X) > (Y) ? (X) : (Y))
/**
Esta estructura almacena la información necesaria y los datos de un flujo.
*/
typedef struct __attribute__((aligned(CACHE_LINE_SIZE))) IPFlow
{
 /*@{*/
	uint32_t source_ip; /**< IP origen del flujo en formato decimal*/
	uint32_t destination_ip; /**< IP destino del flujo en formato decimal*/
	uint64_t source_mac; /**< MAC origen del flujo. Se usan 2 bytes de más ya que la MAC son solo 6 Bytes*/
	uint64_t destination_mac; /**< MAC destino del flujo. Se usan 2 bytes de más ya que la MAC son solo 6 Bytes*/
	uint16_t source_port; /**< Puerto origen del flujo en formato decimal*/
	uint16_t destination_port; /**< Puerto destino del flujo en formato decimal*/
	uint16_t vlanTag;/**< Id VLAN del flujo. Si vale 65535 se indica que no tiene tag. Los IDs de VLAN solo pueden tener 12 bits(4096) así que no hay conflictos con este número. Si hay etiquetas anidadas (QinQ) únicmanete se guarda la última.*/	
	uint8_t transport_protocol; /**< Protocolo (a nivel IP) del flujo*/

	uint32_t npack; /**< Número de paquetes observados para el flujo*/

	
	uint64_t nbytes; /**< Número de bytes observados para el flujo*/

	
	

	
	
  /*@}*/
} IPFlow;

/**
Esta estructura almacena la información necesaria y los datos de una sesión (flujo bidireccional).
*/
typedef struct __attribute__((aligned(CACHE_LINE_SIZE))) IPSession
{
 /*@{*/
	IPFlow *current_flow; /**<Puntero al flujo incoming o outgoing según el último paquete recibido para este flujo pertenezca al incoming o al outgoing.*/
	uint64_t exportation_timestamp; /**<Timestamp en microsegundos de exportación del flujo*/ 
	uint64_t lastpacket_timestamp;/**<Timestamp en microsegundos del último paquete del flujo*/
	uint64_t firstpacket_timestamp;/**<Timestamp en microsegundos de del primer paquete del flujo*/
	node_l *active_node; /**<Puntero a ::node_l que apunta a la posición de esta sesión dentro de la lista de flujos/sessiones activas.*/
	
	
	IPFlow incoming; /**<Estructura ::IPFlow con los datos del flujo entrante*/

	
	
/*@}*/
}IPSession;

/**Definición del template del puntero a función de comparación de tupla. Estas funciones reciben 2 estructuras de flujo o sesión , comparan sus campos y devuelve 0 si son iguales.*/
typedef int (*compare_tuple_fn)(void *a, void *b);







#ifdef DP_FLOW_CREAT_PRINT
void printFlowCreation (IPSession *session,FILE* f_txt);
#endif

IPSession *insertFlow (IPSession* aux_session);
void cleanup_flows ();
void processFlow(uint8_t *bp,struct pcap_pkthdr *h,uint8_t num_tags,uint16_t vlanTag);
void processL4Flow(uint8_t *bp,struct pcap_pkthdr *h,uint16_t ipLen,uint16_t ipHLen,uint16_t skipped);
void processFragL4Flow(uint8_t *bp,struct pcap_pkthdr *h,uint16_t ipLen,uint16_t ipHLen,uint16_t skipped);
void updateFlowMembership(void);
#endif
