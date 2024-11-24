# BirdNET-Pixel
An Ubuntu Touch Pixel 3a port for the BirdNET-Pi project for mobile detection

This project uses the work created within BirdNET-Pi installed on a mobile phone.

## Aim:

This project aims to create an off-grid portable bird detection device.

The Pixel 3a is used as it has the following advantages over a Raspberry Pi.
- Cheap to buy secondhand.  Broken screen models are suitable
- More cores and faster processing
- Better power conservation
- Built in UPS
- Built in microphone
- Built in mobile data networking

## Hardware
- Pixel 3a
- TRRS Microphone
- 50W Solar panel
- Solar controller
- SLA Battery
- Raspberry Pi 4 running BirdNET-Pi

## System
- Pixel is an off-grid device using wifi or phone network, powered by Solar, always listening and processing bird calls.
- If the phone network is used, A WireGuard VPN connection can be used.
- A wifi connection does not require a VPN connection
- A Raspberry pi running Birdnet-pi is used as a back end server
- Data is synced between the Pixel and the Raspberry pi at intervals.

## Install

### UBPorts Ubuntu Touch install

https://docs.ubports.com/en/latest/userguide/install.html

(On Pixel)
- Connect Device to Wifi
- Settings > About Phone > Build Number (Tap 6 times to enter developer mode)
- Developer Options > USB debugging > On
- Developer Options > OEM Unlocking > On

#### From a USB Connected computer using a Chrome browser
- If the device is running an Android version above 9.0, you have to downgrade to the last 9.0 release. Make sure to revert to factory image before continuing.  This is done with the Android Flash tool.

Pixel 3a
    https://developers.google.com/android/images#sargo
    Sargo - 9.0.0 (PQ3B.190801.002, Aug 2019)

3a XL
    https://developers.google.com/android/images#bonito
    Bonito - 9.0.0 (PQ3B.190801.002, Aug 2019)

Flash

#### Install UBPorts Installer on computer
https://devices.ubuntu-touch.io/installer/

- Developer Mode needs to be re-enabled.
- Run through installer


### Enable ssh.  
A certificate must be generated and can be pushed to the pixel with adb
https://docs.ubports.com/en/latest/userguide/advanceduse/adb.html

`adb push ~/.ssh/id_rsa.pub /home/phablet/`

`adb shell`

`mkdir /home/phablet/.ssh`\
`chmod 700 /home/phablet/.ssh`\
`cat /home/phablet/id_rsa.pub >> /home/phablet/.ssh/authorized_keys`\
`chmod 600 /home/phablet/.ssh/authorized_keys`\
`chown -R phablet:phablet /home/phablet/.ssh`\
`rm id_rsa.pub`

`sudo systemctl enable ssh`\
`sudo systemctl start ssh`

All commands can now be performed over ssh

#### Allow ssh communication to a server running BirdNET-Pi
`ssh-keygen`\
`ssh-copy-id -i ~/.ssh/id_rsa.pub <USER_NAME>@<SERVER>`

### Set the Pixel to always switch on when attached to power
From an attached computer\
`fastboot oem off-mode-charge 0`

### Birdnet-Pixel install
`wget -q -O - "https://raw.githubusercontent.com/geoffcarlier/BirdNET-Pixel/main/installer.sh" | bash`\


## Configuration

### Data transfer details
Edit the following credentials in the below file to allow writing of data to a Birdnet-Pi instance
/home/phablet/Documents/.birdnet/local_config.sh

### BirdNET-Pi config
`birdnetctl bash`\
`vi /home/phablet/BirdNET-Pi/birdnet.conf`\
`exit`

## birdnetctl
The birdnetctl tool is available from a fresh login after install

Useage: birdnetctl [-h] [COMMAND] [SERVICE_QUALIFIER]

Manage Birdnet-Pixel services

COMMANDS - (All services will be commanded by default unless a service qualifier is provided)
  - **status**    List all services and provide status informatiom
  - **stop**      Stop a service if running, ignore if not
  - **start**     Start a service
  - **enable**    Enable and start a service if not running.  This ensures a service reboot.
  - **disable**   Disable.  The service will not run after a reboot
  - **log**       Forever output log messages, <CTL>C to break
  - **bash**      Get access to the libertine container
  - **battery**   Get Battery details
  - **reinstall** Rebuild the entire system keeping data intact

SERVICE_QUALIFER - (All services will be commanded, if possible or unless qualified)
  - **recording**
  - **extraction**
  - **analysis**
  - **server**
  - **sync**
  - **cleanup**
  - **watchdog**
  - **vpn**


