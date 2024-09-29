#!/bin/bash

dnf install ansible -y
cd /tmp
git clone https://github.com/mcreddi1/expense-ansible-script.git
cd expense-ansible-script
ansible-playbook -i inventory.ini mysql.yaml
ansible-playbook -i inventory.ini backend.yaml
ansible-playbook -i inventory.ini frontend.yaml