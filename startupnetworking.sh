#!/bin/bash
sudo ip addr add 128.8.238.102/26 brd + dev enp4s2
sudo ip addr add 128.8.238.123/26 brd + dev enp4s2
sudo ip addr add 128.8.238.77/26 brd + dev enp4s2
sudo ip addr add 128.8.238.66/26 brd + dev enp4s2
sudo ip link set dev enp4s2 up
sudo sysctl -w net.ipv4.ip_forward=1
sudo ip route add default via 128.8.238.65 table c1
sudo ip route add default via 128.8.238.65 table container2
sudo ip route add default via 128.8.238.65 table container3
sudo ip route add default via 128.8.238.65 table container4
sudo ip rule add from 128.8.238.102 table c1
sudo ip rule add from 128.8.238.123 table container2
sudo ip rule add from 128.8.238.77 table container3
sudo ip rule add from 128.8.238.66 table container4

# delete all rules
#sudo iptables --table nat --delete POSTROUTING 1
#sudo iptables --table nat --delete POSTROUTING 1
#sudo iptables --table nat --delete POSTROUTING 1
#sudo iptables --table nat --delete POSTROUTING 1

#sudo iptables --table nat --delete PREROUTING 1
#sudo iptables --table nat --delete PREROUTING 1
#sudo iptables --table nat --delete PREROUTING 1
#sudo iptables --table nat --delete PREROUTING 1



sudo iptables --table nat --insert PREROUTING --source 0.0.0.0/0 --destination 128.8.238.102 --jump DNAT --to-destination `sudo lxc-info -n m1 -iH`
sudo iptables --table nat --insert POSTROUTING --source `sudo lxc-info -n m1 -iH`  --destination 0.0.0.0/0 --jump SNAT --to-source 128.8.238.102

sudo iptables --table nat --insert PREROUTING --source 0.0.0.0/0 --destination 128.8.238.123 --jump DNAT --to-destination `sudo lxc-info -n m2 -iH`
sudo iptables --table nat --insert POSTROUTING --source `sudo lxc-info -n m2 -iH`  --destination 0.0.0.0/0 --jump SNAT --to-source 128.8.238.123

sudo iptables --table nat --insert PREROUTING --source 0.0.0.0/0 --destination 128.8.238.77 --jump DNAT --to-destination `sudo lxc-info -n s1 -iH`
sudo iptables --table nat --insert POSTROUTING --source `sudo lxc-info -n s1 -iH`  --destination 0.0.0.0/0 --jump SNAT --to-source 128.8.238.77

sudo iptables --table nat --insert PREROUTING --source 0.0.0.0/0 --destination 128.8.238.66 --jump DNAT --to-destination `sudo lxc-info -n s2 -iH`
sudo iptables --table nat --insert POSTROUTING --source `sudo lxc-info -n s2 -iH`  --destination 0.0.0.0/0 --jump SNAT --to-source 128.8.238.66
