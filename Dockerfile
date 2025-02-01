FROM osrf/ros:noetic-desktop-full

### Nvidia Container Runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

### Install General Dependencies
RUN apt update
RUN apt install -qqy x11-apps && apt clean
RUN apt install -y curl gpg wget && apt clean
RUN apt install -y  && apt clean

### Install Cuda Toolkit 12.5    
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb && dpkg -i cuda-keyring_1.1-1_all.deb && rm -rf cuda-keyring_1.1-1_all.deb
RUN apt update
RUN apt install -y cuda-toolkit-12-5 && apt clean

### Install Husky Dependencies
RUN apt install -y ros-noetic-hector-slam ros-noetic-husky-gazebo ros-noetic-husky-desktop ros-noetic-plotjuggler-ros && apt clean
RUN apt install -y ros-noetic-husky-navigation ros-noetic-tf2-tools && apt clean

### Set PPA for GLIM (3D SLAM)
RUN curl -s --compressed "https://koide3.github.io/ppa/ubuntu2004/KEY.gpg" | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/koide3_ppa.gpg >/dev/null
RUN echo "deb [signed-by=/etc/apt/trusted.gpg.d/koide3_ppa.gpg] https://koide3.github.io/ppa/ubuntu2004 ./" | sudo tee /etc/apt/sources.list.d/koide3_ppa.list
RUN apt update

### Install GLIM Dependencies (Uncomment the correspondent line for CPU, CUDA 12.2 or CUDA 12.5)
RUN apt install -y libiridescence-dev libboost-all-dev libglfw3-dev libmetis-dev && apt clean
## GLIM Without CUDA
# RUN apt install -y libgtsam-points-dev ros-noetic-glim-ros && apt clean
## GLIM With CUDA 12.2
# RUN apt install -y libgtsam-points-cuda12.2-dev ros-noetic-glim-ros-cuda12.2 && apt clean
## GLIM With CUDA 12.5
RUN apt install -y libgtsam-points-cuda12.5-dev ros-noetic-glim-ros-cuda12.5 && apt clean

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