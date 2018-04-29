#!/bin/bash
invoked=$_   # needs to be first thing in the script
OPTIND=1    # also remember to initialize your flags and other variables

unset ACTION
#echo "you passed me" $*
#echo "you passed me" $@

while getopts ":a:" opt; do
  case $opt in
    a)
      echo "-a detected" >&2
      ACTION=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

source ./client-config-terraform-env.sh
terraform init ./terraform-codepipeline
terraform $ACTION ./terraform-codepipeline

