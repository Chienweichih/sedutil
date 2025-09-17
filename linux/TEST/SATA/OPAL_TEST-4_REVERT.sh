#!/bin/bash

source ./linux/TEST/SATA/OPAL_TEST_INIT.sh

if [ -f "$OUTPUT1" ]; then
    rm "$OUTPUT1"
fi

if [ -f "$OUTPUT2" ]; then
    rm "$OUTPUT2"
fi

"$PROG" --revertTPer "$MSID" "$DEVICE"
