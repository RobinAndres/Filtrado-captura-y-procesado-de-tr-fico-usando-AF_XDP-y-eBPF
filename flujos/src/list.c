/*  Copyright (c) 2006-2008, Philip Busch <broesel@studcs.uni-sb.de>
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright notice,
 *     this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 *  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 *  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 *  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 *  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 *  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 *  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 *  POSSIBILITY OF SUCH DAMAGE.
 */

/**
  @file list.c
  @brief Este fichero contiene funciones de inicialización y gestión de listas doblemente enlazadas.


*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <numa.h>
#include <list.h>



 #define MAX_POOL_NODE 5000

/**Nodo estático usado para evitar la reserva de memoria al hacer comparaciones y búsquedas en listas*/
extern node_l static_node;

/**Nodo auxiliar usado para comparaciones e inserciones*/
extern node_l *nodel_aux;
/**Lista prereservada con punteros a nodos vacíos (utilizables)*/
node_l *nodel_pool_free=NULL;
/**Lista prereservada con punteros a nodos usados (no utilizables)*/
node_l *nodel_pool_used=NULL;
/**Contador de nodos libres*/
uint64_t free_nodes;


/**Contador de sesiones totales*/
uint64_t total_nodes;



/**Semáforo que regula el acceso a la lista de nodos prereservados por parte de los hilos de export y process*/
pthread_mutex_t sem_pool_node = PTHREAD_MUTEX_INITIALIZER;


/**
 * Función que devuelve el primer nodo de una lista
 * @param list
 * 	Lista a procesar
 * @return
 *   La función devuelve el primer nodo. Si la lista es NULL se sale con un assert.
 */
node_l *list_get_first_node(node_l **list)
{
	assert(list != NULL);

	return(*list);
}

/**
 * Función que devuelve elúltimo nodo
 * @param list
 * 	Lista a procesar
 * @return
 *   La función devuelve el último nodo. Si la lista es NULL se sale con un assert. Se devuelve el último sin necesidad de recorrer toda la lista para
 *   aumentar la eficiencia haciendo uso de una lista circular.
 */
node_l *list_get_last_node(node_l **list)
{
	assert(list != NULL);

	if(*list == NULL) {
		return(NULL);
	} else {
		return((*list)->prev);
	}
}

/**
 * Función que reserva un nodo de la lista
 * @param data
 * 	Datos a insertar dentro del nodo
 * @return
 *   La función devuelve el nodo reservado o NULL si no se ha podido reservar.
 */
node_l *list_alloc_node(void *data)
{
	node_l *n = NULL;
		if((n = malloc(sizeof(node_l))) != NULL) {
			n->data = data;
		}

	return(n);
}
/**
 * Función que asigna al nodo stático static_node los datos apuntados por data. Esta función evita el overhead de reservar un nodo cuando lo único que queremos
 *  es un nodo auxiliar para buscar en una lista. 
 * @param data
 * 	Datos a insertar dentro del nodo estático
 * @return
 *   La función no devuelve nada pero cambia el valor del campo data d ela variable static_node.
 */
void list_alloc_node_no_malloc(void *data)
{

	static_node.data = data;

}

/**
 * Función que inserta un nodo por la parte delantera de la lista.
 * @param list
 * 	Lista en la que se va a insertar
 * @param node
 *	Nodo que se debe insertar como primer elemento de la lista
 * @return
 *   La función no devuelve nada. Si list o node son NULL se sale del programa con un assert.
 */
void list_prepend_node(node_l **list,
		node_l  *node)
{
	assert(list != NULL);
	assert(node != NULL);
	node_l *here=*list;
	if(*list == NULL) {
		node->prev = node;
		node->next = node;
		*list = node;
	} else {
		assert(here != NULL);

		node->prev = here->prev;
		node->next = here;
		here->prev = node;
		if(node->prev!=NULL)
			node->prev->next = node;

		if(here == *list) {
			*list = node;
		}
	}
}
/**
 * Función que inserta un nodo por la parte trasera de la lista.
 * @param list
 * 	Lista en la que se va a insertar
 * @param node
 *	Nodo que se debe insertar como primer elemento de la lista
 * @return
 *   La función no devuelve nada. Si list o node son NULL se sale del programa con un assert.
 */
void list_append_node(node_l **list,
		node_l *node)
{
	assert(list!=NULL);
	assert(node != NULL);
	list_prepend_node(list,node);
	*list=(*list)->next;
}

/**
 * Función que busca un nodo en una lista
 * @param list
 * 	Lista en la que se va a buscar
 * @param node_to_find
 *	Nodo a encontrar
 * @param cmp
 *	Función de comparación que debe usarse para determinar si dos nodos son iguales
 * @return
 *   La función devuelve un puntero a ::node_l en caso de que se encuentre el nodo en la lista o NULL en caso contrario.
 */

node_l * list_search(node_l **list,node_l *node_to_find,int cmp(void *, void *))
{
	node_l *n;

	assert(list != NULL);

	n = *list;

	while(n != NULL) {
		//printf("n:%p n->data:%p\n",n,n->data);
		if(cmp(n->data,node_to_find->data)==0)
			return n;

		n = list_get_next_node(list, n);
	}

	return NULL;
}
/**
 * Función que elimina un nodo de la lista
 * @param list
 * 	Lista de la cual se va a eliminar el nodo
 * @param node
 *	Nodo a eliminar
 * @return
 *   La función no devuelve nada. Si la lista o el nodo son NULL se sale con un assert.
 */

void list_unlink(node_l **list,
		node_l  *node)
{
	assert(list != NULL);
	assert(node != NULL);

	if(node->next == node) {
		*list = NULL;
	} else {
		if(node->prev!=NULL)
			node->prev->next = node->next;
		if(node->next!=NULL)
			node->next->prev = node->prev;

		if(*list == node)
			*list = node->next;
	}

	node->next = NULL;
	node->prev = NULL;
}
/**
 * Función que extrae el primer nodo de la lista
 * @param list
 * 	Lista de la cual se va a extraer el nodo
 * @return
 *   La función devuelve el primer nodo de la lista. Si la lista es NULL se sale con un assert.
 */

node_l *list_pop_first_node(node_l **list)
{
	node_l *n;

	assert(list != NULL);

	n = list_get_first_node(list);

	if(n != NULL)
		list_unlink(list, n);

	return(n);
}
/**Array de nodos (pool) prereservados al principio de la ejecución*/
node_l *nl;
/**Esta función reserva un pool de estructuras ::node_l. El tamaño del pool de nodos se lee del fichero de config
 * Todos los pool tienen una lista de estructuras usadas y otra de estructuras libres.
 * @return
 *   La función no devuelve nada.
 */
void allocNodelPool(void)
{
	int i=0;
	node_l *n=NULL;
		nl=malloc(sizeof(node_l)*MAX_POOL_NODE);
	bzero(nl,sizeof(node_l)*MAX_POOL_NODE);
	assert(nl!=NULL);
	for(i=0;i<MAX_POOL_NODE;i++)
	{
		n=list_alloc_node(nl+i);
		list_prepend_node(&nodel_pool_free,n);
	}
	free_nodes=MAX_POOL_NODE;
	total_nodes=free_nodes;
		

}

/**Esta función devuelve el puntero a un nodo de la lista en la variable global nodel_aux; No se retorna desde la función para evitar sobrecarga ya que es una función que se llama mucho. La lista de nodos
 * está protegida por un semáforo ya que el hilo de proceso toma estructuras de esta lista mientras que el de export las devuelve al pool.
 * Todos los pool tienen una lista de estructuras usadas y otra de estructuras libres.
 * @return
 *   La función devuelve 0 si se ha podido sacar un nodo o -1 en caso contrario.
 */
int getNodel(void)
{

	pthread_mutex_lock(&sem_pool_node);

	node_l *n=list_pop_first_node(&nodel_pool_free);
	if(nodel_pool_free==NULL){
		list_append_node(&nodel_pool_free,n);
		pthread_mutex_unlock(&sem_pool_node);
		logError("Pool de nodos vacío");
		return -1;
	}
	list_append_node(&nodel_pool_used,n);
	assert(n!=NULL);
	nodel_aux=n->data;
	free_nodes--;
	pthread_mutex_unlock(&sem_pool_node);

	return 0;

}
/**Esta función devuelve el nodo apuntado por f a la lista de nodos disponibles. La lista de nodos
 * está protegida por un semáforo ya que el hilo de proceso toma estructuras de esta lista mientras que el de export las devuelve al pool.
 * @param f
 * 	Puntero al nodo a devolver a la lista
 *  @return 
 *	La función no devuelve nada
 */
void releaseNodel(node_l* f)
{

	assert(f!=NULL);
	pthread_mutex_lock(&sem_pool_node);

	node_l *n=list_pop_first_node(&nodel_pool_used);
	n->data=(void*)f;
	list_append_node(&nodel_pool_free,n);
	free_nodes++;
	pthread_mutex_unlock(&sem_pool_node);


}
/**Esta función libera el pool de nodos liberando los elementos de cada una de las listas.
*   Esta función no libera los punteros a datos que deben ser liberados específicamente antes de llamar a esta función.
*   @return 
*	Esta función no devuelve nada.
*/
void freeNodelPool(void)
{
	node_l *n=NULL;
	while(nodel_pool_free!=NULL)
	{
		n=list_pop_first_node(&nodel_pool_free);
			free(n);
	}

	while(nodel_pool_used!=NULL)
	{
		n=list_pop_first_node(&nodel_pool_used);
			free(n);
	}
		free(nl);
}
