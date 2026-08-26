#!/bin/bash
# Usage: OPAL_TEST-SET_GET_LR.sh [DEVICE]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/OPAL_TEST_INIT.sh" "$1" "/dev/sda"

# 1. Initial Opal
"$PROG" --initialsetup "$MSID" "$DEVICE"

# 2. Setup Locking Range
"$PROG" --setupLockingRange 8 0 64 "$MSID" "$DEVICE"
"$PROG" --enablelockingrange 8 "$MSID" "$DEVICE"

DURATION=10
states=("RW" "RO" "LK")

for _ in 1 2; do
    for state in "${states[@]}"; do
        "$PROG" --setlockingrange 8 "$state" "$MSID" "$DEVICE"
        for i in $(seq 1 "$DURATION"); do
            printf "\r Waiting... %d/%ds " "$i" "$DURATION"
            sleep 1
            "$PROG" --printLockingRangeStatus 8 "$MSID" "$DEVICE"
        done
    done
done

echo -e "\nDone!"
