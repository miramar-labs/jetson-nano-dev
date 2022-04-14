#!/usr/bin/env bash

# Set Jetpack/Python build versions here
source versions.sh

# System - passwordless sudo
if [[ "$PASSWORDLESS" == 1 ]]; then
if [[ ! -f "/etc/sudoers.d/$USER" ]]; then
sudo tee -a /etc/sudoers.d/$USER >/dev/null <<EOF
$USER ALL=(ALL) NOPASSWD:ALL
EOF
fi
fi

# Build Tools and dev packages
sudo apt update -y
sudo apt install -y apt-utils lvm2 vim tree git curl wget terminator tmux ufw gparted neofetch
sudo apt install -y build-essential cmake pkg-config unzip yasm checkinstall
sudo apt install -y tcl-dev zlib1g-dev libatlas-base-dev libhdf5-serial-dev hdf5-tools libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev
sudo apt install -y libzmq3-dev libbbz2-dev liblzma-dev
#sudo apt install -y tk-devlibsqlite3-dev 

# Swap file
SWAPFILE_LINES=`sudo grep '/swapfile' /etc/fstab | wc -l`
if [ "$SWAPFILE_LINES" -eq 0 ];then
    sudo fallocate -l $SWAPFILE /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    sudo swapon --show
    sudo cp /etc/fstab /etc/fstab.bak
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi

# Jetson tweaks
sudo jetson_clocks
sudo nvpmodel -m 0

# System Python3 pip/virtualenv
sudo apt install -y python3-pip python3-dev virtualenv gdown python3-smbus

# System Jetson Stats (jtop)
sudo -H pip3 install -U jetson-stats
sudo systemctl restart jetson_stats.service

# System JupyterLAB
sudo source setup-jupyterlab.sh

# System VSCode Server
sudo source setup-vscode.sh

# System NoMachine
VERSHORT=7.8
VER=$VERSHORT.2_1
ARCH=arm64

wget https://download.nomachine.com/download/${VERSHORT}/Arm/nomachine_${VER}_${ARCH}.deb -P ~/Downloads

sudo dpkg -i ~/Downloads/nomachine_${VER}_${ARCH}.deb

sudo ufw allow 4000/tcp
sudo ufw allow 4011:4999/udp

rm -f ~/Downloads/nomachine_${VER}_${ARCH}.deb*

# Launchers
JLAB_LINES=`sudo grep 'alias jlab' ~/.bashrc | wc -l`
if [ "$JLAB_LINES" -eq 0 ];then
    echo "alias jlab='jupyter lab --ip=0.0.0.0 --port=8080 --allow-root'" >> ~/.bashrc
    echo "alias jlabd='jupyter lab --ip=0.0.0.0 --port=8080 --allow-root --debug'" >> ~/.bashrc
fi
CODESVR_LINES=`sudo grep 'alias codesvr' ~/.bashrc | wc -l`
if [ "$CODESVR_LINES" -eq 0 ];then
    echo "alias codesvr='~/.yarn/bin/code-server'" >> ~/.bashrc
fi

# PiOLED
if [[ "$PIOLED" == 1 ]]; then
    pushd ./installPiOLED
    bash ./installPiOLED.sh
    bash ./createService.sh
    popd
fi

NEOFETCH_LINES=`grep 'neofetch' ~/.bashrc | wc -l`
if [ "$NEOFETCH_LINES" -eq 0 ];then
    echo "neofetch" >> ~/.bashrc
fi

# SMBUS for UPS
sudo apt-get install -y python-smbus

echo "rebooting.. please wait a bit then reconnect..."

# Cleanup
sudo apt autoremove -y
sudo reboot