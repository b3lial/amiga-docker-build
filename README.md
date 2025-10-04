# Amiga Docker Build Container

This container compiles your amiga C and vasm source code. I am using it on systems like MacOS where its more difficult
to set up a native Amiga compiler chain. It mounts the source code directory, invokes `make` and returns the 
compiled binary.

# Tweaks

The GCC source code distribution by `bebbo` allows you to use different GCC versions. The default version is 6.5.
But there is also support for:

* 13.1
* 13.3
* 15.2

I tried them on MacOS but ran into compiler issues (maybe due to its more exotic nature). However, if you want to
give them a try add something like `make branch branch=amiga13.1 mod=gcc` to the docker file before invoking
`make all`.

## Prerequisites

1. Your source code is build with a _Makefile_
    * If it does not use `make`, you have to edit [entrypoint.sh](entrypoint.sh) and add your build steps
2. Execute `docker-build.sh` (or `container-build.sh` if you are using the native MacOS CLI) which will
    * Download vasm sources and gcc distribution
    * Compile gcc and its libraries
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

## Legacy Version

This is version 2.0 which is based on Ubuntu 22.04 and a source code distribution of GCC.
It replaces version 1.2 which uses an older 32 bit binary distribution of GCC. Nevertheless
due to its binary nature, the version 1.2 container builds faster and is still available
via the corresponding git tag. 

## References

- https://github.com/apple/container/blob/main/docs/tutorial.md
- https://franke.ms/git/bebbo/amiga-gcc
- https://www.amiga-news.de/de/forum/thread.php?id=36574
