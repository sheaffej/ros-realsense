#!/usr/bin/env bash

DOCKER_IMAGE="sheaffej/ros-realsense"
CONTAINER_NAME="laserscan"

[ -z "$ROS_MASTER_URI" ] && echo "Please set ROS_MASTER_URI env" && exit 1

docker run -d --rm \
--name ${CONTAINER_NAME} \
--privileged \
--net host \
--env DISPLAY \
--env ROS_MASTER_URI \
${DOCKER_IMAGE} roslaunch realsense2_camera laserscan.launch

#docker logs -f ${CONTAINER_NAME}
