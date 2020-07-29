#! /bin/bash

sudo apt-get update
sudo apt install -y default-jre
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install -y jenkins
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install -y ansible




