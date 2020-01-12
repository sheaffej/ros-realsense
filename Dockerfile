FROM ros:kinetic-perception-xenial

SHELL [ "bash", "-c"]
WORKDIR /root

ENV ROS_WS /ros
ENV INTELRS_VER v2.30.0
ENV RS_ROS_VER  2.2.11

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

# ---------------------
# Install librealsense2
# ---------------------

# RUN \
# apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE \
# && sudo add-apt-repository "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo xenial main" -u \
# && apt update \
# && apt install -y \
#     librealsense2-dkms \
#     librealsense2-utils \
#     librealsense2-dev \
#     librealsense2-dbg \
# && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt update \
&& apt install -y \
    libssl-dev \
    libusb-1.0-0-dev \
    pkg-config \
    libgtk-3-dev \
    libglfw3-dev \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ADD https://github.com/IntelRealSense/librealsense/archive/v${RS_VER}.tar.gz ./libreasense
ADD librealsense ./librealsense

RUN cd librealsense && git checkout ${INTELRS_VER} \
&& mkdir build && cd build \
&& cmake ../ -DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLES=true \
&& make uninstall && make clean && make -j4 && sudo make install


RUN mkdir -p ${ROS_WS}/src/realsense

# Install realsense2-camera
# ADD https://github.com/IntelRealSense/realsense-ros.git ${ROS_WS}/src/realsense-ros/
ADD realsense-ros ${ROS_WS}/src/realsense-ros

RUN \
source /opt/ros/kinetic/setup.bash \
&& cd ${ROS_WS}/src/realsense-ros && git checkout ${RS_ROS_VER} \
&& cd ${ROS_WS}/src && catkin_init_workspace \
&& cd ${ROS_WS} \
&& catkin_make clean \
&& catkin_make -DCATKIN_ENABLE_TESTING=False -DCMAKE_BUILD_TYPE=Release \
&& catkin_make install

ADD ./entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "sleep", "infinity" ]
