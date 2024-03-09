###############################################################################
# A Swiss Army Control for the BirdNET-Pixel system
###############################################################################
#set -x

COMMANDS="status stop start restat enable disable log reinstall battery"
SERVICES="recording analysis extraction server sync cleanup watchdog"
BATTERY_COMMAND="upower -i /org/freedesktop/UPower/devices/battery_battery"
REINSTALL_COMMAND=""https://raw.githubusercontent.com/geoffcarlier/BirdNET-Pixel/main/installer.sh" | bash"

usage()
{
  # Display Usage
  echo "Useage: birdnetctl [-h] [COMMAND] [SERVICE_QUALIFIER]" 
  echo ""
  echo "Manage Birdnet-Pixel services"
  echo ""
  echo "COMMANDS - (All services will be commanded by default unless a service qualifier is provided)"
  echo "  - status    List all servers and provide status informatiom"
  echo "  - stop      Stop a service if running, ignore if not"
  echo "  - start     Start a service"
  echo "  - enable    Enable and start a service if not running.  This ensures a service sevivces reboot."
  echo "  - disable   Disable.  The service will not run after a reboot"
  echo "  - log       Get Battery details"
  echo "  - battery   Get Battery details"  
  echo "  - reinstall Rebuild the entire system keeping data intact"  
  echo ""
  echo "SERVICE_QUALIFER - (All services will be commanded, if possible or unless qualified)"
  echo "  - recording"
  echo "  - extraction"
  echo "  - analysis"
  echo "  - server"  
  echo "  - sync"
  echo "  - cleanup"
  echo "  - watchdog"  
  echo ""
  echo "OPTIONS"
  echo "  -h        Print this message"
}


command_services()
{
  if [ -z $2 ] ; then
    for SERVICE in $SERVICES 
      do
        systemctl --user $1 birdnet_$SERVICE.service
      done
  else 
    systemctl --user $1 birdnet_$2
  fi
}

log_service()
{
  if [ -z $2 ] ; then
    echo "No Service qualifier provided for log"
  else 
    journalctl --user -f -u birdnet_$2
  fi
}


###############################################################################
# Main
###############################################################################

if [ -z $1 ] ; then
    echo "Missing COMMAND ..."
    usage
    exit
fi 

COMMAND=$1

case $COMMAND in
  status)
    systemctl --user list-units | grep birdnet
    ;;
  stop | start | restart | enable | disable)
    command_services $1 $2
    ;;
  log)
    log_service $1 $2
    ;; 
  reinstall)
    command_services stop
    $REINSTALL_COMMAND
    ;;
  battery)
    $BATTERY_COMMAND
    ;;
  *) # Invalid Option
    echo "ERROR:  Unsupported Command: $COMMAND"
    exit
    ;;
esac

while getopts "hb" OPTION; do
  case $OPTION in
    h)  # display help
        usage
        exit
        ;;
    \?) # Invalid Option
        echo "ERROR:  Invalid Option"
        exit;;
  esac
done