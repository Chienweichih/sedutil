#!/bin/bash

source ./linux/TEST/OPAL_TEST_INIT.sh

# 0. Disable Block SID
PSID="${2:-00000000000000000000000000000000}"
"$PROG" --yesIreallywanttoERASEALLmydatausingthePSID "$PSID" "$DEVICE"

# 1. Initial Opal
SID_PW="1234"
ADM_PW="5678"
"$PROG" --initialsetup "$MSID" "$DEVICE"
"$PROG" --setSIDPassword "$MSID" "$SID_PW" "$DEVICE"
"$PROG" --setAdmin1Pwd "$MSID" "$ADM_PW" "$DEVICE"

BLOCK_SIZE="512"
((RANGE_START = "$BLOCK_SIZE" * 1231))
((RANGE_LENGTH = "$BLOCK_SIZE" * 97))

# 2. Setup Locking Range
"$PROG" --setupLockingRange 8 "$RANGE_START" "$RANGE_LENGTH" "$ADM_PW" "$DEVICE"
"$PROG" --setlockingrange 8 RW "$ADM_PW" "$DEVICE"
# "$PROG" --setlockingrange 8 RO "$ADM_PW" "$DEVICE"
# "$PROG" --setlockingrange 8 LK "$ADM_PW" "$DEVICE"
"$PROG" --enablelockingrange 8 "$ADM_PW" "$DEVICE"

# 3. Data Write and Read
(( BYTE_END = "$BLOCK_SIZE" * ("$RANGE_START" + "$RANGE_LENGTH" - 1) ))
hexdump -C -s "$BYTE_END" -n "$BLOCK_SIZE" "$DEVICE" > "$OUTPUT1"
dd if=/dev/urandom of="$DEVICE" bs="$BLOCK_SIZE" count="$RANGE_LENGTH" seek="$RANGE_START" conv=fsync
sync
hexdump -C -s "$BYTE_END" -n "$BLOCK_SIZE" "$DEVICE" > "$OUTPUT2"

echo " ===== BEFORE WRITE ====="
cat "$OUTPUT1" | head -n 10
echo " ===== AFTER WRITE ====="
cat "$OUTPUT2" | head -n 10

if cmp -s "$OUTPUT1" "$OUTPUT2"; then
    echo "[FAIL] $DEVICE is not writable"
else
    echo "[PASS] $DEVICE is writable"
fi

rm "$OUTPUT1" "$OUTPUT2"

"$PROG" --revertTPer "$SID_PW" "$DEVICE"
