## Cartographer Jackal

### Installing

Install the necessary dependencies (replace melodic with kinetic if running on Ubuntu 16):

    sudo apt install ros-melodic-cartographer-ros ros-melodic-cartographer-rviz

Install bumblebee package: http://github.conti.de/CorpSnT-AirRobotics/bumblebee

Generate Jackal's URDF:

    roscd jackal_description/urdf
    xacro jackal.urdf.xacro > jackal.urdf

Build the package in a catkin workspace

### Mapping

SLAMing with collected data offline (**recommended way to map**):

    # Quickly review the collected data
    rosbag play --immediate --loop <path_to_bag>

    # Visualize the bag to verify/plot topics and messages
    rqt_bag <path_to_bag>

    # Validate that the bag has not misalignments and can be used by Cartographer
    rosrun cartographer_ros cartographer_rosbag_validate -bag-filename <path_to_bag>

    # SLAM the bag, this will create a .pbstream file with the optimized sparse pose graph
    # Use 3d:=true if you want 3D localization
    roslaunch cartographer_jackal jackal.launch 3d:=false slam:=true bag_filenames:=<path_to_bag>

SLAMing with collected data:

    # SLAM the bag
    roslaunch cartographer_jackal jackal.launch 3d:=false slam:=true online:=true use_bag:=true bag_filenames:=<path_to_bag>

    # Finish and write state (pose graph)
    rosservice call /finish_trajectory 0
    rosservice call /write_state <path_to_bag>.pbstream

SLAMing with live data:

    roslaunch cartographer_jackal jackal.launch 3d:=false slam:=true online:=true use_bag:=false

### Localization

Localizing in a premapped environment with collected data (**validate that mapping worked**):

    # Launch pure localization using the saved state
    roslaunch cartographer_jackal jackal.launch 3d:=false slam:=false online:=true use_bag:=true bag_filenames:=<path_to_bag> load_state_filename:=<path_to_bag>.pbstream

    # The initial pose starts at the origin of the map, to relocalize at a new pose you can send it through RViz's "2D Pose Estimate"

    # The same relocalization can also be done manually
    rosservice call /finish_trajectory 1
    # Use jackal_3d_localization.lua if running 3D
    rosrun cartographer_ros cartographer_start_trajectory -configuration_directory <path_to_config_dir> -configuration_basename jackal_2d_localization.lua -initial_pose '{to_trajectory_id = 0, relative_pose = { translation = { 0., 0., 0. }, rotation = { 0., 0., 0. } } }'

    # Press space to play rosbag

Localizing in a premapped environment with live data (**real-time localization**):

    # Launch pure localization at origin of map using the saved state
    roslaunch cartographer_jackal jackal.launch 3d:=false slam:=false online:=true use_bag:=false load_state_filename:=<path_to_bag>.pbstream

    # Similar to before, set initial pose optionally...

### Asset Generation

Reconstructing 2D environment and generating assets (occupancy grid map):

    # Replay the bag using the saved state (pose graph) to accurately reconstruct the 2D environment and write the desired assets
    roslaunch cartographer_jackal jackal_2d_assets.launch bag_filenames:=<path_to_bag> pose_graph_filename:=<path_to_bag>.pbstream

    # When finished succefully, an error message "process [cartographer_assets_writer-2] has died" will show

Reconstructing 3D environment and generating assets (XY ortho image, 3D point cloud, voxelized hybrid map, occupancy grid map):

    # Replay the bag using the saved state (pose graph) to accurately reconstruct the 3D environment and write the desired assets
    roslaunch cartographer_jackal jackal_3d_assets.launch bag_filenames:=<path_to_bag> pose_graph_filename:=<path_to_bag>.pbstream

### Tuning

Tuning Cartographer for 2D or 3D is very complex due to the many parameters affecting the algorithm.
The most important parameters for SLAM and localization have been documented in the lua configuration files

Process of tuning:

* Get 2D Cartographer working only with local SLAM (disable loop closure)
* Add IMU inputs for more accurate matching
* Get 3D Cartographer working (if 3D localization is needed)
* Add odometry inputs for faster matching
* Use global SLAM for more consistent results (enable loop closure)
* Add nav sat inputs for mapping long traversals

A few tips:

* A high rate IMU that can "follow" the robot when turning can converge faster and provide better results
* Don't subsample the inputs (especially) IMU since the benefit (less processing) does not outweight the drawbacks (robustness loss)
* Online correlative scan matcher slows down local SLAM dramatically. Use it to initialize ceres scan matcher only when the other sensory inputs (IMU, odometry) are not trusted.
* Extreme values of the z-axis bandpass filter can cause elevated obstacles to be project to the 2D map as occupied

TODO:

* Tune for 3D SLAM and localization
* Tune for lower latency 2D localization
* Tune for faster 2D relocalization
