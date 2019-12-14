#!/bin/bash

echo "stopping all bytesweep containers"
watchdog=$(sudo docker ps | grep 'bytesweep-watchdog' | awk '{print $1}')
if [ -n "$watchdog" ]; then
	sudo docker stop $watchdog && echo "watchdog stopped"
fi
cvefetch=$(sudo docker ps | grep 'bytesweep-cvefetch' | awk '{print $1}')
if [ -n "$cvefetch" ]; then
	sudo docker stop $cvefetch && echo "cvefetch stopped"
fi
worker=$(sudo docker ps | grep 'bytesweep-worker' | awk '{print $1}')
if [ -n "$worker" ]; then
	sudo docker stop $worker && echo "worker stopped"
fi
web=$(sudo docker ps | grep 'bytesweep-web' | awk '{print $1}')
if [ -n "$web" ]; then
	sudo docker stop $web && echo "web stopped"
fi
db=$(sudo docker ps | grep 'bytesweep-db' | awk '{print $1}')
if [ -n "$db" ]; then
	sudo docker stop $db && echo "database stopped"
fi
