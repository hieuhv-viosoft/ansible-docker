#!/bin/bash

apt-get -y update
apt-get install -y openssh-server
ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -P ""
apt-get install -y sshpass
sshpass -p "blueteam11" ssh-copy-id -o StrictHostKeyChecking=no root@172.17.0.1
scp script.sh root@172.17.0.1:/root
ssh root@172.17.0.1 sh script.sh $1 $2 $3 $4 $5 $6 $7
