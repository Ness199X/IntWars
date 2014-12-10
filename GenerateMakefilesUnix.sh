#!/bin/sh

echo Generate IntWars Makefiles
echo --------------------------
if [ -d "./build" ]; then
	echo Build directory exists, removing...
	rm -rf ./build
fi

echo Creating build directory...
mkdir build
cd build
echo Creating MinGW Makefiles...
echo ---------------------------
cmake ../