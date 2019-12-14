#!/bin/bash
source docker-config.sh

rm_volume() {
	volume=$1
	result="$(sudo docker volume rm $volume 2>&1 > /dev/null )"
	if [ $? -ne 0 ]; then
		csv=$(sudo docker volume rm $volume 2>&1 > /dev/null | awk -F[ '{print $2}' | awk -F] '{print $1}')
		for i in $(echo $csv | sed "s/,/ /g")
		do
			sudo docker rm $i
		done
		sudo docker volume rm $volume
	fi
}

rm_network() {
	network=$1
	sudo docker network ls | grep "$network"
	if [ $? -eq 0 ]; then
		netid=$(sudo docker network ls | grep "$network" | awk '{print $1}')
		sudo docker network rm $netid
	fi
}

rm_volume "$upload_volume"
rm_volume "$extraction_volume"
rm_volume "$pgdata_volume"
rm_network "$bs_network"


