#!/bin/bash
# Usage: OPAL_TEST-2_WRITE.sh [DEVICE]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/OPAL_TEST_INIT.sh" "$1" "/dev/sda"

# 1. MBRDone ON
"$PROG" --setMBRDone on "$MSID" "$DEVICE"

# 2. Disable Locking Range 8
"$PROG" --disablelockingrange 8 "$MSID" "$DEVICE"
hexdump -C -n 64 "$DEVICE"

# 3. Write Magic Pattern
dd if=/dev/urandom of="$DEVICE" bs=32768 count=1 conv=fsync
sync
hexdump -C -n 64 "$DEVICE"

# 4. Check MD5
dd if="$DEVICE" of="$OUTPUT1" bs=512 count=64 conv=fsync
sync
md5sum "$OUTPUT1"

echo "Power off the device, then power it on again and run OPAL_TEST-3_READ.sh"
