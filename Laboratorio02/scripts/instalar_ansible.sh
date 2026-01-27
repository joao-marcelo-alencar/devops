#!/bin/bash
# Este script instala o Ansible no Ubuntu.
# Execute com sudo.
apt-get update
apt-get install software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible
apt install ansible python3-boto3