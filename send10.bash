#! /bin/bash
# $1 Rate in packets per s
# $2 Number of CPUs to use
function pgset() {
    local result
    echo $1 > $PGDEV
}

# Config Start Here -----------------------------------------------------------

# thread config
PKTS=$1
CORE=$2
CLONE_SKB="clone_skb 1"
PKT_SIZE="pkt_size 1500"
COUNT="count $PKTS"
DELAY="delay 0"
MAC="90:e2:ba:82:6c:95" #enp3s0f1
ETH="enp3s0f1" 

for ((processor=0;processor<12;processor++))
do
 PGDEV=/proc/net/pktgen/kpktgend_$processor
  echo "Removing all devices"
 pgset "rem_device_all"
done



PGDEV=/proc/net/pktgen/kpktgend_$CORE
  echo "Adding $ETH"
 pgset "add_device $ETH@$CORE"
 
PGDEV=/proc/net/pktgen/$ETH@$CORE
  echo "Configuring $PGDEV"
 pgset "$COUNT"
 pgset "flag QUEUE_MAP_CPU"
 pgset "$CLONE_SKB"
 pgset "$PKT_SIZE"
 pgset "$DELAY"
 pgset "src_min 10.0.0.1" #192.168.1.2
 pgset "src_max 10.0.0.1" #Para generar 1000 direcciones ip diferentes
 pgset "dst 10.0.0.10" #enp3s0f1
 pgset "dst_mac $MAC" #enp3s0f1
 pgset "udp_dst_min 9001"
 pgset "udp_dst_max 9004"
 pgset "udp_src_min 3000"
 pgset "udp_src_max 3000"
 pgset "tos 00"
# Time to run
PGDEV=/proc/net/pktgen/pgctrl

 echo "Running... ctrl^C to stop"
 pgset "start" 
 echo "Done"

cat /proc/net/pktgen/$ETH@$CORE
