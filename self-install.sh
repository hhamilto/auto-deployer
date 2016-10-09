#! /bin/bash

BASEDIR=`realpath $(dirname $0)`

#install git and node

sudo apt-get install git wget

wget https://nodejs.org/dist/v6.7.0/node-v6.7.0-linux-x64.tar.xz
tar -xvf node-v*.tar.xz

echo 'export PATH=$PATH:/home/`whoami`/node-v6.7.0-linux-x64/bin' > .noninteractive_profile
echo 'export PATH=$PATH:/home/`whoami`/node-v6.7.0-linux-x64/bin' > .bashrc
source .bashrc

# clone actual application
echo 'What is the git url of the repository to clone and run?'
read REPO_URL
NODE_PROJECT_DIRECTORY=`git clone $REPO_URL 2>&1 | grep 'Cloning into' | sed 's/.*'"'"'\(.*\)'"'"'.*/\1/' | xargs realpath`

cd $NODE_PROJECT_DIRECTORY
npm install
cd $BASEDIR

# clone watch dog
git clone https://github.com/hhamilto/watchdog.git watchdog-for-project
# configure watchdog
echo "
RESTART_COMMAND='bash -c \"cd $NODE_PROJECT_DIRECTORY; npm start\"'
" > watchdog-for-project/conf.env

watchdog-for-project/start-dog.sh # also starts project up

# finally clone self and start listening for githooks
echo "Cloning auto-deployer..."
git clone https://github.com/hhamilto/auto-deployer.git
echo "Cloned"
AUTO_DEPLOYER_DIRECTORY=`realpath auto-deployer`
cd $AUTO_DEPLOYER_DIRECTORY
npm install
echo "$NODE_PROJECT_DIRECTORY" > PROJECT_TO_MANAGE_DIR
cd $BASEDIR

# give the githook listener a watchdog
cp -r watchdog-for-project watchdog-for-auto-deployer

# Start the hook reciever
echo "
RESTART_COMMAND='bash -c \"cd $AUTO_DEPLOYER_DIRECTORY; npm start\"'
" > watchdog-for-auto-deployer/conf.env

watchdog-for-auto-deployer/start-dog.sh # also starts project up

#spit out githook url
echo "Your githook url:"
echo 'http://'`dig +short myip.opendns.com @resolver1.opendns.com`':1337/redeploy'