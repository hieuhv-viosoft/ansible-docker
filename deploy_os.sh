#!/bin/bash
sed -i "s/server0/$2/g" /opt/stack/bifrost/playbooks/inventory/baremetal.yml
sed -i "s/00000000-0000-0000-0000-000000000001/$1/g" /opt/stack/bifrost/playbooks/inventory/baremetal.yml
sed -i "s/user_ipmi/$3/g" /opt/stack/bifrost/playbooks/inventory/baremetal.yml
sed -i "s/addr_ipmi/$4/g" /opt/stack/bifrost/playbooks/inventory/baremetal.yml
sed -i "s/pass_ipmi/$5/g" /opt/stack/bifrost/playbooks/inventory/baremetal.yml
sed -i "s/mac_nic/$6/g" /opt/stack/bifrost/playbooks/inventory/baremetal.yml
sed -i "s/ip_addr/$7/g" /opt/stack/bifrost/playbooks/inventory/baremetal.yml

cd /opt/stack/bifrost/playbooks/
ansible-playbook -vvvv -i inventory/bifrost_inventory.py enroll-dynamic.yaml
ansible-playbook -vvvv -i inventory/bifrost_inventory.py deploy-dynamic.yaml
