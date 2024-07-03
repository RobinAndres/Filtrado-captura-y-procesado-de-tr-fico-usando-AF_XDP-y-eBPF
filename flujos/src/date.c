/**
  @file date.c
  @brief Este fichero contiene funciones auxiliares relacionadas con fecha y hora. 


*/

#include <date.h>

/**
 * Esta función devuelve el número de día y segundo dado un timestamp. Esta función y :week_number pueden fusionarse en una sola.
 * @param timestamp
	Estructura ::time_t que contiene el timestamp
   @param day
	Entero que se rellenará con el número de día
   @param second
	Entero que se rellenará con el segundo
   @return
	La función no devuelve nada
*/

void day_second_number(time_t timestamp,uint16_t *day,uint32_t *second)
{
	struct tm *struct_timestamp;

    struct_timestamp=gmtime(&timestamp);
    *day=(*struct_timestamp).tm_wday;
    if(*day==0) *day=7; //Domingo es 7, en lugar de 0

    *second=((*struct_timestamp).tm_hour*60*60)+((*struct_timestamp).tm_min*60)+(*struct_timestamp).tm_sec;

}
/**
 * Esta función devuelve el número de año y semana dado un timestamp. Esta función y :day_second_number pueden fusionarse en una sola.
 * @param timestamp
	Estructura ::time_t que contiene el timestamp
   @param year
	Entero que se rellenará con el número de año
   @param week
	Entero que se rellenará con el número de semana
   @return
	La función no devuelve nada
*/
void week_number(time_t timestamp,uint16_t *year,uint16_t *week){
	struct tm *struct_timestamp;
	struct_timestamp=gmtime(&timestamp);
	*year=BASE_YEAR+struct_timestamp->tm_year;
	int correction = (struct_timestamp->tm_wday == 0) ? DAYS_IN_WEEK  : struct_timestamp->tm_wday;
	*week = ((struct_timestamp->tm_yday + MONTH_YEAR - correction) / DAYS_IN_WEEK );
		
}

/**
 * Función que obtiene el offset de una zona horaria para un instante temporal determinado.
 * @param timezone
 *	Zona horaria como cadena de texto
 * @param current
 *	El tiempo en el que obtener el offset. Necesario por los cambios horarios
 * @return 
 *	Devuelve el offset de la zona temporal, teniendo en cuenta los horarios de verano.
 */
inline int32_t get_timezone_offset(char *timezone,time_t current)
{
	//Guardar timezone anterior
	char *local_timezone;
	struct tm *local;
	int32_t offset;

	//Guardar timezone anterior
	local_timezone=getenv("TZ");

	//Cambiar timezone al indicado
	setenv("TZ", timezone, 1);
	tzset();

	local=localtime(&current);
	offset=local->tm_gmtoff;

	//Volver al timezone anterior
	if (local_timezone != NULL) 
	{
        setenv("TZ", local_timezone, 1);
        free(local_timezone);
    } 
    else 
        unsetenv("TZ");

    return offset;
}

