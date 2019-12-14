#!/bin/bash
echo "input versions without the 'v'"
read -p "bytesweep version: " bytesweep_version
read -p "bytewalk version: " bytewalk_version
scriptdir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
sudo docker build --build-arg bytesweep_version=$bytesweep_version --build-arg bytewalk_version=$bytewalk_version -t pkg-builder pkg-builder
sudo rm -rf $scriptdir/artifacts/*
sudo docker run -i -v $scriptdir/artifacts:/artifacts -t pkg-builder /builds/export_artifacts.sh
