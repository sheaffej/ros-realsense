#!/usr/bin/env bash

DOCKER_IMAGE="sheaffej/ros-realsense"
LABEL="b2"

[ -z "$ROS_MASTER_URI" ] && echo "Please set ROS_MASTER_URI env" && exit 1

docker run -it --rm \
--label ${LABEL} \
--net host \
--privileged \
--env DISPLAY \
--env ROS_MASTER_URI \
${DOCKER_IMAGE} $@
