#!/bin/bash
# Usage: OPAL_TEST-HEARTBEAT.sh [DEVICE]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/OPAL_UTILS.sh"
source "$SCRIPT_DIR/../common/OPAL_TEST_INIT.sh" "$1" "/dev/sda"

# Function: LockingSP_Admin1_Heartbeat
# Purpose: Invoke Heartbeat on the Locking SP, authenticated as Admin1.
# Arguments:
#   $1 - SMUID
#   $2 - Parameters list
LockingSP_Admin1_Heartbeat() {
    _OPAL_RawCmd "$SEDUTIL_SP_LOCKING_NUM" "$OPAL_AUTHORITY_ADMIN1" "$MSID" "$1" "${OPAL_TD_METHODID}000004FF" "$2"
}

# 1. Initial Opal
"$PROG" --initialsetup "$MSID" "$DEVICE"

# 2. Setup Locking Range
"$PROG" --setupLockingRange 8 0 64 "$MSID" "$DEVICE"
"$PROG" --enablelockingrange 8 "$MSID" "$DEVICE"
"$PROG" --setlockingrange 8 "RW" "$MSID" "$DEVICE"
"$PROG" --printLockingRangeStatus 8 "$MSID" "$DEVICE"

# 3. HEARTBEAT - this should pass
hexparms=$(concat_multiple \
    "$OPAL_TOKEN_SL" \
    "A8" "1EB2458B099815C4" \
    "A4" "D0070000" \
    "$OPAL_TOKEN_EL" \
)
LockingSP_Admin1_Heartbeat "${OPAL_UID_SMUID}" "$hexparms"

"$PROG" --printLockingRangeStatus 8 "$MSID" "$DEVICE"

# 4. HEARTBEAT - this should fail
hexparms=$(concat_multiple \
    "$OPAL_TOKEN_SL" \
    "A8" "1EB2458B099815C4" \
    "A4" "D0070000" \
    "$OPAL_TOKEN_EL" \
)
LockingSP_Admin1_Heartbeat "${OPAL_UID_SMUID}" "$hexparms"

"$PROG" --printLockingRangeStatus 8 "$MSID" "$DEVICE"
