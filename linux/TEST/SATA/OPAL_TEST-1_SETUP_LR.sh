#!/bin/bash

source ./linux/TEST/SATA/OPAL_TEST_INIT.sh

# 1. Initial Opal
"$PROG" --initialsetup "$MSID" "$DEVICE"

# 2. Setup Locking Range
"$PROG" --setupLockingRange 8 0 64 "$MSID" "$DEVICE"
"$PROG" --setlockingrange 8 RW "$MSID" "$DEVICE"
"$PROG" --enablelockingrange 8 "$MSID" "$DEVICE"

echo "Continue test OPAL_TEST-2_WRITE.sh"
