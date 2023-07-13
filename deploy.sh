#!/bin/bash
CURR_DIR=$PWD
cd ./infra/deployment || exit
terraform apply -auto-approve
cd "$CURR_DIR" || exit
