#!/usr/bin/env bash

git config --global url."git@github.com:".insteadOf "https://github.com/"
git config --global user.email "aaron@aaroncody.com"
git config --global user.name "Aaron Cody"
git config --global push.default simple
pushd ~
git clone https://github.com/miramar-labs/interview-practice.git
git clone https://github.com/fastai/fastai.git
git clone https://github.com/fastai/fastbook.git
popd