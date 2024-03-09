#!/usr/bin/env bash
# An installation script to create:
# - Libertine ontainer for binaries and BirdNET-Pi and BirdNET-Pixel git projects
# - Install required services
# - Create the required Directory structure and file. 
#
# Code is based around the BirdNET-Pi code

set -x # Uncomment to enable debugging
trap 'rm -f ${tmpfile}' EXIT
trap 'exit 1' SIGINT SIGHUP
set -e # exit installation if anything fails

tmpfile=$(mktemp)

config_file=$my_dir/birdnet.conf
export USER=phablet
export HOME=/home/phablet

export BIRDNET_PIXEL_HOME=/home/phablet/Documents/.birdnet

install_scripts() {
  ln -sf ${my_dir}/scripts/* /usr/local/bin/
}

[ -d /home/phablet/.config/systemd/ ] || mkdir -p /home/phablet/.config/systemd/
[ -d /home/phablet/.config/systemd/user ] || mkdir -p /home/phablet/.config/systemd/user

install_service() {
  cp $BIRDNET_PIXEL_HOME/services/$1.service /home/phablet/.config/systemd/user/
  chmod 644 /home/phablet/.config/systemd/user/$1.service
  systemctl --user enable $1.service
}

install_timer() {
  cp $BIRDNET_PIXEL_HOME/services/$1.service /home/phablet/.config/systemd/user/
  cp $BIRDNET_PIXEL_HOME/services/$1.timer /home/phablet/.config/systemd/user/
  chmod 644 /home/phablet/.config/systemd/user/$1.*
  systemctl --user enable $1.timer
}

install_services() {
  install_service "birdnet_analysis"
  install_service "birdnet_server"
  install_service "birdnet_recording"
  install_service "birdnet_extraction"
  install_timer "birdnet_cleanup"
  install_timer "birdnet_sync"
  install_timer "birdnet_watchdog"
}

install_services
