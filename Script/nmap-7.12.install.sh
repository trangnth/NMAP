#!/bin/bash

# date: 22/03/2017

### Check version ###
CURRENT_VERSION=`nmap -V | grep version | cut -d ' ' -f3`
VERSION="7.12"

if [ "$CURRENT_VERSION" == "$VERSION" ]; then
	echo "Installed nmap $VERSION"
	exit
fi

### Remove old version
if [ "x$CURRENT_VERSION" != "x" ]; then
	apt-get remove nmap -y
fi

##############Install #############
# Install nmap 8
add-apt-repository ppa:pi-rho/security -y
apt-get update
apt-get -y install nmap
rm -rf /etc/apt/sources.list.d/pi-rho-security-trusty.list
apt-get update

# check nmap
INSTALLED_VERSION=`nmap -V | grep version | cut -d ' ' -f3`

echo "nmap $INSTALLED_VERSION Intalled!"