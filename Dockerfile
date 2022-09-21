FROM nvidia/opengl:1.2-glvnd-runtime-ubuntu20.04
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
ENV PYTHONIOENCODING=utf8
RUN apt update && apt install locales apt-utils -y
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8
RUN apt install software-properties-common -y
RUN add-apt-repository universe
RUN apt install curl gnupg2 lsb-release -y
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN mv /bin/sh /bin/sh_tmp && ln -s /bin/bash /bin/sh
RUN sh -c "echo 'deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main' | tee /etc/apt/sources.list.d/ros2.list"
RUN apt update && apt upgrade -y
RUN apt install ros-foxy-desktop python3-colcon-common-extensions -y
RUN apt install git python3-rosdep vim -y
RUN sh -c "echo 'source /opt/ros/foxy/setup.bash' >> /root/.bashrc"
RUN sh -c "echo 'export ROS_DOMAIN_ID=0' >> /root/.bashrc"
RUN sh -c "echo 'source /usr/share/colcon_cd/function/colcon_cd.sh' >> /root/.bashrc"
RUN sh -c "echo 'export _colcon_cd_root=/opt/ros/foxy/' >> /root/.bashrc"
RUN sh -c "echo 'source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash' >> /root/.bashrc"
WORKDIR /mnt
