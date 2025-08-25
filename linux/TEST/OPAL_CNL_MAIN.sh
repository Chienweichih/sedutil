#!/bin/bash

source ./linux/TEST/OPAL_CONFIG.sh
source ./linux/TEST/OPAL_CNL_UTILS.sh

PROG=./sedutil-cli
DEVICE="${1:-/dev/nvme0n1}"
PSID="${2:-00000000000000000000000000000000}"
SID_PW="1234"
ADM_PW="5678"

SEDUTIL_ANYBODY="FFFFFFFFFFFFFFFF" # OPAL_UID::OPAL_UID_HEXFF

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

# 0. Disable Block SID
"$PROG" --yesIreallywanttoERASEALLmydatausingthePSID "$PSID" "$DEVICE"

# 1. Initial Opal
"$PROG" --initialsetup "$MSID" "$DEVICE"
"$PROG" --setSIDPassword "$MSID" "$SID_PW" "$DEVICE"
"$PROG" --setAdmin1Pwd "$MSID" "$ADM_PW" "$DEVICE"

# 2. lv0 discovery
"$PROG" --query "$DEVICE"

# 3. rawCmd
MethodIDTablePreconfiguration

# 4. rawCmd
AccessControlTablePreconfiguration

# 5. rawCmd
ACETablePreconfiguration

# 6. rawCmd
LockingTablePreconfiguration

"$PROG" --revertTPer "$SID_PW" "$DEVICE"
