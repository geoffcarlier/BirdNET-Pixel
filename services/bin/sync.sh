#!/bin/bash

# A script to sync data from a BirdNET-Pixel recording and classifying device to a running BirdNet-Pi server for reporting
source /home/phablet/Documents/.birdnet/local_config.sh

DOCUMENT_HOME=/home/phablet/Documents
DB_FILE=$DOCUMENT_HOME/BirdData/birds.db
BIRDSONGS_DIR=$DOCUMENT_HOME/BirdSongs/

# Backup the database
libertine-container-manager exec -i birdnet -c "/home/phablet/BirdNET-Pi/birdnet/bin/python3 /home/phablet/BirdNET-Pixel/services/bin/backup.py"

# Sync database
rsync -avz $DB_FILE $FILE_SERVER_USER@$FILE_SERVER:/home/$FILE_SERVER_USER/BirdNET-Pi/scripts/birds.db

# Sync files
rsync -avz $BIRDSONGS_DIR/Extracted/By_Date $FILE_SERVER_USER@$FILE_SERVER:/home/$FILE_SERVER_USER/BirdSongs/Extracted
#rsync -avz $BIRDSONGS_DIR/Processed $FILE_SERVER_USER@$FILE_SERVER:/home/$FILE_SERVER_USER/BirdSongs/Processed
rsync -avz $BIRDSONGS_DIR/*20* $FILE_SERVER_USER@$FILE_SERVER:/home/$FILE_SERVER_USER/BirdSongs

rsync -avz $DOCUMENT_HOME/.birdnet/logs/* $FILE_SERVER_USER@$FILE_SERVER:/home/$FILE_SERVER_USER/phablet-logs