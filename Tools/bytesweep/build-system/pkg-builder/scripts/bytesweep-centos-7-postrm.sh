#!/bin/bash

BSUSER=bytesweep
BSGROUP=bytesweep

#remove directories
rm -rf /opt/bytesweep-web
rm -rf /opt/bytesweep-worker
rm -rf /opt/bytesweep-cvefetch
rm -rf /opt/bytesweep-watchdog
rm -rf /etc/bytesweep

#delete bytesweep user and group
userdel $BSUSER 2>&1 > /dev/null
groupdel $BSGROUP
