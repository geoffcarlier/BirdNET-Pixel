#!/usr/bin/env bash
# Install BirdNET script
set -x # Debugging
exec > >(tee -i installation-$(date +%F).txt) 2>&1 # Make log
set -e # exit installation if anything fails

BIRDNET_DOC_HOME=~/Documents
BIRDNET_PIXEL_HOME=$BIRDNET_DOC_HOME/.birdnet
BIRDNET_DATA=$BIRDNET_DOC_HOME/BirdData
BIRDNET_INSTALL_SCRIPTS=$BIRDNET_PIXEL_HOME/install
BIRDNET_SERVICES=$BIRDNET_PIXEL_HOME/services

echo "Creating necessary directories"
[ -d ${BIRDNET_DATA} ] || mkdir -p ${BIRDNET_DATA}
[ -d ${BIRDNET_PIXEL_HOME} ] || mkdir -p ${BIRDNET_PIXEL_HOME}
[ -d ${BIRDNET_INSTALL_SCRIPTS} ] || mkdir -p ${BIRDNET_INSTALL_SCRIPTS}
[ -d ${BIRDNET_SERVICES} ] || mkdir -p ${BIRDNET_SERVICES}

cp /home/phablet/BirdNET-Pi/scripts/birds.db $BIRDNET_DATA

cp /home/phablet/BirdNET-Pixel/install/install_services.sh ${BIRDNET_INSTALL_SCRIPTS}
cp -r /home/phablet/BirdNET-Pixel/services/* ${BIRDNET_SERVICES}

chmod g+rx ${BIRDNET_INSTALL_SCRIPTS}
chmod g+rw ${BIRDNET_SERVICES}/*
chmod g+rx ${BIRDNET_SERVICES}/bin/*

exit 0
