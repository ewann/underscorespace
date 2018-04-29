#!/bin/bash

if [ ! -f ./bin/terraform ]; then
    pushd bin
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
    sudo apt-get install git-lfs
    git lfs install 
    git lfs track ./bin/*
    echo "terraform binary not found. This seems strange, but we will attempt to download it"
    curl -k https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip | bsdtar -xf- -C .
    chmod 700 ./terraform
    popd
fi

