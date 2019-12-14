FROM ubuntu:18.04

ARG DBPASS

# apt install watchdog deps
RUN apt-get update
RUN apt-get -y install wget git python3 python3-pip openssh-client sudo

# pull watchdog
RUN cd /opt && git clone https://gitlab.com/bytesweep/bytesweep-watchdog.git

# install bytesweep-cvefetch python deps
RUN pip3 install -r /opt/bytesweep-watchdog/requirements.txt

# create bytesweep user and group
RUN getent passwd bytesweep >/dev/null || useradd -r --create-home -U -d /home/bytesweep -s /sbin/nologin -c "Bytesweep user" bytesweep

# create config file
RUN mkdir /etc/bytesweep
RUN cp /opt/bytesweep-watchdog/example-config.yaml /etc/bytesweep/config.yaml
RUN chown bytesweep:bytesweep /etc/bytesweep/config.yaml
RUN chmod 400 /etc/bytesweep/config.yaml

# set dbpass and dbhost
RUN sed -i -e "s/dbpass: '.*'/dbpass: '${DBPASS}'/g" /etc/bytesweep/config.yaml
RUN sed -i -e "s/dbhost: '127.0.0.1'/dbhost: 'database'/g" /etc/bytesweep/config.yaml

CMD ["/usr/bin/sudo","-u","bytesweep","/usr/bin/python3","/opt/bytesweep-watchdog/watchdog.py"]
