#!/bin/bash
#apply for Ubuntu 14.04
#author: Vu Phi Hung - 14/03/2017
SOFT="nmap"

# use for downloading script to use
#SERVER=

##############Install #############
#apt-cache search nmap
### Check version OS
version=`lsb_release --release | cut -f2`
distributorid=`lsb_release --id | cut -f2`
if [ "$distributorid" == "Ubuntu" ] && [ "$version" == "14.04" ]; then
        echo -e "$distributorid $version"
#       wget $SERVER/nmap.scan.sh
#       bash
else
        echo -e "Not apply OS -- exit"
        exit
fi

### Check avaible install
Installed=`apt-cache policy $SOFT | grep Installed | cut -d ' ' -f4`
if [ "$Installed" == "(none)" ]; then
        echo "$SOFT is not installed!"
        install="true"
elif [ "x$Installed" == "x" ]; then
        echo "$SOFT is not avaible!"
        exit
else
        echo "$SOFT is installed!"
fi

### Install
if [ "$install" == "true" ]; then
        apt-get update
        apt-get -y install $SOFT
fi
