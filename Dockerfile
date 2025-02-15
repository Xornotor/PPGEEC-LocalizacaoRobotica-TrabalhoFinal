FROM osrf/ros:noetic-desktop-full

### Install General Dependencies
RUN apt update
RUN apt install -qqy x11-apps && apt clean
RUN apt install -y curl gpg && apt clean
RUN apt install -y && apt clean

### Install Husky Dependencies
RUN apt install -y ros-noetic-hector-slam ros-noetic-husky-gazebo ros-noetic-husky-desktop ros-noetic-plotjuggler-ros && apt clean
RUN apt install -y ros-noetic-husky-navigation ros-noetic-tf2-tools && apt clean

### Set PPA for GLIM (3D SLAM)
RUN curl -s --compressed "https://koide3.github.io/ppa/ubuntu2004/KEY.gpg" | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/koide3_ppa.gpg >/dev/null
RUN echo "deb [signed-by=/etc/apt/trusted.gpg.d/koide3_ppa.gpg] https://koide3.github.io/ppa/ubuntu2004 ./" | sudo tee /etc/apt/sources.list.d/koide3_ppa.list
RUN apt update

### Install GLIM Dependencies (CPU only)
RUN apt install -y libiridescence-dev libboost-all-dev libglfw3-dev libmetis-dev && apt clean
RUN apt install -y libgtsam-points-dev ros-noetic-glim-ros && apt clean

# User Config
RUN export uid=1000 gid=1000
RUN mkdir -p /home/docker_user
RUN echo "docker_user:x:${uid}:${gid}:docker_user,,,:/home/docker_user:/bin/bash" >> /etc/passwd
RUN echo "docker_user:x:${uid}:" >> /etc/group
RUN echo "docker_user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/docker_user
RUN chmod 0440 /etc/sudoers.d/docker_user
RUN chown ${uid}:${gid} -R /home/docker_user

USER docker_user
ENV HOME /home/docker_user
CMD ["bash"]