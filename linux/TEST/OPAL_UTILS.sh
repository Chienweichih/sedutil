#!/bin/bash

# Function: AdminSP_Anybody_Next
# Purpose:
# Arguments:
#   $1 - TableUID
#   $2 - Parameters list
# Returns: None (sedutil dump response)
AdminSP_Anybody_Next() {
    local SEDUTIL_ANYBODY="FFFFFFFFFFFFFFFF" # OPAL_UID::OPAL_UID_HEXFF
    local sp="2" # OPAL_UID::OPAL_ADMINSP_UID
    local hexauth="$SEDUTIL_ANYBODY"
    local pass="$SEDUTIL_ANYBODY"
    local hexinvokingUID=$1
    local hexmethod="$OPAL_METHOD_NEXT"
    local hexparms=$2
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"
}

# Function: AdminSP_GetACL
# Purpose:
# Arguments:
#   $1 - Parameters list
# Returns: None (sedutil dump response)
AdminSP_GetACL() {
    local SEDUTIL_ANYBODY="FFFFFFFFFFFFFFFF" # OPAL_UID::OPAL_UID_HEXFF
    local sp="2" # OPAL_UID::OPAL_ADMINSP_UID
    local hexauth="$SEDUTIL_ANYBODY"
    local pass="$SEDUTIL_ANYBODY"
    local hexinvokingUID="${OPAL_TD_ACCESSCONTROL}${OPAL_UID_TABLE}"
    local hexmethod="$OPAL_METHOD_GETACL"
    local hexparms=$1
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"
}

# Function: AdminSP_Anybody_Get
# Purpose:
# Arguments:
#   $1 - TableUID or ObjectUID
#   $2 - Parameters list
# Returns: None (sedutil dump response)
AdminSP_Anybody_Get() {
    local SEDUTIL_ANYBODY="FFFFFFFFFFFFFFFF" # OPAL_UID::OPAL_UID_HEXFF
    local sp="2" # OPAL_UID::OPAL_ADMINSP_UID
    local hexauth="$SEDUTIL_ANYBODY"
    local pass="$SEDUTIL_ANYBODY"
    local hexinvokingUID=$1
    local hexmethod="$OPAL_METHOD_GET"
    local hexparms=$2
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"
}

# Function: LockingSP_Anybody_Next
# Purpose:
# Arguments:
#   $1 - TableUID
#   $2 - Parameters list
# Returns: None (sedutil dump response)
LockingSP_Anybody_Next() {
    local SEDUTIL_ANYBODY="FFFFFFFFFFFFFFFF" # OPAL_UID::OPAL_UID_HEXFF
    local sp="3" # OPAL_UID::OPAL_LOCKINGSP_UID
    local hexauth="$SEDUTIL_ANYBODY"
    local pass="$SEDUTIL_ANYBODY"
    local hexinvokingUID=$1
    local hexmethod="$OPAL_METHOD_NEXT"
    local hexparms=$2
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"
}

# Function: LockingSP_GetACL
# Purpose:
# Arguments:
#   $1 - Parameters list
# Returns: None (sedutil dump response)
LockingSP_GetACL() {
    local SEDUTIL_ANYBODY="FFFFFFFFFFFFFFFF" # OPAL_UID::OPAL_UID_HEXFF
    local sp="3" # OPAL_UID::OPAL_LOCKINGSP_UID
    local hexauth="$SEDUTIL_ANYBODY"
    local pass="$SEDUTIL_ANYBODY"
    local hexinvokingUID="${OPAL_TD_ACCESSCONTROL}${OPAL_UID_TABLE}"
    local hexmethod="$OPAL_METHOD_GETACL"
    local hexparms=$1
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"
}

# Function: LockingSP_Anybody_Get
# Purpose:
# Arguments:
#   $1 - TableUID or ObjectUID
#   $2 - Parameters list
# Returns: None (sedutil dump response)
LockingSP_Anybody_Get() {
    local SEDUTIL_ANYBODY="FFFFFFFFFFFFFFFF" # OPAL_UID::OPAL_UID_HEXFF
    local sp="3" # OPAL_UID::OPAL_LOCKINGSP_UID
    local hexauth="$SEDUTIL_ANYBODY"
    local pass="$SEDUTIL_ANYBODY"
    local hexinvokingUID=$1
    local hexmethod="$OPAL_METHOD_GET"
    local hexparms=$2
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"
}

# Function: LockingSP_Admin1_Get
# Purpose:
# Arguments:
#   $1 - TableUID or ObjectUID
#   $2 - Parameters list
# Returns: None (sedutil dump response)
LockingSP_Admin1_Get() {
    local sp="3" # OPAL_UID::OPAL_LOCKINGSP_UID
    local hexauth="$OPAL_AUTHORITY_ADMIN1"
    local pass="$MSID"
    local hexinvokingUID=$1
    local hexmethod="$OPAL_METHOD_GET"
    local hexparms=$2
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"
}

# Function: concat_multiple
# Purpose: Generate parameters list
# Arguments:
#   $1 - Parameters list
# Returns: None (sedutil dump response)
concat_multiple() {
    local item result=""
    for item in "$@"; do
        result+="$item"
    done
    echo "$result"
}

# Function: OPAL_Get_MSID
# Purpose:
# Arguments:
# Returns: None (sedutil dump response)
OPAL_Get_MSID() {
    local hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" "$OPAL_TOKEN_SL" \
        "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_SC" "03" "$OPAL_TOKEN_EN" \
        "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_EC" "03" "$OPAL_TOKEN_EN" \
        "$OPAL_TOKEN_EL" "$OPAL_TOKEN_EL" \
    )
    AdminSP_Anybody_Get "$OPAL_C_PIN_MSID" "$hexparms"
}
