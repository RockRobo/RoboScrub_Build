#include <gazebo/transport/transport.hh>
#include <gazebo/msgs/msgs.hh>
#include <gazebo/gazebo_client.hh>

#include "ros/ros.h"
#include "std_msgs/String.h"

#include <iostream>
#include <string>
#include <unordered_map>
#include <regex>
#include <fstream>
#include <chrono>
#include <thread>

#include <geometry_msgs/Twist.h>
#include <atomic>

#include <gazebo_msgs/SetModelState.h>
#include "std_msgs/Bool.h"

std::thread cmd_thread_;
ros::Publisher cmd_vel_pub_;
ros::Publisher collision_pub_;
ros::Publisher expand_collision_pub_;
ros::ServiceClient client_;
std::atomic<bool> stop_;
std_msgs::Bool collison_;

void SendCmd(double x,double y,double z);
void reset_model();
