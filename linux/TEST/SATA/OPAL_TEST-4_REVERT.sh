#!/bin/bash
# Usage: OPAL_TEST-4_REVERT.sh [DEVICE]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/OPAL_TEST_INIT.sh" "$1" "/dev/sda"

if [ -f "$OUTPUT1" ]; then
    rm "$OUTPUT1"
fi

if [ -f "$OUTPUT2" ]; then
    rm "$OUTPUT2"
fi

"$PROG" --revertTPer "$MSID" "$DEVICE"
