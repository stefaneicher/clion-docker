#!/usr/bin/env bash

#fixme improve --device=/dev/bus/usb/001/015 /

#./build.sh ./Dockerfile stefaneicher/clion-docker


docker run -ti --rm \
-e DISPLAY=$DISPLAY \
--device=/dev/bus/usb/001/005 \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v `pwd`:/home/developer/workspace \
stefaneicher/clion-docker
#-v $HOME/.ideaIC-2018.1:/home/developer/.ideaIC-2018.1 \


#- then clone repo

#- run Dockerfile-ESW-Build.sh as root to install the needed tools
#- configure cmake with the build.sh arguments
#- create openocd target and debug
# you ran successfully on an container and did debugg