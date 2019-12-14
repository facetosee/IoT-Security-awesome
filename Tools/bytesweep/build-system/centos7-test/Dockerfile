

FROM library/centos:7

# Import keys and fix passwd issue.
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

RUN yum -y update

# install epel-release
RUN yum -y install epel-release

#for fast dev: bytesweep
RUN yum -y install python36 python36-devel python36-pip python36-ruamel-yaml python36-urllib3 python36-psycopg2 python36-requests gcc

# for fast dev: bytewalk
RUN yum -y install python36 python36-devel python36-pip python python-setuptools python2-pip python-Bottleneck cpio wget git gcc gcc-c++ make openssl-devel qtwebkit-devel qt-devel gzip bzip2 tar arj p7zip p7zip-plugins cabextract squashfs-tools zlib zlib-devel lzo lzo-devel xz xz-compat-libs xz-libs xz-devel xz-lzma-compat python-backports-lzma lzip pyliblzma perl-Compress-Raw-Lzma lzop srecord

# install dev tools
#RUN yum -y groupinstall "Development Tools"

# centos7 deps
#RUN yum -y install python36 rubygems ruby-devel

# install fpm
#RUN gem install --no-document fpm


