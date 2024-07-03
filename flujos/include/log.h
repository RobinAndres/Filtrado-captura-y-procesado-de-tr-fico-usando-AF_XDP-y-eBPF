#ifndef __LOG__H
#define __LOG__H

/**Macro que define el número de errores que deben producirse antes de mostrar un evento en el log para logs con contabilización de errores (función ::logErrorCount)*/
#define MESSAGE_COUNT_LIMIT 50000
/**Macro que asigna a los errores de disco el valor 0*/
#define DISK_ERROR 0
/**Macro que asigna a los errores de disco el valor 0*/
#define MEMORY_ERROR 1
/**Macro que define cuántos tipos de errores con conteo variable se van a considerar*/
#define NUM_ERROR_TYPES 2

#include<stdio.h>
#include<stdlib.h>
#include<time.h>
#include<stdint.h>
#include <inttypes.h>
#include <stdarg.h>
#include <string.h>
int startLog();
void logInfo(char *message);
void logHighPerformance(uint64_t time,char *message);
void logError(char *message);
void logErrorCount(char *message,int error);
void logInfoVar(char *fmt,...);
void logErrorVar(char *fmt,...);
int stopLog();
#endif
