#!/bin/bash

source docker-config.sh

echo "create docker networks and volumes"
./create-docker-objects.sh

echo "killing any running bytesweep containers..."
./stop-bytesweep.sh

echo "starting bytesweep containers..."
sudo docker run -d -p 5432:5432 --network "$bs_network" --network-alias database -v "$pgdata_volume:/var/lib/postgresql/data" bytesweep-db && echo "database started"
# sleep 10 seconds for database to come online
sleep 10
sudo docker run -d -p8000:8000 --network "$bs_network" --network-alias web -v "$upload_volume:/var/opt/bytesweep-uploads" -v "$extraction_volume:/var/opt/bytesweep-extraction" -t bytesweep-web && echo "web started"
sudo docker run -d --network "$bs_network" --network-alias worker -t -v "$upload_volume:/var/opt/bytesweep-uploads" -v "$extraction_volume:/var/opt/bytesweep-extraction" bytesweep-worker && echo "worker started"
sudo docker run -d --network "$bs_network" --network-alias cvefetch -t bytesweep-cvefetch && echo "cvefetch started"
sudo docker run -d --network "$bs_network" --network-alias watchdog -t bytesweep-watchdog && echo "watchdog started"
echo "bytesweep running on http://127.0.0.1:8000"

