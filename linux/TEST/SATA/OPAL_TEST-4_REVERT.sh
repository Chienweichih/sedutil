#!/bin/bash

source ./linux/TEST/SATA/OPAL_TEST_UTILS.sh

# 1. MBRDone ON
"$PROG" --setMBRDone on "$MSID" "$DEVICE"

rm "$OUTPUT1" "$OUTPUT2"

"$PROG" --revertTPer "$MSID" "$DEVICE"
