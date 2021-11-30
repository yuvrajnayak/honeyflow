#!/bin/bash

# kill mitm 
countpid=$(ps aux | grep "node" | grep -v "grep" | wc -l)

for i in $(seq $countpid); do
  pid=$(ps aux | grep "node" | grep -v "grep" | awk 'NR == 1 {print $2}')
  kill -9 $pid
done

# call recycling script on all four containers. 
# script will not run if a user is currently logged on.
/honeyflow/mongoRecycling.sh m1 mongoTemplate
/honeyflow/mongoRecycling.sh m2 mongoTemplate
/honeyflow/sqlRecycling.sh s1 mysqlTemplate
/honeyflow/sqlRecycling.sh s2 mysqlTemplate

# delete current ip rules
counts=$(sudo iptables --table nat --list --numeric --verbose | grep -c SNAT)
countd=$(sudo iptables --table nat --list --numeric --verbose | grep -c DNAT)

for i in $(seq $countd); do
  sudo iptables --table nat --delete PREROUTING 1
done

for i in $(seq $counts); do
  sudo iptables --table nat --delete POSTROUTING 1
done

# delete old ban list
count_input=$((`sudo iptables --list INPUT --numeric --verbose | wc -l` - 6))
for i in $(seq $count_input); do
  sudo iptables -D INPUT 1
done

# add new ban list
for line in $(cat /root/MITM_data/logins/* | cut -d ";" -f 2 | sort | uniq)
do
  iptables -I INPUT -s $line -j DROP
  echo "$line banned!"
done

# mitm for all 4 containers
iplist=('128.8.238.102' '128.8.238.123' '128.8.238.77' '128.8.238.66')
iplist=( $(shuf -e "${iplist[@]}") )

cp /honeyflow/banners/no_honey_motd.txt /var/lib/lxc/m1/rootfs/etc/motd
cp /honeyflow/banners/email_phone_motd.txt /var/lib/lxc/m2/rootfs/etc/motd
cp /honeyflow/banners/research_data_motd.txt /var/lib/lxc/s1/rootfs/etc/motd
cp /honeyflow/banners/high_perf_motd.txt /var/lib/lxc/s2/rootfs/etc/motd

/honeyflow/mitmSetup.sh m1 ${iplist[0]} 10005
/honeyflow/mitmSetup.sh m2 ${iplist[1]} 10006
/honeyflow/mitmSetup.sh s1 ${iplist[2]} 10007
/honeyflow/mitmSetup.sh s2 ${iplist[3]} 10008


