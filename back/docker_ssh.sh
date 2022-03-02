#!/bin/bash

CONTAINER_ID=`docker ps -aqf "name=pialab_back"`

docker exec -it $CONTAINER_ID /bin/bash
