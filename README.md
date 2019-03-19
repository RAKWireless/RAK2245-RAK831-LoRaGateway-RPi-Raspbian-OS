# RAK2245-RAK831-LoRaGateway-RPi-Raspbian-OS

ttn_gateway based on the latest SX1301 driver [lora_gateway](https://github.com/Lora-net/lora_gateway) v5.0.1 and semtech [packet_forwarder](https://github.com/Lora-net/packet_forwarder) v4.0.1  

##	Introduction 

The aim of this project is to help users set up a LoRa network easily. The User Guide can be get from our Web.

##	Supported platforms

This project currently provides support for the below platforms.

* RAK2245
* RAK831

##	Changelog

2019-03-19 RAK V2.2

* Initial version

##	Installation procedure

step1 : Download and install [Raspbian Stretch LITE](https://www.raspberrypi.org/downloads/raspbian/) 

step2 : Use "sudo raspi-config" command, enable spi interface

step3 : Clone the installer and start the installation

      $ git clone https://github.com/RAKWireless/RAK2245-RAK831-LoRaGateway-RPi-Raspbian-OS.git ~/RAK2245-RAK831-LoRaGateway-RPi-Raspbian-OS
      $ cd ~/RAK2245-RAK831-LoRaGateway-RPi-Raspbian-OS
      $ sudo ./install.sh

step4 : Next you will see some messages as follow. Just hit the Enter key to keep default or enter your information if you want.

      Host name [rak-gateway]:
      Latitude [0]: 
      Longitude [0]: 
      Altitude [0]: 
    
step5 : Now you have a running gateway after restart!

step6 (Optional):You can use the command "sudo gateway-config" to select other bands if your hardware supports.
