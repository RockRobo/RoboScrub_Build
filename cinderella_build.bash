#!/bin/bash

FILE_PATH=/home/roborock_rc/Cinderella/version.txt
DATE=`date '+%Y-%m-%d'`
DATE_FILE=$(sed -n '1p' $FILE_PATH)
daily_num=$(sed -n '2p' $FILE_PATH)
version=$(sed -n '3p' $FILE_PATH)

new_daily_num=daily_num
new_version=`expr $version + 1`

if [ $DATE == $DATE_FILE ]
then
new_daily_num=`expr $daily_num + 1`

else
new_daily_num=1
fi

build_version=$(sed -n '4p' $FILE_PATH)"."$new_version
echo "build_version:"$build_version"    daily_num:"$new_daily_num
bash /home/roborock_rc/Cinderella/pull_and_build.sh $build_version $new_daily_num

if [ $? -ne 0 ]
then
    echo  "cinderella build failed"
    exit 1
fi

sed -i '1d' $FILE_PATH
sed -i "1i $DATE" $FILE_PATH

sed -i "2d" $FILE_PATH
sed -i "2i $new_daily_num" $FILE_PATH

sed -i '3d' $FILE_PATH
sed -i "3i $new_version" $FILE_PATH

