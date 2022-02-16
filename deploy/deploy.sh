#!/bin/bash

set -e

apt-get update -y
apt-get upgrade -y
pip install -u docker-compose


if [ $USER = "root" ]; then
    su pialab
    cd $HOME
fi

cd pialab
# clone code
git fetch
git reset --hard origin/master
(cd ./back/src && git fetch && git reset --hard origin/dev)
(cd ./front/src && git fetch && git reset --hard origin/dev)

# build
docker-compose build --no-cache

cp ./back/docker/.env ./back/src/
cp ./front/docker/environment.dev.ts ./front/src/src/environments/

mkdir -p ./back/src/var
chmod 777 ./back/src/var

