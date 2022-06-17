#!/bin/sh

apt-get remove -y --purge nodejs
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo bash -
apt install -y nodejs
npm install
$@
