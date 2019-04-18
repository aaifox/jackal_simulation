## Gmapping Jackal

### Installing

Install the necessary dependencies (replace melodic with kinetic if running on Ubuntu 16):

    sudo apt install ros-melodic-tf2-sensor-msgs ros-melodic-amcl

If using ROS kinetic install gmapping by hand, otherwise install from source:

    # https://github.com/ros-perception/pointcloud_to_laserscan
    # https://github.com/ros-perception/openslam_gmapping
    # https://github.com/ros-perception/slam_gmapping

### Running

Create map of the environment:

    # Start gmapping
    roslaunch gmapping_jackal gmapping.launch

    # Teleoperate robot to cover the environment
    rosrun teleop_twist_keyboard teleop_twist_keyboard.py

    # Save the built map
    rosrun map_server map_saver -f map
    mv map.* <path_to_gmapping_jackal>/maps/

Run pure localization with the built map:

    # Start amcl from map origin
    roslaunch gmapping_jackal amcl.launch

### Extra

Give initial 2D pose to amcl (the particles will be dispersed around pose using the initial covariance):

    # Either start amcl with the pose as a param
    roslaunch gmapping_jackal amcl.launch x:=0.0 y:=0.0 yaw:=0.0

    # Or select "2D Pose Estimate" in RViz and place the arrow accordingly

Relocalize globally in the map (the particles will be dispersed randomly in the map using the initial covariance):

    rosservice call /global_localization

Update the particle filter after relocalization to converge without moving:

    rosservice call /request_nomotion_update

    # Tip: You can repeat the command several times until the PF converges by using a "for loop" in bash or a "repeat" in zsh:
    repeat 20 rosservice call /request_nomotion_update

Use depth camera to generate octomap:

    # Launch node to extract pointcloud from rectified depth image and launch octomap server
    roslaunch gmapping_jackal octomap.launch

### Tuning

TODO
