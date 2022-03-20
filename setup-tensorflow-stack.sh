#!/usr/bin/env bash

source versions.sh

TAG=Tensorflow_jp${JPVER}

PYVENV=py${PYVER}_${TAG}

source ./utils/pyvenv.sh $PYVER $TAG

source /home/$USER/venv/$PYVENV/bin/activate

source setup-jupyterlab.sh

source ./JetPack$JPVER/install-tensorflow.sh
