# ros-realsense
Docker image for using Intel Realsense with ROS

```
git clone https://github.com/IntelRealSense/librealsense.git
cd librealsense && git checkout v2.30.0 && cd ..

git clone https://github.com/IntelRealSense/realsense-ros.git
cd realsense-ros && git checkout 2.2.11 && cd ..


# Add udev rules to the Docker host
cd librealsense
sudo scripts/setup_udev_rules.sh
cd ..


./run_realsense <command>
```


