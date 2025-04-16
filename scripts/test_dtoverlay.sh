#!/bin/sh
set -e


# Define the filename and the string to search for
CONFIG_FILENAME="/boot/firmware/config.txt"
TPM_OVERLAY="dtoverlay=tpm-slb9670"
SPI_OVERLAY_OFF="dtparam=spi=off"
SPI_OVERLAY_ON="dtparam=spi=on"

# Check if the file exists
if [ -f "$CONFIG_FILENAME" ]; then
    echo "Found file $CONFIG_FILENAME."
    # Check if the string exists in the file
    if grep -q "$TPM_OVERLAY" "$CONFIG_FILENAME"; then
        echo "The string '$TPM_OVERLAY' already exists in $CONFIG_FILENAME."
    else
        # Append the string to the end of the file
        echo "$TPM_OVERLAY" | sudo tee -a  "$CONFIG_FILENAME"
        echo "The string '$TPM_OVERLAY' has been appended to $CONFIG_FILENAME."
    fi
 # Check if the string exists in the file
	if sudo grep -q "$SPI_OVERLAY_ON" "$CONFIG_FILENAME"
	then
		echo "The string '$SPI_OVERLAY_ON' already exists in $CONFIG_FILENAME."
	else
		if sudo grep -q "$SPI_OVERLAY_OFF" "$CONFIG_FILENAME"
		then
			# Search for the string and replace it with sudo permission
			echo "The string '$SPI_OVERLAY_ON' has been added to $CONFIG_FILENAME."
			sudo sed -i "s/$SPI_OVERLAY_OFF/$SPI_OVERLAY_ON/g" "$CONFIG_FILENAME"
		else
			echo "$SPI_OVERLAY_ON" | sudo tee -a  "$CONFIG_FILENAME"
			echo "The string '$SPI_OVERLAY_ON' has been appended to $CONFIG_FILENAME."
		fi
	fi

else
    echo "The file $CONFIG_FILENAME does not exist."
fi

