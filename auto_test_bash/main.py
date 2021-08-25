#!/usr/bin/env.python

import rospy
import actionlib
import sys
import time
from std_msgs.msg import Bool 
from rr_common.srv import Localization
from rr_common.srv import SwitchState
from rr_common.srv import UICmd 
from rr_common.msg import *

def collisioncallback(data):
    rospy.wait_for_service("/ui_msg_service")
    try:
        print("receive callback")
        ui_msg = rospy.ServiceProxy("/ui_msg_service", UICmd)
        ui_msg(8)
        return 1
    except rospy.ServiceException as e:
        print("ui_msg_service call failed: %s" % e)
        return 0

def locate(mapid, locid):
    rospy.wait_for_service("/roborock_scrubber/localization")
    try:
        print("start locate")
        start_locate = rospy.ServiceProxy("/roborock_scrubber/localization", Localization)
        locate_resq= start_locate(mapid, locid)
        print("locate finished")
        return 1
    except rospy.ServiceException as e:
        print("Auto task service call failed: %s" % e)
        return 0


def switch_state(cur_state):
    rospy.wait_for_service("/roborock_scrubber/app_switch_state")
    try:
        print("switch state %s" % cur_state)
        switch_state_client = rospy.ServiceProxy("/roborock_scrubber/app_switch_state", SwitchState)
        resp1 = switch_state_client(cur_state)
        print("switch state finished" )
        return 1
    except rospy.ServiceException as e:
        print("Switch state service call failed: %s" % e)
        return 0


def start_auto_task(map_id_, plan_id_, clean_config, cycle_time):
    rospy.init_node('app_auto_clean', anonymous=True)
    auto_client = actionlib.SimpleActionClient('app_auto_clean', AppAutoCleanAction)
    auto_client.wait_for_server()

    auto_goal = AppAutoCleanGoal()
    auto_goal.command = 0
    auto_goal.plan.map_id = map_id_
    auto_goal.plan.plan_id = plan_id_
    auto_goal.plan.clean_config = clean_config
    auto_goal.plan.cycle_time = cycle_time
    print("Send mission")
    auto_client.send_goal(auto_goal, done_cb=start_auto_doneback, feedback_cb=start_auto_feedback)
    print("Send mission finished")
    auto_client.wait_for_result()
    return auto_client.get_result()


def start_auto_feedback(fb):
    return

def start_auto_doneback(state, db):
    return

def auto_clean_result():
    data =rospy.wait_for_message('/app_auto_clean/result', AppAutoCleanActionResult)
    print data
    f = open('/mnt/disk1/text.txt','w')
    f.write(str(data))
    f.close()
#    switch_state(20)


def auto_clean_result_callback(fb):
    print "Auto Clean Result: "
    print fb


if __name__ == "__main__":
    map_id = int(sys.argv[1])
    plan_id = int(sys.argv[2])
    loc_id = int(sys.argv[3])
    rospy.Subscriber("/dynamic_obstacle/collision", Bool, collisioncallback)
    switch_state_res = switch_state(22)
    if switch_state_res:
        loc_res = locate(map_id, loc_id)
        time.sleep(60)

        if loc_res:
            start_auto_task(map_id, plan_id, 1, 1)
            auto_clean_result()
        else:
            print("The result of location is fail")

    else:
        print("The result of switch state is false")

    print("finished")

