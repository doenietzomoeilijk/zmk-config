#!/bin/bash

docker run --rm \
    -v "/home/max/private/zmk-config:/zmk-config" \
    -v "/home/max/private/zmk:/zmk" \
    zmkfirmware/zmk-build-arm:3.5-branch \
    /zmk-config/scripts/do-build.sh
