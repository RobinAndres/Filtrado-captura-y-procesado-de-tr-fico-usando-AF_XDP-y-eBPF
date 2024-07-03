#ifndef EXPORT_H
#define EXPORT_H
#include <IPflow.h>
#include <pool.h>


/**Esta estructura contiene la información necesaria para realizar el volcado de los ficheros de flujos y payload*/
typedef struct exportFiles
{ 
	/*@{*/
	FILE *flow_file_txt; /**<Puntero al fichero de escritura de flujos/sesiones*/
 	/*@}*/
}exportFiles;

/**Puntero a función de exportación de datos. Toda función de exportación de datos debe recibir obligatoriamente una estuctura ::IPSession y otra ::exportFiles*/
typedef void(*export_data_fn)(IPSession *session,exportFiles *e);

/**Esta estructura almacena datos relativos al hilo de exportación (en concreto el affinity del hilo y un puntero a la función de exportación a usar)*/
typedef struct exportAttributes

{
    /*@{*/
	int8_t affinity_export;/**< Número de core donde debe ejecutarse el hilo de export*/
	export_data_fn export_data;/**< Púntero a función a ejecutar para exportar*/
    /*@}*/
}exportAttributes;



void printTupleFileText(IPSession *session,exportFiles *e);
void printTupleFileTextAndBin (IPSession *session,exportFiles *e);



void *exportThread(void *parameter);
#endif
