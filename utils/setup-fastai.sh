#!/usr/bin/env bash

# https://github.com/fastai

source versions.sh

TAG=PyTorch_jp${JPVER}

PYVENV=py${PYVER}_${TAG}

source /home/$USER/venv/$PYVENV/bin/activate

git clone https://github.com/fastai/fastai.git

git clone https://github.com/fastai/fastbook.git

pushd fastai
#pip install -e "fastai[dev]"
popd
