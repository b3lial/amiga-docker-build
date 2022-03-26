#!/bin/bash
export PATH=$PATH:/opt/vbcc/bin
cp -r /build /tmp/build
cd /tmp/build
make
cp /tmp/build/$BUILD_RESULT /build/$BUILD_RESULT