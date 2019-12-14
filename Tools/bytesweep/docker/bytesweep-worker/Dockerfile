FROM ubuntu:18.04

ARG DBPASS
ENV RADARE2_TAG 3.5.1

# apt install bytewalk deps
RUN apt-get update
RUN apt-get -y install wget git python3 python3-pip python python-pip python-lzma curl arj cabextract cpio gzip mtd-utils p7zip squashfs-tools tar bzip2 unrar xz-utils lhasa sleuthkit liblzma-dev zlib1g-dev openssh-client sudo liblzo2-dev zlib1g-dev

# pull bytewalk
RUN cd /opt && git clone https://gitlab.com/bytesweep/bytewalk.git

# install bytewalk
RUN cd /opt/bytewalk && python3 setup.py install

# install jefferson
RUN pip2 install cstruct==1.0 backports.lzma
RUN cd /opt && git clone https://github.com/sviehb/jefferson
RUN cd /opt/jefferson && python2 setup.py install

# install sasquatch
RUN cd /opt && git clone https://github.com/devttys0/sasquatch
RUN cd /opt/sasquatch && wget https://downloads.sourceforge.net/project/squashfs/squashfs/squashfs4.3/squashfs4.3.tar.gz
RUN cd /opt/sasquatch && tar -zxvf squashfs4.3.tar.gz
RUN cd /opt/sasquatch/squashfs4.3 && patch -p0 < ../patches/patch0.txt
RUN cd /opt/sasquatch/squashfs4.3/squashfs-tools && make && make install

# INSTALL BYTESWEEP-WORKER

# pull bytesweep-worker
RUN cd /opt && git clone https://gitlab.com/bytesweep/bytesweep-worker.git

# install bytesweep-web python deps
RUN pip3 install -r /opt/bytesweep-worker/requirements.txt

# create bytesweep user and group
RUN getent passwd bytesweep >/dev/null || useradd -r --create-home -U -d /home/bytesweep -s /sbin/nologin -c "Bytesweep user" bytesweep

# create bytesweep extraction_dir
RUN mkdir -p /var/opt/bytesweep-extraction
RUN chown -R bytesweep:bytesweep /var/opt/bytesweep-extraction

# create config file
RUN mkdir /etc/bytesweep
RUN cp /opt/bytesweep-worker/example-config.yaml /etc/bytesweep/config.yaml
RUN chown bytesweep:bytesweep /etc/bytesweep/config.yaml
RUN chmod 400 /etc/bytesweep/config.yaml

# set dbpass and dbhost
RUN sed -i -e "s/dbpass: '.*'/dbpass: '${DBPASS}'/g" /etc/bytesweep/config.yaml
RUN sed -i -e "s/dbhost: '127.0.0.1'/dbhost: 'database'/g" /etc/bytesweep/config.yaml

# install radare2
RUN cd /opt && git clone https://github.com/radare/radare2.git
RUN cd /opt/radare2 && git checkout "tags/${RADARE2_TAG}"
RUN cd /opt/radare2 && ./configure
RUN cd /opt/radare2 && make -j4
RUN cd /opt/radare2 && make install

WORKDIR /opt/bytesweep-worker

CMD ["/usr/bin/python3","/opt/bytesweep-worker/worker.py"]
