#!/usr/bin/env bash
# Install BirdNET script
set -x # Debugging
exec > >(tee -i /home/phablet/Documents/.birdnet/logs/installation-pixel-$(date +%F).txt) 2>&1 # Make log
set -e # exit installation if anything fails

BIRDNET_DOC_HOME=~/Documents
BIRDNET_PIXEL_HOME=$BIRDNET_DOC_HOME/.birdnet
BIRDNET_DATA=$BIRDNET_DOC_HOME/BirdData
BIRDNET_INSTALL_SCRIPTS=$BIRDNET_PIXEL_HOME/install
BIRDNET_SERVICES=$BIRDNET_PIXEL_HOME/services
LOGDIR=/home/phablet/Documents/.birdnet/logs

echo "Creating necessary directories"
[ -d ${BIRDNET_DATA} ] || mkdir -p ${BIRDNET_DATA}
[ -d ${BIRDNET_PIXEL_HOME} ] || mkdir -p ${BIRDNET_PIXEL_HOME}
[ -d ${BIRDNET_PIXEL_HOME}/bin ] || mkdir -p ${BIRDNET_PIXEL_HOME}/bin
[ -d /home/phablet/.local/bin ] || mkdir -p /home/phablet/.local/bin
[ -d $LOGDIR ] || mkdir -p $LOGDIR
[ -d ~/.local/bin ] || mkdir -p ~/.local/bin
[ -d ${BIRDNET_INSTALL_SCRIPTS} ] || mkdir -p ${BIRDNET_INSTALL_SCRIPTS}
[ -d ${BIRDNET_SERVICES} ] || mkdir -p ${BIRDNET_SERVICES}
[ -d ${BIRDNET_SERVICES} ] || mkdir -p ${BIRDNET_SERVICES}

if [ -f $BIRDNET_DATA/birds.db ]; then 
    cp $BIRDNET_DATA/birds.db /home/phablet/BirdNET-Pi/scripts
    echo "Old database preserved!"
else 
    cp /home/phablet/BirdNET-Pi/scripts/birds.db $BIRDNET_DATA
fi

chmod 755 /home/phablet/BirdNET-Pixel/services/bin/*

cp /home/phablet/BirdNET-Pixel/install/install_services.sh ${BIRDNET_INSTALL_SCRIPTS}
cp -r /home/phablet/BirdNET-Pixel/services/* ${BIRDNET_SERVICES}

cp /home/phablet/BirdNET-Pixel/utils/birdnetctl.sh ${BIRDNET_PIXEL_HOME}/bin
ln -sf ${BIRDNET_PIXEL_HOME}/bin/birdnetctl.sh /home/phablet/.local/bin/birdnetctl 

chmod g+rx ${BIRDNET_INSTALL_SCRIPTS}
chmod 755 ${BIRDNET_SERVICES}/*
chmod 755 ${BIRDNET_PIXEL_HOME}/bin/*

exit 0
