#!/bin/bash

# First, add the following line to the /root/.bashrc file:
echo "export LC_ALL="en_US.UTF-8"" >> /root/.bashrc
#Ensure the operating system is up to date
apt-get -y update && apt-get -y upgrade

# set the MySQL password to “secret”
echo mysql-server-5.1 mysql-server/root_password password blueteam11 | debconf-set-selections
echo mysql-server-5.1 mysql-server/root_password_again password blueteam11 | debconf-set-selections
apt-get install git python-setuptools mysql-server -y

mkdir -p /opt/stack
cd /opt/stack
git clone https://git.openstack.org/openstack/bifrost.git
git checkout 2.1.1
cd bifrost

echo "---
ironic_url: "http://localhost:6385/"
network_interface: "ens3"
ironic_db_password: blueteam11
mysql_username: root
mysql_password: secret
ssh_public_key_path: "/root/.ssh/id_rsa.pub"
deploy_image_filename: "user_image.qcow2"
create_image_via_dib: false
transform_boot_image: false
create_ipa_image: false
dnsmasq_dns_servers: 8.8.8.8,8.8.4.4
dnsmasq_router: 172.16.166.14
dhcp_pool_start: 172.16.166.20
dhcp_pool_end: 172.16.166.50
dhcp_lease_time: 12h
dhcp_static_mask: 255.255.255.0" > /opt/stack/bifrost/playbooks/inventory/group_vars/localhost

#Install ansible and all of bifrost’s dependencies:

bash ./scripts/env-setup.sh
source /opt/stack/bifrost/env-vars
source /opt/stack/ansible/hacking/env-setup
cd playbooks
ansible-playbook -v -i inventory/localhost install.yaml

cd /opt/stack/
git clone git://git.openstack.org/openstack/ironic-staging-drivers
cd ironic-staging-drivers/
pip install -e .
pip install "ansible>=2.1.0"

sed -i '/enabled_drivers =*/c\enabled_drivers = pxe_ipmitool_ansible' /etc/ironic/ironic.conf
sed -i 's/automated_clean = false/automated_clean = true/g' /etc/ironic/ironic.conf

service ironic-conductor restart

#To check that everything was installed properly, execute the following command:
ironic driver-list | grep ansible

sed -i '/dhcp-option=3,*/c\dhcp-option=3,172.16.166.1' /etc/dnsmasq.conf

curl -Lk https://github.com/vnogin/Ansible-role-for-baremetal-node-provision/archive/master.tar.gz | tar xz -C /opt/stack/ironic-staging-drivers/ironic_staging_drivers/ansible/playbooks/ --strip-components 1


echo "---
  $2:
    ipa_kernel_url: "http://172.16.166.14:8080/ansible_ubuntu.vmlinuz"
    ipa_ramdisk_url: "http://172.16.166.14:8080/ansible_ubuntu.initramfs"
    uuid: $1
    driver_info:
      power:
        ipmi_username: $3
        ipmi_address: $4
        ipmi_password: $5
        ansible_deploy_playbook: deploy_custom.yaml
    nics:
      -
        mac: $6
    driver: pxe_ipmitool_ansible
    ipv4_address: $7
    properties:
      cpu_arch: x86_64
      ram: 16000
      disk_size: 60
      cpus: 8
    name: server1
    instance_info:
      image_source: "http://172.16.166.14:8080/user_image.qcow2"" > /opt/stack/bifrost/playbooks/inventory/baremetal.yml

export BIFROST_INVENTORY_SOURCE=/opt/stack/bifrost/playbooks/inventory/baremetal.yml



# Create image using DIB (disk image builder)

su - ironic
ssh-keygen
exit

# Next set environment variables for DIB
export ELEMENTS_PATH=/opt/stack/ironic-staging-drivers/imagebuild
export DIB_DEV_USER_USERNAME=ansible
export DIB_DEV_USER_AUTHORIZED_KEYS=/home/ironic/.ssh/id_rsa.pub
export DIB_DEV_USER_PASSWORD=secret
export DIB_DEV_USER_PWDLESS_SUDO=yes

cd /opt/stack/diskimage-builder/
pip install .
disk-image-create -a amd64 -t qcow2 ubuntu baremetal grub2 ironic-ansible -o ansible_ubuntu
mv ansible_ubuntu.vmlinuz ansible_ubuntu.initramfs /httpboot/
disk-image-create -a amd64 -t qcow2 ubuntu baremetal grub2 devuser cloud-init-nocloud -o user_image
mv user_image.qcow2 /httpboot/

cd /httpboot/
chown ironic:ironic *

cd /opt/stack/bifrost/playbooks/
ansible-playbook -vvvv -i inventory/bifrost_inventory.py enroll-dynamic.yaml
ansible-playbook -vvvv -i inventory/bifrost_inventory.py deploy-dynamic.yaml
