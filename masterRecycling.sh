#!/bin/bash

# kill mitm 
countpid=$((`ps aux | grep -c "node"`-1))

for i in $(seq $countpid); do
  pid=$(ps aux | grep "node" | awk 'NR == 1 {print $2}')
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

# mitm for all 4 containers
/honeyflow/mitmSetup.sh m1 128.8.238.102 10001
/honeyflow/mitmSetup.sh m2 128.8.238.123 10002
/honeyflow/mitmSetup.sh s1 128.8.238.77 10003
/honeyflow/mitmSetup.sh s2 128.8.238.66 10004

