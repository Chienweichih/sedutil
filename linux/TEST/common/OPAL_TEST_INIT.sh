#!/bin/bash
# OPAL_TEST_INIT.sh
# Common preflight checks for every test script: locate sedutil-cli, make
# sure DEVICE isn't the boot disk, and fetch the MSID.
#
# Meant to be sourced, not executed directly:
#   source OPAL_TEST_INIT.sh "$1" "<default-device-for-this-caller>"
#
#   $1 - device path passed in by the user running the top-level script
#        (falls back to $2 when empty)
#   $2 - default device the *caller script* wants if $1 was not given
#        (e.g. /dev/nvme0n1 for NVMe scripts, /dev/sda for SATA scripts)

_OPAL_INIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

_OPAL_FindProg() {
    local candidate
    for candidate in \
        "${SEDUTIL_CLI:-}" \
        "$_OPAL_INIT_DIR/../../../sedutil-cli" \
        "./sedutil-cli" \
        "$(command -v sedutil-cli 2> /dev/null)"
    do
        [[ -n "$candidate" && -x "$candidate" ]] && { echo "$candidate"; return 0; }
    done
return 1
}

PROG="$(_OPAL_FindProg)"
DEVICE="${1:-${2:-/dev/sda}}"
OUTPUT1="./opal_test_1"
OUTPUT2="./opal_test_2"

# Check sedutil-cli exists
if [[ -z "$PROG" ]]; then
    echo "[ERROR] sedutil-cli not found."
    echo "        Set \$SEDUTIL_CLI, add it to \$PATH, or place it next to the TEST/ directory."
    exit 1
fi
echo "Using sedutil-cli: $PROG"

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
