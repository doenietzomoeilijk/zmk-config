#!/bin/bash

podman run --rm \
    -v "$(git rev-parse --show-toplevel):/zmk-config" \
    zmkfirmware/zmk-build-arm:3.5-branch \
    /zmk-config/scripts/do-build.sh
