cmake_minimum_required(VERSION 2.8.3)

project(scrubber_model)

## Find depends
find_package(catkin REQUIRED roslaunch)

###################################
## catkin specific configuration ##
###################################
catkin_package()

#############
## Install ##
#############
#foreach(dir config launch meshes urdf)
#	install(DIRECTORY ${dir}/
#		DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/${dir})
#endforeach(dir)

install(FILES launch/scrubber_model.launch
        DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
        )

#############
## Testing ##
#############