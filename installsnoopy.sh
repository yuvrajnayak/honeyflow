#!/bin/bash
if [ $# -ne 1 ]
then
	echo "Please provide 1 argument"
	exit 1
fi
if [ `sudo lxc-ls | grep -c $1` -eq 0 ]
then
       	echo "Container not found"
       exit 1
else
	sudo lxc-attach -n $1 -- sudo apt-get install wget
 	sudo lxc-attach -n $1 -- wget -O install-snoopy.sh https://github.com/a2o/snoopy/raw/install/install/install-snoopy.sh
	sudo lxc-attach -n $1 -- sudo chmod 755 install-snoopy.sh
	sudo lxc-attach -n $1 -- sudo ./install-snoopy.sh stable
	sudo lxc-attach -n $1 -- sudo rm ./install-snoopy.sh
fi
