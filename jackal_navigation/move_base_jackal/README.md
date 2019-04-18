## Move base Jackal

### Installing

Install the necessary dependencies (replace melodic with kinetic if running on Ubuntu 16):

    sudo apt install ros-melodic-move-base ros-melodic-costmap-2d

Install costmap plugins:

    # https://github.com/rst-tu-dortmund/costmap_prohibition_layer
  
Install teb_local_planner:

    # https://github.com/rst-tu-dortmund/teb_local_planner

### Running

Run 2D navigation:

    # Start move_base
    roslaunch move_base_jackal move_base.launch

    # Or select "2D Nav Goal" in RViz and place the arrow accordingly

### Tuning

TODO
