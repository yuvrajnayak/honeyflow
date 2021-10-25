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
  # if template container is running, stop mongod and then stop container
  lxc-attach -n $2 -- systemctl stop mongod
  lxc-stop -n $2
fi

if [ `lxc-ls -1 | grep -c "^$1$"` -eq 0 ]
then
  # container target does not exist, so error
  echo Target container $1 does not exist”
  exit 1
elif [ `lxc-ls -1 --running | grep -c "^$1$"` -eq 1 ]
then
  if [ `lxc-attach $1 -- who | grep -c 'admin'` -gt 0 ]
  then
    echo "Target container $1 has someone logged in. Skipping recycling..."
    exit 1
  fi
  # stop target container if it exists
  lxc-stop -n $1
fi

fname=$(TZ=":US/Eastern" date --iso-8601=s)

# copy mongo logs to local directory
cp /var/lib/lxc/$1/rootfs/var/log/mongodb/mongod.log /logs/mongodb/$1/$fname-$1.log
# copy snoopy logs
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
# start mongodb server -> DOESNT WORK
lxc-attach -n $1 -e -- systemctl start mongod
# log successful recycle
echo "Container $1 recycled using $2 as template at $fname"
