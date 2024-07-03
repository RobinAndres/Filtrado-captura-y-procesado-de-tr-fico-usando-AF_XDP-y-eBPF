# Filtrado, captura y procesado de tráfico usando AF_XDP y eBPF
Este proyecto propone 3 escenarios, de captura, filtrado y procesado de tráfico.

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
