#!/bin/sh
set -e

BSUSER=bytesweep
BSGROUP=bytesweep

# create group
if ! getent group $BSGROUP > /dev/null; then
	addgroup --quiet --system $BSGROUP
fi

# create user
if ! getent passwd $BSUSER > /dev/null; then
	useradd --system --no-user-group --shell /sbin/nologin --groups $BSGROUP $BSUSER
	mkhomedir_helper bytesweep
fi

# set perms on config file
chown $BSUSER:$BSGROUP /etc/bytesweep/config.yaml
chmod 600 /etc/bytesweep/config.yaml

# setup upload and extraction dirs
mkdir -p /var/opt/bytesweep-uploads
mkdir -p /var/opt/bytesweep-extraction
chown -R $BSUSER:$BSGROUP /var/opt/bytesweep-uploads
chown -R $BSUSER:$BSGROUP /var/opt/bytesweep-extraction
chmod 750 /var/opt/bytesweep-uploads
chmod 750 /var/opt/bytesweep-extraction

# set random flask salt
salt=$(tr -dc A-Za-z0-9_ < /dev/urandom | head -c 50)
sed -i "s/flask_secret_key: '.*'/flask_secret_key: '$salt'/" /etc/bytesweep/config.yaml
