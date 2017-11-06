#!/bin/bash
cd /opt/stack/bifrost/
bash ./scripts/env-setup.sh
source /opt/stack/bifrost/env-vars
source /opt/stack/ansible/hacking/env-setup
cd playbooks
ansible-playbook -v -i inventory/localhost install.yaml

cd /opt/stack/ironic-staging-drivers/
pip install -e .
pip install "ansible>=2.1.0"

sed -i '/enabled_drivers =*/c\enabled_drivers = pxe_ipmitool_ansible' /etc/ironic/ironic.conf
sed -i 's/automated_clean = false/automated_clean = true/g' /etc/ironic/ironic.conf

service ironic-conductor restart

#To check that everything was installed properly, execute the following command:
ironic driver-list | grep ansible
sed -i '/dhcp-option=3,*/c\dhcp-option=3,172.16.166.1' /etc/dnsmasq.conf

sed -i "s/server0/$2/g" /opt/stack/bifrost/playbooks/inventory/baremetal.yml
sed -i "s/00000000-0000-0000-0000-000000000001/$1/g" /opt/stack/bifrost/playbooks/inventory/baremetal.yml
sed -i "s/user_ipmi/$3/g" /opt/stack/bifrost/playbooks/inventory/baremetal.yml
sed -i "s/addr_ipmi/$4/g" /opt/stack/bifrost/playbooks/inventory/baremetal.yml
sed -i "s/pass_ipmi/$5/g" /opt/stack/bifrost/playbooks/inventory/baremetal.yml
sed -i "s/mac_nic/$6/g" /opt/stack/bifrost/playbooks/inventory/baremetal.yml
sed -i "s/ip_addr/$7/g" /opt/stack/bifrost/playbooks/inventory/baremetal.yml
export BIFROST_INVENTORY_SOURCE=/opt/stack/bifrost/playbooks/inventory/baremetal.yml

cd /opt/stack/bifrost/playbooks/
ansible-playbook -vvvv -i inventory/bifrost_inventory.py enroll-dynamic.yaml
ansible-playbook -vvvv -i inventory/bifrost_inventory.py deploy-dynamic.yaml
