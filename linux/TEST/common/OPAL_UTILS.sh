#!/bin/bash
# OPAL_UTILS.sh
# Generic sedutil-cli --rawCmd wrappers, shared by every test script.

[[ -n "${OPAL_UTILS_SH_INCLUDED:-}" ]] && return
OPAL_UTILS_SH_INCLUDED=1

_OPAL_UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$_OPAL_UTILS_DIR/OPAL_CONFIG.sh"
source "$_OPAL_UTILS_DIR/SEDUTIL_CONFIG.sh"

# Function: _OPAL_RawCmd
# Purpose: Single point of contact with `sedutil-cli --rawCmd`. All the
#          Admin/Locking SP helper functions below are thin wrappers around
#          this so the actual command line is only assembled in one place.
# Arguments:
#   $1 - sp (Security Provider number, e.g. $SEDUTIL_SP_ADMIN_NUM)
#   $2 - hexauth (authority UID)
#   $3 - pass (password / PIN)
#   $4 - hexinvokingUID (TableUID or ObjectUID)
#   $5 - hexmethod (MethodID)
#   $6 - hexparms (parameters list)
# Returns: None (sedutil dump response)
_OPAL_RawCmd() {
    local sp="$1" hexauth="$2" pass="$3" hexinvokingUID="$4" hexmethod="$5" hexparms="$6"
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"
}

# Function: AdminSP_Anybody_Next
# Purpose: Invoke Next on the Admin SP, authenticated as Anybody.
# Arguments:
#   $1 - TableUID
#   $2 - Parameters list
AdminSP_Anybody_Next() {
    _OPAL_RawCmd "$SEDUTIL_SP_ADMIN_NUM" "$SEDUTIL_ANYBODY" "$SEDUTIL_ANYBODY" "$1" "$OPAL_METHOD_NEXT" "$2"
}

# Function: AdminSP_GetACL
# Purpose: Invoke GetACL on the Admin SP AccessControl table, as Anybody.
# Arguments:
#   $1 - Parameters list
AdminSP_GetACL() {
    _OPAL_RawCmd "$SEDUTIL_SP_ADMIN_NUM" "$SEDUTIL_ANYBODY" "$SEDUTIL_ANYBODY" \
        "${OPAL_TD_ACCESSCONTROL}${OPAL_UID_TABLE}" "$OPAL_METHOD_GETACL" "$1"
}

# Function: AdminSP_Anybody_Get
# Purpose: Invoke Get on the Admin SP, authenticated as Anybody.
# Arguments:
#   $1 - TableUID or ObjectUID
#   $2 - Parameters list
AdminSP_Anybody_Get() {
    _OPAL_RawCmd "$SEDUTIL_SP_ADMIN_NUM" "$SEDUTIL_ANYBODY" "$SEDUTIL_ANYBODY" "$1" "$OPAL_METHOD_GET" "$2"
}

# Function: LockingSP_Anybody_Next
# Purpose: Invoke Next on the Locking SP, authenticated as Anybody.
# Arguments:
#   $1 - TableUID
#   $2 - Parameters list
LockingSP_Anybody_Next() {
    _OPAL_RawCmd "$SEDUTIL_SP_LOCKING_NUM" "$SEDUTIL_ANYBODY" "$SEDUTIL_ANYBODY" "$1" "$OPAL_METHOD_NEXT" "$2"
}

# Function: LockingSP_GetACL
# Purpose: Invoke GetACL on the Locking SP AccessControl table, as Anybody.
# Arguments:
#   $1 - Parameters list
LockingSP_GetACL() {
    _OPAL_RawCmd "$SEDUTIL_SP_LOCKING_NUM" "$SEDUTIL_ANYBODY" "$SEDUTIL_ANYBODY" \
        "${OPAL_TD_ACCESSCONTROL}${OPAL_UID_TABLE}" "$OPAL_METHOD_GETACL" "$1"
}

# Function: LockingSP_Anybody_Get
# Purpose: Invoke Get on the Locking SP, authenticated as Anybody.
# Arguments:
#   $1 - TableUID or ObjectUID
#   $2 - Parameters list
LockingSP_Anybody_Get() {
    _OPAL_RawCmd "$SEDUTIL_SP_LOCKING_NUM" "$SEDUTIL_ANYBODY" "$SEDUTIL_ANYBODY" "$1" "$OPAL_METHOD_GET" "$2"
}

# Function: LockingSP_Admin1_Get
# Purpose: Invoke Get on the Locking SP, authenticated as Admin1.
# Arguments:
#   $1 - TableUID or ObjectUID
#   $2 - Parameters list
LockingSP_Admin1_Get() {
    _OPAL_RawCmd "$SEDUTIL_SP_LOCKING_NUM" "$OPAL_AUTHORITY_ADMIN1" "$MSID" "$1" "$OPAL_METHOD_GET" "$2"
}

# Function: LockingSP_Assign
# Purpose: Invoke Assign on the Locking SP, authenticated as Admin1.
# Arguments:
#   $1 - LockingTableUID
#   $2 - Parameters list
LockingSP_Assign() {
    _OPAL_RawCmd "$SEDUTIL_SP_LOCKING_NUM" "$OPAL_AUTHORITY_ADMIN1" "$MSID" "$1" "$OPAL_METHOD_ASSIGN" "$2"
}

# Function: LockingSP_Deassign
# Purpose: Invoke Deassign on the Locking SP, authenticated as Admin1.
# Arguments:
#   $1 - LockingTableUID
#   $2 - Parameters list
LockingSP_Deassign() {
    _OPAL_RawCmd "$SEDUTIL_SP_LOCKING_NUM" "$OPAL_AUTHORITY_ADMIN1" "$MSID" "$1" "$OPAL_METHOD_DEASSIGN" "$2"
}

# Function: concat_multiple
# Purpose: Concatenate a list of hex tokens into a single parameters string.
# Arguments:
#   $@ - list of hex token strings
# Returns: echoes the concatenated string
concat_multiple() {
    local item result=""
    for item in "$@"; do
        result+="$item"
    done
    echo "$result"
}

# Function: OPAL_Get_MSID
# Purpose: Read back the MSID PIN via a raw Get on the Admin SP C_PIN table.
OPAL_Get_MSID() {
    local hexparms
    hexparms=$(concat_multiple \
        "$OPAL_TOKEN_SL" "$OPAL_TOKEN_SL" \
        "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_SC" "03" "$OPAL_TOKEN_EN" \
        "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_EC" "03" "$OPAL_TOKEN_EN" \
        "$OPAL_TOKEN_EL" "$OPAL_TOKEN_EL" \
    )
    AdminSP_Anybody_Get "$OPAL_C_PIN_MSID" "$hexparms"
}
