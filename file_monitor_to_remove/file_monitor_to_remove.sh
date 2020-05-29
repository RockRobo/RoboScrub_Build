#!/bin/bash
#!/usr/bin/env
#exit #
source /etc/profile



file_suffix="*.avi"
#absolute_path="/ssd2/"
absolute_path="/home/roborock/scrubber_videos/"
all_result=`ls $absolute_path$file_suffix -alrt | awk {'print$9'}` #
#maxsize=$((1024*10)) 
maxsize=300 #M
GOING="ongoing"
max_disk_usage=90
disk_path="/dev/mmcblk0p1"
current_disk_usage=`df -P ${2} |  grep $disk_path | awk '{print $5 }' | cut -d'%' -f1 | tr -d '\n'`
#echo "current_disk_usage == $current_disk_usage "
#echo "max_disk_usage == $max_disk_usage "

for file in $all_result
do
filesize=`du -sm  $absolute_path |awk '{print $1}'` #
if [ $filesize -gt $maxsize ]
then
	result=$(echo $file | grep "${GOING}")
	if [[ "$result" = "" ]] || [[ $current_disk_usage -gt $max_disk_usage ]]
	then
	    	echo "rm -- $file not include $GOING***$result or gt max_disk_usage"
		rm -rf $file
	else
	    	echo "$file include $GOING***$result"
	fi	
else
	echo "$maxsize***$filesize"
fi
done

















#echo "wj1" >> /var/log/test.log




