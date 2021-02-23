#!/usr/bin/env bash
set -euo pipefail

# Install ansible
echo
PROMPT="Do you want to install ansible? [y/n] "
read -p "$PROMPT" ANSWER
if [ -z "$ANSWER" ] || [ "$ANSWER" == "y" ]; then
    sudo apt-get install software-properties-common
    sudo apt-add-repository ppa:ansible/ansible
    sudo apt-get update
    sudo apt-get install ansible
fi

# Install git
sudo apt install -y git
export REPO_NAME="dots"
export REPO_URL="https://github.com/luk-pio/${REPO_NAME}.git"

# Clone the repo and configure vals
echo
PROMPT="Do you want to clone the dotfs repo? [y/n] "
read -p "$PROMPT" ANSWER
if [ -z "$ANSWER" ] || [ "$ANSWER" == "y" ]; then
    git clone $REPO_URL
    cd $REPO_NAME
fi

ANS_PULL_CMD="sudo ansible-pull -U ${REPO_URL} -C main -v -e @$( pwd )/vars.yml"

read -p "Github username: " GH_USER
read -p "Github email: " GH_EMAIL
read -p "Which environent do you want to install (home|work|wsl)? " INSTALL_TYPE

sed "s/install_type: \w*$/install_type: ${INSTALL_TYPE}/" vars.yml -i
sed "s/gh_user: \w*$/gh_user: ${GH_USER}/" vars.yml -i
sed "s/gh_email: \w*$/gh_email: ${GH_EMAIL}/" vars.yml -i
sed "s/system_username: \w*$/system_username: $(whoami)/" vars.yml -i
sed "s/repo_dir: .*$/repo_dir: $(pwd)/" vars.yml -i

ESCAPED_PULL_CMD=$(printf '%s\n' "$ANS_PULL_CMD" | sed 's:[\\/&]:\\&:g;$!s/$/\\/')
sed "s/pull_cmd: .*$/pull_cmd: '${ESCAPED_PULL_CMD}'/" vars.yml -i
sed "s/sudo .*$/${ESCAPED_PULL_CMD}/" pull.sh -i

echo "Everything is set up. Now just ./pull.sh and watch the magic happen :)"
