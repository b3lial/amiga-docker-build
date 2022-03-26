# Amiga Docker Build Container

This container compiles your amiga C and vasm source code.

## Prerequisites

1. Your source code is build with a _Makefile_
    * If it does not use `make`, you have to edit [entrypoint.sh](entrypoint.sh) and add your build steps
2. Execute `docker-build.sh` which will
    * Download vasm sources and gcc binary distribution
    * create the container image

## Usage

Run the container in your project with the following parameters:

* Mount your source code directory into the containers `/build` directory via `-v`
* Specify the output binary name via `--env BUILD_RESULT=<binary name>`

## How it works

After running the image, it will:

* copy `/build` to `/tmp/build`
* Run `make` in `/tmp/build`
* Copy `$BUILD_RESULT` back to `/build`

## Run Docker Image Example

I use the following build script in my [amiga-demo1](https://github.com/b3lial/amiga-demo1)
project which can be used as an example:

```bash
#!/bin/bash
SERVICE_NAME=amiga-gcc-build-process
IMAGE=amiga-gcc-builder
PROCESS_RUNNING=`docker ps -a --format '{{.Names}}' | grep $SERVICE_NAME`

echo "starting $IMAGE"
  
if [ -n "$PROCESS_RUNNING" ]
then
    echo terminating old build process
    docker rm $SERVICE_NAME > /dev/null
fi

docker run --name=$SERVICE_NAME \
    -v  /home/belial/amiga-demo1:/build \
    --env BUILD_RESULT=demo-1-gcc \
    $IMAGE:latest
```