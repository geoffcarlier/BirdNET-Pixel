#!/bin/bash
#############################################################################
# A Monitoring script handling logging and attempting repairs
#############################################################################
set -x # Debugging
exec > >(tee -i /home/phablet/Documents/.birdnet/logs/watchdog-debug-$(date +%F).txt) 2>&1 # Make log


LOGDIR=/home/phablet/Documents/.birdnet/logs
LOGFILE=$LOGDIR/stats-$(date +%F).log
BIRDNETCTL=/home/phablet/Documents/.birdnet/bin/birdnetctl.sh
BATTERY_LOW_LEVEL=10
BATTERY_DISCHARGE_STATE="discharging"
DISC_FULL_PERCENT_LIMIT=90


[ -d $LOGDIR ] || mkdir -p $LOGDIR


log()
{
  echo "`date +%y-%m-%d:%H:%M:%S` $@" >> $LOGFILE
}

stop_all_services()
{
  $BIRDNETCTL stop recording
  $BIRDNETCTL stop analysis
  $BIRDNETCTL stop extraction
  $BIRDNETCTL stop server
  $BIRDNETCTL stop watchdog.timer
  $BIRDNETCTL stop sync.timer
  $BIRDNETCTL stop cleanup.timer
}

start_all_services()
{
  $BIRDNETCTL start
  $BIRDNETCTL start watchdog.timer
  $BIRDNETCTL start sync.timer
  $BIRDNETCTL start cleanup.timer
}

handle_container_error(){
  stop_all_services
  #journalctl -o json > $LOGDIR/journal-dump-$(date +%F).json
  cp /home/phablet/Documents/.birdnet/ContainersConfig.json /home/phablet/.local/share/libertine
  start_all_services
}

rebuild_system()
{
  stop_all_services

  rm -rf /home/phablet/.local/share/libertine-container/user-data/birdnet/BirdNET-Pi*

  $BIRDNETCTL reinstall
  $BIRDNETCTL start
  $BIRDNETCTL watchdog.timer
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
    stop_all_services
fi

if [ $BATTERY_LEVEL -le $BATTERY_LOW_LEVEL ] && [ "$BATTERY_STATE" -eq "$BATTERY_DISCHARGE_STATE" ] 
then
    sudo systemctl poweroff
fi
# 

# Check Container still exists.  If not shut everything down and gather diagnostics.
CONTAINER=`libertine-container-manager list`

if [ -z $CONTAINER ] 
then
    log "ERROR Container has disappeared!  Shutting down and dumping diagnostics"
    #rebuild_system
    handle_container_error
    #exit
fi
