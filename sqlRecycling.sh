#!/bin/bash

# Args: target container, template container

if [ $# -ne 2 ]
then
  echo "Usage: $0 <container to recycle> <template to use>"
  exit 1
fi

if [ `lxc-ls -1 | grep -c "^$2$"` -eq 0 ]
then
  # container template does not exist, so error
  echo “Template container $2 does not exist”
  exit 1
elif [ `lxc-ls -1 --running | grep -c "^$2$"` -eq 1 ]
then
  # if template container is running, stop 
  lxc-stop -n $2
fi

if [ `lxc-ls -1 | grep -c "^$1$"` -eq 0 ]
then
  # container target does not exist, so error
  echo "Target container $1 does not exist"
  exit 1
elif [ `lxc-attach $1 -- who | grep -c 'admin'` -gt 0 ]
then
  echo "Target container $1 has someone logged in. Skipping recycling..."
  exit 1
elif [ `lxc-ls -1 --running | grep -c "^$1$"` -eq 1 ]
then
  # stop target container if it exists
  lxc-stop -n $1
fi

fname=$(TZ=":US/Eastern" date --iso-8601=s)

# copy log files to local directory
cp /var/lib/lxc/$1/rootfs/var/lib/mysql/mysqlTemplate.log /logs/sql/$1/$fname-$1.log
# copy snoopy log
cp /var/lib/lxc/$1/rootfs/var/log/auth.log /logs/snoopy/$1/$fname-$1.log
#copy bash history
cp /var/lib/lxc/$1/rootfs/home/admin/.bash_history /logs/bashhistory/$1/$fname-$1.log
# destroy target container
lxc-destroy -n $1
# copy template to target
lxc-copy -n $2 -N $1
# start new target container
lxc-start -n $1
sleep 5
# log successful recycle
echo "Container $1 recycled using $2 as template at $fname"
