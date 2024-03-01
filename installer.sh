#!/usr/bin/env bash

# Based on the BirdNET-Pi newinstaller.sh but Ubuntu Touch uses Libertine containers.
# - Binaries are installed in the container
# - Services are installed in the host OS
# - Data is written to the Documents directory which is accessible from both container and host OS

if [ "$EUID" == 0 ]
  then echo "Please run as a non-root user."
  exit
fi

if [ "$(uname -m)" != "aarch64" ];then
  echo "BirdNET-Pixel requires a 64-bit OS.
It looks like your operating system is using $(uname -m),
but would need to be aarch64."
  exit 1
fi

HOME=$HOME
USER=$USER

export HOME=$HOME
export USER=$USER

# Create a libertine container.
libertine-container-manager create -i birdnet --force

# Install basic packages
libertine-container-manager install-package -i birdnet -p git jq

# Install services dependencies
libertine-container-manager install-package -i birdnet -p ftpd sqlite3 alsa-utils pulseaudio sox libsox-fmt-mp3
libertine-container-manager install-package -i birdnet -p ffmpeg wget unzip curl cmake make bc libjpeg-dev zlib1g-dev
libertine-container-manager install-package -i birdnet -p python3.9 python3.9-dev python3-pip python3.9-venv lsof net-tools

branch=main
libertine-container-manager exec -i birdnet -c "git clone -b $branch --depth=1 https://github.com/mcguirepr89/BirdNET-Pi.git ${HOME}/BirdNET-Pi"
libertine-container-manager exec -i birdnet -c "git clone -b $branch --depth=1 https://github.com/geoffcarlier/BirdNET-Pixel.git ${HOME}/BirdNET-Pixel"

libertine-container-manager exec -i birdnet -c "find $HOME/BirdNET-Pixel/install -type f -exec chmod 0755 {} \;"
libertine-container-manager exec -i birdnet -c "$HOME/BirdNET-Pixel/install/modify_birdnet_pi.sh"
libertine-container-manager exec -i birdnet -c "$HOME/BirdNET-Pixel/install/install_birdnet_pi.sh"

libertine-container-manager exec -i birdnet -c "$HOME/BirdNET-Pixel/install/install_birdnet_pixel.sh"


/home/phablet/Documents/.birdnet/install/install_services.sh

if [ ${PIPESTATUS[0]} -eq 0 ];then
  echo "Installation completed successfully.  Authorise reboot or Ctl-C"
  sudo reboot
else
  echo "The installation exited unsuccessfully."
  exit 1
fi
