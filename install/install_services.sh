#!/usr/bin/env bash
# An installation script to create:
# - Libertine ontainer for binaries and BirdNET-Pi and BirdNET-Pixel git projects
# - Install required services
# - Create the required Directory structure and file. 
#
# Code is based around the BirdNET-Pi code

# Make sure only root can run this script
if [ "$(id -u)" != "0" ]; then
   echo "    Must be run as root, you must prepend sudo !" 1>&2 ; exit 1
fi

set -x # Uncomment to enable debugging
trap 'rm -f ${tmpfile}' EXIT
trap 'exit 1' SIGINT SIGHUP
tmpfile=$(mktemp)

config_file=$my_dir/birdnet.conf
export USER=phablet
export HOME=/home/phablet

export BIRDNET_PIXEL_HOME=/home/phablet/Documents/.birdnet

install_scripts() {
  ln -sf ${my_dir}/scripts/* /usr/local/bin/
}

install_service() {
  su - ${USER} -c "cp $BIRDNET_PIXEL_HOME/services/$1.service /home/phablet/.config/systemd/user/"
  systemctl enable $1.service
}

install_timer() {
  su - ${USER} -c "cp $BIRDNET_PIXEL_HOME/services/$1.service /home/phablet/.config/systemd/user/"
  su - ${USER} -c "cp $BIRDNET_PIXEL_HOME/services/$1.timer /home/phablet/.config/systemd/user/"  
  systemctl enable $1.timer
}



install_services() {
  install_service "birdnet_analysis"
  install_service "birdnet_server"
  install_service "birdnet_recording"
  install_service "birdnet_extraction"
  install_timer "birdnet_cleanup"
  install_timer "birdnet_weekly_report"
  install_timer "birdnet_sync"
}

install_services

