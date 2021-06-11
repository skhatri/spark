#!/usr/bin/env bash

set -e

local_refs=$(find . -name "*.yaml" -exec grep "$(whoami)" {} \; -print 2>/dev/null|wc -l)
if [[ $local_refs -ne 0 ]];
then
  echo local references were found. fix them
  find . -name "*.yaml" -exec grep "$(whoami)" {} \; -print 2>/dev/null
  exit 1;
fi;


msg="$@"

files=$(git status -s|wc -l)

if [[ $files -ne 0 ]];
then

  if [[ -z $msg ]];
  then
    echo "msg is required"
    exit 1; 
  fi;

  current="$(git describe --tags --abbrev=0|sed s/"v0\."//g)"
  next=$((current + 1))

  new_tag="v0.${next}"
  
  git add .
  git commit -m"${msg}"

  git tag -m"${new_tag}" ${new_tag} 
  echo new tag ${new_tag}
fi;






