#!/bin/bash

BSUSER=bytesweep
BSGROUP=bytesweep

#delete bytesweep user and group
userdel $BSUSER 2>&1 > /dev/null
groupdel $BSGROUP
