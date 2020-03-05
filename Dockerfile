# FROM ros:kinetic-perception-xenial
FROM ros:melodic-perception-bionic


SHELL [ "bash", "-c"]
WORKDIR /root
ADD ./entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "bash" ]

ENV ROS_WS /ros
ENV INTELRS_VER 2.30.0
ENV INTELRS_BRANCH v2.30.0
ENV RS_ROS_BRANCH 2.2.11

RUN mkdir -p ${ROS_WS}/src

# Additional OS dependencies
RUN apt update \
&& apt install -y \
    libssl-dev \
    libusb-1.0-0-dev \
    pkg-config \
    libgtk-3-dev \
    libglfw3-dev \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install librealsense2
RUN curl -LO https://github.com/IntelRealSense/librealsense/archive/v${INTELRS_VER}.tar.gz \
&& tar xzf v${INTELRS_VER}.tar.gz \
&& pushd librealsense-${INTELRS_VER} \
&& mkdir build && cd build \
&& cmake ../ -DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLES=true -DBUILD_GRAPHICAL_EXAMPLES=false \
&& make uninstall && make clean && make -j4 && sudo make install \
&& popd \
&& rm -Rf librealsense-${INTELRS_VER} v${INTELRS_VER}.tar.gz

# Additional ROS packages
RUN apt update \
&& apt install -y \
    # ros-kinetic-cv-bridge \
    # ros-kinetic-image-transport \
    # ros-kinetic-tf \
    # ros-kinetic-diagnostic-updater \
    # ros-kinetic-ddynamic-reconfigure \
    # ros-kinetic-rgbd-launch \
    # ros-kinetic-depthimage-to-laserscan \
    ros-melodic-cv-bridge \
    ros-melodic-image-transport \
    ros-melodic-tf \
    ros-melodic-diagnostic-updater \
    ros-melodic-ddynamic-reconfigure \
    ros-melodic-rgbd-launch \
    ros-melodic-depthimage-to-laserscan \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download realsense-ros
RUN git clone --branch ${RS_ROS_BRANCH} https://github.com/IntelRealSense/realsense-ros.git \
&& mv realsense-ros/realsense2_camera ${ROS_WS}/src/realsense2_camera \
&& rm -Rf realsense-ros

# Add additional launch files
COPY ./launch/* ${ROS_WS}/src/realsense2_camera/launch/

# Build ROS workspace
RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
&& cd ${ROS_WS}/src \
&& catkin_init_workspace \
&& cd ${ROS_WS} \
&& catkin_make clean \
&& catkin_make -DCATKIN_ENABLE_TESTING=False -DCMAKE_BUILD_TYPE=Release \
&& catkin_make install

