FROM ubuntu:18.04

ARG DBPASS

# apt install bytewalk deps
RUN apt-get update
RUN apt-get -y install vim git python3 python3-pip python openssh-client sudo
# for debug
#RUN apt-get -y install curl net-tools dnsutils iputils-ping postgresql-client-10

# pull bytesweep-web
RUN cd /opt && git clone https://gitlab.com/bytesweep/bytesweep-web.git

# install bytesweep-web python deps
RUN pip3 install -r /opt/bytesweep-web/requirements.txt

# create bytesweep user and group
RUN getent passwd bytesweep >/dev/null || useradd -r --create-home -U -d /home/bytesweep -s /sbin/nologin -c "Bytesweep user" bytesweep

# create bytesweep upload_dir
RUN mkdir -p /var/opt/bytesweep-uploads
RUN chown -R bytesweep:bytesweep /var/opt/bytesweep-uploads

# create config file
RUN mkdir /etc/bytesweep
RUN cp /opt/bytesweep-web/example-config.yaml /etc/bytesweep/config.yaml
RUN chown bytesweep:bytesweep /etc/bytesweep/config.yaml
RUN chmod 400 /etc/bytesweep/config.yaml

# set dbpass and dbhost
RUN sed -i -e "s/dbpass: '.*'/dbpass: '${DBPASS}'/g" /etc/bytesweep/config.yaml
RUN sed -i -e "s/dbhost: '127.0.0.1'/dbhost: 'database'/g" /etc/bytesweep/config.yaml

# set flask_secret_key
RUN salt=$(tr -dc A-Za-z0-9_ < /dev/urandom | head -c 50) && sed -i "s/flask_secret_key: '.*'/flask_secret_key: '$salt'/" /etc/bytesweep/config.yaml


CMD ["/usr/local/bin/gunicorn","-b","0.0.0.0:8000","--chdir","/opt/bytesweep-web","main:app"]
