#! /bin/bash
cd /home/roborock/auto_test
deb_name=$(ls | grep .run)
sensor_name=sensor_monitor.yaml
base_name=roborock_base-start

expect -c "
    spawn scp -r /home/roborock/auto_test/$deb_name $sensor_name $base_name root@192.168.1.11:/mnt/disk1
    expect {
        \"*assword\" {set timeout 20; send \"R0boR0ck!2014\r\"; exp_continue;} 
    }
expect eof"


/usr/bin/expect <<EOF
set timeout 300
spawn ssh root@192.168.1.11
expect "*password:" 
send "R0boR0ck!2014\r"
expect "*#"
send "cd /mnt/disk1\r"
expect "*#"
send "sudo chmod 777 $deb_name \r"
expect "*#"
send "./$deb_name --no-mcu\r"

expect "*#"
send "ssh root@192.168.1.10\r"
expect "*#"
send "mount -o remount,rw /opt/roborock/\r"
expect "*#"
send "scp root@192.168.1.11:/mnt/disk1/$sensor_name /opt/roborock/scrubber/nav/share/scrubber/param/\r"
expect "*#"
send "scp root@192.168.1.11:/mnt/disk1/$base_name /opt/roborock/system/sys_monitor/bin/\r"
expect "*#"
send "systemctl restart sys_monitor\r"
expect "*#"
send "exit\r"
EOF
