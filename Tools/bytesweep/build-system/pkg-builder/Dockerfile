FROM ubuntu:18.04


# apt install bytewalk deps
RUN apt-get update
RUN apt-get -y install vim git sudo openssh-client ruby ruby-dev rubygems build-essential python3 python3-distutils python3-setuptools wget python lsb-core curl

# testing deps: this speeds up testing
RUN apt-get -y install dh-python gir1.2-glib-2.0 gunicorn3 libexpat1-dev libgirepository-1.0-1 libpq5 libpython3-dev libpython3.6-dev python-pip-whl python3-asn1crypto python3-bcrypt python3-blinker python3-certifi python3-cffi-backend python3-chardet python3-click python3-colorama python3-crypto python3-cryptography python3-dbus python3-dev python3-flask python3-flask-login python3-gi python3-gunicorn python3-idna python3-itsdangerous python3-jinja2 python3-keyring python3-keyrings.alt python3-magic python3-markupsafe python3-openssl python3-pip python3-psycopg2 python3-pyinotify python3-requests python3-ruamel.yaml python3-secretstorage python3-simplejson python3-six python3-urllib3 python3-werkzeug python3-wheel python3-xdg python3.6-dev

# install fpm
RUN gem install --no-ri --no-rdoc fpm

# clone all bytesweep repos
ARG bytesweep_version
ARG bytewalk_version
RUN mkdir -p /builds/bytesweep
RUN mkdir -p /builds/bytewalk
RUN cd /builds/bytesweep && git clone https://gitlab.com/bytesweep/bytesweep-web.git
RUN cd /builds/bytesweep/bytesweep-web && git fetch --all --tags --prune
RUN cd /builds/bytesweep/bytesweep-web && git checkout "tags/v${bytesweep_version}" -b "v${bytesweep_version}"
RUN cd /builds/bytesweep && git clone https://gitlab.com/bytesweep/bytesweep-worker.git
RUN cd /builds/bytesweep/bytesweep-worker && git fetch --all --tags --prune
RUN cd /builds/bytesweep/bytesweep-worker && git checkout "tags/v${bytesweep_version}" -b "v${bytesweep_version}"
RUN cd /builds/bytesweep && git clone https://gitlab.com/bytesweep/bytesweep-cvefetch.git
RUN cd /builds/bytesweep/bytesweep-cvefetch && git fetch --all --tags --prune
RUN cd /builds/bytesweep/bytesweep-cvefetch && git checkout "tags/v${bytesweep_version}" -b "v${bytesweep_version}"
RUN cd /builds/bytesweep && git clone https://gitlab.com/bytesweep/bytesweep-watchdog.git
RUN cd /builds/bytesweep/bytesweep-watchdog && git fetch --all --tags --prune
RUN cd /builds/bytesweep/bytesweep-watchdog && git checkout "tags/v${bytesweep_version}" -b "v${bytesweep_version}"
RUN cd /builds/bytewalk && git clone https://gitlab.com/bytesweep/bytewalk.git
RUN cd /builds/bytewalk/bytewalk && git fetch --all --tags --prune
RUN cd /builds/bytewalk/bytewalk && git checkout "tags/v${bytewalk_version}" -b "v${bytewalk_version}"

# bytesweep build setup
WORKDIR /builds/bytesweep
RUN echo "${bytesweep_version}" > version
ADD scripts/bytesweep-ubuntu-18-postinst.sh bytesweep-ubuntu-18-postinst.sh
ADD scripts/bytesweep-centos-7-postinst.sh bytesweep-centos-7-postinst.sh
ADD scripts/bytesweep-centos-7-postrm.sh bytesweep-ubuntu-18-postrm.sh
ADD scripts/bytesweep-centos-7-postrm.sh bytesweep-centos-7-postrm.sh
RUN mv bytesweep-web/example-config.yaml config.yaml
RUN mv bytesweep-web/bytesweep-web.service .
RUN mv bytesweep-worker/bytesweep-worker.service .
RUN mv bytesweep-cvefetch/bytesweep-cvefetch.service .
RUN mv bytesweep-watchdog/bytesweep-watchdog.service .
RUN cd bytesweep-web && rm -rf .gitignore .git scripts utils
RUN cd bytesweep-worker && rm -rf .gitignore .git scripts
RUN cd bytesweep-cvefetch && rm -rf .gitignore .git
RUN cd bytesweep-watchdog && rm -rf .gitignore .git

# build bytesweep: ubuntu 18.04 deb
RUN fpm -s dir -t deb -n bytesweep -v ${bytesweep_version} --package "bytesweep-${bytesweep_version}-ubuntu-18.04.deb" --description "an IoT firmware security analysis platform" --license "AGPLv3/GPLv3" --after-install bytesweep-ubuntu-18-postinst.sh --after-remove bytesweep-ubuntu-18-postrm.sh -d python3 -d python3-pip -d python3-magic -d python3-distutils -d python3-ruamel.yaml -d python3-flask -d python3-flask-login -d python3-werkzeug -d python3-urllib3 -d python3-psycopg2 -d python3-bcrypt -d python3-gunicorn -d python3-requests -d gunicorn3 --deb-systemd bytesweep-web.service --deb-systemd bytesweep-worker.service --deb-systemd bytesweep-cvefetch.service --deb-systemd bytesweep-watchdog.service bytesweep-web=/opt/ bytesweep-worker=/opt/ bytesweep-cvefetch=/opt/ bytesweep-watchdog=/opt/ config.yaml=/etc/bytesweep/config.yaml

# build bytesweep: centos 7 rpm
RUN fpm -s dir -t rpm -n bytesweep -v ${bytesweep_version} --package "bytesweep-${bytesweep_version}-centos-7.rpm" --description "an IoT firmware security analysis platform" --license "AGPLv3/GPLv3" --after-install bytesweep-centos-7-postinst.sh --after-remove bytesweep-centos-7-postrm.sh -d python36 -d python36-devel -d python36-pip -d python36-urllib3 -d python36-psycopg2 -d python36-requests -d gcc bytesweep-web.service=/lib/systemd/system/ bytesweep-worker.service=/lib/systemd/system/ bytesweep-cvefetch.service=/lib/systemd/system/ bytesweep-watchdog.service=/lib/systemd/system/ bytesweep-web=/opt/ bytesweep-worker=/opt/ bytesweep-cvefetch=/opt/ bytesweep-watchdog=/opt/ config.yaml=/etc/bytesweep/config.yaml

# bytewalk build setup
WORKDIR /builds/bytewalk
RUN echo "${bytesweep_version}" > version
ADD scripts/bytewalk-ubuntu-18-postinst.sh bytewalk-ubuntu-18-postinst.sh
ADD scripts/bytewalk-centos-7-postinst.sh bytewalk-centos-7-postinst.sh

# build bytewalk: ubuntu 18.04 deb
RUN fpm -s python -t deb -n bytewalk -v ${bytewalk_version} --package "bytewalk-${bytewalk_version}-ubuntu-18.04.deb" --description "firmware extraction tool" --license "MIT" --after-install bytewalk-ubuntu-18-postinst.sh -d python3 -d python3-pip -d python3-distutils -d python3-matplotlib -d python3-capstone -d python -d python-setuptools -d python-pip -d git -d build-essential -d libqt4-opengl -d mtd-utils -d gzip -d bzip2 -d tar -d arj -d lhasa -d p7zip -d p7zip-full -d cabextract -d cramfsswap -d squashfs-tools -d zlib1g-dev -d liblzma-dev -d liblzo2-dev -d sleuthkit -d lzop -d srecord -d cpio --python-bin /usr/bin/python3 bytewalk/setup.py

# build bytewalk: centos 7 deb
RUN fpm -s python -t rpm -n bytewalk -v ${bytewalk_version} --package "bytewalk-${bytewalk_version}-centos-7.rpm" --description "firmware extraction tool" --license "MIT" --python-install-lib /usr/local/lib/python3.6/site-packages --after-install bytewalk-centos-7-postinst.sh -d python36 -d python36-devel -d python36-pip -d python -d python-setuptools -d python2-pip -d python-Bottleneck -d cpio -d wget -d git -d gcc -d gcc-c++ -d make -d openssl-devel -d qtwebkit-devel -d qt-devel -d gzip -d bzip2 -d tar -d arj -d p7zip -d p7zip-plugins -d cabextract -d squashfs-tools -d zlib -d zlib-devel -d lzo -d lzo-devel -d xz -d xz-compat-libs -d xz-libs -d xz-devel -d xz-lzma-compat -d python-backports-lzma -d lzip -d pyliblzma -d perl-Compress-Raw-Lzma -d lzop -d srecord --python-bin /usr/bin/python3 bytewalk/setup.py

# add release & testing tools
ADD create_release.sh /builds/create_release.sh
RUN chmod 755 /builds/create_release.sh
ADD delete_release.sh /builds/delete_release.sh
RUN chmod 755 /builds/delete_release.sh
ADD export_artifacts.sh /builds/export_artifacts.sh
RUN chmod 755 /builds/export_artifacts.sh
WORKDIR /builds

