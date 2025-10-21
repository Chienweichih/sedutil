#!/bin/bash

source ./linux/TEST/OPAL_CONFIG.sh
source ./linux/TEST/OPAL_UTILS.sh
source ./linux/TEST/OPAL_TEST_INIT.sh

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
