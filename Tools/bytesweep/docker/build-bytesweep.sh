#!/bin/bash

DBPASS="dbpass"
sudo docker build -t bytesweep-db bytesweep-db
sudo docker build -t bytesweep-web --build-arg DBPASS="$DBPASS" bytesweep-web
sudo docker build -t bytesweep-worker --build-arg DBPASS="$DBPASS" bytesweep-worker
sudo docker build -t bytesweep-cvefetch --build-arg DBPASS="$DBPASS" bytesweep-cvefetch
sudo docker build -t bytesweep-watchdog --build-arg DBPASS="$DBPASS" bytesweep-watchdog
