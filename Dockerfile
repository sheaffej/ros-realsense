FROM ros:kinetic-perception-xenial

SHELL [ "bash", "-c"]
WORKDIR /root

ENV ROS_WS /ros
ENV INTELRS_VER 2.30.0
ENV RS_ROS_VER  2.2.11

RUN mkdir -p ${ROS_WS}/src

RUN apt update \
&& apt install -y \
    unzip \
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

# ---> Only works on amd64 <----
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
# ADD librealsense ./librealsense

RUN curl -LO https://github.com/IntelRealSense/librealsense/archive/v${INTELRS_VER}.tar.gz \
&& tar xzf v${INTELRS_VER}.tar.gz \
&& pushd librealsense-${INTELRS_VER} \
# && git checkout ${INTELRS_VER} \
&& mkdir build && cd build \
&& cmake ../ -DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLES=true \
&& make uninstall && make clean && make -j4 && sudo make install \
&& popd \
&& rm -Rf librealsense-${INTELRS_VER}


# Install realsense2-camera
# ADD https://github.com/IntelRealSense/realsense_ros.git ${ROS_WS}/src/realsense_ros/
# ADD realsense-ros/realsense2_camera ${ROS_WS}/src/realsense2_camera

RUN curl -LO https://github.com/IntelRealSense/realsense-ros/archive/${RS_ROS_VER}.zip \
&& unzip ${RS_ROS_VER}.zip \
&& cd realsense-ros-${RS_ROS_VER} \
# && cd ${ROS_WS}/src/realsense2_camera && git checkout ${RS_ROS_VER} \
&& source /opt/ros/kinetic/setup.bash \
&& cd ${ROS_WS}/src && catkin_init_workspace \
&& cd ${ROS_WS} \
&& catkin_make clean \
&& catkin_make -DCATKIN_ENABLE_TESTING=False -DCMAKE_BUILD_TYPE=Release \
&& catkin_make install

ADD ./entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "sleep", "infinity" ]
