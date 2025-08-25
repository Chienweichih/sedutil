#!/bin/bash

source ./linux/TEST/OPAL_CONFIG.sh

PROG=./sedutil-cli
DEVICE="${1:-/dev/nvme0n1}"
PSID="${2:-00000000000000000000000000000000}"
SID_PW="1234"
ADM_PW="5678"

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

# 2. rawCmd
echo "SubCase 2: Get the MaxRanges on the LockingInfo table"

segments=(
    "$OPAL_TOKEN_SL" "$OPAL_TOKEN_SL"
    "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_SC" "04" "$OPAL_TOKEN_EN"
    "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_EC" "04" "$OPAL_TOKEN_EN"
    "$OPAL_TOKEN_EL" "$OPAL_TOKEN_EL"
)

sp="3" # OPAL_UID::OPAL_LOCKINGSP_UID
hexauth="$OPAL_ADMIN1_UID"
pass="$ADM_PW"
hexinvokingUID="$OPAL_LOCKINGINFO_UID"
hexmethod="$OPAL_METHOD_GET"
hexparms=""
for seg in "${segments[@]}"; do
    hexparms+="$seg"
done
"$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"

# 3. rawCmd
echo "SubCase 3: Next Request on the Locking table with an empty parameter list"

segments=(
    "$OPAL_TOKEN_SL" "$OPAL_TOKEN_EL"
)

sp="3" # OPAL_UID::OPAL_LOCKINGSP_UID
hexauth="$OPAL_ADMIN1_UID"
pass="$ADM_PW"
hexinvokingUID="${OPAL_TD_LOCKING}${OPAL_UID_TABLE}"
hexmethod="$OPAL_METHOD_NEXT"
hexparms=""
for seg in "${segments[@]}"; do
    hexparms+="$seg"
done
"$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"

# 4. rawCmd
echo "SubCase 4: Next Request with the first UID from the list and Count = 1"

segments=(
    "$OPAL_TOKEN_SL"
    "$OPAL_TOKEN_SN" "00" "A8${OPAL_TD_LOCKING}00000001" "$OPAL_TOKEN_EN" # Where
    "$OPAL_TOKEN_SN" "01" "01" "$OPAL_TOKEN_EN" # Count
    "$OPAL_TOKEN_EL"
)

sp="3" # OPAL_UID::OPAL_LOCKINGSP_UID
hexauth="$OPAL_ADMIN1_UID"
pass="$ADM_PW"
hexinvokingUID="${OPAL_TD_LOCKING}${OPAL_UID_TABLE}"
hexmethod="$OPAL_METHOD_NEXT"
hexparms=""
for seg in "${segments[@]}"; do
    hexparms+="$seg"
done
"$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"

"$PROG" --revertTPer "$SID_PW" "$DEVICE"
