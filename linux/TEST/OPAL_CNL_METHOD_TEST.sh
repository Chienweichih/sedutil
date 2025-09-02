#!/bin/bash

source ./linux/TEST/OPAL_UTILS.sh
source ./linux/TEST/OPAL_CNL_UTILS.sh

PROG=./sedutil-cli
DEVICE="${1:-/dev/nvme0n1}"

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
    OPAL_Get_MSID
fi

# 0. Disable Block SID
PSID="${2:-00000000000000000000000000000000}"
"$PROG" --yesIreallywanttoERASEALLmydatausingthePSID "$PSID" "$DEVICE"

# 1. Initial Opal
"$PROG" --initialsetup "$MSID" "$DEVICE"

# 2. Assign
hexparms=$(concat_multiple \
    "$OPAL_TOKEN_SL" \
    "$OPAL_TOKEN_SN" "00" "A8" "00000000" "00000000" "$OPAL_TOKEN_EN" \
    "$OPAL_TOKEN_EL" \
)
LockingSP_Assign "$OPAL_LOCKING_GLOBALRANGE" "$hexparms"

# 3. Deassign
hexparms=$(concat_multiple \
    "$OPAL_TOKEN_SL" \
    "$OPAL_TOKEN_SN" "00" "A8" "00000000" "00000000" "$OPAL_TOKEN_EN" \
    "$OPAL_TOKEN_EL" \
)
LockingSP_Deassign "$OPAL_LOCKING_GLOBALRANGE" "$hexparms"

# 4. Revert TPER
"$PROG" --revertTPer "$MSID" "$DEVICE"
