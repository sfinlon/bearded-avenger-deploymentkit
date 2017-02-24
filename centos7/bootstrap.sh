#!/bin/bash

export CIF_ELASTICSEARCH=$CIF_ELASTICSEARCH
export CIF_ANSIBLE_SDIST=$CIF_ANSIBLE_SDIST

sudo rpm -iUvh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

set -e

yum -y update

echo 'updating apt-get tree and installing python-pip'
sudo yum install -y gcc python-pip python-devel git libffi-devel openssl-devel

bash ../ansible.sh

bash ../test.sh