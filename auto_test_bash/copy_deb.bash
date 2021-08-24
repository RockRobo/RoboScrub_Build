#!/bin/bash

rm -rf /home/roborock/auto_test/*.run
expect -c "
spawn scp roborock@192.168.132.74:/home/roborock/Cinderella_HF1_0/RoboScrub_Utilities/DEB/*/SELINUX/*.run /home/roborock/auto_test/
    expect {
        \"*assword\" {set timeout 600; send \"roborock\r\"; exp_continue;} 
    }
expect eof"
