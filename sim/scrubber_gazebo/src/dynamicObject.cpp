//
// Created by tony on 2021/6/9.
//

#include <ros/ros.h>
#include <gazebo_msgs/ModelState.h>
#include <gazebo_msgs/ModelStates.h>

#define MODEL_CAR "CleaningCar"
#define MODEL_BOX_0 "unit_box_0"
#define MODEL_BOX_1 "unit_box_1"
#define MODEL_BOX_2 "unit_box_2"

ros::Publisher pub_box_;
ros::Timer action_timer_, random_timer_;
geometry_msgs::Point car_;
geometry_msgs::Point box_0_, init_box_0_;
geometry_msgs::Point box_1_, init_box_1_;
geometry_msgs::Point box_2_, init_box_2_;

void resetBox(int box) {
    gazebo_msgs::ModelState model_state;
    std::string name;
    geometry_msgs::Point point;
    switch (box) {
        case 0:
            name = MODEL_BOX_0;
            point = init_box_0_;
            break;
        case 1:
            name = MODEL_BOX_1;
            point = init_box_1_;
            break;
        case 2:
            name = MODEL_BOX_2;
            point = init_box_2_;
            break;
        default:
            break;
    }

    model_state.model_name = name;
    model_state.pose.position = point;
    pub_box_.publish(model_state);
}

void resetAllBoxes() {
    for (auto i = 0; i < 3; ++i) {
        resetBox(i);
    }
}

void goLine(geometry_msgs::Point start, double vx, double vy, double keep_time) {
    ros::spinOnce();
    int frequency = 20;
    gazebo_msgs::ModelState model_state_1, model_state_2;
    model_state_1.model_name = MODEL_BOX_1;
    model_state_2.model_name = MODEL_BOX_2;

    model_state_1.pose.position.x = car_.x + start.x;
    model_state_1.pose.position.y = car_.y + start.y;
    model_state_1.pose.orientation.w = 1.0;
    model_state_2.pose.position.x = car_.x - start.x;
    model_state_2.pose.position.y = car_.y - start.y;
    model_state_2.pose.orientation.w = 1.0;
    pub_box_.publish(model_state_1);
    pub_box_.publish(model_state_2);
    usleep(100000);

    ros::Rate loop(frequency);
    int cnt = 0;
    auto vx_delta = vx / frequency;
    auto vy_delta = vy / frequency;
    while (ros::ok() && cnt++ < keep_time * frequency) {
        ros::spinOnce();
        model_state_1.pose.position.x = box_1_.x + vx_delta;
        model_state_1.pose.position.y = box_1_.y + vy_delta;
        model_state_2.pose.position.x = box_2_.x - vx_delta;
        model_state_2.pose.position.y = box_2_.y - vy_delta;

        pub_box_.publish(model_state_1);
        pub_box_.publish(model_state_2);
        loop.sleep();
    }

    resetBox(1);
    resetBox(2);
}

void randomBox() {
    ros::spinOnce();
    auto a = ((std::rand() % 30) * 0.1 + 1.0) * (std::rand() % 2 == 0 ? 1.0 : -1.0);
    auto b = ((std::rand() % 30) * 0.1 + 1.0) * (std::rand() % 2 == 0 ? 1.0 : -1.0);
    gazebo_msgs::ModelState model_state;
    model_state.model_name = MODEL_BOX_0;
    model_state.pose.position.x = car_.x + a;
    model_state.pose.position.y = car_.y + b;

    if (std::abs(model_state.pose.position.x - box_1_.x) < 0.5
        || std::abs(model_state.pose.position.y - box_1_.y) < 0.5
        || std::abs(model_state.pose.position.x - box_2_.x) < 0.5
        || std::abs(model_state.pose.position.y - box_2_.y) < 0.5)
        return;

    pub_box_.publish(model_state);
}

void modelStatesCallback(gazebo_msgs::ModelStates const &msg) {
    static bool first = true;
    auto iter_car = std::find(msg.name.begin(), msg.name.end(), MODEL_CAR);
    auto iter_box0 = std::find(msg.name.begin(), msg.name.end(), MODEL_BOX_0);
    auto iter_box1 = std::find(msg.name.begin(), msg.name.end(), MODEL_BOX_1);
    auto iter_box2 = std::find(msg.name.begin(), msg.name.end(), MODEL_BOX_2);

    car_ = msg.pose.at(iter_car - msg.name.begin()).position;
    box_0_ = msg.pose.at(iter_box0 - msg.name.begin()).position;
    box_1_ = msg.pose.at(iter_box1 - msg.name.begin()).position;
    box_2_ = msg.pose.at(iter_box2 - msg.name.begin()).position;

    if (!first) return;

    first = false;
    init_box_0_ = box_0_;
    init_box_1_ = box_1_;
    init_box_2_ = box_2_;
    ROS_INFO_STREAM("Got boxes init position.");
    ROS_INFO_STREAM("box 0 " << init_box_0_.x << ", " << init_box_0_.y);
    ROS_INFO_STREAM("box 1 " << init_box_1_.x << ", " << init_box_1_.y);
    ROS_INFO_STREAM("box 2 " << init_box_2_.x << ", " << init_box_2_.y);
    action_timer_.start();
    random_timer_.start();
}

void actionCallback(ros::TimerEvent const&) {
    static int cnt;
    resetAllBoxes();

    geometry_msgs::Point start;
    if (++cnt % 2 == 0) {
        start.x = 3;
        start.y = -3;
        goLine(start, 0, 1, 5);
    } else {
        start.x = 5;
        start.y = 0;
        goLine(start, -0.5, 0, 2.5);
    }
}

void randomCallback(ros::TimerEvent const&) {
    randomBox();
}

int main(int argc, char** argv) {
    const char* NODE_NAME       = "dynamic_object";
    const char* MODEL_TOPIC     = "/gazebo/model_states";
    const char* SET_MODEL_TOPIC = "/gazebo/set_model_state";

    ros::init(argc, argv, NODE_NAME);

    ros::NodeHandle nh;
//    ros::AsyncSpinner spinner(0);
//    spinner.start();

    ros::Subscriber model_states_sub;
    model_states_sub = nh.subscribe(MODEL_TOPIC, 5, &modelStatesCallback);
    pub_box_ = nh.advertise<gazebo_msgs::ModelState>(SET_MODEL_TOPIC, 5, false);
    action_timer_ = nh.createTimer(ros::Duration(10.0), &actionCallback, false, false);
    random_timer_ = nh.createTimer(ros::Duration(3.0), &randomCallback, false, false);

    ros::spin();
//    ros::waitForShutdown();
    return 0;
}
