#!/usr/bin/env python
# -*- coding:utf-8 -*-
import rospy
from geometry_msgs.msg import Twist

class cmdVelController:
  def __init__(self, topic):
      self.topic = topic
      self.command_publisher = rospy.Publisher(self.topic, Twist, queue_size=1000)
      self.cmd_vel = Twist()
      rospy.on_shutdown(self.shutdown)

  def command(self, vel_x, vel_y, vel_z, ang_x, ang_y, ang_z):
    self.cmd_vel.linear.x = vel_x
    self.cmd_vel.linear.y = vel_y
    self.cmd_vel.linear.z = vel_z
    self.cmd_vel.angular.x = ang_x
    self.cmd_vel.angular.y = ang_y
    self.cmd_vel.angular.z = ang_z

    self.command_publisher.publish(self.cmd_vel)

  def shutdown(self):
    rospy.loginfo("Stoping robots")
    self.command_publisher.publish(Twist())
    rospy.sleep(1)

def main():
  updateRate = 1
  rospy.init_node("obstacle_bot_controller")
  rospy.loginfo("Press CTRL+c to stop controller")
  obstacle_bot0_controller = cmdVelController("/dynamic_obstacle/cmd_vel")

  
  while not rospy.is_shutdown():
    cl_step0 = 0
    rospy.loginfo("Moving forward")
    while cl_step0 <= 8:
      obstacle_bot0_controller.command(-0.6,0,0,0,0,0)
      cl_step0 += 1
      rospy.Rate(updateRate).sleep()

    rospy.loginfo("Moving backward")
    cl_step2 = 0
    while cl_step2 <= 8:
      obstacle_bot0_controller.command(0.6,0,0,0,0,0)
      cl_step2 += 1
      rospy.Rate(updateRate).sleep()

if __name__ == "__main__":
  try:
    main()
  except:
    rospy.loginfo("Controller stopped")
