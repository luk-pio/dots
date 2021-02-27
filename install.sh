#!/usr/bin/env bash
set -euo pipefail

REPO_NAME="dots"

ansible_flag=''
git_flag=''
clone_flag=''
pull_flag=''
all_flag=''
environ='home'

print_usage() {
  printf "Usage: install.sh [-a]nsible [-g]it [-c]lone [-p]ull [-a]ll [-e]nvironent (home|work|wsl)"
}

while getopts 'ngcpa' flag; do
  case "${flag}" in
    n) ansible_flag='true' ;;
    g) git_flag='true' ;;
    c) clone_flag='true' ;;
    p) pull_flag='true' ;;
    a) all_flag='true' ;;
    e) environ="${OPTARG}" ;;
    *) print_usage
       exit 1 ;;
  esac
done

if [ "$all_flag" == "true" ]; then
    ansible_flag='true'
    git_flag='true'
    clone_flag='true'
    pull_flag='true'
fi

# Install ansible
if [ "$ansible_flag" == "true" ]; then
    sudo apt-get install software-properties-common
    sudo apt-add-repository ppa:ansible/ansible
    sudo apt-get update
    sudo apt-get install ansible
fi

# Clone the repo and configure vals
if [ "$clone_flag" == "true" ]; then
    git clone $REPO_URL
    cd $REPO_NAME
fi

if [ "$git_flag" == "true" ]; then
    sudo apt install -y git

    # Read git credentials
    read -p "Github username: " GH_USER
    read -p "Github email: " GH_EMAIL
    read -p "Which enviroment do you want to install? (home|work|wsl)? " environ
    sed "s/install_type: \w*$/install_type: ${environ}/" vars.yml -i
    sed "s/gh_user: \w*$/gh_user: ${GH_USER}/" vars.yml -i
    sed "s/gh_email: \w*$/gh_email: ${GH_EMAIL}/" vars.yml -i
fi


if [ "$pull_flag" == "true" ]; then
    GH_USER=$(grep -Po 'gh_user: \K.+' vars.yml)
    REPO_URL="https://github.com/${GH_USER}/${REPO_NAME}.git"
    ANS_PULL_CMD="sudo ansible-pull -U ${REPO_URL} -C main -v -e @$( pwd )/vars.yml"
    ESCAPED_CWD=$(printf '%s\n' "$(pwd)" | sed 's:[\\/&]:\\&:g;$!s/$/\\/')

    sed "s/system_username: \w*$/system_username: $(whoami)/" vars.yml -i
    sed "s/repo_dir: .*$/repo_dir: ${ESCAPED_CWD}/" vars.yml -i

    ESCAPED_PULL_CMD=$(printf '%s\n' "$ANS_PULL_CMD" | sed 's:[\\/&]:\\&:g;$!s/$/\\/')
    sed "s/pull_cmd: .*$/pull_cmd: '${ESCAPED_PULL_CMD}'/" vars.yml -i
    git pull
    $ANS_PULL_CMD
fi
