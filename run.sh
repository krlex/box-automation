#!/bin/bash

export ANSIBLE_HOST_KEY_CHECKING=False
PATH="${HOME}/.local/bin:${PATH}"
virtual_env="provision"
virtual_env_path=~/.virtualenvs/$virtual_env

sudo apt-get install -y build-essential libssl-dev libffi-dev python3-dev sudo python3-pip sshpass
pip3 install --user vex
vex --make $virtual_env pip3 install -U pip
source $virtual_env_path/bin/activate
pip3 install -U ansible
ansible-playbook -i provision/inventory/localhost provision/site.yml -c local

rm -rf ~/.virtualenvs
