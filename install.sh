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


# 1) Get the repo url, update vars.yml (in case GH_USER or repository CWD changed).
# 2) Pull the repository
# 3) Ansible Pull
if [ "$pull_flag" == "true" ]; then
    
    # Get the username from vars.yml
    GH_USER=$(grep -Po 'gh_user: \K.+' vars.yml)
    REPO_URL="https://github.com/${GH_USER}/${REPO_NAME}.git"

    git pull
    # Update the local path to this repository
    # We do this every time in case a "git pull" command overwrites
    # TODO maybe vars.yml could be added to .gitignore to simplify
    ESCAPED_CWD=$(printf '%s\n' "$(pwd)" | sed 's:[\\/&]:\\&:g;$!s/$/\\/')
    sed "s/system_username: \w*$/system_username: $(whoami)/" vars.yml -i
    sed "s/repo_dir: .*$/repo_dir: ${ESCAPED_CWD}/" vars.yml -i

    # Update the cron pull cmd
    CRON_PULL_CMD="cd $(pwd); ./install.sh -p"
    ESCAPED_CRON_PULL_CMD=$(printf '%s\n' "$CRON_PULL_CMD" | sed 's:[\\/&]:\\&:g;$!s/$/\\/')
    sed "s/cron_pull_cmd: .*$/cron_pull_cmd: '${ESCAPED_CRON_PULL_CMD}'/" vars.yml -i

    ANS_PULL_CMD="sudo ansible-pull -U ${REPO_URL} -C main -v -e @$( pwd )/vars.yml"
    $ANS_PULL_CMD
fi
