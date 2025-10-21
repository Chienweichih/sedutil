#!/bin/bash

PROG=./sedutil-cli
DEVICE="${1:-/dev/nvme0n1}"
OUTPUT1="./opal_test_1"
OUTPUT2="./opal_test_2"

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
