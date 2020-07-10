#!/usr/bin/env bash
PORT_PATH=~/pika-tools
#1. install the third libs
git submodule update --init --recursive

#2. install compression lib
yum install -y snappy snappy-devel
yum install -y zlib zlib-devel
yum install -y bzip2 bzip2-devel
yum install -y lz4-devel

#3. install gflags
if [ ! -d "$(PORT_PATH)/third/gflags" ]; then
  git clone https://github.com/gflags/gflags.git
  cd gflags && git chekout v2.0 
fi
./configure --prefix=/usr/local
make && make install
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

#4. install glog
cd $(PORT_PATH)/third/glog
./configure --prefix=/usr/local
make && make install

#5. compile pika 2.3.7
cd $PORT_PATH/pika-port/pika_port_2/
make
