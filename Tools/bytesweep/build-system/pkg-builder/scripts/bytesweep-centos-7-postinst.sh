#!/bin/sh
set -e

BSUSER=bytesweep
BSGROUP=bytesweep

# create group
if ! getent group $BSGROUP > /dev/null; then
	groupadd --system $BSGROUP
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

# install python deps not avaiable in package manager
pip3 install python-magic flask flask-login werkzeug bcrypt gunicorn ruamel.yaml

# set random flask salt
salt=$(tr -dc A-Za-z0-9_ < /dev/urandom | head -c 50)
sed -i "s/flask_secret_key: '.*'/flask_secret_key: '$salt'/" /etc/bytesweep/config.yaml

# set gunicorn path
sed -i 's#/usr/bin/gunicorn3#/usr/local/bin/gunicorn#' /lib/systemd/system/bytesweep-web.service

# enable bytesweep
systemctl daemon-reload
systemctl enable bytesweep-web
systemctl enable bytesweep-worker
systemctl enable bytesweep-cvefetch
systemctl enable bytesweep-watchdog
