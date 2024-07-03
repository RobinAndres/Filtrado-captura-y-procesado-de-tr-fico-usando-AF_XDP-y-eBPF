/**
  @file IPflow.c
  @brief Este fichero contiene funciones de gestión de flujos como inserción o expiración.
*/
#include <IPflow.h>
#include <list.h>
#include <dp.h>
#include <numa.h>
#include <pool.h>


/**Macro para el número de protocolo de TCP*/
#define TCP_PROTO 6
/**Macro que devuelve el tamaño de un hash de n bits*/
#define hashsize(n) ((uint32_t)1<<(n))
/**Macro que define la máscara que debe aplicarse a un hash de n bits para truncar el resultado*/
#define hashmask(n) (hashsize(n)-1)

/**Macro que pasa de microsegundos a segundos*/
#define us2s(x) (double)(x)/US_IN_SEC


/**Contador de paquetes mal formados*/
uint64_t count_pckts_malformed=0;

/**Contador de sesiones usadas. Se muestra cada cierto tiempo por log*/
extern uint64_t used_session;
/**Contador de sesiones libres. Se muestra cada cierto tiempo por log*/
extern uint64_t free_session;



/**Nodo estático usado para minimizar las reservas al buscar en una lista por ejemplo*/
node_l static_node;

/**Nodo auxiliar*/
node_l *nodel_aux;

#ifdef DP_DEBUG
	/**Contador de sesiones activas. Útil para debug*/
	uint64_t active_session;
	/**Contador de sesiones expiradas. Útil para debug*/
	uint64_t expired_session;
	/**Contador de banderas totales*/
	uint64_t num_flags;

#endif

/**Puntero a sesión auxiliar para llamar a la función ::getIPSession*/
IPSession *aux_session=NULL;
/**Estructura ::pthread_t para el hilo principal*/
extern pthread_t main_thread;


/**Tabla de flujos. Es un doble puntero a ::node_l porque cada entrada consiste en una lista para resolver las colisiones.*/
extern node_l **flow_table;
/**Lista de flujos activos.*/
extern node_l *active_flow_list;
/**Lista de flujos a expirar.*/
extern node_l *expired_flow_list;
/**Lista de flujos a expirar por bandera.*/
extern node_l *flags_expired_flow_list;
/**Contador de flujos expirados. Útil para debug*/
extern uint64_t expired_flows;
/**Contador de flujos activos. Útil para debug*/
extern uint64_t active_flows;
/**Contador de flujos expirados en sentido entrante.Útil para debug*/
extern uint64_t in_expired_list_flows;
/**Semáforo para la lista de expirados. Tanto el hilo de proceso como el de export comparten la lista*/
extern pthread_mutex_t sem_expired_list;
/**Tiempo del último paquete recibido (en microsegundos)*/
extern uint64_t last_packet_timestamp;


/**Contador total de paquetes*/
extern uint64_t pkts_total;
extern uint64_t unprocessed_flows;



/**
 * Esta función recibe un flujo e imprime su tupla por pantalla
 * @param f
 * Estructura ::IPSession a imprimir
 * @return
 *   La función no devuelve nada
 */
void printTuple(IPFlow *f)
{
	printf("%u %u %u %u %u %u\n",f->source_ip,f->destination_ip,f->source_port,f->destination_port,f->transport_protocol,f->vlanTag);
}






	 /**
	 * Esta función compara las 5-tuplas y la vlan de dos flujos para determinar si son el mismo flujo.
	 * Esta función se usa a la hora de insertar y actualizar flujos. Además pone el puntero current_flow apuntando al
	 * flujo incoming de la sesión. Esta función solo debe usarse cuando se hagan flujos no cuando se hagan sesiones.
	 * @param a
	 * Estructura ::IPSession a comparar. Viene en formato void * porque las funciones que lo usan por debajo son genéricas.
	 * @param b
	 * Estructura ::IPSession a comparar. Viene en formato void * porque las funciones que lo usan por debajo son genéricas.
	 * @return
	 *   La función devuelve 0 si son iguales y 1 si son diferentes. 
	 */
	int compareTupleFlow(void *a, void *b)
	{
		
		

		if(	(((IPSession*)a)->incoming.source_ip == ((IPSession*)b)->incoming.source_ip) &&
				(((IPSession*)a)->incoming.destination_ip == ((IPSession*)b)->incoming.destination_ip) &&
				(((IPSession*)a)->incoming.source_port == ((IPSession*)b)->incoming.source_port) &&
				(((IPSession*)a)->incoming.destination_port == ((IPSession*)b)->incoming.destination_port) &&
				(((IPSession*)a)->incoming.transport_protocol == ((IPSession*)b)->incoming.transport_protocol) &&
				(((IPSession*)a)->incoming.vlanTag == ((IPSession*)b)->incoming.vlanTag) 
		  )
		{
			//((IPSession*)b)->current_flow=&(((IPSession*)b)->incoming);
			return 0;
		}

		return 1;
	}
	


	compare_tuple_fn compareTuple=compareTupleFlow;









 /**
 * Esta función inserta un flujo o sesión en la tabla de flujos. Anteriormente a la llamada de esta función se 
 * ha comprobado si el flujo existía o no para actualziarlo. Si no existía se llama a esta función para insertarlo dentro de la
 * tabla. Además de inicializar los contadores inserta un nodo con un puntero a aux_session en la lista ::active_flow_list y otro nodo
 * con otro puntero en la lista que gestiona las colisiones del hash en la entrada apuntada por index. Si empieza por un paquete con bandera FIN el flujos
 * se manda a la lista de exportar automáticamente a no ser que el programa esté compilado con la bandera -DNO_FLAGS_EXPIRATION en cuyo caso no se exportan flujos por bandera.
 * @param aux_session
 * Estructura ::IPSession a insertar en la tabla de flujos
 * @param new_flow
 * Estructura ::IPFlow contenida en ::IPSession para la inicialización. Este argumento es redundante porque IPFlow ya está contenido en IPSession. TODO cambio de arguemntos.
 * @param index
 * Entero que indica la posición de la tabla hash donde debe ser insertado el flujo. Este índice se ha calculado previamente mediante la función ::getIndex
 * @return
 *  Esta función deveuelve siempre NULL. La razón por la que el prototipo devuelve IPSession* es por comptabilidad y coherencia con los otros prototipos de funciones
 *   de inserción de flujos.
 *
 */

IPSession *insertFlowTable(IPSession *aux_session,IPFlow *new_flow,int index)
{



	node_l *new_active_node = NULL;
	node_l *naux = NULL;

	node_l *list=flow_table[index];

	//new_flow->previous_timestamp=last_packet_timestamp;
	aux_session->lastpacket_timestamp= last_packet_timestamp;
	aux_session->firstpacket_timestamp= last_packet_timestamp; 
	

	

	aux_session->current_flow=&(aux_session->incoming);	




	if(unlikely((getNodel()==-1)))
	{
		unprocessed_flows++;
		return aux_session;
	}

	naux=nodel_aux;
	naux->data=(aux_session);


	
	if(unlikely(getNodel()==-1))
	{
		unprocessed_flows++;
		releaseNodel(naux);
		return aux_session;
	}

	new_active_node=nodel_aux;
	new_active_node->data=naux;


	list_prepend_node(&list,naux);
	flow_table[index]=list;  //asignamos por si ha cambiado la cabeza
	
	
	list_prepend_node(&active_flow_list,new_active_node);
	aux_session->active_node=new_active_node;


	

	return NULL;
}
 /**
 * Esta función actualiza un flujo o sesión existente en la tabla de flujos. Anteriormente a la llamada de esta función se 
 * ha comprobado si el flujo existía.Además de actualizar los contadoresm se saca el flujo de la lista ::active_flow_list y se inserta por el principio haciendo que quede
 * ordenada automáticamente por último tiempo de acceso lo cual facilita la expiración de flujos.
 * Si el paquete que provoca la actualización del flujo contiene la bandera FIN se manda a la lista de exportar automáticamente a no ser que el programa esté compilado con 
 * la bandera -DNO_FLAGS_EXPIRATION en cuyo caso no se exportan flujos por bandera.
 * @param current_session
 * Estructura ::IPSession a actualziar
 * @param new_flow
 * Estructura ::IPFlow que contiene los datos con los que se va a hacer la actualización.
 * @return
 *  Esta función no devuelve nada ya que solo actualiza los contadores y campos de la estructura ::IPSession
 */

inline void updateFlowTable(IPSession *current_session,IPFlow *new_flow){



	
	
	


	

	//current_session->current_flow->previous_timestamp=last_packet_timestamp;

	

	

	
	



	(current_session->current_flow->nbytes) += new_flow->nbytes;
	current_session->lastpacket_timestamp = last_packet_timestamp;
	(current_session->current_flow->npack)++;

	
	
	list_unlink(&active_flow_list,current_session->active_node);
	list_prepend_node(&active_flow_list,current_session->active_node);
	
}


 /**
 * Esta función inserta un flujo. Para ello comprueba si el flujo existía previamente. Si no existía llama a la función ::insertFlowTable. Si existía pero estaba caducado lo exporta
 * e inserta un nuevo flujo llamando a ::insertFlow. Si existía pero no estaba caducado llama a ::updateFlow;
 * @param aux_session
 * Estructura ::IPSession a insertar.
 * @return
 *  Esta función devuelve un puntero a una estructura ::IPSession o NULL. En caso de que la estructura que se pasa como argumento sea isnertada en la tabla 
 *  se devuelve NULL. Si solo se actualiza un flujo se devuelve la estructura IPSession para reutilizarla desde process_flow y evitar llamadas inútiles a ::getIPSession.
 */
inline IPSession *insertFlow (IPSession * aux_session)
{

	
	IPFlow *new_flow=&(aux_session->incoming);
	uint32_t index = getIndex (new_flow);
	
	node_l *list=flow_table[index];

	

	list_alloc_node_no_malloc(aux_session);

	
	node_l *current_node=list_search(&list,&static_node,compareTuple);
	
	if(current_node==NULL)
	{


	
	
		#if DP_DEBUG	
			active_session++;
		#endif
		
	
		return insertFlowTable(aux_session,new_flow,index);
		

	}
	/*If session exists */
	
	IPSession *current_session=(IPSession*)(current_node->data);
	/*If flow has expired*/
	
	if (unlikely((last_packet_timestamp - (current_session->lastpacket_timestamp)) > EXPIRATION_FLOW_TIME))
	{

		#ifdef DP_DEBUG
			active_session++;
		#endif
		
		return insertFlowTable(aux_session,new_flow,index);
	}
	else
	{

	
	
		updateFlowTable(current_session,new_flow);
		return aux_session;
	}
	
	return aux_session;
}




 /**
 * Esta función  limpia los flujos de la lista de activos. Para ello, la recorre en orden inverso hasta econtrar el primer flujo que no ha expirado por tiempo. Los nodos que se quitan de la lista
 * de activos se añaden a la de expirados y los de expirados por banderas se añaden a la lista de expirados para colapsarla en una sola lista. La lista de expirados tiene un semáforo que la bloquea 
 * para evitar el acceso concurrente por parte del flujo de export y del de proceso. A la hora de expirar también se saca el nodo con puntero a la estructura ::IPSession alojado en la lista de 
 * colisiones de la tabla hash de flujos.
 * @return
 *  Esta función no devuelve nada.
 */
void cleanup_flows ()
{

	node_l *n=NULL,*n_flags=NULL;
	node_l *current_node_session_table=NULL;
	IPSession *current_session=NULL;
	#ifdef DP_DEBUG
	int num_expired=0;
	#endif
	uint64_t aux = 0;
	uint32_t index=0;


	n_flags=list_get_last_node(&flags_expired_flow_list);
	n=list_get_last_node(&active_flow_list);
#ifdef DP_DEBUG
	logInfoVar("USED:%d FREE:%d ACTIVE:%d IN_EXPIRED_LIST:%d EXPIRED:%d ACTIVE+EXPIRED:%d\n",used_session,free_session,active_flows,in_expired_list_flows,expired_flows,active_flows+in_expired_list_flows);
#endif
	while(n != NULL) 
	{

		current_node_session_table=(node_l*)n->data;
		current_session=(IPSession*)current_node_session_table->data;

		aux =(last_packet_timestamp - ((current_session)->lastpacket_timestamp));
#ifdef DP_DEBUG
		logInfoVar("last_packet_timestamp:%lu current_session->lastpacket_timestamp:%lu aux:%lu expiration_flow_time:%lu\n",last_packet_timestamp/US_IN_SEC,current_session->lastpacket_timestamp/US_IN_SEC,aux/US_IN_SEC,EXPIRATION_FLOW_TIME/US_IN_SEC);
#endif
		if ((aux > EXPIRATION_FLOW_TIME))//ha expirado
		{
			
			//sacamos de la tabla hash
			index=getIndex(&(current_session->incoming));
			list_unlink(&(flow_table[index]),current_node_session_table);
			n->data=current_node_session_table->data; //apuntamos directamente a la estructura para poder borrarla
			releaseNodel(current_node_session_table);
			
			node_l* naux=n;
			//avanzamos en la lista de activos
			n = list_get_prev_node(&active_flow_list, n);
			//sacamos de la lista de activos para insertarlo al final de la de expirados por banderas
			list_unlink(&active_flow_list,naux);
			list_append_node(&flags_expired_flow_list,naux);
			#ifdef DP_DEBUG
				num_expired++;
				active_session--;
				expired_session++;
			#endif
		}
		else{
			break;
		}

	}


	int nf=0;
	n=n_flags;
	while(n != NULL) 
	{
		current_node_session_table=(node_l*)n->data;
		current_session=(IPSession*)current_node_session_table->data;
		//sacamos de la tabla hash
		index=getIndex(&(current_session->incoming));
		list_unlink(&(flow_table[index]),current_node_session_table);
		n->data=current_node_session_table->data; //apuntamos directamente a la estructura para poder borrarla
		releaseNodel(current_node_session_table);
		
		//avanzamos en la lista de activos
		n = list_get_prev_node(&flags_expired_flow_list, n);
		#ifdef DP_DEBUG
			num_expired++;
			active_session--;
			expired_session++;
			num_flags--;
		#endif

		nf++;
	}




	//insertar los expirados por tiempo y banderas al final de la lista de expirados (a exportar)
	if(likely(flags_expired_flow_list!=NULL)){
		pthread_mutex_lock(&sem_expired_list);
		node_l* first_expired=list_get_first_node(&expired_flow_list);
		node_l* last_expired=list_get_last_node(&expired_flow_list);
		node_l *last_expired_flags=list_get_last_node(&flags_expired_flow_list);
		node_l *first_expired_flags=list_get_first_node(&flags_expired_flow_list);
		if(first_expired!=NULL){//hay elementos en la lista de expirados
			first_expired->prev=last_expired_flags;
			last_expired->next=first_expired_flags;
			first_expired_flags->prev=last_expired;
			last_expired_flags->next=first_expired;
		}
		else{//lista de expirados vacia
			expired_flow_list=first_expired_flags;
		}
		pthread_mutex_unlock(&sem_expired_list);
	}
	flags_expired_flow_list=NULL;
}




 /**
 * Esta función procesa un paquete perteneciente a un flujo que contiene TCP, UDP o ICMP
 * @param bp
 *	Puntero al inicio de la cabecera de nivel 4 (TCP, UDP o ICMP)
 * @param h
 *	Estructura ::struct pcap_pkthdr que contiene el timestamp del paquete y la longitud del mismo
 * @param ipLen
 *	Longitud en bytes extraída del campo longitud de IP
 * @param ipHLen
 *	Longitud en bytes extraído del campo longitud de la cabecera IP
 * @param skipped
 *	Número de bytes que se han analizado desde el principio del paquete hasta el inicio de la cabecera de nivel 4 (TCP, UDP o ICMP)
 * @return
 *  Esta función no devuelve nada.
 */
void processL4Flow(uint8_t *bp,struct pcap_pkthdr *h,uint16_t ipLen,uint16_t ipHLen,uint16_t skipped){



	
	
	uint16_t dataLen = 0;
	uint16_t tcpHLen = 0;

	IPFlow *aux=&aux_session->incoming;

	/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
	/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

		switch(aux->transport_protocol)
		{
			case TCP_PROTO:
				{
			

				
			
				//Nos saltamos la cabecera IP
				aux->source_port=*((uint16_t*)bp);
				aux->source_port = ntohs (aux->source_port);
				aux->destination_port=*((uint16_t*)(bp+sizeof(uint16_t)));
				aux->destination_port = ntohs (aux->destination_port);

			




				tcpHLen = (((bp[TCP_HLEN_OFFSET] >> 4) & 0x0F) * 4);
				if(unlikely(( (tcpHLen>(ipLen-ipHLen)) || (tcpHLen<TCP_MIN_HLEN)||(tcpHLen>TCP_MAX_HLEN))))
				{
					count_pckts_malformed++;
					return;
				}

				dataLen = ipLen - ipHLen - tcpHLen;
			
				
			
				if(unlikely(dataLen>MAX_JUMBO_SIZE))//Malformed packets
					dataLen=0;
				
				
				aux_session=insertFlow(aux_session);
			
				


				}
			break;
			case UDP_PROTO:
				{
		
					
				
					aux->source_port=*((uint16_t*)bp);
					aux->source_port = ntohs (aux->source_port);
					aux->destination_port=*((uint16_t*)(bp+sizeof(uint16_t)));
					aux->destination_port = ntohs (aux->destination_port);
				

					if(unlikely(UDP_HLEN>(ipLen-ipHLen)))
					{
						count_pckts_malformed++;
						return;
					}
					dataLen=ipLen-ipHLen-UDP_HLEN;

			
			
			
					if(unlikely(dataLen>MAX_JUMBO_SIZE))//Malformed packets
						dataLen=0;
			
					
					aux_session=insertFlow(aux_session);
			

				}
			break;
			case ICMP_PROTO:
				{

				
					//El puerto será tipo y código de ICMP
					aux->source_port = bp[ICMP_TYPE_OFF];
					aux->destination_port = bp[ICMP_CODE_OFF];
					dataLen=ipLen-ipHLen-ICMP_HLEN;
					//PRUEBAS PAYLOAD


					aux_session=insertFlow(aux_session);
			

				}
			break;
		
		}
	
}

