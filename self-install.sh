#! /bin/bash

#install git and node

sudo apt-get install git wget

if
wget https://nodejs.org/dist/v6.7.0/node-v6.7.0-linux-x64.tar.xz
tar -zxvf node-v*.tar.xz

echo 'export PATH=$PATH:/home/`whoami`/node-v6.7.0-linux-x64/bin' > .noninteractive_profile
echo 'export PATH=$PATH:/home/`whoami`/node-v6.7.0-linux-x64/bin' > .bashrc

# clone watch dog

# clone actual application
echo 'What is the git url of the repository to clone and run?'