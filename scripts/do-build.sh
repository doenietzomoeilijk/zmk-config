#!/bin/bash

NOW=$(date +"%Y%m%d-%H%M%S")
REV=$(git --git-dir=/zmk-config/.git rev-parse --short HEAD)
OUTDIR="/zmk-config/firmware/${NOW}-${REV}"
LOG="${OUTDIR}/build.log"
ZMKDIR=/zmk-config/zmk
mkdir ${OUTDIR}

git config --global --add safe.directory '*'
cd ${ZMKDIR}

echo "Writing to logfile ${LOG}..."
echo "**********************************************************************" >> $LOG
echo "West init/update" >> $LOG
[ -d "$ZMKDIR/.west" ] || west init -l app/ >> $LOG
west update >> $LOG

echo "" >> $LOG
echo "**********************************************************************" >> $LOG
echo "" >> $LOG
echo "*** Builds... ***" >> $LOG

for board in lily58 cradio; do
    for side in left right; do 
        echo "${board} / ${side}..."
        echo "" >> $LOG
        echo "*** ${board} / ${side} side ***" >> $LOG
        echo "**********************************************************************" >> $LOG

        if [[ $side == "left" ]]; then 
            pristine="--pristine";
            studio_snippet="-S studio-rpc-usb-uart"; #  -S zmk-usb-logging
            studio_config="-DCONFIG_ZMK_STUDIO=y";
            studio_config="";
        else
            pristine="";
            studio_snippet="";
            studio_config="";
        fi

        echo "Command line:"
        echo west build ${pristine} -b nice_nano_v2 -s "${ZMKDIR}/app" -d "build/${board}/${side}" ${studio_snippet} -- -DZMK_CONFIG=/zmk-config/config -DSHIELD="${board}_${side}" ${studio_config}
        echo ""

        west build ${pristine} -b nice_nano_v2 \
            -s "${ZMKDIR}/app" \
            -d "build/${board}/${side}" \
            ${studio_snippet} \
            -- \
            -DZMK_CONFIG=/zmk-config/config \
            -DSHIELD="${board}_${side}" \
            ${studio_config} \
            >> $LOG 2>&1

        outfile="${ZMKDIR}/build/${board}/${side}/zephyr/zmk.uf2" 
        [[ -f "${outfile}" ]] && cp "${outfile}" "${OUTDIR}/${board}-${side}-${NOW}-${REV}.uf2"
        echo "" >> $LOG
    done
done

chown -R 1000:100 "${OUTDIR}"
