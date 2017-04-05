#!/bin/bash
###Golbal

VNDATE=`date "+%Y-%m-%d-%H%M"`

### SERVER to send results by rsyslog
SERVER="192.168.169.135"
PORT="514"

RSYSLOGCONF="/etc/rsyslog.d/nmap.conf"
DATESCAN=`date '+%Y-%m-%d %H:%M:%S'`
PATH_CONF="/home/huyentrang/nmap/"
CONF_FILE="nmap.conf"

##################Code Scan##############

### check version
CURRENT_VERSION=`nmap -V | grep version | cut -d ' ' -f3`

if [ "x$CURRENT_VERSION" == "x" ]; then
	echo "nmap is not installed, please check again"
	exit 1
fi

### check config

if [ ! -f $CONF_FILE ]; then
	echo "No config file!"
fi 

cd $PATH_CONF
TARGET_SCAN=`cat $CONF_FILE | grep TARGET_SCAN | cut -f2`
OPTIONS=`cat $CONF_FILE | grep OPTIONS | cut -f2`
RUN=`cat $CONF_FILE | grep -w RUN | cut -f2`
#echo $RUN
if [[ $RUN == "n" ]]; then
	#echo "3"
	exit 0
fi 

RESULTS=/var/log/nmap.results.log

if [ -f $RESULTS ]; then
	rm $RESULTS
	touch $RESULTS
	#echo "del"
else
	touch $RESULTS
#	chmod 660 $RESULTS
fi

# add config rsyslog
cat > $RSYSLOGCONF <<EOL
module(load="imfile" PollingInterval="10") 
input(type="imfile"
  File="$RESULTS"
  Tag="nmap"
  Severity="info"
  Facility="local3"
)
local3.* @$SERVER:$PORT
EOL

service rsyslog restart 

# start scan
echo "Defaut scan: DIRECTORY=$TARGET_SCAN ! "

nmap $OPTIONS -T4 $TARGET_SCAN -oG $RESULTS
#echo $DATESCAN >> $RESULTS

##################Exit Code Scan##############
