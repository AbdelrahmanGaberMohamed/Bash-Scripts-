#!/bin/bash 
###This script sets up mongo and mongo-express containers 
###Exit codes:
#	0: Success 
#Create docker network mongo-network to connect the two containers if it 
#doesn't exist
NETCHK=$(docker network ls | grep mongo-network | wc -l)
#echo "${NETCHK}"
if [ ${NETCHK} -eq 0 ]
then 
	docker network create mongo-network
fi
#Create a container for mongodb 
docker run -d --rm -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=password --name mongodb --net mongo-network mongo
#Create a container for mongo-express 
docker run -d --rm -p 8081:8081 -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin -e ME_CONFIG_MONGODB_ADMINPASSWORD=password -e ME_CONFIG_MONGODB_SERVER=mongodb --name mongo-express --net mongo-network mongo-express 
exit 0
