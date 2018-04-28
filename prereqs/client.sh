#!/bin/bash

curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install git-lfs
git lfs install 
git lfs track ./bin/*

pushd bin
curl -k https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip | bsdtar -xf- -C .
chmod 700 ./terraform
