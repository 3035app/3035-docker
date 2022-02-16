#!/bin/bash

set -e

# install dependencies
apt-get update -y
apt-get upgrade -y
apt-get install -y python3-pip docker
pip install docker-compose

# create user
useradd pialab
su pialab
cd $HOME

# clone code
git clone ssh://git@git.pialab.io:2222/pialab/docker.git pialab -b master
cd pialab
git clone ssh://git@git.pialab.io:2222/pialab/back.git ./back/src -b dev
git clone ssh://git@git.pialab.io:2222/pialab/front.git ./front/src -b dev

