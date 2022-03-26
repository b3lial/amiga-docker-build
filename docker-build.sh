#!/bin/sh
VERSION=`cat VERSION`          
IMAGE=amiga-gcc-builder

# download compiler, assembler and linker
if [ ! -f "m68k-amigaos_linux_i386.tar.gz" ]
then
  echo Downloading GCC binary distribution
  curl https://amiga-docker-build.s3.eu-central-1.amazonaws.com/m68k-amigaos_linux_i386.tar.gz -o m68k-amigaos_linux_i386.tar.gz
fi
if [ ! -f "vasm.tar.gz" ]
then
  echo Downloading vasm sources
  curl https://amiga-docker-build.s3.eu-central-1.amazonaws.com/vasm.tar.gz -o vasm.tar.gz
fi
if [ ! -f "vlink.tar.gz" ]
then
  Downloading vlink sources
  curl https://amiga-docker-build.s3.eu-central-1.amazonaws.com/vlink.tar.gz -o vlink.tar.gz
fi

echo "creating $IMAGE, version: $VERSION"
docker build -t $IMAGE:latest .
docker tag $IMAGE:latest $IMAGE:$VERSION
