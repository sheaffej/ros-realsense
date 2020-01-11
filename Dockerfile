FROM ros:kinetic-perception-xenial

SHELL [ "bash", "-c"]

ENV ROS_WS /ros
RUN mkdir -p ${ROS_WS}

RUN apt update \
&& apt install -y software-properties-common \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Additional ROS packages
RUN apt update \
&& apt install -y \
    ros-kinetic-cv-bridge \
    ros-kinetic-image-transport \
    ros-kinetic-tf \
    ros-kinetic-diagnostic-updater \
    ros-kinetic-ddynamic-reconfigure \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install librealsense2
RUN \
# apt-key adv --keyserver keys.gnupg.net --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE \
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE \
&& sudo add-apt-repository "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo xenial main" -u \
# echo 'deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo xenial main' ||  tee /etc/apt/sources.list.d/realsense-public.list \
# && add-apt-repository "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo xenial main" \
&& apt update \
# && apt install --allow-unauthenticated -y \
&& apt install -y \
    librealsense2-dkms \
    librealsense2-utils \
    librealsense2-dev \
    librealsense2-dbg \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN mkdir -p ${ROS_WS}/src/realsense

# Install realsense2-camera
# mv * ${ROS_WS}/src/realsense/     # This leaves behind .git, .gitignore and .travis.yml but no matter.
ADD https://github.com/IntelRealSense/realsense-ros.git ${ROS_WS}/src/realsense/

RUN \
source /opt/ros/kinetic/setup.bash \
&& cd ${ROS_WS}/src/ \
&& catkin_init_workspace \
&& cd ${ROS_WS} \
&& catkin_make clean \
&& catkin_make -DCATKIN_ENABLE_TESTING=False -DCMAKE_BUILD_TYPE=Release \
&& catkin_make install



ADD ./entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "sleep", "infinity" ]
