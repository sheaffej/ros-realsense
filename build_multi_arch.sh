#!/usr/bin/env bash
# Reference: https://www.docker.com/blog/multi-arch-images/

DOCKER_IMAGE="sheaffej/ros-realsense:latest"
PLATFORM="linux/amd64,linux/arm/v7,linux/arm64"
#PLATFORM="linux/arm64"


echo
while [ $# -gt 0 ]; do
    case $1 in
        "push")
            PUSH="--push"
            echo "Push to Docker Hub requested"
            ;;
        "tag")
            shift
            DOCKER_IMAGE="$1"
            echo "Using tag: $TAG"
            ;;
        *)
            echo "Unknown argument" $1
    esac
    shift
done

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

docker buildx build \
-t $DOCKER_IMAGE \
--platform $PLATFORM \
$PUSH \
$MYDIR

