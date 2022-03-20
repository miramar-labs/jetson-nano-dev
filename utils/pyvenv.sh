#!/usr/bin/env bash

if [[ "$#" -ne 2 ]]; then
    echo "must supply python version and tag as args: 3.8.0 general";exit 1
fi

# check if we have it locally, if not, download, compile and locally install it
FILE=$HOME/opt/Python-$1/bin/python3
if [[ ! -f "$FILE1" ]]; then
	pushd $HOME/Downloads
	FILE2=$HOME/Downloads/Python-$1.tgz
	if [[ ! -f "$FILE2" ]]; then
    	wget https://www.python.org/ftp/python/$1/Python-$1.tgz 
    	rm -rf $HOME/Downloads/Python-$1/
    	tar -zxvf Python-$1.tgz
    fi
    pushd Python-$1

    # nuke existing python dir if it exists
	DIR1=$HOME/opt/Python-$1/
	if [[ -d "$DIR1" ]]; then
		rm -rf $DIR1
	fi

	# rebuild
    ./configure -prefix=$HOME/opt/Python-$1 --with-tcltk-includes="-I/usr/include/tcl8.6" --with-tcltk-libs="/usr/lib" --enable-loadable-sqlite-extensions
    make
    make install
    popd
    popd
fi

if [[ -d "~/venv/" ]]; then
	mkdir ~/venv/
fi

# nuke existing venv dir if it exists
DIR2=~/venv/py$1_$2
if [[ -d "$DIR2" ]]; then
	rm -rf $DIR2
fi

# create venv
virtualenv -p ~/opt/Python-$1/bin/python3 $DIR2

ACTIVATE_LINES=`grep "alias py$1_$2" ~/.bashrc | wc -l`
if [ "$ACTIVATE_LINES" -eq 0 ];then
    echo "alias py$1_$2='source $DIR2/bin/activate'" >> ~/.bashrc
fi

echo "TO ACTIVATE: py$1_$2"

