#!/usr/bin/env bash
# Install BirdNET script
set -x # Debugging
exec > >(tee -i installation-$(date +%F).txt) 2>&1 # Make log
set -e # exit installation if anything fails

my_dir=$HOME/BirdNET-Pi
export my_dir=$my_dir

config_file=$my_dir/birdnet.conf

cd $my_dir/scripts || exit 1

if [ "$(uname -m)" != "aarch64" ];then
  echo "BirdNET-Pi requires a 64-bit OS.
It looks like your operating system is using $(uname -m),
but would need to be aarch64.
Please take a look at https://birdnetwiki.pmcgui.xyz for more
information"
  exit 1
fi

HOME=/home/phablet
USER=phablet

export HOME
export USER

#Install/Configure /etc/birdnet/birdnet.conf
./../../BirdNET-Pixel/install/install_config.sh || exit 1

create_necessary_dirs() {
  echo "Creating necessary directories"
  [ -d ${EXTRACTED} ] || mkdir -p ${EXTRACTED}
  [ -d ${EXTRACTED}/By_Date ] || mkdir -p ${EXTRACTED}/By_Date
  [ -d ${EXTRACTED}/Charts ] || mkdir -p ${EXTRACTED}/Charts
  [ -d ${PROCESSED} ] || mkdir -p ${PROCESSED}

  chmod -R g+rw $my_dir
  chmod -R g+rw ${RECS_DIR}
}

source /etc/birdnet/birdnet.conf

[ -d ${RECS_DIR} ] || mkdir -p ${RECS_DIR} &> /dev/null

create_necessary_dirs

install_birdnet() {
  cd ~/BirdNET-Pi || exit 1
  echo "Establishing a python virtual environment"
  python3.9 -m venv birdnet
  source ./birdnet/bin/activate
  python3.9 -m pip install -U -r $HOME/BirdNET-Pi/requirements.txt
}

install_birdnet

cd $my_dir/scripts || exit 1

/home/phablet/BirdNET-Pixel/install/install_language_label_nm.sh -l $DATABASE_LANG || exit 1

generate_BirdDB() {
  echo "Generating BirdDB.txt"
  if ! [ -f $my_dir/BirdDB.txt ];then
    touch $my_dir/BirdDB.txt
    echo "Date;Time;Sci_Name;Com_Name;Confidence;Lat;Lon;Cutoff;Week;Sens;Overlap" | tee -a $my_dir/BirdDB.txt
  elif ! grep Date $my_dir/BirdDB.txt;then
    sed -i '1 i\Date;Time;Sci_Name;Com_Name;Confidence;Lat;Lon;Cutoff;Week;Sens;Overlap' $my_dir/BirdDB.txt
  fi
  chown $USER:$USER ${my_dir}/BirdDB.txt 
  chmod g+rw ${my_dir}/BirdDB.txt
}
generate_BirdDB
${my_dir}/scripts/createdb.sh

ln -sf ${my_dir}/scripts/* /usr/local/bin/

chown_things() {
  chown -R $USER:$USER $HOME/Bird*
}

if [ -f ${config_file} ];then
  source ${config_file}
  #chown_things
else
  echo "Unable to find a configuration file. Please make sure that $config_file exists."
fi



exit 0
