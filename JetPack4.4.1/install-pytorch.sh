#!/usr/bin/env bash
# https://forums.developer.nvidia.com/t/pytorch-for-jetson-version-1-10-now-available/72048

# PyTorch fixes 
sudo apt install -y libopenblas-base libopenmpi-dev libzmq3-dev
LDPRELOAD_LINES=`sudo grep 'LD_PRELOAD' ~/.bashrc | wc -l`
if [ "$LDPRELOAD_LINES" -eq 0 ];then
    echo "export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgomp.so.1" >> ~/.bashrc
fi
OPENBLASCORETYPE_LINES=`sudo grep 'OPENBLAS_CORETYPE' ~/.bashrc | wc -l`
if [ "$OPENBLASCORETYPE_LINES" -eq 0 ];then
    echo "export OPENBLAS_CORETYPE=ARMV8" >> ~/.bashrc
fi

# grab the wheel
wget https://nvidia.box.com/shared/static/fjtbno0vpo676a25cgvuqc1wty0fkkg6.whl -O torch-1.10.0-cp36-cp36m-linux_aarch64.whl

# prerequisites
sudo apt-get install -y libopenblas-base libopenmpi-dev libzmq3-dev libbz2-dev liblzma-dev
pip3 install Cython

# Pytorch
pip3 install numpy torch-1.10.0-cp36-cp36m-linux_aarch64.whl

# Torchvision
sudo apt-get install -y libjpeg-dev zlib1g-dev libpython3-dev libavcodec-dev libavformat-dev libswscale-dev
git clone --branch v0.11.1 https://github.com/pytorch/vision torchvision   # see below for version of torchvision to download
cd torchvision
export BUILD_VERSION=0.11.1  # where 0.x.0 is the torchvision version  
python3 setup.py install --user
cd ../  # attempting to load torchvision from build dir will result in import error
pip install 'pillow<7' # always

# Cleanup
rm -f torch-1.10.0-cp36-cp36m-linux_aarch64.whl

