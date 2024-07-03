# Filtrado, captura y procesado de tráfico usando AF_XDP y eBPF
Este proyecto propone 3 escenarios, de captura, filtrado y procesado de tráfico. Se ha realizado en una distribución de Ubuntu 22.04 con una
versión del núcleo 5.15.0-76. La CPU es el Intel Xeon X5660 de 6 núcleos y con 96 Gb de RAM DDR3. Con dos tarjetas Intel 82599ES 10 Gigabit Ethernet Controller en modo loopback, con driver ixgbe 5.18.11 de Intel. 

## Instalación
Este proyecto utiliza `libxdp` y `libbpf` para cargar y gestionar programas XDP. Se necesitarán varias dependencias para poder ejecutar correctamente.

```bash
git clone https://github.com/RobinAndres/Filtrado-captura-y-procesado-de-trafico-usando-AF_XDP-y-eBPF/
git submodule add https://github.com/xdp-project/xdp-tools/ xdp-tools
git submodule add https://github.com/libbpf/libbpf/ libbpf
```
## Dependencias
```bash
sudo apt install linux-tools-$(uname -r)
```

Para las cabeceras del Kernel
```bash
sudo apt install linux-headers-$(uname -r)
```

Además para poder inspeccionar los programas eBPF y mapas, la herramienta bpftool es muy útil:
```bash
sudo apt install linux-tools-common linux-tools-generic
```

Por último, para generar paquetes a alta tasa es necesario utilizar PKTGEN.
```bash
git clone https://github.com/danieltt/pktgen.git
cd pktgen
make
sudo insmod ./pktgen.ko
```

## Escenario 1
Para el escenario 1, estando en la carpeta y una vez compilado.
```bash
sudo ip link set dev [NIC0] xdp off
sudo ./af_xdp_user -d [NIC0] -Q [número de cola] --filename af_xdp_kern.o
```

Posteriormente para configurar las tarjetas de red y enviar el tráfico. Es importante configurar correctamente los parámetros en el script proporcionado de PKTGEN(send10.bash)
```bash
sudo ethtool -K [NIC0] ntuple on
sudo ethtool -L [NIC0] combined 5
sudo ethtool -N [NIC0] flow-type udp4 action 1 #Filtro UDP4 a la cola 1
sudo ifconfig [NIC0] [IP0]
sudo ifconfig [NIC1] [IP1]
sudo ./send10.bash [Número de paquetes a enviar] [núcleos de la cpu] #Script para generar tráfico con PKTGEN
```
## Escenario 2


## Escenario 3
Para ejecutar el programa de flujos, previamente es necesario cambiar el nombre de la NIC en la variable macro
```bash
sudo ./bin/flujos
```
E instantáneamente se ejecuta el script de PKTGEN o tcpreplay con cualquier captura de traza. En nuestro caso:
```bash
sudo ./send10.bash [Número de paquetes a enviar] [núcleos de la cpu]
```
