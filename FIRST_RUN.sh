#!/usr/bin/env bash
ansible-galaxy install -r roles.yml -p roles
terraform init
terraform apply