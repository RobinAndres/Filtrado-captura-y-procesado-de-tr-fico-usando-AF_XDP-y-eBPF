
CFLAGS = -g -O3 -pedantic -Wall -D_GNU_SOURCE -Iinclude -Ilibs/xdp -c -std=gnu99
LDFLAGS= -lpcap -lm -lpthread  -lnuma -lxdpFlow
EXEC_NAME="flujos"

OBJS = \
./src/comm.o \
./src/list.o \
./src/date.o \
./src/export.o \
./src/pool.o \
./src/IPflow.o \
./src/log.o \
./src/dp.o


%.o: %.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc $(CFLAGS) -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '



all: flujos
.PHONY=clean

flujos: $(OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: GCC C Linker'
	mkdir -p bin
	gcc  -o bin/$(EXEC_NAME) $(OBJS) $(LDFLAGS)
	@echo 'Finished building target: $@'
	@echo ' '
clean:
	rm -rf bin/$(EXEC_NAME) bin/$(EXEC_NAME_SIZE) $(OBJS)
	@true






