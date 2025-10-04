#!/bin/bash
set -e

VERSION=`cat VERSION`          
IMAGE=amiga-gcc-builder-arm

# download compiler, assembler and linker
if [ ! -d "amiga-gcc" ]
then
  echo Downloading GCC distribution
  git clone https://franke.ms/git/bebbo/amiga-gcc.git
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
container builder stop
container builder delete
container builder start --cpus 8 --memory 24g
container build --tag $IMAGE:latest --file Dockerfile .
container images tag $IMAGE:latest $IMAGE:$VERSION