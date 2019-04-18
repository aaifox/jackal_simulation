#include "ros/ros.h"
//#include "std_msgs/String.h"
#include "geometry_msgs/Twist.h"

int main(int argc, char **argv)
{
    ros::init(argc, argv, "control1");
    ros::NodeHandle CN;
    ros::Publisher control_pub = CN.advertise<geometry_msgs::Twist>("twist_marker_server/cmd_vel", 1);
//    ros::Publisher control_pub = CN.advertise<geometry_msgs::Twist>("jackal_velocity_controller/cmd_vel", 1);
    ros::Rate loop_rate(10);

    float count = 0.3;
    while(ros::ok())
    {
        geometry_msgs::Twist cmd_vel;

        cmd_vel.linear.x = count;
        cmd_vel.linear.y = 0.0;
        cmd_vel.angular.z = 0.2;

        ROS_INFO("velocity (x,y,w): %f, %f, %f", cmd_vel.linear.x, cmd_vel.linear.y, cmd_vel.angular.z);

        control_pub.publish(cmd_vel);

        ros::spinOnce();

        loop_rate.sleep();

        count = count+0.1;        
    }

    return 0;
}
