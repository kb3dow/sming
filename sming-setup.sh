#!/bin/bash
# NOTE: Scripted from directions at https://github.com/SmingHub/Sming/wiki/Linux-Quickstart
#Requisites
echo Installing Requisites
sudo apt-get install -y \
    make unrar autoconf automake libtool gcc\
    g++ gperf flex bison texinfo gawk ncurses-dev libexpat1-dev python sed \
    python-serial python-dev srecord bc git help2man unzip

#Build esp-open-sdk
echo Installing esp-open-sdk
WORK_DIR=$PWD
cd $WORK_DIR
git clone --recursive https://github.com/pfalcon/esp-open-sdk.git
cd esp-open-sdk
make VENDOR_SDK=1.5.4 STANDALONE=y

#Set  env variables
echo Creating $WORK_DIR/sourceThis which needs to be sourced before using node-mcu tools

export ESP_HOME=$WORK_DIR/esp-open-sdk
echo export ESP_HOME=$ESP_HOME > $WORK_DIR/sourceThis

export SMING_HOME=$WORK_DIR/Sming/Sming
echo export SMING_HOME=$SMING_HOME >> $WORK_DIR/sourceThis

##RRNOTNEEDED export PATH=$PATH:$WORK_DIR/esp-open-sdk/xtensa-lx106-elf/bin
# PATH is put in sourceThis later in this file

##RRNOTNEEDED alias xgcc="xtensa-lx106-elf-gcc"
##RRNOTNEEDED echo alias xgcc="xtensa-lx106-elf-gcc" >> $WORK_DIR/sourceThis

#Get and build Sming Core
echo Installing  Sming Core
cd $WORK_DIR
git clone https://github.com/SmingHub/Sming.git
cd Sming/Sming
git checkout origin/master
make

#Get and build esptool2
echo Installing esptool2
#cd $WORK_DIR
cd $ESP_HOME
git clone https://github.com/raburton/esptool2.git
cd esptool2
make
export PATH=$PATH:$ESP_HOME/esptool2/

#Build Spiffy (if required)
echo Building Spiffy
cd $WORK_DIR/Sming/Sming
make spiffy

#install esptool.py
echo Installing esptool.py
cd $WORK_DIR
sudo apt-get install python-serial unzip
wget https://github.com/themadinventor/esptool/archive/master.zip
unzip master.zip
mv esptool-master $WORK_DIR/esp-open-sdk/esptool
rm master.zip

#git clone original Arduino codebase as reference
echo Cloning original Arduino codebase as reference
cd $WORK_DIR
git clone https://github.com/esp8266/Arduino.git


# This is done at the end as $PATH changes more than once
echo export PATH=$PATH >> $WORK_DIR/sourceThis
