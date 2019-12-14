
# Deployment Options

- Docker
- Ubuntu 18.04
- Centos 7

# Installation

## Docker

### Clone bytesweep Repo
```
git clone https://gitlab.com/bytesweep/bytesweep.git
cd docker
```

### Build Containers
```
./build-bytesweep.sh 
```

### Start Containers
```
./start-bytesweep.sh 
```

### Navigate to http://127.0.0.1:8000

## Ubuntu 18.04

1. Install Postgres DB

The below commands will do the following:
- create user `bsuser`
- create database `bytesweep`
- grant all privs on `bytesweep` to `bsuser`

step-by-step database setup commands:
```
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo -u postgres psql
pqsl> CREATE USER bsuser WITH PASSWORD 'YOUR-PASS-HERE';
psql> CREATE DATABASE bytesweep;
psql> GRANT ALL PRIVILEGES ON DATABASE bytesweep to bsuser;

```

- reference: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-18-04

2. Install ByteSweep and Bytewalk apt dependencies
```
sudo apt-get install python3 python3-distutils python3-pip python3-magic python3-ruamel.yaml python3-flask python3-flask-login python3-werkzeug python3-urllib3 python3-psycopg2 python3-bcrypt python3-gunicorn python3-itsdangerous python3-pyinotify python3-simplejson python3-requests python3-matplotlib python3-capstone python python-setuptools python-pip gunicorn3 git build-essential libqt4-opengl mtd-utils gzip bzip2 tar arj lhasa p7zip p7zip-full cabextract cramfsswap squashfs-tools zlib1g-dev liblzma-dev liblzo2-dev sleuthkit lzop srecord cpio
```

3. Install ByteSweep and Bytewalk

grab latest Ubuntu 18.04 ByteSweep and Bytewalk deb installer URLs: https://gitlab.com/bytesweep/bytesweep/-/releases

```
wget <bytesweep URL>
wget <bytewalk URL>
dpkg -i bytesweep_<version>_amd64.deb bytewalk_<version>_all.deb 
```

4. Install Radare2 and r2pipe

grab either latest from master or latest release. depends on how risky you feel ;)

releases: https://github.com/radare/radare2/releases
master branch: https://github.com/radare/radare2.git

Install from release:
```
# install radare2
wget https://github.com/radare/radare2/archive/<version>.tar.gz
tar -zxf <version>.tar.gz
cd radare2-<version>
./configure
make -j4
sudo make install

# install r2pipe
sudo pip3 install r2pipe
```

5. Set Database Password

edit `/etc/bytesweep/config.yaml` and set the `dbpass` value to the password you set for the user `bsuser` in step 0.

6. Start and Enable Services

```
# start
sudo systemctl start bytesweep-web.service
sudo systemctl start bytesweep-worker.service
sudo systemctl start bytesweep-cvefetch.service
sudo systemctl start bytesweep-watchdog.service
# enable
sudo systemctl enable bytesweep-web.service
sudo systemctl enable bytesweep-worker.service
sudo systemctl enable bytesweep-cvefetch.service
sudo systemctl enable bytesweep-watchdog.service

```

7. Navigate to http://127.0.0.1:8000

8. Optional: Setup Nginx Reverse Proxy

```
sudo apt-get install nginx
```

replace the contents of `/etc/nginx/sites-available/default` with one of the following:

for HTTPS with HTTP redirect to HTTPS:
```
server {
	server_name your.hostname.com;
	proxy_set_header Host   $host;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	client_max_body_size 1000M;
	location / {
		proxy_pass http://127.0.0.1:8000;
	}
    listen 443 ssl;
    ssl_certificate PATH_TO_SSL_CERT;
    ssl_certificate_key PATH_TO_SSL_KEY;
}

server {
    listen 80;
    server_name _;
    return 301 https://$host$request_uri;
}
```

for HTTP
```
server {
    server_name your.hostname.com;
    proxy_set_header Host   $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    client_max_body_size 1000M;
    location / {
        proxy_pass http://127.0.0.1:8000;
    }
    listen 80;
}
```

restart nginx:
```
sudo systemctl restart nginx
```

ByteSweep should now be accessible from `your.hostname.com`


## Centos 7

1. Install Postgres DB

NOTE: bytesweep requires postgres version >= 9.4

The below commands will do the following:
- install postgres 9.4
- create user `bsuser`
- create database `bytesweep`
- grant all privs on `bytesweep` to `bsuser`

step-by-step database setup process:

part 1:
```
sudo rpm -ivh https://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-3.noarch.rpm
sudo yum install postgresql94-server
sudo /usr/pgsql-9.4/bin/postgresql94-setup initdb
```

part 2:
edit `/var/lib/pgsql/9.4/data/pg_hba.conf` to contain the following line:
```
host    all             all             127.0.0.1/32            md5
```
part3:
```
sudo systemctl start postgresql-9.4.service
sudo systemctl enable postgresql-9.4.service
sudo -u postgres psql
pqsl> CREATE USER bsuser WITH PASSWORD 'YOUR-PASS-HERE';
psql> CREATE DATABASE bytesweep;
psql> GRANT ALL PRIVILEGES ON DATABASE bytesweep to bsuser;

```

- reference: https://geekpeek.net/install-postgresql-9-4-on-centos-7/

2. Install ByteSweep and Bytewalk

grab latest Centos 7 ByteSweep and Bytewalk rpm installer URLs: https://gitlab.com/bytesweep/bytesweep/-/releases

```
wget <bytesweep URL>
wget <bytewalk URL>
sudo yum install bytesweep-<version>-centos-7.rpm bytewalk-<version>-centos-7.rpm
```

3. Install Radare2 and r2pipe

grab either latest from master or latest release. depends on how risky you feel ;)

releases: https://github.com/radare/radare2/releases
master branch: https://github.com/radare/radare2.git

Install from release:
```
# compile deps
sudo yum install gcc make patch
# install radare2
wget https://github.com/radare/radare2/archive/<version>.tar.gz
tar -zxf <version>.tar.gz
cd radare2-<version>
./configure
make -j4
sudo make install

# install r2pipe
sudo pip3 install r2pipe
```

4. Set Database Password

edit `/etc/bytesweep/config.yaml` and set the `dbpass` value to the password you set for the user `bsuser` in step 0.

5. Start and Enable Services

```
# start
sudo systemctl start bytesweep-web.service
sudo systemctl start bytesweep-worker.service
sudo systemctl start bytesweep-cvefetch.service
sudo systemctl start bytesweep-watchdog.service
# enable
sudo systemctl enable bytesweep-web.service
sudo systemctl enable bytesweep-worker.service
sudo systemctl enable bytesweep-cvefetch.service
sudo systemctl enable bytesweep-watchdog.service

```

6. Navigate to http://127.0.0.1:8000

7. Optional: Setup Nginx Reverse Proxy

```
sudo yum install nginx
```

replace the `server` block of `/etc/nginx/nginx.conf` with one of the following:

for HTTPS with HTTP redirect to HTTPS:
```
server {
	server_name your.hostname.com;
	proxy_set_header Host   $host;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	client_max_body_size 1000M;
	location / {
		proxy_pass http://127.0.0.1:8000;
	}
    listen 443 ssl;
    ssl_certificate PATH_TO_SSL_CERT;
    ssl_certificate_key PATH_TO_SSL_KEY;
}

server {
    listen 80;
    server_name _;
    return 301 https://$host$request_uri;
}
```

for HTTP
```
server {
    server_name your.hostname.com;
    proxy_set_header Host   $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    client_max_body_size 1000M;
    location / {
        proxy_pass http://127.0.0.1:8000;
    }
    listen 80;
}
```

restart nginx:
```
sudo systemctl restart nginx
```

ByteSweep should now be accessible from `your.hostname.com`
