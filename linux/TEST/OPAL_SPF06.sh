#!/bin/bash

source ./linux/TEST/OPAL_CONFIG.sh
source ./linux/TEST/OPAL_UTILS.sh

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

# 2. Invoke the Get method on the LockingInfo table’s MaxRanges Column
echo "SubCase 2: Get the MaxRanges on the LockingInfo table"

hexparms=$(concat_multiple \
    "$OPAL_TOKEN_SL" "$OPAL_TOKEN_SL" \
    "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_SC" "04" "$OPAL_TOKEN_EN" \
    "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_EC" "04" "$OPAL_TOKEN_EN" \
    "$OPAL_TOKEN_EL" "$OPAL_TOKEN_EL" \
)
LockingSP_Anybody_Get "$OPAL_LOCKINGINFO_UID" "$hexparms"

# 3. Invoke the Next method on the Locking table with an empty parameter list
echo "SubCase 3: Next Request on the Locking table with an empty parameter list"

hexparms=$(concat_multiple \
    "$OPAL_TOKEN_SL" "$OPAL_TOKEN_EL" \
)
LockingSP_Anybody_Next "${OPAL_TD_LOCKING}${OPAL_UID_TABLE}" "$hexparms"

# 4. Invoke the Next method on the Locking table with the Where parameter set to the first UID from the list of
#    UIDs returned in step #3, and the Count parameter set to 1
echo "SubCase 4: Next Request with the first UID from the list and Count = 1"

hexparms=$(concat_multiple \
    "$OPAL_TOKEN_SL" \
    "$OPAL_TOKEN_SN" "00" "A8${OPAL_TD_LOCKING}00000001" "$OPAL_TOKEN_EN" \
    "$OPAL_TOKEN_SN" "01" "01" "$OPAL_TOKEN_EN" \
    "$OPAL_TOKEN_EL" \
)
LockingSP_Anybody_Next "${OPAL_TD_LOCKING}${OPAL_UID_TABLE}" "$hexparms"

# 5. Revert TPER
"$PROG" --revertTPer "$MSID" "$DEVICE"
