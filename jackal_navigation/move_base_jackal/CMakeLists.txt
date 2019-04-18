cmake_minimum_required(VERSION 2.8.12)

project(move_base_jackal)

set(PACKAGE_DEPENDENCIES move_base)

find_package(catkin REQUIRED)

catkin_package()

include_directories()

install(DIRECTORY launch
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
  )
