#!/usr/bin/env bash

# Install ansible
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible

# Install git
sudo apt install -y git
export REPO_NAME="dots"
export REPO_URL="https://github.com/luk-pio/${REPO_NAME}.git"

# Clone the repo and configure vals
git clone $REPO_URL
cd $REPO_NAME

read -p "Github username: " GH_USER
read -p "Github email: " EMAIL
read -p "Which environent do you want to install (home|work|wsl)? " INSTALL_TYPE

sed "s/install_type: \w*$/install_type: ${INSTALL_TYPE}/" vars.yml -i
sed "s/gh_user: \w*$/gh_user: ${GH_USER}/" vars.yml -i
sed "s/gh_email: \w*$/gh_email: ${GH_EMAIL}/" vars.yml -i

echo "Everything is set up. Now just ./pull.sh and watch the magic happen :)"
