#!/bin/bash

#http style:
if [ -z $(git config --list |grep remote.origin.url= | awk -F[/] '{print $4}') ]; then 
  echo "Github org name doesn't appear to be http style, suppose ssh"; 
  github_org_name=$(git config --list |grep remote.origin.url= | awk -F[:/] '{print $2}')
  github_repo_name=$(echo "$(git config --list |grep remote.origin.url= | awk -F[:/] '{print $3}')" | sed 's/....$//')
else 
  echo "Github org name appears to be http style"; 
  github_org_name=$(git config --list |grep remote.origin.url= | awk -F[/] '{print $4}')
  github_repo_name=$(echo "$(git config --list |grep remote.origin.url= | awk -F[/] '{print $5}')" | sed 's/....$//')
fi
echo "exporting github_org_name $github_org_name"
export $github_org_name
echo "exporting github_repo_name $github_repo_name"
export $github_repo_name


