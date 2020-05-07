#!/bin/sh

########################################################################################################################################################################

#Script Name: health_check.sh

#Description: This script queries if the following services are running: Syncthing, Folding@Home, Killing Floor 2 server

########################################################################################################################################################################


#Confirm user is running as root
if [ `whoami` != 'root' ]
        then
          echo "You must be root to run this script. This script will now exit."
          exit
fi


#define and cleanup health check log
rm /var/log/health_check_logs/health_check_log_$(date +\%m.\%d.\%Y).txt
touch /var/log/health_check_logs/health_check_log_$(date +\%m.\%d.\%Y).txt
log=/var/log/health_check_logs/health_check_log_$(date +\%m.\%d.\%Y).txt


#sleep for consumption
sleep 2


#Prompt that health check script is running
echo | tee -a "$log"
echo "####################################" | tee -a "$log"
echo | tee -a "$log"
echo "### Starting system health check ###" | tee -a "$log"
echo | tee -a "$log"
echo "####################################" | tee -a "$log"


#sleep for consumption
sleep 2


#Prompt user that script is checking Syncthing service status
echo | tee -a "$log"
echo "Checking Syncthing service status..." | tee -a "$log"
sleep 2


#Check if Syncthing service is running
syncthing_status=$(systemctl status syncthing@syncthing.service | grep Active)
syncthing_status_logic=$(systemctl status syncthing@syncthing.service | grep running | wc -l)

echo | tee -a "$log"
echo "Syncthing status:" $syncthing_status | tee -a "$log"
echo | tee -a "$log"

if [ "$syncthing_status_logic" == "1" ]; then
        echo "SUCCESS: Syncthing is running" | tee -a "$log"
        continue
        echo | tee -a "$log"
else
        echo "WARNING: Syncthing is not in a running state" | tee -a "$log"
        echo | tee -a "$log"
        cat "$log" | mailx -s "WARNING: Syncthing is not in a running state" andrewbatchelor5@gmail.com
        sleep 2
        echo "Sending Syncthing status alert to AndrewBatchelor5@Gmail.com..." | tee -a "$log"
        echo | tee -a "$log"
fi


#Prompt user that script is checking Folding@Home service status
echo | tee -a "$log"
echo "------------------------------------------------------------" | tee -a "$log"
echo | tee -a "$log"
echo "Checking Folding@Home service status..." | tee -a "$log"
sleep 2


#Check if Folding@Home service is running
fah_status=$(/etc/rc.d/init.d/FAHClient status)
fah_status_logic=$(/etc/rc.d/init.d/FAHClient status | grep PID | wc -l)

echo | tee -a "$log"
echo "Folding@Home Status:" $fah_status | tee -a "$log"
echo | tee -a "$log"

if [ "$fah_status_logic" == "1" ]; then
        echo "SUCCESS: fahclient is running" | tee -a "$log"
        continue
	echo | tee -a "$log"
else
        echo "WARNING: Folding@Home is not in a running state" | tee -a "$log"
	echo | tee -a "$log"
	cat "$log" | mailx -s "WARNING: Folding@Home is not in a running state" andrewbatchelor5@gmail.com
	sleep 2
	echo "Sending Folding@Home status alert to AndrewBatchelor5@Gmail.com..." | tee -a "$log"
	echo | tee -a "$log"
fi



#sleep for consumption
sleep 2

#Start Killing Floor logic
echo | tee -a "$log"
echo "------------------------------------------------------------" | tee -a "$log"
echo | tee -a "$log"
echo "Checking Killing Floor game server status..." | tee -a "$log"
echo | tee -a "$log"


#sleep for consumption
sleep 2


kf_status=$(ps -ef | grep -i kf | wc -l)

if [ "$kf_status" == 3 ]; then
        echo "SUCCESS: Killing Floor 2 game server is running" | tee -a "$log"
	continue
        echo | tee -a "$log"
else
        echo "WARNING: Killing Floor 2 game server is not in a running state" | tee -a "$log"
        echo | tee -a "$log"
        cat "$log" | mailx -s "WARNING: Killing Floor 2 game server is not in a running state" andrewbatchelor5@gmail.com
        echo "Sending Killing Floor 2 game server status alert to AndrewBatchelor5@Gmail.com..." | tee -a "$log"
        echo | tee -a "$log"
fi