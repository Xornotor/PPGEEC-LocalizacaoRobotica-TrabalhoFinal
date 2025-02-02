# GLIM ODOM DIFF
# Author: André Paiva Conrado Rodrigues
# PPGEE - UFBA - 2024.2

import rospy
from tf.transformations import euler_from_quaternion
from nav_msgs.msg import Odometry
from geometry_msgs.msg import Twist, Pose


# Diff Calc Funcion

def diff(measure, gt):
    measure_quat = [measure.orientation.x, measure.orientation.y,
                    measure.orientation.z, measure.orientation.w]
    gt_quat = [gt.orientation.x, gt.orientation.y,
               gt.orientation.z, gt.orientation.w]
    (m_r, m_p, m_y) = euler_from_quaternion(measure_quat)
    (gt_r, gt_p, gt_y) = euler_from_quaternion(gt_quat)
    diff = Twist()
    diff.linear.x = measure.position.x - gt.position.x
    diff.linear.y = measure.position.y - gt.position.y
    diff.linear.z = measure.position.z - gt.position.z
    diff.angular.x = m_r - gt_r
    diff.angular.y = m_p - gt_p
    diff.angular.z = m_y - gt_y
    return diff


# GLIM Odom Diff Class

class glim_odom_diff():
    # Class function for creating map relations
    def __init__(self):
        rospy.init_node('glim_odom_diff_node')
        self.rate = rospy.Rate(10)
        self.gt_pose = Pose()
        self.glim_pose = Pose()
        
        # Publishers
        self.pub_diff = rospy.Publisher("/glim_odom_diff", Twist, queue_size=10)
        # Subscribers
        rospy.Subscriber("/gazebo_ground_truth/odom", Odometry, self.ground_truth_callback)
        rospy.Subscriber("/glim_ros/odom", Odometry, self.glim_odom_callback)

    def ground_truth_callback(self, data):
        self.gt_pose = data.pose.pose
        glim_diff = diff(self.glim_pose, self.gt_pose)
        self.pub_diff.publish(glim_diff)

    def glim_odom_callback(self, data):
        self.glim_pose = data.pose.pose

    def main(self):
        rospy.spin()

if __name__ == '__main__':
    try:
        diff_node = glim_odom_diff()
        diff_node.main()
    finally:
        pass