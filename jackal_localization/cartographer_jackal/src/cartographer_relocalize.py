#!/usr/bin/env python

import subprocess
import math

from rospy import init_node, get_param, spin, Subscriber

from geometry_msgs.msg import PoseWithCovarianceStamped

class CartographerRelocalizeNode:
    def __init__(self):
        print('Initializing cartographer_relocalize node...')

        init_node('cartographer_relocalize')

        self.configuration_directory = get_param('~configuration_directory')
        self.configuration_basename = get_param('~configuration_basename')

        self.reference_trajectory = 0
        self.current_trajectory = 1

        self.trajectory_process = None
        
        Subscriber('/initialpose', PoseWithCovarianceStamped, self.callback)
        
        print('Initialized cartographer_relocalize node!')

    def callback(self, data):
        print('\nRelocalization pose received!')

        q = data.pose.pose.orientation
        x = data.pose.pose.position.x
        y = data.pose.pose.position.y
        yaw = math.atan2(2.0 * (q.w * q.z + q.x * q.y), 1.0 - 2.0 * (q.y*q.y + q.z*q.z))

        if self.trajectory_process:
            self.trajectory_process.terminate()
            self.trajectory_process.wait()

        cmd_1 = 'rosservice call /finish_trajectory ' + str(self.current_trajectory)

        subprocess.call(cmd_1, shell=True)

        cmd_2 = 'rosrun cartographer_ros cartographer_start_trajectory'
        cmd_2 += ' -configuration_directory {}'.format(self.configuration_directory)
        cmd_2 += ' -configuration_basename {}'.format(self.configuration_basename)
        cmd_2 += ' -initial_pose \'{{to_trajectory_id = {}, relative_pose = {{ translation = {{ {}, {}, 0. }}, rotation = {{ 0., 0., {} }} }} }}\''.format(self.reference_trajectory, x, y, yaw)

        self.trajectory_process = subprocess.Popen(cmd_2, shell=True)

        self.current_trajectory += 1

if __name__ == '__main__':
    node = CartographerRelocalizeNode()
    spin()
