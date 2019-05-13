## Install dependencies :

This is *manual* way to install necessary packages :
```
sudo apt install ros-kinetic-robot-localization ros-kinetic-controller-manager ros-kinetic-joint-state-controller ros-kinetic-diff-drive-controller ros-kinetic-gazebo-ros ros-kinetic-gazebo-ros-control ros-kinetic-gazebo-plugins ros-kinetic-lms1xx ros-kinetic-pointgrey-camera-description ros-kinetic-roslint ros-kinetic-amcl ros-kinetic-gmapping ros-kinetic-map-server ros-kinetic-move-base ros-kinetic-urdf ros-kinetic-xacro ros-kinetic-message-runtime ros-kinetic-topic-tools ros-kinetic-teleop-twist-keyboard ros-kinetic-velodyne-simulator ros-kinetic-twist-mux ros-kinetic-ros-control
```
for *ros-melodic*
```
sudo apt install ros-melodic-robot-localization ros-melodic-controller-manager ros-melodic-joint-state-controller ros-melodic-diff-drive-controller ros-melodic-gazebo-ros ros-melodic-gazebo-ros-control ros-melodic-gazebo-plugins ros-melodic-roslint ros-melodic-amcl ros-melodic-map-server ros-melodic-move-base ros-melodic-urdf ros-melodic-xacro ros-melodic-message-runtime ros-melodic-topic-tools ros-melodic-teleop-twist-keyboard ros-melodic-twist-mux ros-melodic-ros-control ros-melodic-joint-state-controller-dbgsym ros-melodic-velodyne-simulator
```
### currrently melodic do not support following packages:
```
lms1xx
gmapping
pointgrey-camera-description
```

comment out lines in file: *`jackal/jackal_description/urdf/accessories.urdf.xacro`*
```
lms1xx: line 19-31
pointgrey-camera-description: line 49, 104
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
