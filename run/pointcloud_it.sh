#!/usr/bin/env bash

DOCKER_IMAGE="sheaffej/ros-realsense"
CONTAINER_NAME="pointcloud"
LABEL="b2"

[ -z "$ROS_MASTER_URI" ] && echo "Please set ROS_MASTER_URI env" && exit 1

docker run -it --rm \
--name ${CONTAINER_NAME} \
--label ${LABEL} \
--net host \
--privileged \
--env DISPLAY \
--env ROS_MASTER_URI \
${DOCKER_IMAGE} roslaunch realsense2_camera rs_camera.launch \
filters:=pointcloud \
enable_pointcloud:=true \
enable_infra2:=false \
enable_infra1:=false \
align_depth:=false
