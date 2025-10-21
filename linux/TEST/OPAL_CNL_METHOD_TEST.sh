#!/bin/bash

source ./linux/TEST/OPAL_UTILS.sh
source ./linux/TEST/OPAL_CNL_UTILS.sh
source ./linux/TEST/OPAL_TEST_INIT.sh

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
