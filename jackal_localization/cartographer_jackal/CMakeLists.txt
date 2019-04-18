cmake_minimum_required(VERSION 2.8.12)

project(cartographer_jackal)

set(PACKAGE_DEPENDENCIES cartographer_ros)

find_package(catkin REQUIRED)

catkin_package()

include_directories()

install(DIRECTORY launch config
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
  )
