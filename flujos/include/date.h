#ifndef DATE_H
#define DATE_H

#include <time.h>
#include <stdlib.h>
#include <stdint.h>


/**Macro que define el número de dias en una semana. Usado en conversión de fechas*/
#define DAYS_IN_WEEK 7
/**Macro que define el año base de las estructura tm. Usado en conversión de fechas*/
#define BASE_YEAR 1900
/**Macro que define el número de meses en una año. El 11 es porque la struct tm cuenta los meses de 0 a 11.Usado en conversión de fechas*/
#define MONTH_YEAR 11

/**Macro que define el número segundos en un día. Usado en conversión de fechas*/
#define SECONDS_IN_DAY 86400


void day_second_number(time_t timestamp,uint16_t *day,uint32_t *second);

void week_number(time_t timestamp,uint16_t *year,uint16_t *week);
int32_t get_timezone_offset(char *tz,time_t current);

#endif
