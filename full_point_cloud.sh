#!/bin/bash

export SVGA_VGPU10=0
source ./ros_entrypoint.sh

if [ -d "Point_Cloud_Resolution/build" ]; then
    rm -rf Atividade_03/build
fi

if [ -d "Point_Cloud_Resolution/devel" ]; then
    rm -rf Point_Cloud_Resolution/devel
fi

cd Point_Cloud_Resolution && catkin_make && cd ..

source Point_Cloud_Resolution/devel/setup.bash
source Point_Cloud_Resolution/src/husky_accessories.sh

rosdep update
rosdep install --from-paths Point_Cloud_Resolution/src --ignore-src -r -y --rosdistro noetic

roslaunch lar_point_cloud_dec lar_full_point_cloud.launch