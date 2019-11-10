# This is an auto generated Dockerfile for ros:ros-core
# generated from docker_images/create_ros_core_image.Dockerfile.em
FROM ubuntu:xenial

SHELL ["/bin/bash","-c"]

# install packages
RUN apt-get update && apt-get install -q -y \
    dirmngr \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros1-latest.list

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    && rm -rf /var/lib/apt/lists/*

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

# install ros packages
ENV ROS_DISTRO kinetic
RUN apt-get update && apt-get install -y \
    ros-kinetic-ros-core=1.3.2-0* \
    && rm -rf /var/lib/apt/lists/*
	
	


RUN apt-get update -yq \
&& apt-get install curl gnupg -yq \
&& apt-get install ros-kinetic-catkin ros-kinetic-rospack python-wstool openjdk-8-jdk -yq \
&& apt-get install ros-kinetic-rosjava -yq \
&& apt-get clean -y

RUN mkdir -p /opt/rosjava/src \
&& wstool init -j4 /opt/rosjava/src https://raw.githubusercontent.com/Furansujin/rosjava/kinetic/rosjava.rosinstall \
&& source /opt/ros/kinetic/setup.bash \
&& cd /opt/rosjava \
&& rosdep update \
&& rosdep install --from-paths src -i -y \
&& catkin_make
 

# setup entrypoint
COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]