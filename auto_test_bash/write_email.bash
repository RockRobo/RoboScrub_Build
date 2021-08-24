#!/bin/bash

rm -rf /home/roborock/auto_test/email.txt
touch /home/roborock/auto_test/email.txt

report_path="/home/roborock/auto_test/text.txt"
email_path="/home/roborock/auto_test/email.txt"

rm -rf $email_path
touch $email_path

cd /home/roborock/auto_test
released_name=$(ls | grep .run)
echo "【商用deb仿真测试报告】 HF1.0版本：$released_name" >>$email_path
collision=$(sed -n '18 p' $report_path | tr -cd "[0-9]")
if [ $collision -eq 0 ]
then
   echo "任务执行成功，无碰撞" >>$email_path
else
   echo "任务执行失败，发生碰撞，请进行检查确认" >>$email_path
fi
echo "总用时：$(sed -n '28 p' $report_path | tr -cd "[0-9]")秒 " >>$email_path
echo "清扫路径用时：$(sed -n '23 p' $report_path | tr -cd "[0-9]")秒" >>$email_path
echo "暂停用时：$(sed -n '24 p' $report_path | tr -cd "[0-9]")秒" >>$email_path
echo "GOTO路径用时：$(sed -n '25 p' $report_path | tr -cd "[0-9]")秒" >>$email_path
echo "脱困用时：$(sed -n '26 p' $report_path | tr -cd "[0-9]")秒" >>$email_path
echo "避障用时：$(sed -n '27 p' $report_path | tr -cd "[0-9]")秒" >>$email_path

