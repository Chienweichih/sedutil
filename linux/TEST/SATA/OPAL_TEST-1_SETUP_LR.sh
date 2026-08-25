#!/bin/bash
# Usage: OPAL_TEST-1_SETUP_LR.sh [DEVICE]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/OPAL_TEST_INIT.sh" "$1" "/dev/sda"

# 1. Initial Opal
"$PROG" --initialsetup "$MSID" "$DEVICE"

# 2. Setup Locking Range
"$PROG" --setupLockingRange 8 0 64 "$MSID" "$DEVICE"
"$PROG" --setlockingrange 8 RW "$MSID" "$DEVICE"
"$PROG" --enablelockingrange 8 "$MSID" "$DEVICE"

echo "Continue test OPAL_TEST-2_WRITE.sh"
