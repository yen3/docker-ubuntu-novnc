## Ubuntu with noVNC for multi-arch

noVNC is a HTML5 VNC client that runs well in any modern browser including mobile browsers.

## Support arch

* x86_64
* aarch64 (arm64v8)
* armhf (arm32v7)

## Usage

The recommended way to run this container looks like this:

    $ docker run -d -p 6080:6080 yen3/ubuntu-novnc

This will start a container in a detached session in the background and will expose its web interface to port 6080 of the host. Now you can browse to:

[http://localhost:6080/](http://localhost:6080/)

to access the Ubuntu desktop.

## Build the image

* Requirement
    * wget
    * docker with privileged access
* Command

    ```
    make
    ```
    

## Original repo

* [docker-ubuntu-vnc-desktop ](https://github.com/fcwu/docker-ubuntu-vnc-desktop)
* [docker-ubuntu-novnc-armhf ](https://github.com/ColinHuang/docker-ubuntu-novnc-armhf)


## Reference

* https://github.com/estesp/manifest-tool
* https://container-solutions.com/multi-arch-docker-images/
