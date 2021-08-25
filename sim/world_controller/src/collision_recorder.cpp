#include "collision_recorder.h"

using namespace std;

extern string premsg = "";

int passInfoToMap(string messages, map<string, string> &infoMap)
{
  std::regex regexCollisionObject1 ("collision1: \".*\"");
  std::regex regexCollisionObject2 ("collision2: \".*\"");
  std::smatch CollisionObject1Matches;
  std::smatch CollisionObject2Matches;

  std::regex_search(messages, CollisionObject1Matches, regexCollisionObject1);
  std::regex_search(messages, CollisionObject2Matches, regexCollisionObject2);

  try
  {
    infoMap["Object1"] = CollisionObject1Matches.str().substr(12);
    infoMap["Object2"] = CollisionObject2Matches.str().substr(12);
  }
  catch(...)
  {
    return 1;
  }

  return 0;
}

int collisionRecordWrite(map<string, string> infoMap)
{
  ofstream fout("CollisionRecord.txt", ios::app);
  fout << infoMap["Object1"] << "::Collision::" << infoMap["Object2"] << endl;
  fout.close();

  return 0;
}

void genROSFeedback(map<string, string> infoMap)
{
  std_msgs::String infoOut;
  std::stringstream ss;

  ss << infoMap["Object1"] << "::Collision::" << infoMap["Object2"];

  if(premsg != ss.str())
  {
    infoOut.data = ss.str();
    ROS_WARN("%s", infoOut.data.c_str());
    collisionRecordWrite(infoMap);
    premsg = ss.str();
  }
}

void CollisionCheck(ConstContactsPtr &_msg)
{
    string messages = _msg -> Utf8DebugString();
    string groundName = "ground_plane";
    string carName ="CleaningCar";
    string expandName ="expand_body_collision";

    map<string, string> infoMap;

    if(passInfoToMap(messages, infoMap) == 0)
    {
      bool isCar = infoMap["Object1"].find(carName) != string::npos || infoMap["Object2"].find(carName) != string::npos;
      bool isNotGround = infoMap["Object1"].find(groundName) == string::npos && infoMap["Object2"].find(groundName) == string::npos;
      bool isexpand = infoMap["Object1"].find(expandName) != string::npos || infoMap["Object2"].find(expandName) != string::npos;
 
      stop_.store(false); 
      if(isNotGround)
      {
        if(isCar&&!isexpand){
          //std::cout<<"-----------collision-------"<<std::endl; 
          stop_.store(true);
          collision_pub_.publish(collison_);
        }else if(isCar&&isexpand){
          //std::cout<<"close"<<std::endl;
          stop_.store(true);
          expand_collision_pub_.publish(collison_);
        }        
      }
    }
} 


void SendCmd(double x,double y,double z){
    geometry_msgs::Twist twist;
    twist.linear.x=x;
    twist.linear.y=y;
    twist.linear.z=z;
    twist.angular.x=0;
    twist.angular.y=0;
    twist.angular.z=0;
    cmd_vel_pub_.publish(twist);
}

void reset_model(){
    gazebo_msgs::SetModelState objstate;
     
    objstate.request.model_state.model_name = "robot1";
    objstate.request.model_state.pose.position.x = -2;
    objstate.request.model_state.pose.position.y = -8;
    objstate.request.model_state.pose.position.z = 0;
    objstate.request.model_state.pose.orientation.w = 0.707075536915;
    objstate.request.model_state.pose.orientation.x = 1.27498125549e-05;
    objstate.request.model_state.pose.orientation.y = -1.05056483175e-05;
    objstate.request.model_state.pose.orientation.z = 0.707138023885;
    objstate.request.model_state.twist.linear.x = 0.0;
    objstate.request.model_state.twist.linear.y = 0.0;
    objstate.request.model_state.twist.linear.z = 0.0;
    objstate.request.model_state.twist.angular.x = 0.0;
    objstate.request.model_state.twist.angular.y = 0.0;
    objstate.request.model_state.twist.angular.z = 0.0;
    objstate.request.model_state.reference_frame = "world";
    client_.call(objstate);

    objstate.request.model_state.model_name = "robot2";
    objstate.request.model_state.pose.position.x = 3;
    objstate.request.model_state.pose.position.y = -8;
    objstate.request.model_state.pose.position.z = 0;
    client_.call(objstate);

    objstate.request.model_state.model_name = "robot3";
    objstate.request.model_state.pose.position.x = 8;
    objstate.request.model_state.pose.position.y = -8;
    objstate.request.model_state.pose.position.z = 0;
    client_.call(objstate);

     

}

int main(int _argc, char **_argv)
{
  ros::init(_argc, _argv, "collision_recorder");
  ros::NodeHandle n;

  stop_.store(false);
  collison_.data = true;


  cmd_vel_pub_= n.advertise<geometry_msgs::Twist>("/dynamic_obstacle/cmd_vel", 1, true);
  collision_pub_= n.advertise<std_msgs::Bool>("/dynamic_obstacle/collision", 1, true);
  expand_collision_pub_= n.advertise<std_msgs::Bool>("/dynamic_obstacle/expand_collision", 1, true);
  client_ = n.serviceClient<gazebo_msgs::SetModelState>("/gazebo/set_model_state");
  //cmd_thread_ = std::thread(&CmdThread);

  ROS_INFO("collision recorder started");

  gazebo::client::setup(_argc, _argv);
  gazebo::transport::NodePtr node(new gazebo::transport::Node());
  node->Init();
  gazebo::transport::SubscriberPtr sub = node->Subscribe("~/physics/contacts", CollisionCheck);

  while(ros::ok()){
    if(!stop_.load())
    reset_model();
  
    for(int i=0;i<16;i++)
    {
      if(stop_.load()){
        SendCmd(0,0,0);
        sleep(1);
        continue;
      }
      SendCmd(-0.6,0,0);
      usleep(500000);
    }
    for(int i=0;i<16;i++)
    {
      if(stop_.load()){
        SendCmd(0,0,0);
        sleep(1);
        continue;
      }
      SendCmd(0.6,0,0);
      usleep(500000);
    }
  }

  gazebo::client::shutdown();
  ros::spin();

  return 0;
}
