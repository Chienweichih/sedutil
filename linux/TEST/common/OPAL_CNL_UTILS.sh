#!/bin/bash
# OPAL_CNL_UTILS.sh
# Higher level CNL (Configurable Namespace Locking) preconfiguration
# procedures, built on top of OPAL_UTILS.sh.

[[ -n "${OPAL_CNL_UTILS_SH_INCLUDED:-}" ]] && return
OPAL_CNL_UTILS_SH_INCLUDED=1

_OPAL_CNL_UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$_OPAL_CNL_UTILS_DIR/OPAL_UTILS.sh"

# Function: MethodIDTablePreconfiguration
# Purpose: Dump the Locking SP MethodID table (4.4.1.1.2 / Table 11), then
#          read back the Assign/Deassign method rows.
MethodIDTablePreconfiguration() {
    echo "4.4.1.1.2 Preconfiguration"
    echo "Table 11 Locking SP - MethodID Table Preconfiguration"

    local hexparms item
    local -a list

    hexparms=$(concat_multiple "$OPAL_TOKEN_SL" "$OPAL_TOKEN_EL")
    LockingSP_Anybody_Next "${OPAL_TD_METHODID}${OPAL_UID_TABLE}" "$hexparms"

    # dump each row
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" "$OPAL_TOKEN_SL" \
        "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_SC" "00" "$OPAL_TOKEN_EN" \
        "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_EC" "01" "$OPAL_TOKEN_EN" \
        "$OPAL_TOKEN_EL" "$OPAL_TOKEN_EL" \
    )
    list=("$OPAL_METHOD_ASSIGN" "$OPAL_METHOD_DEASSIGN")
    for item in "${list[@]}"; do
        echo "dump $item row data:"
        LockingSP_Anybody_Get "$item" "$hexparms"
    done
}

# Function: _OPAL_GetACL_Checks
# Purpose: Run a list of "GetACL" checks. Each entry describes which UID and
#          which Method to check, plus a human readable label to print.
#          Extending the ACL coverage only means adding a row here instead of
#          duplicating the whole hexparms/echo block.
# Arguments:
#   $@ - entries of the form "<uid>:<method>:<label>"
_OPAL_GetACL_Checks() {
    local entry uid method label hexparms
    for entry in "$@"; do
        IFS=':' read -r uid method label <<< "$entry"
        echo "GetACL $label"
        hexparms=$(concat_multiple "$OPAL_TOKEN_SL" "A8" "$uid" "A8" "$method" "$OPAL_TOKEN_EL")
        LockingSP_GetACL "$hexparms"
    done
}

# Function: AccessControlTablePreconfiguration
# Purpose: 3.2.2.2 Access Control (M) + Table 12 Locking SP - AccessControl
#          Table Preconfiguration. Dumps GetACL results for the fixed set of
#          (UID, Method) pairs defined by the OPAL Core / CNL specs.
AccessControlTablePreconfiguration() {
    echo "3.2.2.2 Access Control (M)"

    _OPAL_GetACL_Checks \
        "$OPAL_ACE_LOCKING_NAMESPACE_IDTOGLBRNG:$OPAL_METHOD_SET:OPAL_ACE_LOCKING_NAMESPACE_IDTOGLBRNG SET" \
        "$OPAL_ACE_LOCKING_NAMESPACE_IDTOGLBRNG:$OPAL_METHOD_GET:OPAL_ACE_LOCKING_NAMESPACE_IDTOGLBRNG GET" \
        "$OPAL_LOCKING_RANGE1:$OPAL_METHOD_GET:OPAL_LOCKING_RANGE1 GET" \
        "$OPAL_LOCKING_RANGE2:$OPAL_METHOD_GET:OPAL_LOCKING_RANGE2 GET" \
        "$OPAL_LOCKING_RANGE3:$OPAL_METHOD_GET:OPAL_LOCKING_RANGE3 GET" \
        "$OPAL_LOCKING_RANGE4:$OPAL_METHOD_GET:OPAL_LOCKING_RANGE4 GET" \
        "$OPAL_LOCKING_RANGE5:$OPAL_METHOD_GET:OPAL_LOCKING_RANGE5 GET" \
        "$OPAL_LOCKING_RANGE6:$OPAL_METHOD_GET:OPAL_LOCKING_RANGE6 GET" \
        "$OPAL_LOCKING_RANGE7:$OPAL_METHOD_GET:OPAL_LOCKING_RANGE7 GET" \
        "$OPAL_LOCKING_RANGE8:$OPAL_METHOD_GET:OPAL_LOCKING_RANGE8 GET"

    echo "Table 12 Locking SP - AccessControl Table Preconfiguration"

    _OPAL_GetACL_Checks \
        "${OPAL_TD_LOCKING}${OPAL_UID_TABLE}:$OPAL_METHOD_ASSIGN:OPAL_TD_LOCKING ASSIGN" \
        "${OPAL_TD_LOCKING}${OPAL_UID_TABLE}:$OPAL_METHOD_DEASSIGN:OPAL_TD_LOCKING DEASSIGN" \
        "$OPAL_ACE_ASSIGN:$OPAL_METHOD_GET:OPAL_ACE_ASSIGN GET" \
        "$OPAL_ACE_ASSIGN:$OPAL_METHOD_SET:OPAL_ACE_ASSIGN SET" \
        "$OPAL_ACE_DEASSIGN:$OPAL_METHOD_GET:OPAL_ACE_DEASSIGN GET" \
        "$OPAL_ACE_DEASSIGN:$OPAL_METHOD_SET:OPAL_ACE_DEASSIGN SET"
}

# Function: ACETablePreconfiguration
# Purpose: Table 13 Locking SP - ACE Table Preconfiguration.
ACETablePreconfiguration() {
    echo "Table 13 Locking SP - ACE Table Preconfiguration"

    local hexparms item
    local -a list

    hexparms=$(concat_multiple "$OPAL_TOKEN_SL" "$OPAL_TOKEN_EL")
    LockingSP_Anybody_Next "${OPAL_TD_ACE}${OPAL_UID_TABLE}" "$hexparms"

    # dump each row
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" "$OPAL_TOKEN_SL" \
        "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_SC" "00" "$OPAL_TOKEN_EN" \
        "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_EC" "04" "$OPAL_TOKEN_EN" \
        "$OPAL_TOKEN_EL" "$OPAL_TOKEN_EL" \
    )
    list=("$OPAL_ACE_LOCKING_NAMESPACE_IDTOGLBRNG" "$OPAL_ACE_ASSIGN" "$OPAL_ACE_DEASSIGN")
    for item in "${list[@]}"; do
        echo "dump $item row data:"
        LockingSP_Admin1_Get "$item" "$hexparms"
    done
}

# Function: LockingTablePreconfiguration
# Purpose: Table 14 Locking SP - Locking Table Preconfiguration.
LockingTablePreconfiguration() {
    echo "Table 14 Locking SP - Locking Table Preconfiguration"

    local hexparms item
    local -a list

    hexparms=$(concat_multiple "$OPAL_TOKEN_SL" "$OPAL_TOKEN_EL")
    LockingSP_Anybody_Next "${OPAL_TD_LOCKING}${OPAL_UID_TABLE}" "$hexparms"

    # dump each row
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" "$OPAL_TOKEN_SL" \
        "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_SC" "14" "$OPAL_TOKEN_EN" \
        "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_EC" "15" "$OPAL_TOKEN_EN" \
        "$OPAL_TOKEN_EL" "$OPAL_TOKEN_EL" \
    )
    list=(
        "$OPAL_LOCKING_GLOBALRANGE"
        "$OPAL_LOCKING_RANGE1" "$OPAL_LOCKING_RANGE2"
        "$OPAL_LOCKING_RANGE3" "$OPAL_LOCKING_RANGE4"
        "$OPAL_LOCKING_RANGE5" "$OPAL_LOCKING_RANGE6"
        "$OPAL_LOCKING_RANGE7" "$OPAL_LOCKING_RANGE8"
    )
    for item in "${list[@]}"; do
        echo "dump $item row data:"
        LockingSP_Admin1_Get "$item" "$hexparms"
    done
}
