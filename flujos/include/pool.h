#ifndef __POOL_H
#define __POOL_H
#include <IPflow.h> 




IPSession* getIPSession(void);
void releaseIPSession(IPSession* f);
void allocIPSessionPool(uint64_t nNetworks);
void freeIPSessionPool(uint64_t nNetworks);
uint32_t getIndex (IPFlow * flow);
void updateMembershipSize(uint64_t nNetworks);
#endif
