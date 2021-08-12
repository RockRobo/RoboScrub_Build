#!/bin/bash
FILE_PATH=/home/roborock_rc/Cinderella/version.txt
build_version=$(sed -n '4p' $FILE_PATH)"."$(sed -n '3p' $FILE_PATH)
echo "build_version:"$build_version

path="/home/roborock_rc/Cinderella/RoboScrub_Utilities/"
mkdir -p $path/DEB
rm -rf $path/DEB/*
dir_name=$(date "+%m-%d")
cd $path/DEB
mkdir -p ${dir_name}/released/develop
mkdir -p ${dir_name}/EH-ES/develop
mkdir -p ${dir_name}/SELINUX/develop
mkdir -p ${dir_name}/SELINUX-EH-ES/develop
cd $path
mv *_EH_ES_SELINUX_*_K$build_version_*_FULL.run ${path}/DEB/${dir_name}/SELINUX-EH-ES/develop
mv *_EH_ES_SELINUX_*_K$build_version_*.run ${path}/DEB/${dir_name}/SELINUX-EH-ES
mv *_SELINUX_*_K$build_version_*_FULL.run ${path}/DEB/${dir_name}/SELINUX/develop
mv *_SELINUX_*_K$build_version_*.run ${path}/DEB/${dir_name}/SELINUX/
mv *_EH_ES_*_K$build_version_*_FULL.run ${path}/DEB/${dir_name}/EH-ES/develop
mv *_EH_ES_*_K$build_version_*.run ${path}/DEB/${dir_name}/EH-ES/
mv *_K$build_version_*_FULL.run ${path}/DEB/${dir_name}/released/develop/
mv *_K$build_version_*.run ${path}/DEB/${dir_name}/released/

if [ $# -eq 2 ]; then
	exit 0
fi

smbclientCMD="prompt OFF;recurse ON;lcd $path/DEB/;mput \"${dir_name}\""
#echo ${smbclientCMD}
smbclient -U rockrobo/wangshuangshuang%Wss190422 //192.168.111.49/cinderellabuilds/ --directory Cinderella/BuildRelease/hf1.0/ -c "${smbclientCMD}"
