#!/usr/bin/env bash
# ******************************************************
# DESC    : glog build script
# AUTHOR  : Alex Stocks
# VERSION : 1.0
# LICENCE : Apache License 2.0
# EMAIL   : alexstocks@foxmail.com
# MOD     : 2019-01-22 19:54
# FILE    : build.sh
# ******************************************************

mkdir -p deps
cd deps
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
##############
### install cmake3 && automake for compiling glog
##############

#if [ ! -d "./cmake-3.13.3" ]; then
#  wget https://github.com/Kitware/CMake/releases/download/v3.13.3/cmake-3.13.3.tar.gz
#  tar -zxvf cmake-3.13.3.tar.gz
#fi
#cd cmake-3.13.3 && ./bootstrap  && gmake && sudo gmake install && cd ..
#rm -f /usr/bin/cmake
#ln -s /usr/local/bin/cmake /usr/bin/cmake
#
yum install -y automake
autoreconf -ivf

##############
### compile libunwind
##############

if [ ! -d "./libunwind-1.3.1" ]; then
  wget https://github.com/libunwind/libunwind/releases/download/v1.3.1/libunwind-1.3.1.tar.gz
  tar -xf libunwind-1.3.1.tar.gz
fi

cd libunwind-1.3.1
./configure --prefix=/usr/local
make
make install
cd ..

##############
### compile gflags
##############
# 卸载系统的gflags
# sudo yum remove -y gflags-devel
# 下载编译gflags
if [ ! -d "./gflags" ]; then
  git clone https://github.com/gflags/gflags.git
fi
cd gflags
git checkout v2.0
./configure --prefix=/usr/local
make && make install

##############
### compile glog
##############

cd third/glog
./configure --prefix=/usr/local
rm -rf build && mkdir -p build && cd build
export CXXFLAGS="-fPIC" && cmake .. -DCMAKE_INSTALL_PREFIX=../../../deps/glog && make VERBOSE=1 && make install
cd ../../..

