#!/bin/bash

##############Install #############
# Install rsyslog 8
add-apt-repository ppa:adiscon/v8-stable -y
apt-get update
apt-get -y install rsyslog
rm /etc/apt/sources.list.d/adiscon-v8-stable-trusty.list
apt-get update;

# restart service
service rsyslog restart

# check rsyslog
rsyslogd -v
