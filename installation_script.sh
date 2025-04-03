#!/bin/sh
set -e
sudo apt update 
sudo apt --yes install libtss2-* tpm-udev tpm2-abrmd tpm2-tools

cd $PWD/Python_TPM20_GUI/
sudo chmod a+rwx create_binary_package.sh 
./create_binary_package.sh
cd bin/
sudo reboot
