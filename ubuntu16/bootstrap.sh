#!/bin/bash

set -e

export CIF_ANSIBLE_ES=$CIF_ANSIBLE_ES
export CIF_ANSIBLE_SDIST=$CIF_ANSIBLE_SDIST
export CIF_HUNTER_THREADS=$CIF_HUNTER_THREADS
export CIF_HUNTER_ADVANCED=$CIF_HUNTER_ADVANCED
export CIF_GATHERER_GEO_FQDN=$CIF_GATHERER_GEO_FQDN

echo 'installing the basics'
apt-get update && apt-get upgrade -y
apt-get install -y gcc git python3-minimal python3-pip unzip

update-alternatives --install /usr/bin/python python /usr/bin/python3.5 1
update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

pip install --upgrade pip cryptography
apt-get --auto-remove --yes remove python3-yaml


echo 'checking for python-openssl'
set +e
EXISTS=$( dpkg -l | grep python-openssl )
set -e
if [[ ! -z ${EXISTS} ]]; then
	echo "Python-openssl found. Applying workaround"
	echo "#@link https://github.com/csirtgadgets/bearded-avenger-deploymentkit/issues/15"
	echo "# sudo apt-get --auto-remove --yes remove python-openssl"
	echo "# sudo pip install pyOpenSSL"
	sudo apt-get --auto-remove --yes remove python-openssl && sudo pip3 install pyOpenSSL
fi

sudo pip install 'pytest>=2.8.0,<3.0'

bash ../ansible.sh

if [[ "$CIF_BOOTSTRAP_TEST" -eq '1' ]]; then
    bash ../test.sh
fi
