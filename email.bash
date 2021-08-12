#!/bin/bash

rm -rf /home/roborock_rc/Cinderella/email.txt
touch /home/roborock_rc/Cinderella/email.txt

rm -rf /home/roborock_rc/Cinderella/email_subject.txt
touch /home/roborock_rc/Cinderella/email_subject.txt


util_path=/home/roborock_rc/Cinderella/RoboScrub_Utilities/DEB
DATE=`date '+%m-%d'`

cd $util_path/$DATE/released
released_name=$(ls | grep .run)
cd $util_path/$DATE/released/develop
released_develop_name=$(ls | grep .run)

cd $util_path/$DATE/EH-ES
EH_ES_name=$(ls | grep .run)
cd $util_path/$DATE/EH-ES/develop
EH_ES_develop_name=$(ls | grep .run)

cd $util_path/$DATE/SELINUX
SELINUX_name=$(ls | grep .run)
cd $util_path/$DATE/SELINUX/develop
SELINUX_develop_name=$(ls | grep .run)

cd $util_path/$DATE/SELINUX-EH-ES
SELINUX_EH_ES_name=$(ls | grep .run)
cd $util_path/$DATE/released/develop
SELINUX_EH_ES__develop_name=$(ls | grep .run)

cd /home/roborock_rc/Cinderella
echo "Hi,all">>email.txt
echo "HF1.0版本新的安装包发布在：">>email.txt
echo "非加密版本：smb://192.168.111.49/cinderellabuilds/Cinderella/BuildRelease/hf1.0/$DATE/released/$released_name">>email.txt
echo "加密签名版本：smb://192.168.111.49/cinderellabuilds/Cinderella/BuildRelease/hf1.0/$DATE/EH-ES/$EH_ES_name">>email.txt
echo "SELINUX版本：smb://192.168.111.49/cinderellabuilds/Cinderella/BuildRelease/hf1.0/$DATE/SELINUX/$SELINUX_name">>email.txt
echo "SELINUX加密版本：smb://192.168.111.49/cinderellabuilds/Cinderella/BuildRelease/hf1.0/$DATE/SELINUX-EH-ES/$SELINUX_EH_ES_name">>email.txt
echo ""开发调试Coredump所需要带有symbol的安装包在：>>email.txt
echo "非加密版本：smb://192.168.111.49/cinderellabuilds/Cinderella/BuildRelease/hf1.0/$DATE/released/develop/$released_develop_name">>email.txt
echo "加密签名版本：smb://192.168.111.49/cinderellabuilds/Cinderella/BuildRelease/hf1.0/$DATE/EH-ES/develop/$EH_ES_develop_name">>email.txt
echo "SELINUX版本：smb://192.168.111.49/cinderellabuilds/Cinderella/BuildRelease/hf1.0/$DATE/SELINUX/develop/$SELINUX_develop_name">>email.txt
echo "SELINUX加密版本：smb://192.168.111.49/cinderellabuilds/Cinderella/BuildRelease/hf1.0/$DATE/SELINUX-EH-ES/develop/$SELINUX_EH_ES_develop_name">>email.txt
echo " ">>email.txt

echo "【商用上层DEB发布】HF1.0版本：$released_name">>email_subject.txt


#################################################################
release_note_path="/home/roborock_rc/Cinderella/release_note.txt"
version_path="/home/roborock_rc/Cinderella/version.txt"
nav_commit=$(sed -n '6p' $version_path)
navigation_commit=$(sed -n '8p' $version_path)
qt_commit=$(sed -n '10p' $version_path)
system_commit=$(sed -n '12p' $version_path)


nav_line=$(grep -n $nav_commit release_note.txt| cut -d ":" -f 1)
navigation_line=$(grep -n $navigation_commit release_note.txt| cut -d ":" -f 1)
qt_line=$(grep -n $qt_commit release_note.txt| cut -d ":" -f 1)
system_line=$(grep -n $system_commit release_note.txt| cut -d ":" -f 1)


echo "Nav 新增">>email.txt
if [ 5 -ge  $nav_line ]
then
echo "无">>email.txt
else
sed -n "5, $[$nav_line-1] p" $release_note_path >>email.txt
nav_commit=$(sed -n '5p' $release_note_path | cut -b 2-10)
fi
echo " ">>email.txt
sed -i '6d' $version_path
sed -i "6i $nav_commit" $version_path

echo "Navigation 新增">>email.txt
if [ 58 -ge  $navigation_line ]
then
echo "无">>email.txt
else
sed -n "58, $[$navigation_line-1] p" $release_note_path >>email.txt
navigation_commit=$(sed -n '58p' $release_note_path | cut -b 2-10)
fi
echo " ">>email.txt
sed -i "8d" $version_path
sed -i "8i $navigation_commit" $version_path

echo "qt 新增">>email.txt
if [ 111 -ge  $qt_line ]
then
echo "无">>email.txt
else
sed -n "111, $[$qt_line-1] p" $release_note_path >>email.txt
qt_commit=$(sed -n '111p' $release_note_path | cut -b 2-10)
fi
echo " ">>email.txt
sed -i '10d' $version_path
sed -i "10i $qt_commit" $version_path

echo "system 新增">>email.txt
if [ 164 -ge  $system_line ]
then
echo "无">>email.txt
else
sed -n "164, $[$system_line-1] p" $release_note_path >>email.txt
system_commit=$(sed -n '164p' $release_note_path | cut -b 2-10)
fi
echo " ">>email.txt
sed -i '12d' $version_path
sed -i "12i $system_commit" $version_path
