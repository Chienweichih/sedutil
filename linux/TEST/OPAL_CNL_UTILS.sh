#!/bin/bash

source ./linux/TEST/OPAL_CONFIG.sh
source ./linux/TEST/OPAL_UTILS.sh

# Function: MethodIDTablePreconfiguration
# Purpose:
# Arguments:
# Returns: None (sedutil dump response)
MethodIDTablePreconfiguration() {
    echo "4.4.1.1.2 Preconfiguration"
    echo "Table 11 Locking SP - MethodID Table Preconfiguration"

    local hexparms item list=""

    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" "$OPAL_TOKEN_EL" \
    )
    LockingSP_Anybody_Next "${OPAL_TD_METHODID}${OPAL_UID_TABLE}" "$hexparms"

    # dump each row
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" "$OPAL_TOKEN_SL" \
        "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_SC" "00" "$OPAL_TOKEN_EN" \
        "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_EC" "01" "$OPAL_TOKEN_EN" \
        "$OPAL_TOKEN_EL" "$OPAL_TOKEN_EL" \
    )
    list=("$OPAL_METHOD_ASSIGN" "$OPAL_METHOD_DEASSIGN")
    for item in "${list[@]}"
    do
        echo "dump $item row data:"
        LockingSP_Anybody_Get "$item" "$hexparms"
    done
}

# Function: AccessControlTablePreconfiguration
# Purpose:
# Arguments:
# Returns: None (sedutil dump response)
AccessControlTablePreconfiguration() {
    echo "3.2.2.2 Access Control (M)"

    local hexparms=""

    echo "GetACL OPAL_ACE_LOCKING_NAMESPACE_IDTOGLBRNG SET"
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" \
        "A8" "$OPAL_ACE_LOCKING_NAMESPACE_IDTOGLBRNG" \
        "A8" "$OPAL_METHOD_SET" \
        "$OPAL_TOKEN_EL" \
    )
    LockingSP_GetACL "$hexparms"

    echo "GetACL OPAL_ACE_LOCKING_NAMESPACE_IDTOGLBRNG GET"
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" \
        "A8" "$OPAL_ACE_LOCKING_NAMESPACE_IDTOGLBRNG" \
        "A8" "$OPAL_METHOD_GET" \
        "$OPAL_TOKEN_EL" \
    )
    LockingSP_GetACL "$hexparms"

    echo "GetACL OPAL_LOCKING_RANGE1 GET"
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" \
        "A8" "$OPAL_LOCKING_RANGE1" \
        "A8" "$OPAL_METHOD_GET" \
        "$OPAL_TOKEN_EL" \
    )
    LockingSP_GetACL "$hexparms"

    echo "GetACL OPAL_LOCKING_RANGE2 GET"
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" \
        "A8" "$OPAL_LOCKING_RANGE2" \
        "A8" "$OPAL_METHOD_GET" \
        "$OPAL_TOKEN_EL" \
    )
    LockingSP_GetACL "$hexparms"

    echo "GetACL OPAL_LOCKING_RANGE3 GET"
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" \
        "A8" "$OPAL_LOCKING_RANGE3" \
        "A8" "$OPAL_METHOD_GET" \
        "$OPAL_TOKEN_EL" \
    )
    LockingSP_GetACL "$hexparms"

    echo "GetACL OPAL_LOCKING_RANGE4 GET"
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" \
        "A8" "$OPAL_LOCKING_RANGE4" \
        "A8" "$OPAL_METHOD_GET" \
        "$OPAL_TOKEN_EL" \
    )
    LockingSP_GetACL "$hexparms"

    echo "GetACL OPAL_LOCKING_RANGE5 GET"
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" \
        "A8" "$OPAL_LOCKING_RANGE5" \
        "A8" "$OPAL_METHOD_GET" \
        "$OPAL_TOKEN_EL" \
    )
    LockingSP_GetACL "$hexparms"

    echo "GetACL OPAL_LOCKING_RANGE6 GET"
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" \
        "A8" "$OPAL_LOCKING_RANGE6" \
        "A8" "$OPAL_METHOD_GET" \
        "$OPAL_TOKEN_EL" \
    )
    LockingSP_GetACL "$hexparms"

    echo "GetACL OPAL_LOCKING_RANGE7 GET"
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" \
        "A8" "$OPAL_LOCKING_RANGE7" \
        "A8" "$OPAL_METHOD_GET" \
        "$OPAL_TOKEN_EL" \
    )
    LockingSP_GetACL "$hexparms"

    echo "GetACL OPAL_LOCKING_RANGE8 GET"
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" \
        "A8" "$OPAL_LOCKING_RANGE8" \
        "A8" "$OPAL_METHOD_GET" \
        "$OPAL_TOKEN_EL" \
    )
    LockingSP_GetACL "$hexparms"

    echo "Table 12 Locking SP - AccessControl Table Preconfiguration"

    echo "GetACL OPAL_TD_LOCKING ASSIGN"
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" \
        "A8" "${OPAL_TD_LOCKING}${OPAL_UID_TABLE}" \
        "A8" "$OPAL_METHOD_ASSIGN" \
        "$OPAL_TOKEN_EL" \
    )
    LockingSP_GetACL "$hexparms"

    echo "GetACL OPAL_TD_LOCKING DEASSIGN"
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" \
        "A8" "${OPAL_TD_LOCKING}${OPAL_UID_TABLE}" \
        "A8" "$OPAL_METHOD_DEASSIGN" \
        "$OPAL_TOKEN_EL" \
    )
    LockingSP_GetACL "$hexparms"

    echo "GetACL OPAL_ACE_ASSIGN GET"
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" \
        "A8" "$OPAL_ACE_ASSIGN" \
        "A8" "$OPAL_METHOD_GET" \
        "$OPAL_TOKEN_EL" \
    )
    LockingSP_GetACL "$hexparms"

    echo "GetACL OPAL_ACE_ASSIGN SET"
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" \
        "A8" "$OPAL_ACE_ASSIGN" \
        "A8" "$OPAL_METHOD_SET" \
        "$OPAL_TOKEN_EL" \
    )
    LockingSP_GetACL "$hexparms"

    echo "GetACL OPAL_ACE_DEASSIGN GET"
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" \
        "A8" "$OPAL_ACE_DEASSIGN" \
        "A8" "$OPAL_METHOD_GET" \
        "$OPAL_TOKEN_EL" \
    )
    LockingSP_GetACL "$hexparms"

    echo "GetACL OPAL_ACE_DEASSIGN SET"
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" \
        "A8" "$OPAL_ACE_DEASSIGN" \
        "A8" "$OPAL_METHOD_SET" \
        "$OPAL_TOKEN_EL" \
    )
    LockingSP_GetACL "$hexparms"
}

# Function: ACETablePreconfiguration
# Purpose:
# Arguments:
# Returns: None (sedutil dump response)
ACETablePreconfiguration() {
    echo "Table 13 Locking SP - ACE Table Preconfiguration"

    local hexparms item list=""

    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" "$OPAL_TOKEN_EL" \
    )
    LockingSP_Anybody_Next "${OPAL_TD_ACE}${OPAL_UID_TABLE}" "$hexparms"

    # dump each row
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" "$OPAL_TOKEN_SL" \
        "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_SC" "00" "$OPAL_TOKEN_EN" \
        "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_EC" "04" "$OPAL_TOKEN_EN" \
        "$OPAL_TOKEN_EL" "$OPAL_TOKEN_EL" \
    )
    list=("$OPAL_ACE_LOCKING_NAMESPACE_IDTOGLBRNG" "$OPAL_ACE_ASSIGN" "$OPAL_ACE_DEASSIGN")
    for item in "${list[@]}"
    do
        echo "dump $item row data:"
        LockingSP_Admin1_Get "$item" "$hexparms"
    done
}

# Function: LockingTablePreconfiguration
# Purpose:
# Arguments:
# Returns: None (sedutil dump response)
LockingTablePreconfiguration() {
    echo "Table 14 Locking SP - Locking Table Preconfiguration"

    local hexparms item list=""

    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" "$OPAL_TOKEN_EL" \
    )
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
    for item in "${list[@]}"
    do
        echo "dump $item row data:"
        LockingSP_Admin1_Get "$item" "$hexparms"
    done
}

# Function: LockingSP_Assign
# Purpose:
# Arguments:
#   $1 - LockingTableUID
#   $2 - Parameters list
# Returns: None (sedutil dump response)
LockingSP_Assign() {
    local sp="3" # OPAL_UID::OPAL_LOCKINGSP_UID
    local hexauth="$OPAL_AUTHORITY_ADMIN1"
    local pass="$MSID"
    local hexinvokingUID=$1
    local hexmethod="$OPAL_METHOD_ASSIGN"
    local hexparms=$2
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"
}

# Function: LockingSP_Deassign
# Purpose:
# Arguments:
#   $1 - LockingTableUID
#   $2 - Parameters list
# Returns: None (sedutil dump response)
LockingSP_Deassign() {
    local sp="3" # OPAL_UID::OPAL_LOCKINGSP_UID
    local hexauth="$OPAL_AUTHORITY_ADMIN1"
    local pass="$MSID"
    local hexinvokingUID=$1
    local hexmethod="$OPAL_METHOD_DEASSIGN"
    local hexparms=$2
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"
}
