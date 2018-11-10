#!/bin/bash

export ANSIBLE_HOST_KEY_CHECKING=False
PATH="${HOME}/.local/bin:${PATH}"
virtual_env="provision"
virtual_env_path=~/.virtualenvs/$virtual_env

sudo apt-get install build-essential libssl-dev libffi-dev python3-dev
apt-get install -y sudo python3-pip python3-dev sshpass
pip3 install --user vex
vex --make $virtual_env pip install -U pip
source $virtual_env_path/bin/activate
pip3 install -U ansible
ansible-playbook -i provision/inventory/localhost provision/site.yml -c local

rm -rf ~/.virtualenvs
