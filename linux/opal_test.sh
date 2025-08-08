#!/bin/bash

PROG=./sedutil-cli
DEVICE="${1:-/dev/nvme0n1}"
PSID="${2:-00000000000000000000000000000000}"
SID_PW="1234"
ADM_PW="5678"
OUTPUT1="/tmp/opal_test_1"
OUTPUT2="/tmp/opal_test_2"

# Check sedutil-cli exists
if ! command -v "$PROG" &> /dev/null; then
    echo "[ERROR] $PROG not found."
    exit 1
fi

# Check if DEVICE is system disk
root_device=$(df / | tail -1 | awk '{print $1}')
base_device=$(basename "$root_device" | sed 's/p[0-9]*$//')
if [[ "/dev/$base_device" == "$DEVICE" ]]; then
    echo "[ERROR] $DEVICE is the current system disk."
	exit 1
fi

# Get MSID
MSID=$("$PROG" --printDefaultPassword "$DEVICE" | grep -oP 'MSID:\s*\K.*')
if [[ -z "$MSID" ]]; then
    echo "[ERROR] Failed to retrieve MSID from $DEVICE"
    exit 1
else
    echo "MSID: $MSID"
fi

# 0. Disable Block SID
# "$PROG" --yesIreallywanttoERASEALLmydatausingthePSID "$PSID" "$DEVICE"

# 1. Initial Opal
"$PROG" --initialsetup "$MSID" "$DEVICE"
"$PROG" --setSIDPassword "$MSID" "$SID_PW" "$DEVICE"
"$PROG" --setAdmin1Pwd "$MSID" "$ADM_PW" "$DEVICE"

# 2. Setup Locking Range
"$PROG" --setupLockingRange 8 0 64 "$ADM_PW" "$DEVICE"
"$PROG" --setlockingrange 8 RW "$ADM_PW" "$DEVICE"
# "$PROG" --setlockingrange 8 RO "$ADM_PW" "$DEVICE"
# "$PROG" --setlockingrange 8 LK "$ADM_PW" "$DEVICE"
"$PROG" --enablelockingrange 8 "$ADM_PW" "$DEVICE"

# 3. Data Write and Read
hexdump -C -n 512 "$DEVICE" > "$OUTPUT1"
dd if=/dev/urandom of="$DEVICE" bs=1024k count=100
hexdump -C -n 512 "$DEVICE" > "$OUTPUT2"

if cmp -s "$OUTPUT1" "$OUTPUT2"; then
    echo "[FAIL] $DEVICE is not writable"
else
    echo "[PASS] $DEVICE is writable"
fi

rm "$OUTPUT1" "$OUTPUT2"

"$PROG" --revertTPer "$SID_PW" "$DEVICE"
