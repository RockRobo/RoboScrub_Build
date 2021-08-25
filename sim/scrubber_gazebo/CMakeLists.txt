cmake_minimum_required(VERSION 2.8.3)
project(scrubber_gazebo)

## Compile as C++11, supported in ROS Kinetic and newer
# add_compile_options(-std=c++11)

## Find depends
find_package(catkin REQUIRED
            roscpp
		    rospy)

###################################
## catkin specific configuration ##
###################################
catkin_package(
)

###########
## Build ##
###########
# build exec scrubber_gazebo_cleanArea
add_executable(${PROJECT_NAME}_cleanArea src/cleanMarkers.cpp)
target_link_libraries(${PROJECT_NAME}_cleanArea ${catkin_LIBRARIES})
target_include_directories(${PROJECT_NAME}_cleanArea PRIVATE ${catkin_INCLUDE_DIRS})
add_executable(${PROJECT_NAME}_dynamicObject src/dynamicObject.cpp)
target_link_libraries(${PROJECT_NAME}_dynamicObject ${catkin_LIBRARIES})
target_include_directories(${PROJECT_NAME}_dynamicObject PRIVATE ${catkin_INCLUDE_DIRS})
# end build exec scrubber_gazebo_cleanArea

#############
## Install ##
#############
## Mark executables and/or libraries for installation
#install(TARGETS ${PROJECT_NAME}_cleanArea ${PROJECT_NAME}_cleanArea
#   ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
#   LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
#   RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
#)
#
### Mark other files for installation (e.g. launch and bag files, etc.)
#install(DIRECTORY
#        launch
#        configuration_files
#        maps
#        worlds
#  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
#)
#############
## Testing ##
#############
