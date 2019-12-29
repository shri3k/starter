#! /usr/bin/env bash

##
# - Clones git repo with
#   - user defined depth (1 by default)
#   - user defined branch (none by default)
#   - user defined commit (HEAD by default)
# in current directory
# @TODO: Add option to copy specific commit hash
##

: ${STARTER_REPO:='git@github.com:shri3k/min'}

function starters() {
  if [ -z $1 ]
  then
    echo "No branch provided"
    return 1
  fi

  TMP_FOLDER=".$(date +%s)"
  BRANCH="${1}"
  DEPTH="${2:-1}"

  echo "Cloning $STARTER_REPO with branch $BRANCH"
  cd /tmp/ && git clone --depth "$DEPTH" "$STARTER_REPO" --branch "$BRANCH" --single-branch "$TMP_FOLDER" && rm -rf .git
  if [ $? -eq 0 ]
    then
    echo "Copying files"
    mv "/tmp/$TMP_FOLDER/" "$PWD"
    rm -rf "$TMP_FOLDER"
  else
    return 1
  fi
}

function help() {
cat << EOF

Usage: starter <branch_name> [depth=1]
---
Clones repository from repo that is defined in $STARTER_REPO
or defaults to $STARTER_REPO

EOF
}

case $1 in
  "help"|"-h"|"--help")
    help
    ;;
  *)
    starters $@
    if [ $? -eq 1 ]
      then
      help
    fi
    ;;
esac
