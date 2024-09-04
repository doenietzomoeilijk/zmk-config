#!/bin/sh

. venv/bin/activate

keymap parse -c 10 -z config/cradio.keymap > keymap.yaml
keymap draw keymap.yaml > keymap.svg
convert keymap.svg keymap.png

deactivate
