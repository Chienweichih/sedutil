#!/bin/bash

source ./linux/TEST/SATA/OPAL_TEST_UTILS.sh

# 1. MBRDone ON
"$PROG" --setMBRDone on "$MSID" "$DEVICE"

# 2. Write Magic Pattern 
hexdump -C -n 64 "$DEVICE"
dd if=/dev/urandom of="$DEVICE" bs=32768 count=1 conv=fsync
sync
hexdump -C -n 64 "$DEVICE"

# 3. Check MD5
dd if="$DEVICE" of="$OUTPUT1" bs=512 count=64 conv=fsync
sync
md5sum "$OUTPUT1"

echo "Power off the device, then power it on again and run OPAL_TEST-3_READ.sh"
