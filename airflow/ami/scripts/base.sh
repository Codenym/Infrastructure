#!/bin/bash
set -e

systemctl disable apt-daily.service
systemctl disable apt-daily.timer

apt-get update -y
apt-get upgrade -y

apt-get install -y \
        # build-essential  \
        wget \
        apt-transport-https \
        ca-certificates \
        python-apt \
        python3-pip \
        curl \
        unzip \

pip install awscli
pip install credstash

apt-get dist-upgrade -y
