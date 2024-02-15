#!/bin/bash

git config --global --add safe.directory '*'
cd /zmk
west update

BOARD=lily58
NOW=$(date +"%Y%m%d-%H%M%S")
REV=$(git --git-dir=/zmk-config/.git rev-parse --short HEAD)
OUTDIR="/zmk-config/firmware/${NOW}-${REV}"
mkdir ${OUTDIR}

for side in left right; do 
    west build -b nice_nano_v2 -s /zmk/app -d "build/${BOARD}/${side}" -- \
        -DZMK_CONFIG=/zmk-config/config \
        -DSHIELD="${BOARD}_${side}"
    cp "/zmk/build/${BOARD}/${side}/zephyr/zmk.uf2" "${OUTDIR}/${BOARD}-${side}-${NOW}-${REV}.uf2"
done

chown -R 1000:100 "${OUTDIR}"
