/**
  @file dp.c
  @brief Este fichero contiene funciones de inicialización del monitor de flujos así como el main del programa.


*/

#define   _DEFAULT_SOURCE
#include <dp.h>
#include <export.h>
#include <comm.h>

#define DP_VERSION "test_flows"


#define ITFNAME "enp3s0f1"

 struct xsk_socket_info * xdp_sock=NULL;

/**Contador de flujos creados totales.*/
uint64_t created_flows=0;
/**Contador de flujos eliminados totales.*/
uint64_t dead_flows=0;




/**Contador de paquetes no procesados debido a falta de memoria*/
uint64_t unprocessed_packets=0;
/**Contador de flujos no procesados debido a sampling o falta de memoria*/
uint64_t unprocessed_flows=0;



/**Contador de nodos libres. Útil para debug*/
extern uint64_t free_nodes;

/**Contador de sesiones libres. Se muestra cada cierto tiempo por log*/
extern uint64_t free_session;
/**Contador de sesiones usadas. Se muestra cada cierto tiempo por log*/
extern uint64_t used_session;



/**Contador de segundos para mostrar la ocupación de flujos*/
uint8_t node_sec_counter=0;

/**Puntero a sesión auxiliar para llamar a la función ::getIPSession*/
extern IPSession *aux_session;



#ifdef DP_DEBUG
	
	/**Contador de sesiones exportadas. Útil para debug*/
	uint64_t exported_sessions;
	/**Contador de sesiones expiradas. Útil para debug*/
	extern uint64_t expired_session;
	/**Contador de sesiones activas. Útil para debug*/
	extern uint64_t  active_session;
#endif

/**Estructura de tipo passwd que se usa para los permisos de los ficheros en la función chown*/
struct passwd *pwd=NULL;


/**Estructura ::pthread_t para el hilo principal*/
pthread_t main_thread;
/**Estructura ::pthread_t para el hilo de export*/
pthread_t idHiloExport;
/**Estructura ::pthread_t para el hilo de proceso*/
pthread_t idHiloProcess;



/**Tiempo de la última comprobación de redes*/
uint64_t previous_update=0;
/**Variable que almacena el anterior número de semana observado para un paquete*/
uint16_t previous_week=0;
/**Variable que almacena el último número de semana observado para un paquete */
uint16_t current_week=0;
/**Variable que almacena el anterior año observado para un paquete*/
uint16_t previous_year=0;
/**Variable que almacena el actual año observado para un paquete*/
uint16_t current_year=0;





/**Nodo auxiliar*/
extern node_l *nodel_aux;
/**Nodo estático usado para minimizar las reservas al buscar en una lista por ejemplo*/
extern node_l static_node;

/**Tabla de flujos. Es un doble puntero a ::node_l porque cada entrada consiste en una lista para resolver las colisiones.*/
node_l **flow_table=NULL;
/**Lista de flujos activos.*/
node_l *active_flow_list=NULL;
extern node_l *expired_flow_list;
/**Lista de flujos a expirar por bandera.*/
node_l *flags_expired_flow_list=NULL;

/**Contador de flujos expirados.*/
uint64_t expired_flows=0;
/**Contador de flujos expirados en sentido entrante.Útil para debug*/
uint64_t in_expired_list_flows=0;
/**Contador de flujos activos. Útil para debug*/
uint64_t active_flows=0;

/**Puntero a sesión auxiliar para llamar a la función ::getIPSession*/
extern IPSession *aux_session;

/**Tiempo del último paquete recibido (en microsegundos)*/
uint64_t last_packet_timestamp=0;






/**Contador de paquetes totales analizados*/
uint64_t pkts_total=0;
/**Contador de bytes totales analizados*/
uint64_t bytes_total=0;
/**Contador de flujos totales analizados*/
uint64_t flows_total=0;

/**Bandera que indica si debe pararse el bucle infinito del hilo de export*/
int stop_et=0;
/**Bandera que indica si debe pararse el bucle infinito del hilo de proceso*/
int stop_pt=0;
/**Timestamp del paquete anterior (en segundos)*/
uint64_t previous=0;
/**Timestamp del paquete actual (en segundos)*/
uint64_t current=0;
/**Timestamp del paquete actual (en milisegundos)*/
uint64_t currentMs=0;
/**Timestamp del paquete anterior (en milisegundos)*/
uint64_t previousMs=0;

/**Timestamp del paquete anterior al anterior(en segundos). Esta variable se usa para controlar los rollbacks espúreos de marcado que ocurren en el driver cuando hay alguna pérdida.Usando 2 valores anteriores evitamos valores negativos. */
uint64_t previous2=0;



/**Estructura ::exportAttributes que almacena las propiedades que deben pasarse al hilo de export*/
exportAttributes ea;


/**Contador de paquetes mal formados/no procesables por detectpro*/
extern uint64_t count_pckts_malformed;

extern uint64_t total_nodes;



/**
 * Función que limpia la tabla de flujos poniendo el tiempo a inifinito para forzar que se exporten
 * todos los flujos. Después llama a la función clenaup_flows que se encarga de exportar los flujos.
 * @return
 *   La función no retorna nada
 */
inline void reset_flow_table(){
	last_packet_timestamp=INFINITY;
	cleanup_flows();
	
}



 /**
 * Esta función se ejecuta cuando se pulsa Ctrl+C o bien en el modo
 * de funcionamiento de lectura de traza cuando se llega al final de 
 * la misma. En esta función se liberan los recursos reservados y se cierra
 * la captura de HPCAP en caso de que haga falta. Además modifica las variables 
 * globales stop_et,stop_pt y stop_dt que indican a los hilos de export, process 
 * y dump respectivamente que deben dejar de ejecutarse.
 * @param nSenial
 * Número de señal UNIX recibida
 * @return
 *   La función no devuelve nada
*/

void capturaSenial (int nSenial)
{

#ifdef DP_DEBUG
	logInfoVar("En captura señal %u\n",nSenial);
#endif


logInfoVar("En captura señal %u\n",nSenial);
	
	stop_pt=1;

	sleep(2);


	if(nSenial==SIGINT){


	
		if( idHiloProcess )
			pthread_join(idHiloProcess, NULL);

		reset_flow_table();
		stop_et=1;

		if( idHiloExport )
			pthread_join(idHiloExport, NULL);

#ifdef DP_DEBUG
		logInfo("Fichero flujos cerrado\n");

#endif


		last_packet_timestamp=0;
		

		freeIPSessionPool(0);
		
		logInfo("Pool sesiones liberado");
		freeNodelPool();
		free(flow_table);

		
		logInfo("Recursos liberados");
		logInfo("Saliendo...");
		stopLog();
	}
}



	
 /**
 * Esta función se ejecuta (tentativamente) cada segundo.
 * En la función se comprueban las alarmas, se llama a ::flushStats para volcar los datos
 * de series temporales, se llama a la función de limpiar flujos, se actualizan los ficheros de traza asociados a alarmas y se comprueba
 * si hay que crear nuevos ficheros de series temporales de redes, subredes y alarmas (una vez por semana).
 * Esta función modifica la variable global previous y previous2 que almacenan el timestamp (en segundos) del último y penúltimo
 * paquete recibido respectivamente.
 * @return
 *   La función no devuelve nada.
*/

static inline void perSecOps()
{
#ifdef DP_DEBUG
		logInfoVar("previous:%lu USED_FLOWS:%d EXPIRED_FLOWS=%d ACTIVE_SESSIONS=%d DIFF:%d\n",previous,used_session,expired_session,active_session,used_session-active_session-expired_session);

#endif

		node_sec_counter++;
		if(node_sec_counter>=10)
		{
			logInfoVar("FLOW COUNTER - FREE: %"PRIu64" USED: %"PRIu64" NODE COUNTER - FREE: %"PRIu64" USED: %"PRIu64" UNPROCESSED PACKETS: %"PRIu64" UNPROCESSED FLOWS: %"PRIu64"\n",free_session,used_session,free_nodes,total_nodes-free_nodes,unprocessed_packets,unprocessed_flows);
			node_sec_counter=0;
		}

		


		cleanup_flows();
	
		previous2=previous;
		previous=current;

	

	

}


 /**
 * Esta función se ejecuta cuando llega el primer paquete tras haber arrancado el monitor.
 * En esta función se asignan valores a las variables globales previous,previous2 y previousMs, se inicia el intervalo de 
 * captura (usado para los ficheros de alarma), se calcula el número de semana en que nos encontramos, y se abren 
 * los ficheros de series temporales para las redes, superredes y alarmas. También se inicializa la tabla de flujos y la 
 * lista de flujos activos así como la lista de capturas.
 * @return
 *   La función no devuelve nada.
*/
static void inline initData()
{
		
		
		//contadores de tiempo
		previous2=previous;
		previous=current;//segundo actual
		previousMs=currentMs;
		
		previous_update=current;//ultima actualizacion de redes

		


	
		active_flow_list=NULL;
		expired_flow_list=NULL;
		flags_expired_flow_list=NULL;
		active_flows=0;
		expired_flows=0;
		memset(flow_table,0,MAX_FLOW_TABLE_SIZE*sizeof(node_l *));
		aux_session=NULL;
}



 /**
 * Esta función parsea una paquete de red cuyo contenido se encuentra apuntado por bp.
 * La función comprueba avanza por el contenido del paquete extrayendo los tags 802.1q, MPLS, 
 * VN Tag o FabricPath hasta encontrar un paquete IP. En caso de que haya IP sobre IP o similar se guardan
 * registros de las IPs y MACs externas e internas de los túneles. Cuando se encuentra un datagrama IP con protocolo
 * TCP, UDP o ICMP se llama a la función de nivel superior ::processL4Flow o ::processFragL4Flow dependiendo de si hay fragmentación o no.
 * La función procesa más o menos tipo de tráfico dependiendo de si se ha compilado con las opciones DP_ETHERTUNNEL, DP_MPLS, DP_GRE o DP_ERSPAN. En 
 * caso de que la bandera DP_ERSPAN esté activa se responde a peticiones ARP para una dirección IP definida en el archivo global.cfg. La función modifica el 
 * contenido de la variable ::aux_session.
 * @param bp
 * Array de bytes con el contenido del paquete
 * @param hcap
 * Estructura pcap_pkthdr que contiene el timestamp del paquete y el len y caplen.
 * @return
 *   La función no devuelve nada
*/

static inline void parsePacket(uint8_t *bp,struct pcap_pkthdr *hcap)
{
	
	uint8_t num_tags=0;

	


 	uint16_t ipLen = 0;
	uint16_t ipHLen = 0;
	
    uint8_t *bpStart=bp;

	uint8_t stopParsing=0;
	//printf("T:%"PRIu64"\n",last_packet_timestamp);


	if(aux_session==NULL)
	{
		if(unlikely((aux_session=getIPSession())==NULL))
		{

			
			unprocessed_packets++;
			return;
		}
		
	}
	else
	{
		
		memset(&(aux_session->incoming),0,sizeof(IPFlow));
			

		
	}


	IPFlow *aux=&aux_session->incoming;

	
	
	aux->vlanTag=-1;


	memcpy(&(aux->destination_mac),bp,ETH_ALEN);
	memcpy(&(aux->source_mac),bp+ETH_ALEN,ETH_ALEN);
	
	//Skip MAC addresses
	bp+=(2*ETH_ALEN);
	uint16_t aux16=(*(uint16_t*)(bp));
	aux16=ntohs(aux16);
	//printf("%X\n",aux16);
	while(!stopParsing)
	{

		if(bp-bpStart>=hcap->caplen)
		{
				return;
		}
		
		switch(aux16)
		{


			
			
			case QINQ_ETYPE:
				
				bp+=sizeof(uint16_t);
				aux->vlanTag=ntohs(*((uint16_t*)(bp)));
				(aux->vlanTag)&=0x0FFF;
				//printf("VLAN %u\n",aux->vlanTag);
				bp+=sizeof(uint16_t);
				aux16=ntohs((*(uint16_t*)(bp)));
				num_tags++;
			break;

			



				case IP_ETYPE:

					bp+=sizeof(uint16_t);
					if(unlikely((((bp+IP_HLEN)-bpStart>=hcap->caplen))))
					{

				
			                	return;
					}
					
					//printf("IP\n");
					aux->source_ip=ntohl(*((uint32_t*)(bp+IP_SIP)));
					aux->destination_ip=ntohl(*((uint32_t*)(bp+IP_DIP)));
					
					
					

					


			
					aux16=bp[IP_PROTO];
					//printf("PROTO %u %u\n",aux16,aux->ip_id);
					ipHLen = (bp[IP_HL_V] & IP_HL_MASK) * IP_ALEN;
					ipLen=ntohs( *((uint16_t*)(bp+IP_LEN)));
					if(unlikely(((ipHLen<IP_MIN_HLEN)||(ipHLen>IP_MAX_HLEN)||(ipLen<ipHLen))))
					{

						count_pckts_malformed++;
						return;
					}

					
					

					

					bp += ipHLen;
					
				break;

				case UDP_16B:
					aux->npack=1;
					aux->nbytes=hcap->len;
					aux_session->firstpacket_timestamp =last_packet_timestamp;
					aux_session->lastpacket_timestamp = last_packet_timestamp;
					
					aux->transport_protocol= UDP_PROTO;
					//printf("Offset:%"PRIu16"\n",offsetIP);
					
					
					


						processL4Flow(bp,hcap,ipLen,ipHLen,bp-bpStart);
					
					return;
				case TCP_16B:
					aux->npack=1;
					aux->nbytes=hcap->len;
					aux_session->firstpacket_timestamp =last_packet_timestamp;
					aux_session->lastpacket_timestamp = last_packet_timestamp;
					aux->transport_protocol= TCP_PROTO;
					
					
						
						processL4Flow(bp,hcap,ipLen,ipHLen,bp-bpStart);
						
					
					return;
				case ICMP_16B:
					aux->npack=1;
					aux->nbytes=hcap->len;
					aux_session->firstpacket_timestamp =last_packet_timestamp;
					aux_session->lastpacket_timestamp = last_packet_timestamp;
				
					aux->transport_protocol= ICMP_PROTO;
					
				

						processL4Flow(bp,hcap,ipLen,ipHLen,bp-bpStart);
				
					return;
				
				

			default:
				return;
		}
		
	}


	
	
}

 /**
 * Esta función se llama desde el hilo process_thread cada vez que llega un paquete. En cada recepción de
 * paquete se actulizan las variables globales current, currentMs y last_packet_timestamp. Si es la primera recpeción 
 * se llama a la función ::initData. Si ha pasado 1 segundo se llama a ::perSecOps  si ha pasado 1 ms se llama a ::perMsOps.
 * Si el paquete tiene al menos 14 Bytes (ETH_HLEN) se llama a la función parse packets. Debida a la estructura del driver se 
 * puede devolver "paquetes falsos" que no tienen contenido (len y caplen a 0) pero tienen timestamps para poder hacer las comprobaciones temporales.
 * Esta función también comprueba en cuantos de networksupdateinterval segundos si hay un fichero networks.update.
 * @param bp
 * Array de bytes con el contenido del paquete
 * @param hcap
 * Estructura pcap_pkthdr que contiene el timestamp del paquete y el len y caplen.
 * @return
 *   La función no devuelve nada
*/
void process_packet(uint8_t *bp,struct pcap_pkthdr *hcap){

	printf("AAAAAAAAAAAAAAAAAA %u %u\n",hcap->ts.tv_sec,hcap->ts.tv_usec);	

	
	last_packet_timestamp=((uint64_t) ((uint64_t) (hcap->ts.tv_sec) * US_IN_SEC_ULL  )+(uint64_t) (hcap->ts.tv_usec));
	
	current=last_packet_timestamp/US_IN_SEC;
	currentMs=last_packet_timestamp/MS_IN_SEC;

	if(previous==0){//primer paquete
		
		initData();
	}
	

	if ((previous < current)) {//pasa un segundo
		
		perSecOps();
	}
	else
	{
		if(previous==current)
		{
			previous=current;
		}
		else
		{
			if(previous2<current)
				previous=previous2;

		}
	}
	
	if(hcap->caplen>=ETH_HLEN)
		parsePacket(bp,hcap);
	
	

}

void *processThread(void *parameter){

  printf("Entrando en process\n");
  rx_and_process(true,xdp_sock,5,1000,process_packet,NULL);
  printf("Saliendo process\n");

	
}


 /**
 * Función main que se encarga de leer los archivos de configuración y lanzar los hilos de process, export y capture. Una vez lanzados los hilos se queda dormido hasta quye recibe un Ctrl+C.
 * @param argc
 * Número de argumentos pasados por línea de comandos
 * @param argv[]
 * Argumentos pasados. El monitor solo debe recibir  1 parámetro que es la ruta del fichero global.cfg
 * @return
 *   La función devuelve -1 si hay algún error y 0 en caso contrario.
*/

int main (int argc, char *argv[])
{

	int __attribute__((unused)) ret;
	cpu_set_t mask;
	
	
	startLog("stderr");

	

	xdp_sock =createXDPSocket(ITFNAME,0);
	if(xdp_sock==NULL){
		return DP_ERR;
	}





	#define AFFINITY_PROCESS 2

	CPU_ZERO(&mask);
	CPU_SET(AFFINITY_PROCESS,&mask);
	main_thread=pthread_self();
	if( pthread_setaffinity_np(pthread_self(), sizeof(cpu_set_t),&mask) < 0 )
	{
		perror("pthread_setaffinity_np");
		logError("No se ha podido establecer el affinity. El rendimiento no será optimo");
	}

	{/* ADVANCED CONFIGURATION */
		numa_set_localalloc();
		//set perms
	

		

		
		logInfo("Configuracion alarmas leida");

		logInfo("Reservando tabla de flujos\n");
		flow_table=malloc(MAX_FLOW_TABLE_SIZE*sizeof(node_l*));
		if(flow_table==NULL)
		{
			logError("Error reservando tabla de flujos");
			return DP_ERR;
		}
		memset(flow_table,0,MAX_FLOW_TABLE_SIZE*sizeof(node_l *));

		logInfo("Reservando pool de memoria...");
		allocIPSessionPool(0);//pool de nodos
		allocNodelPool();
		
		logInfo("Pool de memoria reservado");
	}



	

	if (mlockall(MCL_CURRENT | MCL_FUTURE)) {
	   logError("Fallo llamada mlockall las páginas no se mantendran en memoria");
	}

	/* Once memory has been allocated, re-place main thread on its core */
	CPU_ZERO(&mask);
	#define AFFINITY_MAIN 3
	CPU_SET(AFFINITY_MAIN,&mask);
	if (pthread_setaffinity_np(pthread_self(), sizeof(cpu_set_t),&mask) <0) {
		perror("pthread_setaffinity_np");
	}

	
	ea.export_data=printTupleFileText;
	

	
	pthread_create (&idHiloExport, NULL, exportThread, &ea);
	pthread_create (&idHiloProcess, NULL, processThread, NULL);
	

	sigset_t sigmask;
	main_thread=pthread_self();
	/* Create a mask holding only SIGINT - ^C Interrupt */
	sigemptyset( & sigmask );
	sigaddset( & sigmask, SIGINT );

	/* Set the mask for our main thread to include SIGINT */

	pthread_sigmask( SIG_BLOCK, & sigmask, NULL );
	int sig_caught; 
	sigwait (&sigmask, &sig_caught);
	switch (sig_caught)
	{
		case SIGINT:
			capturaSenial(SIGINT);
			break;
		case SIGKILL:
			capturaSenial(SIGKILL);
			break;
	}

	destroyXDPSocket(xdp_sock);
	return DP_OK;
}


