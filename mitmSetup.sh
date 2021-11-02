#!/bin/bash
if [ $# -ne 3 ]
then
  echo "usage: hw11 [container name] [external IP] [port]"
else
  ip=$(sudo lxc-info -n $1 -iH)
  hostip=`hostname -I | cut -d' ' -f1`
  fname=$(date --iso-8601=s)
  sudo nohup node /MITM/mitm/index.js HACS200_1A $3 $ip $1 false mitm.js &> /logs/MITM/$1/$fname-$1.log &
  sudo ip addr add $2/"16" dev enp4s1
  sudo iptables --table nat --insert PREROUTING --source 0.0.0.0/0 --destination $2 --jump DNAT --to-destination $ip
  sudo iptables --table nat --insert POSTROUTING --source $ip --destination 0.0.0.0/0 --jump SNAT --to-source $2
  sudo iptables --table nat --insert PREROUTING --source 0.0.0.0/0 --destination $2 --protocol tcp --dport 22 --jump DNAT --to-destination $hostip:$3
fi
