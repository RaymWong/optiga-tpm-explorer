#!/bin/sh

set -e

CONFIG_FILENAME="/boot/firmware/config.txt"
TPM_SPI_OVERLAY="dtoverlay=tpm-slb9670"
TPM_I2C_OVERLAY="dtoverlay=tpm-tis-i2c"
SPI_OVERLAY_OFF="dtparam=spi=off"
SPI_OVERLAY_ON="dtparam=spi=on"
TPM_PATCH_DIR=~/tpm2-rpi4

# Update & install required packages
sudo apt update
sudo apt install --yes libtss2-* tpm-udev tpm2-abrmd tpm2-tools tpm2-openssl python-wxtools xxd python3-pubsub
sudo apt install --yes git device-tree-compiler
sudo usermod --append --groups tss $(whoami)

# Create GUI binary package
cd "$PWD/Python_TPM20_GUI/"
sudo chmod a+rwx create_binary_package.sh
./create_binary_package.sh
cd bin/

# Clone TPM overlay repo (if not exist)
if [ ! -d "$TPM_PATCH_DIR" ]; then
    git clone https://github.com/wxleong/tpm2-rpi4 "$TPM_PATCH_DIR"
fi

# Compile I2C TPM device tree overlay
dtc -@ -I dts -O dtb -o tpm-tis-i2c.dtbo "$TPM_PATCH_DIR"/dts/tpm-tis-i2c.dts
sudo cp tpm-tis-i2c.dtbo /boot/overlays/

# Modify /boot/config.txt to enable TPM overlays and SPI
if [ -f "$CONFIG_FILENAME" ]; then
    echo "Found file $CONFIG_FILENAME."

    # Add SPI TPM overlay (optional)
    if ! grep -q "$TPM_SPI_OVERLAY" "$CONFIG_FILENAME"; then
        echo "$TPM_SPI_OVERLAY" | sudo tee -a "$CONFIG_FILENAME"
        echo "Added '$TPM_SPI_OVERLAY' to $CONFIG_FILENAME."
    fi

    # Add I2C TPM overlay
    if ! grep -q "$TPM_I2C_OVERLAY" "$CONFIG_FILENAME"; then
        echo "$TPM_I2C_OVERLAY" | sudo tee -a "$CONFIG_FILENAME"
        echo "Added '$TPM_I2C_OVERLAY' to $CONFIG_FILENAME."
    fi

    # Ensure SPI is enabled
    if grep -q "$SPI_OVERLAY_ON" "$CONFIG_FILENAME"; then
        echo "'$SPI_OVERLAY_ON' already exists."
    elif grep -q "$SPI_OVERLAY_OFF" "$CONFIG_FILENAME"; then
        sudo sed -i "s/$SPI_OVERLAY_OFF/$SPI_OVERLAY_ON/g" "$CONFIG_FILENAME"
        echo "Replaced '$SPI_OVERLAY_OFF' with '$SPI_OVERLAY_ON'."
    else
        echo "$SPI_OVERLAY_ON" | sudo tee -a "$CONFIG_FILENAME"
        echo "Added '$SPI_OVERLAY_ON' to $CONFIG_FILENAME."
    fi
else
    echo "The file $CONFIG_FILENAME does not exist."
fi

sudo reboot
