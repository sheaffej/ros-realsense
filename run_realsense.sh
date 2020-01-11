#!/usr/bin/env bash

IMAGE="ros-realsense"

docker run -it --rm \
--privileged \
--net host \
--env DISPLAY \
${IMAGE} $@
