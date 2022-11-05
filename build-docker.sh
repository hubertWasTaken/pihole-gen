#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo "Please run this script as root" 1>&2
    exit 1
fi

pushd . > /dev/null
cd pi-gen || exit 2

./build-docker.sh