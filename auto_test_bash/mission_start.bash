#!/bin/bash
sensor_name=sensor_monitor.yaml
base_name=roborock_base-start
echo "mission start"
rm -rf /home/roborock/auto_test/data/rosbag
rm -rf /home/roborock/auto_test/data/log
sleep 60s

gnome-terminal -e "roslaunch scrubber_gazebo scrubber_testworld.launch"

sleep 20s

rosnode kill /amcl
echo "kill amcl"
sleep 20s

/usr/bin/expect <<EOF
set timeout 300000
spawn ssh root@192.168.1.11
expect "*password:"
send "R0boR0ck!2014\r"
expect "*#"
send "cd /mnt/disk1/rosbag\r"
expect "*#"
send "rm -rf *\r"
expect "*#"
send "cd /mnt/disk1/log\r"
expect "*#"
send "rm -rf *\r"
expect "*#"
send "cd /mnt/disk1\r"
send "python main.py 7 6 1\r"
expect "*#"
send "scp text.txt roborock@192.168.1.20:/home/roborock/auto_test\r"
expect "*password:"
send "roborock\r"
expect "*#"
send "scp -r /mnt/disk1/rosbag /mnt/disk1/log roborock@192.168.1.20:/home/roborock/auto_test/data\r"
expect "*password:"
send "roborock\r"

expect "*#"
send "exit\r"
EOF


sleep 5s

pkill roslaunch
