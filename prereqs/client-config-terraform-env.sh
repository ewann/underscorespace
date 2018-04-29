#!/bin/bash

#If not already on the path, add ./bin to the end of path
[[ ":$PATH:" != *":$(pwd)/bin:"* ]] && PATH=$PATH:$(pwd)/bin

if [ -z ${TF_VAR_aws_access_key+x} ]; then 
  echo "supply a value for aws_access_key:"; 
  read aws_access_key; 
else 
  echo "TF_VAR_aws_access_key is already set"; 
fi

if [ -z ${TF_VAR_aws_secret_key+x} ]; then 
  echo "supply a value for aws_secret_key:"; 
  read aws_secret_key; 
else 
  echo "TF_VAR_aws_secret_key is already set"; 
fi

if [ -z ${GITHUB_TOKEN+x} ]; then 
  echo "supply a value for GITHUB_TOKEN:"; 
  read github_token; 
else 
  echo "GITHUB_TOKEN is already set"; 
fi

source ./lookup-github-org-name.sh
echo "exporting TF_VAR_github_org_name $github_org_name"
export TF_VAR_github_org_name=$github_org_name
echo "exporting $github_repo_name"
export TF_VAR_github_repo_name=$github_repo_name

echo "exporting TF_VAR_aws_access_key"
export TF_VAR_aws_access_key=$aws_access_key
echo "exporting TF_VAR_aws_secret_key"
export TF_VAR_aws_secret_key=$aws_secret_key
echo "exporting GITHUB_TOKEN"
export GITHUB_TOKEN=$github_token



