#!/usr/bin/env bash
# Adapted from https://github.com/mcguirepr89/BirdNET-Pi
# This script removes all data that has been collected. It is tantamount to
# starting all data-collection from scratch. Only run this if you are sure
# you are okay will losing all the data that you've collected and processed
# so far.
set -x

echo "Stopping services"
systemctl stop birdnet_recording.service --user
systemctl stop birdnet_analysis.service --user
systemctl stop birdnet_server.service --user

libertine-launch -i birdnet /home/phablet/BirdNET-Pi/scripts/clear_all_data.sh

echo "Restarting services"
systemctl start birdnet_recording.service --user
systemctl start birdnet_analysis.service --user
systemctl start birdnet_server.service --user