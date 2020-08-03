# ros-realsense
Docker image for using Intel Realsense with ROS

### Build the Docker image
```
./build_docker.sh
```

### Run the ROS Realsense node
To run the node publishing a `sensor_msgs/LaserScan` topic
```
run/laserscan.sh
```

To run the node publishing a `sensor_msgs/PointCoud2` topic
```
run/pointcloud.sh
```

To launch a Bash shell inside of the container without starting any nodes (for example, to run test commands)
```
run/cmd.sh
```

### Testing operation of the Intel Realsense camera
The Docker image inclues the example tools in /usr/local/bin
```
root@docker:~# ls /usr/local/bin
rs-color    rs-distance           rs-fw-update        rs-pose-and-image  rs-save-to-disk
rs-convert  rs-enumerate-devices  rs-hello-realsense  rs-pose-predict    rs-terminal
rs-depth    rs-fw-logger          rs-pose             rs-record
```

A quick test can be performed using `rs-distance`
```
root@docker:~# rs-distance
There are 1 connected RealSense devices.

Using device 0, an Intel RealSense D435
    Serial number: xxxxxxxxxxxx
    Firmware version: 05.12.01.00

The camera is facing an object 2.739 meters away.
The camera is facing an object 2.703 meters away.
The camera is facing an object 2.727 meters away.
The camera is facing an object 2.751 meters away.
The camera is facing an object 2.727 meters away.
The camera is facing an object 2.751 meters away.
```

A more interesting test can be performed with `rs-depth` which outputs an approximate depth image on the console using text characters.

### Add udev rules to the Docker host
You may need to add udev rules to your Docker host so that the Realsense camera can be found at the correct device names. To do this, perform these steps on the Docker host (not inside of a container). The Docker containers use the `--privileged` option to access the hosts's /dev file system directly:

```
git clone https://github.com/IntelRealSense/librealsense.git
cd librealsense
sudo scripts/setup_udev_rules.sh
```


