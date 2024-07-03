/**
  @file log.c
  @brief Este fichero contiene funciones para hacer abrir y escribir a los logs del detectpro. 


*/

#include <log.h>



/**Variable para tener en cuenta el número de mensajes de error mostrados */
uint64_t message_count[NUM_ERROR_TYPES]={0};

/**
  @file log.c
  @brief Este fichero contiene funciones para mostrar mensajes de log.
*/
/**Puntero a fichero de log del monitor.*/
FILE *dplog=NULL;


/**
 * Función que inicia el proceso de log.
 *
 * @param pathToLog
 *	Ruta al fichero de log. Si se pasa el valor stderr saca los parámetros por stderr en vez de volcarlos a fichero.
 * @return
 *	La función devuelve 0 si todo va bien o -1 si no se ha podido abrir el fichero de log.
 */
int startLog(char *pathToLog)
{

	if(strcmp(pathToLog,"stderr")==0)
	{
		dplog=stderr;
	}
	else if((dplog=fopen(pathToLog,"a+"))==NULL)
	{
		fprintf(stderr,"Error creating log file\n");
		return -1;
	}
	time_t t = time(NULL);
	struct tm tm = *localtime(&t);

	fprintf(dplog,"----------------- Nueva Sesion (%02d:%02d:%02d %02d-%02d-%02d) -----------------\n",tm.tm_hour, tm.tm_min, tm.tm_sec,tm.tm_mday,tm.tm_mon + 1,tm.tm_year + 1900);

	return 0;
}

/**
 * Función que genera logs con nivel INFO y lista de argumentos variable
 *
 * @param fmt
 *	Cadena de formato (similar a la de printf)
 * @param ...
 *	Variables asociadas al formato anteriormente especificado
 * @return
 *	La función no devuelve nada
 */
void logInfoVar(char *fmt,...)
{
	va_list arg;
	time_t t = time(NULL);
	struct tm tm = *localtime(&t);

	fprintf(dplog,"(%02d:%02d:%02d %02d-%02d-%02d) INFO: ",tm.tm_hour, tm.tm_min, tm.tm_sec,tm.tm_mday,tm.tm_mon + 1,tm.tm_year + 1900);
	va_start(arg, fmt);
	vfprintf(dplog, fmt, arg);
	va_end(arg);
}
/**
 * Función que genera logs con nivel ERROR y lista de argumentos variable
 *
 * @param fmt
 *	Cadena de formato (similar a la de printf)
 * @param ...
 *	Variables asociadas al formato anteriormente especificado
 * @return
 *	La función no devuelve nada
 */
void logErrorVar(char *fmt,...)
{
	va_list arg;
	time_t t = time(NULL);
	struct tm tm = *localtime(&t);

	fprintf(dplog,"(%02d:%02d:%02d %02d-%02d-%02d) ERROR: ",tm.tm_hour, tm.tm_min, tm.tm_sec,tm.tm_mday,tm.tm_mon + 1,tm.tm_year + 1900);
	va_start(arg, fmt);
	vfprintf(dplog, fmt, arg);
	va_end(arg);
}

/**
 * Función que genera logs con nivel INFO
 *
 * @param message
 *	Cadena a mostrar
 * @return
 *	La función no devuelve nada
 */
void logInfo(char *message)
{
	time_t t = time(NULL);
	struct tm tm = *localtime(&t);

	fprintf(dplog,"(%02d:%02d:%02d %02d-%02d-%02d) INFO: %s\n",tm.tm_hour, tm.tm_min, tm.tm_sec,tm.tm_mday,tm.tm_mon + 1,tm.tm_year + 1900,message);
	fflush(dplog);
}


/**
 * Función que genera logs con formato reducido para minimizar el impacto en el rendimiento
 *
 * @param time
 *	Entero de 64 bits con el tiempo a mostrar
 * @param message
 *	Mensaje a mostrar en el log
 * @return
 *	La función no devuelve nada
 */
void logHighPerformance(uint64_t time,char *message)
{
	fprintf(dplog,"%"PRIu64" HP: %s\n",time,message);

}

/**
 * Función que genera logs con nivel ERROR
 *
 * @param message
 *	Cadena a mostrar
 * @return
 *	La función no devuelve nada
 */
void logError(char *message)
{
	time_t t = time(NULL);
	struct tm tm = *localtime(&t);

	fprintf(dplog,"(%02d:%02d:%02d %02d-%02d-%02d) ERROR: %s\n",tm.tm_hour, tm.tm_min, tm.tm_sec,tm.tm_mday,tm.tm_mon + 1,tm.tm_year + 1900,message);
	fflush(dplog);

}
/**
 * Función de log con nivel ERROR que muestra mensajes solo cada cierto número de errores de
 * cada tipo. Este sirve para evitar que se llene el log cuando hay fallos en el disco o similares.
 *
 * @param message 
 *	Mensaje a mostrar
 * @param error
 *	El número de error a mostrar
 * @return
 *	La función no devuelve nada
 */
void logErrorCount(char *message,int error)
{
	
	if(error < NUM_ERROR_TYPES)
	{
		if(message_count[error]==0 || message_count[error] >= MESSAGE_COUNT_LIMIT)
		{
			time_t t = time(NULL);
			struct tm tm = *localtime(&t);

			fprintf(dplog,"(%02d:%02d:%02d %02d-%02d-%02d) ERROR: %s\n",tm.tm_hour, tm.tm_min, tm.tm_sec,tm.tm_mday,tm.tm_mon + 1,tm.tm_year + 1900,message);
			fflush(dplog);

			message_count[error]=1;
		}

		message_count[error]++;
	}
}
/**
 * Función que para el proceso de log.
 *
 * @return
 *	La función devuelve 0.
 */
int stopLog()
{
	if(dplog==NULL)
		return -1;

	time_t t = time(NULL);
	struct tm tm = *localtime(&t);

	fprintf(dplog,"-----------------  Fin Sesion (%02d:%02d:%02d %02d-%02d-%02d)  -----------------\n",tm.tm_hour, tm.tm_min, tm.tm_sec,tm.tm_mday,tm.tm_mon + 1,tm.tm_year + 1900);

	fflush(dplog);
	if(dplog!=stderr)
		fclose(dplog);
	return 0;
}

