#!/bin/sh

npm audit fix --force
npm install
ng update
npm update
$@
