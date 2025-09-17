#!/bin/bash

source ./linux/TEST/SATA/OPAL_TEST_INIT.sh

# 1. MBRDone ON
"$PROG" --setMBRDone on "$MSID" "$DEVICE"

# 2. Disable Locking Range 8
"$PROG" --disablelockingrange 8 "$MSID" "$DEVICE"
hexdump -C -n 64 "$DEVICE"

# 3. Check MD5
dd if="$DEVICE" of="$OUTPUT2" bs=512 count=64 conv=fsync
sync
md5sum "$OUTPUT2"

if cmp -s "$OUTPUT1" "$OUTPUT2"; then
    echo "[PASS] $DEVICE keeps data after power cycle"
else
    echo "[FAIL] $DEVICE loses data after power cycle"
fi

echo "To finish the test, run OPAL_TEST-4_REVERT.sh"
