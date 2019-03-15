#!/bin/bash

# Stop on the first sign of trouble
set -e

if [ $UID != 0 ]; then
    echo "ERROR: Operation not permitted. Forgot sudo?"
    exit 1
fi

SCRIPT_DIR=$(pwd)

VERSION="master"
if [[ $1 != "" ]]; then VERSION=$1; fi

echo "The Things Network Gateway installer"
echo "Version $VERSION"

# Request gateway configuration data
# There are two ways to do it, manually specify everything
# or rely on the gateway EUI and retrieve settings files from remote (recommended)
echo "Gateway configuration:"

# Try to get gateway ID from MAC address
# First try eth0, if that does not exist, try wlan0 (for RPi Zero)
GATEWAY_EUI_NIC="eth0"
if [[ `grep "$GATEWAY_EUI_NIC" /proc/net/dev` == "" ]]; then
    GATEWAY_EUI_NIC="wlan0"
fi

if [[ `grep "$GATEWAY_EUI_NIC" /proc/net/dev` == "" ]]; then
    echo "ERROR: No network interface found. Cannot set gateway ID."
    exit 1
fi

GATEWAY_EUI=$(ip link show $GATEWAY_EUI_NIC | awk '/ether/ {print $2}' | awk -F\: '{print $1$2$3"FFFE"$4$5$6}')
GATEWAY_EUI=${GATEWAY_EUI^^} # toupper

echo "Detected EUI $GATEWAY_EUI from $GATEWAY_EUI_NIC"


printf "       Host name [rak-gateway]:"
read NEW_HOSTNAME
if [[ $NEW_HOSTNAME == "" ]]; then NEW_HOSTNAME="rak-gateway"; fi

printf "       Latitude [0]: "
read GATEWAY_LAT
if [[ $GATEWAY_LAT == "" ]]; then GATEWAY_LAT=0; fi

printf "       Longitude [0]: "
read GATEWAY_LON
if [[ $GATEWAY_LON == "" ]]; then GATEWAY_LON=0; fi

printf "       Altitude [0]: "
read GATEWAY_ALT
if [[ $GATEWAY_ALT == "" ]]; then GATEWAY_ALT=0; fi


# Change hostname if needed
CURRENT_HOSTNAME=$(hostname)

if [[ $NEW_HOSTNAME != $CURRENT_HOSTNAME ]]; then
    echo "Updating hostname to '$NEW_HOSTNAME'..."
    hostname $NEW_HOSTNAME
    echo $NEW_HOSTNAME > /etc/hostname
    sed -i "s/$CURRENT_HOSTNAME/$NEW_HOSTNAME/" /etc/hosts
fi

# Check dependencies
echo "Installing dependencies..."
apt-get install git minicom dialog -y

# Install LoRaWAN packet forwarder repositories
INSTALL_DIR="/opt/ttn-gateway"
if [ ! -d "$INSTALL_DIR" ]; then mkdir $INSTALL_DIR; fi
pushd $INSTALL_DIR

# Build LoRa gateway app

git clone https://github.com/Lora-net/lora_gateway.git

pushd lora_gateway

cp $SCRIPT_DIR/library.cfg ./libloragw/library.cfg
cp $SCRIPT_DIR/loragw_spi.native.c ./libloragw/src/loragw_spi.native.c
make

popd

# Build packet forwarder

git clone https://github.com/Lora-net/packet_forwarder.git
pushd packet_forwarder

cp $SCRIPT_DIR/start.sh ./lora_pkt_fwd/start.sh
cp $SCRIPT_DIR/set_eui.sh ./lora_pkt_fwd/set_eui.sh
cp $SCRIPT_DIR/update_gwid.sh ./lora_pkt_fwd/update_gwid.sh
cp $SCRIPT_DIR/global_conf.json ./lora_pkt_fwd/global_conf.json
cp $SCRIPT_DIR/lora_pkt_fwd.c ./lora_pkt_fwd/src/lora_pkt_fwd.c

make

popd

LOCAL_CONFIG_FILE=$INSTALL_DIR/packet_forwarder/lora_pkt_fwd/local_conf.json

#config local_conf.json

    echo -e "{\n\t\"gateway_conf\": {\n\t\t\"gateway_ID\": \"$GATEWAY_EUI\",\n\t\t\"serv_port_up\": 1700,\n\t\t\"serv_port_down\": 1700,\n\t\t\"serv_enabled\": true,\n\t\t\"ref_latitude\": $GATEWAY_LAT,\n\t\t\"ref_longitude\": $GATEWAY_LON,\n\t\t\"ref_altitude\": $GATEWAY_ALT \n\t}\n}" >$LOCAL_CONFIG_FILE

echo "Gateway EUI is: $GATEWAY_EUI"
echo "The hostname is: $NEW_HOSTNAME"
echo "Open TTN console and register your gateway using your EUI: https://console.thethingsnetwork.org/gateways"
echo
echo "Installation completed."

# Start packet forwarder as a service
#cp ./start.sh $INSTALL_DIR/bin/
cp $SCRIPT_DIR/ttn-gateway.service /lib/systemd/system/
systemctl enable ttn-gateway.service

# add config "dtoverlay=pi3-disable-bt" to config.txt
linenum=`sed -n '/dtoverlay=pi3-disable-bt/=' /boot/config.txt`
if [ ! -n "$linenum" ]; then
	echo "dtoverlay=pi3-disable-bt" >> /boot/config.txt
fi


# add cmd "systemctl stop serial-getty@ttyAMA0.service" to rc.local
linenum=`sed -n '/serial-getty@ttyAMA0.service/=' /etc/rc.local`
if [ ! -n "$linenum" ]; then
	set -a line_array
	line_index=0
	for linenum in `sed -n '/exit 0/=' /etc/rc.local`; do line_array[line_index]=$linenum; let line_index=line_index+1; done
	sed -i "${line_array[${#line_array[*]} - 1]}isystemctl stop serial-getty@ttyAMA0.service" /etc/rc.local
fi
systemctl disable hciuart
cd $SCRIPT_DIR
cp gateway-config /usr/bin/gateway-config
cp rak-version* /usr/bin/
cp lora_conf /etc/ -rf
#cp config.txt /boot/config.txt

echo "The system will reboot in 5 seconds..."
sleep 5
shutdown -r now
