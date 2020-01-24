#!/usr/bin/env bash

DOCKER_IMAGE="sheaffej/ros-realsense"

[ -z "$ROS_MASTER_URI" ] && echo "Please set ROS_MASTER_URI env" && exit 1

docker run -d --rm \
--name rs_rgbd \
--privileged \
--net host \
--env DISPLAY \
--env ROS_MASTER_URI \
${DOCKER_IMAGE} roslaunch realsense2_camera rs_rgbd.launch

