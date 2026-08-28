#!/bin/bash
# Usage: OPAL_TEST-HEARTBEAT.sh [DEVICE]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/OPAL_UTILS.sh"
source "$SCRIPT_DIR/../common/OPAL_TEST_INIT.sh" "$1" "/dev/sda"

# 1. Initial Opal
"$PROG" --initialsetup "$MSID" "$DEVICE"

# 2. Setup Locking Range
"$PROG" --setupLockingRange 8 0 64 "$MSID" "$DEVICE"
"$PROG" --enablelockingrange 8 "$MSID" "$DEVICE"
"$PROG" --setlockingrange 8 "RW" "$MSID" "$DEVICE"
"$PROG" --printLockingRangeStatus 8 "$MSID" "$DEVICE"

# 3. HEARTBEAT
hexparms=$(concat_multiple \
    "$OPAL_TOKEN_SL" \
    "A8" "0102030405060708" \
    "A4" "00000001" \
    "$OPAL_TOKEN_EL" \
)
_OPAL_RawCmd "$SEDUTIL_SP_LOCKING_NUM" "$OPAL_AUTHORITY_ADMIN1" "$MSID" "${OPAL_UID_THISSP}" "${OPAL_TD_METHODID}000004FF" "$hexparms"
