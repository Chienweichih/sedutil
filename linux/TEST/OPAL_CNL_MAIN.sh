#!/bin/bash

source ./linux/TEST/OPAL_UTILS.sh
source ./linux/TEST/OPAL_CNL_UTILS.sh
source ./linux/TEST/OPAL_TEST_INIT.sh

# 0. Disable Block SID
PSID="${2:-00000000000000000000000000000000}"
"$PROG" --yesIreallywanttoERASEALLmydatausingthePSID "$PSID" "$DEVICE"

# 1. Initial Opal
"$PROG" --initialsetup "$MSID" "$DEVICE"

# 2. Level 0 discovery
"$PROG" --query "$DEVICE"

# 3. MethodID Table Preconfiguration
MethodIDTablePreconfiguration

# 4. Access Control Table Preconfiguration
AccessControlTablePreconfiguration

# 5. ACE Table Preconfiguration
ACETablePreconfiguration

# 6. Locking Table Preconfiguration
LockingTablePreconfiguration

# 7. Revert TPER
"$PROG" --revertTPer "$MSID" "$DEVICE"
