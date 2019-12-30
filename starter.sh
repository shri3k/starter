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

function starter() (
  local CURRDIR=$PWD
  local TMP_FOLDER="/tmp/.$(date +%s)"

  function cleanup() {
    echo "Cleaning up"
    rm -rf "${TMP_FOLDER}"
    cd "${CURRDIR}" || exit
  }


  function starters() {
    trap cleanup EXIT

    if [ -z "${1}" ]
    then
      >&2 echo "No branch provided"
      return 1
    fi

    local BRANCH="${1}"
    local DEPTH="${2:-1}"

    echo "Cloning $STARTER_REPO with branch $BRANCH"
    if cd /tmp/ && git clone --depth "$DEPTH" "$STARTER_REPO" --branch "$BRANCH" --single-branch "$TMP_FOLDER" && rm -rf .git
      then
      echo "Copying files"
      mv "${TMP_FOLDER}" "${PWD}"
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
      starters "${@}"
      if [ $? -eq 1 ]
      then
        help
      fi
      ;;
  esac

)
