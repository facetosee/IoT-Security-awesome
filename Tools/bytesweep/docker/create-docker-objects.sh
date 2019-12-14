#!/bin/bash
source docker-config.sh

sudo docker network ls | grep "$bs_network"
if [ $? -ne 0 ]; then
	sudo docker network create $bs_network
fi

sudo docker volume ls | grep "$upload_volume"
if [ $? -ne 0 ]; then
	sudo docker volume create --name $upload_volume
fi

sudo docker volume ls | grep "$extraction_volume"
if [ $? -ne 0 ]; then
	sudo docker volume create --name $extraction_volume
fi

sudo docker volume ls | grep "$pgdata_volume"
if [ $? -ne 0 ]; then
	sudo docker volume create --name $pgdata_volume
fi

