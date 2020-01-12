# ros-realsense
Docker image for using Intel Realsense with ROS

```
git clone https://github.com/IntelRealSense/librealsense.git
git clone https://github.com/IntelRealSense/realsense-ros.git

# Add udev rules to the Docker host
librealsense/scripts/setup_udev_rules.sh
./run_realsense <command>
```


