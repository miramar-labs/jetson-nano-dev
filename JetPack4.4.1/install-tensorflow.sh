#!/usr/bin/env bash
# https://forums.developer.nvidia.com/t/official-tensorflow-for-jetson-nano/71770

# prerequisites
sudo apt-get install -y libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev liblapack-dev libblas-dev gfortran
pip3 install -U pip testresources setuptools numpy==1.16.1 future==0.17.1 mock==3.0.5 h5py==2.9.0 keras_preprocessing==1.0.5 keras_applications==1.0.8 gast==0.2.2 protobuf pybind11
pip3 install Cython

# Tensorflow
TF_VERSION=2.3.1
NV_VERSION=20.12
JP_VERSION=44

pip3 install --pre --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v$JP_VERSION tensorflow==$TF_VERSION+nv$NV_VERSION

