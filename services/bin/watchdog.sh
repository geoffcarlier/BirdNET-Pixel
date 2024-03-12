#!/bin/bash
#############################################################################
# A Monitoring script handling logging and attempting repairs
#############################################################################

LOGDIR=/home/phablet/Documents/.birdnet/logs
LOGFILE=$LOGDIR/birdnet-`date +%y-%m-%d`.log
BIRDNETCTL=/home/phablet/Documents/.birdnet/bin/birdnetctl.sh
BATTERY_LOW_LEVEL=10
BATTERY_DISCHARGE_STATE="discharging"
DISC_FULL_PERCENT_LIMIT=90


[ -d $LOGDIR ] || mkdir -p $LOGDIR


log()
{
  echo "`date +%y-%m-%d:%H:%M:%S` $@" >> $LOGFILE
}

rebuild_system()
{
  $BIRDNETCTL stop recording
  $BIRDNETCTL stop analysis
  $BIRDNETCTL stop extraction
  $BIRDNETCTL stop server

  rm -rf /home/phablet/.local/share/libertine-container/user-data/birdnet/BirdNET-Pi*

  $BIRDNETCTL reinstall
  $BIRDNETCTL start
}

################################## MAIN #####################################

# Collect and log info
BATTERY_LEVEL=`$BIRDNETCTL battery | grep percentage | grep -Eo '[0-9]{1,3}'`
BATTERY_TEMP=`$BIRDNETCTL battery | grep temperature | awk '{print $2}'`
BATTERY_STATE=`$BIRDNETCTL battery | grep state | awk '{print $2}'`

log "Battery $BATTERY_LEVEL $BATTERY_TEMP $BATTERY_STATE"

log "Uptime `uptime`"

DISC_USED=`df | grep userdata | awk '{print $3}'`
DISC_USED_PERCENT=`df | grep userdata | awk '{print $5}' | tr -d %`
DISC_AVAILABLE=`df | grep userdata | awk '{print $4}'`

log "Disk $DISC_USED $DISC_AVAILABLE $DISC_USED_PERCENT"

if [ $DISC_USED_PERCENT -gt $DISC_FULL_PERCENT_LIMIT ] 
then
    log "ERROR Disc is too full for continued operation.  Stopping services"
    $BIRDNETCTL disable recording
    $BIRDNETCTL stop recording
    $BIRDNETCTL disable extraction
    $BIRDNETCTL stop extraction
    $BIRDNETCTL disable analysis
    $BIRDNETCTL stop analysis
    $BIRDNETCTL disable server
    $BIRDNETCTL stop server
fi

if [ $BATTERY_LEVEL -le $BATTERY_LOW_LEVEL ] && [ "$BATTERY_STATE" -eq "$BATTERY_DISCHARGE_STATE" ] 
then
    sudo systemctl poweroff
fi
# 

# Check Container still exists.  If not try rebuilding.
CONTAINER=`libertine-container-manager list`

if [ -z $CONTAINER ] 
then
    log "ERROR Container has disappeared!  Attempting to rebuild"
    rebuild_system
    exit
fi
