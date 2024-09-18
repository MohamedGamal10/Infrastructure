#!/bin/bash
#cat /var/log/cloud-init-output.log
sudo apt-get update -y
sudo apt-get install -y python3-pip 
sudo apt-get install -y ansible
sudo wget https://raw.githubusercontent.com/MohamedGamal10/Infrastructure/master/playbooks/asg-playbook.yml
ansible-playbook -i localhost, asg-playbook.yml --connection=local