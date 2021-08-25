cmake_minimum_required(VERSION 3.0.2)
project(world_controller)

if (CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64")
find_package(catkin REQUIRED COMPONENTS
             roscpp
             rospy
             std_msgs
            )
return()
endif()

find_package(catkin REQUIRED COMPONENTS
             gazebo_dev REQUIRED
             gazebo_ros
             roscpp
             rospy
             std_msgs
            )

catkin_package(
              INCLUDE_DIRS include
              CATKIN_DEPENDS roscpp std_msgs
)

include_directories(
          include
					${catkin_INCLUDE_DIRS}
)

include_directories(
  ${catkin_INCLUDE_DIRS}
  ${GAZEBO_INCLUDE_DIRS}
)

link_directories(${GAZEBO_LIBRARY_DIRS})
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${GAZEBO_CXX_FLAGS}")
add_executable(collision_recorder src/collision_recorder.cpp)
target_link_libraries(collision_recorder ${GAZEBO_LIBRARIES} ${catkin_LIBRARIES})