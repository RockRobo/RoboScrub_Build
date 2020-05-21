#!/bin/bash
#!/usr/bin/env
#exit #
source /etc/profile



file_suffix="*.avi"
absolute_path="/ssd2/"
all_result=`ls $absolute_path$file_suffix -alrc | awk {'print$9'}` 
#maxsize=$((1024*10)) 
maxsize=90 #M
GOING="ongoing"

for file in $all_result
do
filesize=`du -sm  $absolute_path |awk '{print $1}'` 
if [ $filesize -gt $maxsize ]
then
	result=$(echo $file | grep "${GOING}")
	if [[ "$result" = "" ]]
	then
	    	echo "$file not include $GOING***$result"
		rm -rf $file
	else
	    	echo "$file include $GOING***$result"
	fi
else
	echo "$maxsize***filesize == $filesize"
fi
done







#echo "wj1" >> /var/log/test.log



