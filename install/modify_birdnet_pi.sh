#!/usr/bin/env bash
# A script to port Raspberry pi specific elements of the Birdnet Pi project to work on Ubuntu touch.

set -x # Uncomment to enable debugging
trap 'rm -f ${tmpfile}' EXIT
trap 'exit 1' SIGINT SIGHUP
set -e # exit installation if anything fails

BIRDNET_PI_DIR=/home/phablet/BirdNET-Pi

COREUTIL_ENV_TOKEN="-S --default-signal=PIPE "


# coreutils mismatch
sed -i 's/-S --default-signal=PIPE //g' ${BIRDNET_PI_DIR}/scripts/birdnet_analysis.sh