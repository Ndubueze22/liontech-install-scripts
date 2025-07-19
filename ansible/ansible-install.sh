#!/bin/bash 
sudo apt update 
sudo apt-add-repository ppa:ansible/ansible
sudo apt update 
sudo apt install ansible 
ansible –-version
