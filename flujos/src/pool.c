/**
  @file pool.c
  @brief Este fichero contiene funciones de inicialización y gestión del pool de estructuras ::IPSession.
*/
#include <pool.h>
#define MAX_POOL_NODE 5000
#define MAX_FLOW_TABLE_SIZE 60000

/**Lista de estructuras ::IPSession libres (se usa para gestionar el pool)*/
node_l *ip_session_pool_free=NULL;
/**Lista de estructuras ::IPSession usadas (se usa para gestionar el pool)*/
node_l *ip_session_pool_used=NULL;





/**Array de estructuras ::IPSession que se preserva para formar el pool*/
IPSession *ips=NULL;



/**Contador de sesiones usadas. Se muestra cada cierto tiempo por log*/
uint64_t used_session;
/**Contador de sesiones libres. Se muestra cada cierto tiempo por log*/
uint64_t free_session;



/**Semáforo que protege el pool de sesiones*/
pthread_mutex_t sem_pool_session = PTHREAD_MUTEX_INITIALIZER;

/**Estructura ::pthread_t para el hilo principal*/
extern pthread_t main_thread;



 /**
 * Esta función reserva un pool de estructuras ::IPSession.
 * Por defecto el tamaño de la sesión es la mitad del tamaño de pool de nodos.
 * Si es necesario puede añadirse en el fichero de configuración un valor específico para este tamaño.
 * Todos los pool tienen una lista de estructuras usadas y otra de estructuras libres.
 * @param nNetworks
 *	Número de redes leídas del fichero networks.cfg
 * @return
 *   La función no devuelve nada. En caso de que falle alguna reserva hay un assert que lo controla y se para el programa.
 */
void allocIPSessionPool(uint64_t nNetworks)
{

	
	int i=0;
	node_l *n=NULL;
	
		ips=calloc(MAX_POOL_NODE/2,sizeof(IPSession));
	assert(ips!=NULL);
	bzero(ips,(MAX_POOL_NODE/2)*sizeof(IPSession));
	for(i=0;i<(MAX_POOL_NODE/2);i++)
	{
	
			
		n=list_alloc_node(ips+i);
		list_prepend_node(&ip_session_pool_free,n);
	}

	used_session=0;
	free_session=(MAX_POOL_NODE/2);
	
	
}
 /**
 * Esta función obtiene una estructura ::IPSession sacándola de la lista de 
 * estructuras libres.
 * Es necesario un lock en la función porque tanto el hilo de proceso como el de export trabajan sobre
 * el pool de estructuras (el primero para obtener estucturas y el segundo para devolverlas). En caso de que no haya nodos suficientes en el pool se para la ejecución del programa
 *   porque si no se perderían sesiones o flujos. Como posible modificación si no se quiere parar habría que devolver NULL y controlar desde el hilo de 
 *   proceso que no se hagan más flujos hasta que haya epsacio disponible.
 * @return
 *   La función siempre devuelve un puntero a ::IPSession. 
 */
IPSession * getIPSession(void)
{
	pthread_mutex_lock(&sem_pool_session);

	node_l *n=list_pop_first_node(&ip_session_pool_free);

	if(ip_session_pool_free==NULL)
	{
		if(n==NULL)
		{
			printf("Aquí no tendría que entrar nunca\n");
			exit(-1);
		}
		list_append_node(&ip_session_pool_free,n);
		pthread_mutex_unlock(&sem_pool_session);
		logErrorCount("Pool de flujos vacío",MEMORY_ERROR);
		return NULL;
	}
	list_append_node(&ip_session_pool_used,n);

	used_session++;
	free_session--;
	
	__builtin_prefetch(ip_session_pool_free->next);
	pthread_mutex_unlock(&sem_pool_session);

	
	
	return  (n->data);

}
 /**
 * Esta función toma una estructura ::IPSession y la devuelve a la lista de nodos libres. 
 * Es necesario un lock en la función porque tanto el hilo de proceso como el de export trabajan sobre
 * el pool de estructuras (el primero para obtener estucturas y el segundo para devolverlas). 
 * @param f
 * Estructura ::IPSession a devolver al pool de Nodos.
 * @return
 *   La función no devuelve nada. 
 */
void releaseIPSession(IPSession * f)
{



	pthread_mutex_lock(&sem_pool_session);
	
	
	memset(&(f->incoming),0,sizeof(IPFlow));
		
	


	node_l *n=list_pop_first_node(&ip_session_pool_used);
	n->data=(void*)f;
	list_append_node(&ip_session_pool_free,n);

	used_session--;
	free_session++;
	

	pthread_mutex_unlock(&sem_pool_session);

}
 /**
 * Esta función libera la memoria del pool de nodos y vacía las listas de usados y libres
 * @return
 *   La función no devuelve nada. 
 */
void freeIPSessionPool(uint64_t nNetworks)
{
	node_l *n=NULL;
	while(ip_session_pool_free!=NULL)
	{
		n=list_pop_first_node(&ip_session_pool_free);
			free(n);
	}
	//TODO free memberships
	while(ip_session_pool_used!=NULL)
	{
		n=list_pop_first_node(&ip_session_pool_used);
			free(n);
	}
	
	
		free(ips);
}






 /**
 * Esta función toma un flujo y devuelve la posición que le corresponde en la tabla hash de flujos. Se usa un hash sencillo basado en las sumas
 * de los campos y un módulo para controlar que no desborde el tamaño de la tabla. Adicionalmente se puede usar la función hash de BOB si se quiere menor tasa de colisión. 
 * TODO-> se puede añadir la VLAN o MPLS para aumentar la dispersión aunque la vlan se mira en las funciones ::compareTupleFlow y ::compareTupleFlowList
 * @return
 *  Esta función devuelve un entero de 32 bits con la posición dentro de la tabla hash donde el flujo debe ser insertado.
 */
uint32_t getIndex(IPFlow * flow)
{


	return (flow->source_ip + flow->destination_ip + flow->source_port + flow->destination_port + flow->transport_protocol)%(MAX_FLOW_TABLE_SIZE);
	//return hashlittle((const void*)flow,13,0xDEADBEEF)&hashmask(24);

}

