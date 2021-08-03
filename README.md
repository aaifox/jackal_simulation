## Install dependencies :

This is *manual* way to install necessary packages :

for *ros-melodic*
```
sudo apt install ros-melodic-robot-localization ros-melodic-controller-manager ros-melodic-joint-state-controller ros-melodic-diff-drive-controller ros-melodic-gazebo-ros ros-melodic-gazebo-ros-control ros-melodic-gazebo-plugins ros-melodic-roslint ros-melodic-amcl ros-melodic-map-server ros-melodic-move-base ros-melodic-urdf ros-melodic-xacro ros-melodic-message-runtime ros-melodic-topic-tools ros-melodic-teleop-twist-keyboard ros-melodic-twist-mux ros-melodic-ros-control ros-melodic-joint-state-controller-dbgsym ros-melodic-velodyne-simulator ros-melodic-lms1xx ros-melodic-gmapping ros-melodic-navigation ros-melodic-teb-local-planner ros-melodic-sbpl ros-melodic-sbpl-lattice-planner ros-melodic-interactive-marker-twist-server ros-melodic-pointcloud-to-laserscan ros-melodic-move-base-flex ros-melodic-plotjuggler ros-melodic-plotjuggler-ros
```
for *ros-noedic*
```
sudo apt install ros-noetic-robot-localization ros-noetic-controller-manager ros-noetic-joint-state-controller ros-noetic-diff-drive-controller ros-noetic-gazebo-ros ros-noetic-gazebo-ros-control ros-noetic-gazebo-plugins ros-noetic-roslint ros-noetic-amcl ros-noetic-map-server ros-noetic-move-base ros-noetic-urdf ros-noetic-xacro ros-noetic-message-runtime ros-noetic-topic-tools ros-noetic-teleop-twist-keyboard ros-noetic-twist-mux ros-noetic-ros-control ros-noetic-joint-state-controller-dbgsym ros-noetic-velodyne-simulator ros-noetic-lms1xx ros-noetic-gmapping ros-noetic-navigation ros-noetic-teb-local-planner ros-noetic-sbpl ros-noetic-sbpl-lattice-planner ros-noetic-interactive-marker-twist-server ros-noetic-pointcloud-to-laserscan ros-noetic-move-base-flex ros-noetic-plotjuggler ros-noetic-plotjuggler-ros
```

If you want to use `rosdep` and install all dependencies (for example for doc generation etc), the skip this step.

## Use original repo:

### Create a workspace and clone sources
```
mkdir -p jackal_ws/src; cd jackal_ws/src; catkin_init_workspace
git clone https://github.com/jackal/jackal.git
git clone https://github.com/jackal/jackal_simulator.git
git clone https://github.com/jackal/jackal_desktop.git
git clone https://github.com/ros-visualization/interactive_marker_twist_server.git
```

*Install dependencies with* `rosdep` : 
```
cd jackal_ws; rosdep install --from-paths . --ignore-src --rosdistro=kinetic
```

### Build and source

```
cd jackal_ws; catkin_make; source devel/setup.bash
```
### Start simulation : 

In terminal 1 :
```
roslaunch jackal_gazebo jackal_world.launch config:=front_laser gui:=false
```
In terminal 2 :
```
roslaunch jackal_viz view_robot.launch
```
and follow the [tutorial](http://docs.ros.org/indigo/api/jackal_tutorials/html/simulation.html)


### If there are problems with "DefaultRobotHWSim" (ros-kinetic)
(skip this if using ros-melodic)

Edit the file *``jackal/jackal_description/urdf/jackal.gazebo``*

add
```
      <robotSimType>gazebo_ros_control/DefaultRobotHWSim</robotSimType>
      <legacyModeNS>true</legacyModeNS>
```
within
``` 
<plugin name="gazebo_ros_control" filename="libgazebo_ros_control.so"> 
... 
</plugin> 
```

so finally it looks like:
```
  <gazebo>
    <plugin name="gazebo_ros_control" filename="libgazebo_ros_control.so">
      <robotNamespace>/</robotNamespace>
      <robotSimType>gazebo_ros_control/DefaultRobotHWSim</robotSimType>
      <legacyModeNS>true</legacyModeNS>
    </plugin>
  </gazebo>
```
