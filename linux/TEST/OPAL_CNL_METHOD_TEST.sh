#!/bin/bash

source ./linux/TEST/OPAL_UTILS.sh
source ./linux/TEST/OPAL_CNL_UTILS.sh
source ./linux/TEST/OPAL_TEST_INIT.sh

# 0. Disable Block SID
PSID="${2:-00000000000000000000000000000000}"
"$PROG" --yesIreallywanttoERASEALLmydatausingthePSID "$PSID" "$DEVICE"

# 1. Initial Opal
"$PROG" --initialsetup "$MSID" "$DEVICE"

# 2. Assign - Global Range
hexparms=$(concat_multiple \
    "$OPAL_TOKEN_SL" \
    "A4" "00000001" \
    "$OPAL_TOKEN_SN" "00" "00" "$OPAL_TOKEN_EN" \
    "$OPAL_TOKEN_SN" "01" "00" "$OPAL_TOKEN_EN" \
    "$OPAL_TOKEN_EL" \
)
LockingSP_Assign "${OPAL_TD_LOCKING}${OPAL_UID_TABLE}" "$hexparms"

# 3. Assign - Range 2
hexparms=$(concat_multiple \
    "$OPAL_TOKEN_SL" \
    "A4" "00000001" \
    "$OPAL_TOKEN_SN" "00" "00" "$OPAL_TOKEN_EN" \
    "$OPAL_TOKEN_SN" "01" "84" "00000040" "$OPAL_TOKEN_EN" \
    "$OPAL_TOKEN_EL" \
)
LockingSP_Assign "${OPAL_TD_LOCKING}${OPAL_UID_TABLE}" "$hexparms"

# 4. Get Locking Table
hexparms=$(concat_multiple \
    "$OPAL_TOKEN_SL" "$OPAL_TOKEN_SL" \
    "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_SC" "00" "$OPAL_TOKEN_EN" \
    "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_EC" "15" "$OPAL_TOKEN_EN" \
    "$OPAL_TOKEN_EL" "$OPAL_TOKEN_EL" \
)
LockingSP_Admin1_Get "${OPAL_LOCKING_RANGE2}" "$hexparms"

# 5. Deassign
hexparms=$(concat_multiple \
    "$OPAL_TOKEN_SL" \
    "A8" "${OPAL_LOCKING_RANGE2}" \
    "$OPAL_TOKEN_EL" \
)
LockingSP_Deassign "${OPAL_TD_LOCKING}${OPAL_UID_TABLE}" "$hexparms"

# 6. Revert TPER
"$PROG" --revertTPer "$MSID" "$DEVICE"
