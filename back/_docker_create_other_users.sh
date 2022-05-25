#!/bin/bash

CONTAINER_ID=`docker ps -aqf "name=pialab_back"`

# applications

docker exec -it $CONTAINER_ID bin/console pia:application:create --name=Default-app --url=

# structures

docker exec -it $CONTAINER_ID bin/console pia:structure:create --name=Default-struct --type=default-S1-type

# users

docker exec -it $CONTAINER_ID bin/console pia:user:create Emmanuel@Eval.Eval Emmanuel \
   --application=Default-app --structure=Default-struct

docker exec -it $CONTAINER_ID bin/console pia:user:promote Emmanuel@Eval.Eval --role=ROLE_EVALUATOR


docker exec -it $CONTAINER_ID bin/console pia:user:create Robert@Red.Red Robert \
   --application=Default-app --structure=Default-struct

docker exec -it $CONTAINER_ID bin/console pia:user:promote Robert@Red.Red --role=ROLE_REDACTOR


docker exec -it $CONTAINER_ID bin/console pia:user:create Daniel@DPO.DPO Daniel \
   --application=Default-app --structure=Default-struct

docker exec -it $CONTAINER_ID bin/console pia:user:promote Daniel@DPO.DPO --role=ROLE_DPO


docker exec -it $CONTAINER_ID bin/console pia:user:create Thierry@RT.RT Thierry \
   --application=Default-app --structure=Default-struct

docker exec -it $CONTAINER_ID bin/console pia:user:promote Thierry@RT.RT --role=ROLE_CONTROLLER
