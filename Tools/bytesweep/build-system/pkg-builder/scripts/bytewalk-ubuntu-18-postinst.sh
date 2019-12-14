#!/bin/bash

function install_yaffshiv
{
	echo "yaffshiv: installing from source..."
	git clone https://github.com/devttys0/yaffshiv 2>&1 >/dev/null
	cd yaffshiv && python2 setup.py install 2>&1 >/dev/null
	rm -rf yaffshiv 2>&1 >/dev/null
}

function install_sasquatch
{
	echo "sasquatch: installing from source..."
	git clone https://github.com/devttys0/sasquatch 2>&1 >/dev/null
	cd sasquatch && ./build.sh 2>&1 >/dev/null
	rm -rf sasquatch 2>&1 >/dev/null
}

function install_jefferson
{
	echo "jefferson: installing from source..."
	pip2 install "cstruct==1.0" 2>&1 >/dev/null
	git clone https://github.com/sviehb/jefferson 2>&1 >/dev/null
	cd jefferson && python2 setup.py install 2>&1 >/dev/null
	rm -rf jefferson 2>&1 >/dev/null
}

function install_unstuff
{
	echo "unstuff: installing from source..."
	mkdir -p /tmp/unstuff 2>&1 >/dev/null
	cd /tmp/unstuff 2>&1 >/dev/null
	wget -O - http://my.smithmicro.com/downloads/files/stuffit520.611linux-i386.tar.gz | tar -zxv 2>&1 >/dev/null
	cp bin/unstuff /usr/local/bin/ 2>&1 >/dev/null
	cd - 2>&1 >/dev/null
	rm -rf /tmp/unstuff 2>&1 >/dev/null
}

function install_cramfstools
{
	echo "cramfstools: installing from source..."
	# Downloads cramfs tools from sourceforge and installs them to $INSTALL_LOCATION
	TIME=`date +%s`
	INSTALL_LOCATION=/usr/local/bin
	
	# https://github.com/torvalds/linux/blob/master/fs/cramfs/README#L106
	wget  https://downloads.sourceforge.net/project/cramfs/cramfs/1.1/cramfs-1.1.tar.gz?ts=$TIME -O cramfs-1.1.tar.gz 2>&1 >/dev/null
	tar xf cramfs-1.1.tar.gz 2>&1 >/dev/null
	# There is no "make install"
	(cd cramfs-1.1 \
	&& make 2>&1 >/dev/null \
	&& install mkcramfs $INSTALL_LOCATION 2>&1 >/dev/null \
	&& install cramfsck $INSTALL_LOCATION) 2>&1 >/dev/null
	
	rm cramfs-1.1.tar.gz 2>&1 >/dev/null
	rm -rf cramfs-1.1 2>&1 >/dev/null
}

function install_ubireader
{
	echo "ubireader: installing from source..."
	git clone https://github.com/jrspruitt/ubi_reader 2>&1 >/dev/null
	# Some UBIFS extraction breaks after this commit, due to "Added fatal error check if UBI block extends beyond file size"
	# (see this commit: https://github.com/jrspruitt/ubi_reader/commit/af678a5234dc891e8721ec985b1a6e74c77620b6)
	# Reset to a known working commit.
	cd ubi_reader && git reset --hard 0955e6b95f07d849a182125919a1f2b6790d5b51 && python setup.py install 2>&1 >/dev/null
	rm -rf ubi_reader 2>&1 >/dev/null
}

install_sasquatch
install_yaffshiv
install_jefferson
install_unstuff
install_ubireader
install_cramfstools
pip3 install matplotlib
pip3 install capstone
