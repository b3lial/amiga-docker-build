#!/bin/bash

if [ -z "${BUILD_RESULT}" ]; then
  echo aborting because \$BUILD_RESULT is not set
  exit
fi
if [ ! -d /build ]; then 
  echo aborting because /build directory is empty
  exit
fi

export PATH=$PATH:/opt/vbcc/bin
cp -r /build /tmp/build
cd /tmp/build
make
cp /tmp/build/$BUILD_RESULT /build/$BUILD_RESULT