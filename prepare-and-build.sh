#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo "Please run this script as root" 1>&2
    exit 1
fi

./prepare.sh

if [ "${1}" == "--docker" ]; then
    ./build-docker.sh
else
    ./build.sh
fi