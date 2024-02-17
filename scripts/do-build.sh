#!/bin/bash

BOARD=lily58
NOW=$(date +"%Y%m%d-%H%M%S")
REV=$(git --git-dir=/zmk-config/.git rev-parse --short HEAD)
OUTDIR="/zmk-config/firmware/${NOW}-${REV}"
ZMKDIR=/zmk-config/zmk
mkdir ${OUTDIR}

git config --global --add safe.directory '*'
cd ${ZMKDIR}
west init -l app/
west update

for side in left right; do 
    west build -b nice_nano_v2 \
        -s "${ZMKDIR}/app" \
        -d "build/${BOARD}/${side}" -- \
        -DZMK_CONFIG=/zmk-config/config \
        -DSHIELD="${BOARD}_${side}"
    cp "${ZMKDIR}/build/${BOARD}/${side}/zephyr/zmk.uf2" "${OUTDIR}/${BOARD}-${side}-${NOW}-${REV}.uf2"
done

chown -R 1000:100 "${OUTDIR}"
