#!/bin/sh

########################################################################################################################################################################

#Script Name: apt_upgrade.sh

#Description: This script upgrades apt packages and sends the upgraded package list to email.

########################################################################################################################################################################

apt upgrade -y > /var/log/apt_upgrade_$(date +"%m-%d-%Y")