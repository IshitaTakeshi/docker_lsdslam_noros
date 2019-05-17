FROM ubuntu:18.04

ARG OPENCV_VERSION=2.4.13.6
ARG WORKSPACE=$HOME/workspace
ARG NTHREADS=4


RUN mkdir -p $WORKSPACE

RUN apt-get update
RUN apt-get -y install wget cmake


# install Opencv

WORKDIR $WORKSPACE

RUN apt-get -y install clang

RUN wget https://github.com/opencv/opencv/archive/$OPENCV_VERSION.tar.gz \
    && tar xvf $OPENCV_VERSION.tar.gz \
    && cd opencv-$OPENCV_VERSION/ \
    && mkdir -p release \
    && cd release \
    && cmake .. \
    && make -j$NTHREADS \
    && make install


# install Eigen

WORKDIR $WORKSPACE

RUN wget -c https://bitbucket.org/eigen/eigen/get/3.1.4.tar.gz \
    && tar xvf 3.1.4.tar.gz \
    && cd eigen-eigen-36bf2ceaf8f5 \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make install


# install g2o

WORKDIR $WORKSPACE

RUN apt-get -y install git libsuitesparse-dev
RUN git clone https://github.com/RainerKuemmerle/g2o.git \
    && cd g2o \
    && git checkout 67d5fa7 \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release .. \
    && make -j$NTHREADS \
    && make install


# install LSD-SLAM

WORKDIR $WORKSPACE

RUN apt-get -y install libboost-all-dev freeglut3-dev libglew-dev

RUN git clone https://github.com/IshitaTakeshi/lsd_slam_noros.git \
    && cd lsd_slam_noros/ \
    && mkdir build \
    && cd build/ \
    && cmake .. \
    && make -j$NTHREADS
