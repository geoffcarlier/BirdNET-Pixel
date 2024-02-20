#!/usr/bin/env bash
# Install BirdNET script
set -x # Debugging
exec > >(tee -i installation-$(date +%F).txt) 2>&1 # Make log
set -e # exit installation if anything fails

BIRDNET_DOC_HOME=~/Documents
BIRDNET_PIXEL_HOME=$BIRDNET_DOC_HOME/.birdnet
BIRDNET_DATA=$BIRDNET_DOC_HOME/BirdnetData
BIRDNET_INSTALL_SCRIPTS=$BIRDNET_PIXEL_HOME/install

echo "Creating necessary directories"
[ -d ${BIRDNET_DATA} ] || mkdir -p ${BIRDNET_DATA}
[ -d ${BIRDNET_PIXEL_HOME} ] || mkdir -p ${BIRDNET_PIXEL_HOME}
[ -d ${BBIRDNET_INSTALL_SCRIPTS} ] || mkdir -p ${BIRDNET_INSTALL_SCRIPTS}

cp /home/phablet/BirdNET-Pixel/install/install_services.sh BIRDNET_INSTALL_SCRIPTS

chmod -R g+rw $my_dir
chmod -R g+rw ${RECS_DIR}

exit 0
