#!/bin/bash

CONTAINER_ID=`docker ps -aqf "name=pialab_back"`

# user super admin

docker exec -it $CONTAINER_ID bin/console pia:user:create test@test.tld test --username=test

docker exec -it $CONTAINER_ID bin/console pia:user:promote test@test.tld --role=ROLE_SUPER_ADMIN

docker exec -it $CONTAINER_ID bin/console pia:user:promote test@test.tld --role=ROLE_REDACTOR

docker exec -it $CONTAINER_ID bin/console pia:user:promote test@test.tld --role=ROLE_EVALUATOR

docker exec -it $CONTAINER_ID bin/console pia:user:promote test@test.tld --role=ROLE_CONTROLLER

docker exec -it $CONTAINER_ID bin/console pia:user:promote test@test.tld --role=ROLE_CONTROLLER_MULTI

docker exec -it $CONTAINER_ID bin/console pia:user:promote test@test.tld --role=ROLE_DPO

docker exec -it $CONTAINER_ID bin/console pia:user:promote test@test.tld --role=ROLE_SHARED_DPO
