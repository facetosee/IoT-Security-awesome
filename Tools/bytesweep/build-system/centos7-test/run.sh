#!/bin/bash
scriptdir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
sudo docker run -v $scriptdir/../artifacts:/artifacts -it centos7-test
