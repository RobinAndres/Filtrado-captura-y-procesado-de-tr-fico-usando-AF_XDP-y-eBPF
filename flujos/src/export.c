
/**
  @file export.c
  @brief Este fichero contiene la implementación del hilo de export así como las funciones que formatean las salidas de los ficheros de flujos/sesiones que se crean al exportar datos.

*/
#include <export.h>

#define FLOWS_DIR "./output/"
#define FLOW_FILE_DUR 1800
#define BONDING_NAME "test"

/**Contador de sesiones/flujos exportadas*/
extern uint64_t exported_sessions;
/**Contador de sesiones/flujos expiradas*/
extern uint64_t expired_session;


/**Contador de flujos totales analizados*/
extern  uint64_t flows_total;
/**Estructura ::pthread_t para el hilo principal*/
extern pthread_t main_thread;

/**Tiempo del último paquete recibido (en microsegundos)*/
extern uint64_t last_packet_timestamp;

/**Lista de flujos a expirar.*/
node_l *expired_flow_list=NULL;


/**Bandera que indica si debe pararse el bucle infinito del hilo de export*/
extern int stop_et;

/**Semáforo para la lista de expirados. Tanto el hilo de proceso como el de export comparten la lista*/
pthread_mutex_t sem_expired_list = PTHREAD_MUTEX_INITIALIZER;

/**
 * Esta función recibe una estructura ::IPSession e imprime en el fichero de flujos los campos correspondientes. 
 * @param session
 * Estructura ::IPSession que contiene el flujo o sesión a imprimir
 * @param e
 * Estructura ::exportFiles que contiene los punteros a los ficheros de flujos y payload (en caso de que se use la variable DP_PAYLOAD) en los que se volcarán los datos del flujo/sesión
 * @return
 *   La función no devuelve nada. 
 */
void printTupleFileText(IPSession *session,exportFiles *e)
{


	
	uint8_t *sourceIP,*destinationIP,*sourceMAC,*destinationMAC;

	#ifdef DP_SSL
		char *cert=NULL;
		char *certNA="N/A";
	#endif

	sourceIP = (uint8_t*)(&(session->incoming.source_ip));
	destinationIP = (uint8_t*)(&(session->incoming.destination_ip));
	sourceMAC = (uint8_t*)(&(session->incoming.source_mac));
	destinationMAC = (uint8_t*)(&(session->incoming.destination_mac));


	uint64_t duration=session->lastpacket_timestamp/US_IN_SEC-session->firstpacket_timestamp/US_IN_SEC+1;
	

	fprintf(e->flow_file_txt,"%"PRIu8".%"PRIu8".%"PRIu8".%"PRIu8" " //l[3], l[2], l[1], l[0]
		     	"%u.%u.%u.%u " //l2[3], l2[2], l2[1], l2[0]
		      	"%02X:%02X:%02X:%02X:%02X:%02X " //l3[0],l3[1],l3[2],l3[3],l3[4],l3[5]
		      	"%02X:%02X:%02X:%02X:%02X:%02X "  //l4[0],l4[1],l4[2],l4[3],l4[4],l4[5]
	  		"p%"PRIu8" " //session->incoming.transport_protocol
		   	"%"PRIu16" " //session->incoming.source_port
			"%"PRIu16" " //session->incoming.destination_port
			"%"PRIu32" " //session->incoming.npack
			"%"PRIu64" " //session->incoming.nbytes
			"%"PRIu64".%06"PRIu64" "
			"%"PRIu64".%06"PRIu64" "
			"%"PRIu64" " //duration
				"\n",sourceIP[3], sourceIP[2], sourceIP[1], sourceIP[0],
				destinationIP[3], destinationIP[2], destinationIP[1], destinationIP[0],
				sourceMAC[0],sourceMAC[1],sourceMAC[2],sourceMAC[3],sourceMAC[4],sourceMAC[5],
				destinationMAC[0],destinationMAC[1],destinationMAC[2],destinationMAC[3],destinationMAC[4],destinationMAC[5],
				session->incoming.transport_protocol,
				session->incoming.source_port,
				session->incoming.destination_port,
				session->incoming.npack,
				session->incoming.nbytes,
				session->firstpacket_timestamp/US_IN_SEC,session->firstpacket_timestamp%US_IN_SEC,
				session->lastpacket_timestamp/US_IN_SEC,session->lastpacket_timestamp%US_IN_SEC,
				duration
				


				);

}




/**
 * Esta función implementa el hilo principal de exportación de flujos. Este hilo se ejecuta hasta que se
 * para el monitor. Periódicamente consulta la lista de flujos expirados, extrae los nodos y escribe la información 
 * del flujo en el fichero de flujos. Como la lista de expirados se comparte entre el hilo de proceso y el de exportación
 * se usa el semáforo sem_expired_list para hacer el bloqueo.
 * 
 * @param parameter
 *	Variable de tipo ::exportAttributes que contiene la información necesaria para realizar la exportación.
 * @return
 *   La función devuelve NULL cuando acaba. Para ello la variable stop_et debe cambiar de valor. Dicho cambio se hace en la función que gestiona la señal Ctrl+c
 */
void *exportThread(void *parameter){
	node_l *n=NULL;
	exportFiles e;
	exportAttributes *eAttrib=(exportAttributes*)parameter;

	cpu_set_t mask;   /* process switches to processor 3 now */
	CPU_ZERO(&mask);
	CPU_SET(eAttrib->affinity_export,&mask);
	if (pthread_setaffinity_np(pthread_self(), sizeof(cpu_set_t),&mask) <0) {
		perror("pthread_setaffinity_np");
	}

	char filename[MAX_LINE_FILE];
	struct timeval initwr;
	time_t rawtime;
	struct tm *info=NULL;
	
	time( &rawtime );
	info = localtime( &rawtime );
	int32_t offset_tz=info->tm_gmtoff;

	gettimeofday(&initwr,NULL);
#ifdef DP_DEBUG
	logInfoVar("%"PRIu64" %d %d\n",initwr.tv_sec,offset_tz,((initwr.tv_sec+offset_tz)/FLOW_FILE_DUR)*FLOW_FILE_DUR);
#endif
	sprintf(filename,"%s/flows%s_%"PRIu64".txt",FLOWS_DIR,BONDING_NAME,(((int)initwr.tv_sec+offset_tz)/FLOW_FILE_DUR)*FLOW_FILE_DUR-offset_tz);

	logInfoVar("Abriendo fichero de flujos:%s\n",filename);
	e.flow_file_txt=fopen(filename,"a");
	if(e.flow_file_txt==NULL)
	{
		logError("Apertura fichero de flujos");
		exit(-1);
		return NULL;
	}	




	


	uint8_t flag_vacia=0;
	int32_t prev_second=0;
	uint64_t current_second=last_packet_timestamp/US_IN_SEC;
	#ifdef DP_DEBUG
		exported_sessions=0;
	#endif 

	while(!stop_et){

		pthread_mutex_lock(&sem_expired_list);
		if(expired_flow_list!=NULL){
			if(flag_vacia==1){
				flag_vacia=0;
			}
			//sacar flujo de la lista
			n=list_pop_first_node(&expired_flow_list);
			#ifdef DP_DEBUG
				expired_session--;
			#endif
			pthread_mutex_unlock(&sem_expired_list);
			//exportar flujo
			node_l *current_node=n;
			IPSession *current_session=NULL;
			current_session=(IPSession*)(current_node->data);
			current_session->exportation_timestamp=last_packet_timestamp;


			eAttrib->export_data(current_session,&e);			

			


			#ifdef DP_DEBUG
				exported_sessions++;
			#endif
	
		
			releaseIPSession(current_session);
			releaseNodel(current_node);
			
#ifdef DP_DEBUG
			logInfo("Flujo exportado");
#endif
			// Frag. packets
			
			flows_total++;
		}
		else{//lista vacia;
			pthread_mutex_unlock(&sem_expired_list);
			usleep(1);
			flag_vacia=1;

		}
		current_second=(last_packet_timestamp/US_IN_SEC)+offset_tz;
		 if(((last_packet_timestamp!=INFINITY)&&(last_packet_timestamp!=0)) && (current_second>prev_second)){


			if((current_second/FLOW_FILE_DUR>prev_second/FLOW_FILE_DUR)){
				//pasa un día
				fflush(e.flow_file_txt);
				fclose(e.flow_file_txt);
				#ifdef DP_PAYLOAD
					fflush(e.flow_file_bin);
					fclose(e.flow_file_bin);
				#endif
				
				
				sprintf(filename,"%s/flows%.10s_%"PRIu64".txt",FLOWS_DIR,BONDING_NAME,(current_second/FLOW_FILE_DUR)*FLOW_FILE_DUR-offset_tz);
				logInfoVar("Abriendo fichero de flujos:%s %"PRIu64" % "PRIu64" \n",filename,current_second,last_packet_timestamp);
				e.flow_file_txt=fopen(filename,"a");
				if( e.flow_file_txt==NULL)
				{
 					logError("Apertura fichero de flujos");
			              	exit(-1);
			               	break;

				}
				#ifdef DP_PAYLOAD
					sprintf(filename,"%s/flows%s_%"PRIu64".bin",FLOWS_DIR,BONDING_NAME,(current_second/FLOW_FILE_DUR)*FLOW_FILE_DUR-offset_tz);
					e.flow_file_bin=fopen(filename,"a");
					if(e.flow_file_bin==NULL)
					{
						logError("Apertura fichero binario de flujos");
		                               exit(-1);
						break;

					}
					e.offset_bin=0;
				#endif
			}
			prev_second=current_second;
		}
	}


	pthread_mutex_lock(&sem_expired_list);
	while (expired_flow_list!=NULL)
	{
		if(flag_vacia==1){
			flag_vacia=0;
		}
		//sacar flujo de la lista
		n=list_pop_first_node(&expired_flow_list);
		#ifdef DP_DEBUG
			expired_session--;
		#endif
		//exportar flujo
		node_l *current_node=n;
		IPSession *current_session=NULL;
		current_session=(IPSession*)(current_node->data);
		current_session->exportation_timestamp=last_packet_timestamp;

		eAttrib->export_data(current_session,&e);

		#ifdef DP_DEBUG
			exported_sessions++;
		#endif
		
		
		releaseIPSession(current_session);
		releaseNodel(current_node);
#ifdef DP_DEBUG
		logInfo("Flujo exportado");
#endif
		
		flows_total++;
	}
	pthread_mutex_unlock(&sem_expired_list);


	logInfo("Export thread finished");
	fflush(stdout);
	if(e.flow_file_txt)
	{	
		fflush(e.flow_file_txt);
		fclose(e.flow_file_txt);

	}

	return NULL;
}

