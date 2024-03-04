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

# sudo cannot be used in the container and services are not accessible
sed -i 's/sudo rm/rm/g' ${BIRDNET_PI_DIR}/scripts/birdnet_analysis.sh
sed -i 's/sudo/#sudo/g' ${BIRDNET_PI_DIR}/scripts/birdnet_analysis.sh

sed -i 's/sudo -u ${USER} //g' ${BIRDNET_PI_DIR}/scripts/clear_all_data.sh
sed -i 's/sudo systemctl/#sudo systemctl/g' ${BIRDNET_PI_DIR}/scripts/clear_all_data.sh
sed -i 's/restart_services.sh/#restart_services.sh/g' ${BIRDNET_PI_DIR}/scripts/clear_all_data.sh
#restart_services.sh