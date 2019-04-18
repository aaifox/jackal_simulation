cmake_minimum_required(VERSION 2.8.3)
project(jackal_gazebo)

find_package(catkin REQUIRED COMPONENTS roslaunch roscpp geometry_msgs)

catkin_package()

include_directories(include ${catkin_INCLUDE_DIRS})

add_executable(control1 src/control1.cpp)

add_dependencies(control1 jackal_gazebo_control1_cpp)

target_link_libraries(control1 ${catkin_LIBRARIES})

roslaunch_add_file_check(launch/jackal_world.launch)

install(DIRECTORY launch Media worlds
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)
