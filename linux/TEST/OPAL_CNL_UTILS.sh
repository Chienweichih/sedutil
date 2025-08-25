#!/bin/bash

MethodIDTablePreconfiguration() {
    echo "4.4.1.1.2 Preconfiguration"
    echo "Table 11 Locking SP - MethodID Table Preconfiguration"

    segments=(
        "$OPAL_TOKEN_SL" "$OPAL_TOKEN_EL"
    )

    sp="3" # OPAL_UID::OPAL_LOCKINGSP_UID
    hexauth="$OPAL_ADMIN1_UID"
    pass="$ADM_PW"
    hexinvokingUID="${OPAL_TD_METHODID}${OPAL_UID_TABLE}"
    hexmethod="$OPAL_METHOD_NEXT"
    hexparms=""
    for seg in "${segments[@]}"; do
        hexparms+="$seg"
    done
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"

    # dump each row
    segments=(
        "$OPAL_TOKEN_SL" "$OPAL_TOKEN_SL"
        "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_SC" "00" "$OPAL_TOKEN_EN"
        "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_EC" "01" "$OPAL_TOKEN_EN"
        "$OPAL_TOKEN_EL" "$OPAL_TOKEN_EL"
    )

    sp="3" # OPAL_UID::OPAL_LOCKINGSP_UID
    hexauth="$OPAL_ADMIN1_UID"
    pass="$ADM_PW"
    hexmethod="$OPAL_METHOD_GET"
    hexparms=""
    for seg in "${segments[@]}"; do
        hexparms+="$seg"
    done
    list=("$OPAL_METHOD_ASSIGN" "$OPAL_METHOD_DEASSIGN")
    for item in "${list[@]}"
    do
        echo "dump $item row data:"
        hexinvokingUID="$item"
        "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"
    done
}

AccessControlTablePreconfiguration() {
    echo "3.2.2.2 Access Control (M)"

    sp="3" # OPAL_UID::OPAL_LOCKINGSP_UID
    hexauth="$SEDUTIL_ANYBODY"
    pass="$SEDUTIL_ANYBODY"
    hexinvokingUID="${OPAL_TD_ACCESSCONTROL}${OPAL_UID_TABLE}"
    hexmethod="$OPAL_METHOD_GETACL"

    echo "GetACL OPAL_ACE_LOCKING_NAMESPACE_IDTOGLBRNG SET"
    segments=(
        "$OPAL_TOKEN_SL"
        "A8" "$OPAL_ACE_LOCKING_NAMESPACE_IDTOGLBRNG"
        "A8" "$OPAL_METHOD_SET"
        "$OPAL_TOKEN_EL"
    )
    hexparms=""
    for seg in "${segments[@]}"; do
        hexparms+="$seg"
    done
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"

    echo "GetACL OPAL_ACE_LOCKING_NAMESPACE_IDTOGLBRNG GET"
    segments=(
        "$OPAL_TOKEN_SL"
        "A8" "$OPAL_ACE_LOCKING_NAMESPACE_IDTOGLBRNG"
        "A8" "$OPAL_METHOD_GET"
        "$OPAL_TOKEN_EL"
    )
    hexparms=""
    for seg in "${segments[@]}"; do
        hexparms+="$seg"
    done
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"

    echo "GetACL OPAL_LOCKING_RANGE1 GET"
    segments=(
        "$OPAL_TOKEN_SL"
        "A8" "$OPAL_LOCKING_RANGE1"
        "A8" "$OPAL_METHOD_GET"
        "$OPAL_TOKEN_EL"
    )
    hexparms=""
    for seg in "${segments[@]}"; do
        hexparms+="$seg"
    done
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"

    echo "GetACL OPAL_LOCKING_RANGE2 GET"
    segments=(
        "$OPAL_TOKEN_SL"
        "A8" "$OPAL_LOCKING_RANGE2"
        "A8" "$OPAL_METHOD_GET"
        "$OPAL_TOKEN_EL"
    )
    hexparms=""
    for seg in "${segments[@]}"; do
        hexparms+="$seg"
    done
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"

    echo "GetACL OPAL_LOCKING_RANGE3 GET"
    segments=(
        "$OPAL_TOKEN_SL"
        "A8" "$OPAL_LOCKING_RANGE3"
        "A8" "$OPAL_METHOD_GET"
        "$OPAL_TOKEN_EL"
    )
    hexparms=""
    for seg in "${segments[@]}"; do
        hexparms+="$seg"
    done
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"

    echo "GetACL OPAL_LOCKING_RANGE4 GET"
    segments=(
        "$OPAL_TOKEN_SL"
        "A8" "$OPAL_LOCKING_RANGE4"
        "A8" "$OPAL_METHOD_GET"
        "$OPAL_TOKEN_EL"
    )
    hexparms=""
    for seg in "${segments[@]}"; do
        hexparms+="$seg"
    done
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"

    echo "GetACL OPAL_LOCKING_RANGE5 GET"
    segments=(
        "$OPAL_TOKEN_SL"
        "A8" "$OPAL_LOCKING_RANGE5"
        "A8" "$OPAL_METHOD_GET"
        "$OPAL_TOKEN_EL"
    )
    hexparms=""
    for seg in "${segments[@]}"; do
        hexparms+="$seg"
    done
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"

    echo "GetACL OPAL_LOCKING_RANGE6 GET"
    segments=(
        "$OPAL_TOKEN_SL"
        "A8" "$OPAL_LOCKING_RANGE6"
        "A8" "$OPAL_METHOD_GET"
        "$OPAL_TOKEN_EL"
    )
    hexparms=""
    for seg in "${segments[@]}"; do
        hexparms+="$seg"
    done
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"

    echo "GetACL OPAL_LOCKING_RANGE7 GET"
    segments=(
        "$OPAL_TOKEN_SL"
        "A8" "$OPAL_LOCKING_RANGE7"
        "A8" "$OPAL_METHOD_GET"
        "$OPAL_TOKEN_EL"
    )
    hexparms=""
    for seg in "${segments[@]}"; do
        hexparms+="$seg"
    done
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"

    echo "GetACL OPAL_LOCKING_RANGE8 GET"
    segments=(
        "$OPAL_TOKEN_SL"
        "A8" "$OPAL_LOCKING_RANGE8"
        "A8" "$OPAL_METHOD_GET"
        "$OPAL_TOKEN_EL"
    )
    hexparms=""
    for seg in "${segments[@]}"; do
        hexparms+="$seg"
    done
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"

    echo "Table 12 Locking SP - AccessControl Table Preconfiguration"

    echo "GetACL OPAL_TD_LOCKING ASSIGN"
    segments=(
        "$OPAL_TOKEN_SL"
        "A8" "${OPAL_TD_LOCKING}${OPAL_UID_TABLE}"
        "A8" "$OPAL_METHOD_ASSIGN"
        "$OPAL_TOKEN_EL"
    )
    hexparms=""
    for seg in "${segments[@]}"; do
        hexparms+="$seg"
    done
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"

    echo "GetACL OPAL_TD_LOCKING DEASSIGN"
    segments=(
        "$OPAL_TOKEN_SL"
        "A8" "${OPAL_TD_LOCKING}${OPAL_UID_TABLE}"
        "A8" "$OPAL_METHOD_DEASSIGN"
        "$OPAL_TOKEN_EL"
    )
    hexparms=""
    for seg in "${segments[@]}"; do
        hexparms+="$seg"
    done
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"

    echo "GetACL OPAL_ACE_ASSIGN GET"
    segments=(
        "$OPAL_TOKEN_SL"
        "A8" "$OPAL_ACE_ASSIGN"
        "A8" "$OPAL_METHOD_GET"
        "$OPAL_TOKEN_EL"
    )
    hexparms=""
    for seg in "${segments[@]}"; do
        hexparms+="$seg"
    done
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"

    echo "GetACL OPAL_ACE_ASSIGN SET"
    segments=(
        "$OPAL_TOKEN_SL"
        "A8" "$OPAL_ACE_ASSIGN"
        "A8" "$OPAL_METHOD_SET"
        "$OPAL_TOKEN_EL"
    )
    hexparms=""
    for seg in "${segments[@]}"; do
        hexparms+="$seg"
    done
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"

    echo "GetACL OPAL_ACE_DEASSIGN GET"
    segments=(
        "$OPAL_TOKEN_SL"
        "A8" "$OPAL_ACE_DEASSIGN"
        "A8" "$OPAL_METHOD_GET"
        "$OPAL_TOKEN_EL"
    )
    hexparms=""
    for seg in "${segments[@]}"; do
        hexparms+="$seg"
    done
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"

    echo "GetACL OPAL_ACE_DEASSIGN SET"
    segments=(
        "$OPAL_TOKEN_SL"
        "A8" "$OPAL_ACE_DEASSIGN"
        "A8" "$OPAL_METHOD_SET"
        "$OPAL_TOKEN_EL"
    )
    hexparms=""
    for seg in "${segments[@]}"; do
        hexparms+="$seg"
    done
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"

    # example:
    # echo "GetACL OPAL_TD_TABLE NEXT"
    # segments=(
    #     "$OPAL_TOKEN_SL"
    #     "A8" "${OPAL_TD_TABLE}${OPAL_UID_TABLE}"
    #     "A8" "$OPAL_METHOD_NEXT"
    #     "$OPAL_TOKEN_EL"
    # )
    # sp="2" # OPAL_UID::OPAL_ADMINSP_UID
    # hexauth="$SEDUTIL_ANYBODY"
    # pass="$SEDUTIL_ANYBODY"
    # hexinvokingUID="${OPAL_TD_ACCESSCONTROL}${OPAL_UID_TABLE}"
    # hexmethod="$OPAL_METHOD_GETACL"
    # hexparms=""
    # for seg in "${segments[@]}"; do
    #     hexparms+="$seg"
    # done
    # "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"
}

ACETablePreconfiguration() {
    echo "Table 13 Locking SP - ACE Table Preconfiguration"

    segments=(
        "$OPAL_TOKEN_SL" "$OPAL_TOKEN_EL"
    )

    sp="3" # OPAL_UID::OPAL_LOCKINGSP_UID
    hexauth="$OPAL_ADMIN1_UID"
    pass="$ADM_PW"
    hexinvokingUID="${OPAL_TD_ACE}${OPAL_UID_TABLE}"
    hexmethod="$OPAL_METHOD_NEXT"
    hexparms=""
    for seg in "${segments[@]}"; do
        hexparms+="$seg"
    done
    "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"

    # dump each row
    segments=(
        "$OPAL_TOKEN_SL" "$OPAL_TOKEN_SL"
        "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_SC" "00" "$OPAL_TOKEN_EN"
        "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_EC" "04" "$OPAL_TOKEN_EN"
        "$OPAL_TOKEN_EL" "$OPAL_TOKEN_EL"
    )

    sp="3" # OPAL_UID::OPAL_LOCKINGSP_UID
    hexauth="$OPAL_ADMIN1_UID"
    pass="$ADM_PW"
    hexmethod="$OPAL_METHOD_GET"
    hexparms=""
    for seg in "${segments[@]}"; do
        hexparms+="$seg"
    done
    list=("$OPAL_ACE_LOCKING_NAMESPACE_IDTOGLBRNG" "$OPAL_ACE_ASSIGN" "$OPAL_ACE_DEASSIGN")
    for item in "${list[@]}"
    do
        echo "dump $item row data:"
        hexinvokingUID="$item"
        "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"
    done
}

LockingTablePreconfiguration() {
    echo "Table 14 Locking SP - Locking Table Preconfiguration"

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

    # dump each row
    segments=(
        "$OPAL_TOKEN_SL" "$OPAL_TOKEN_SL"
        "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_SC" "14" "$OPAL_TOKEN_EN"
        "$OPAL_TOKEN_SN" "$OPAL_CELLBLK_EC" "15" "$OPAL_TOKEN_EN"
        "$OPAL_TOKEN_EL" "$OPAL_TOKEN_EL"
    )

    sp="3" # OPAL_UID::OPAL_LOCKINGSP_UID
    hexauth="$OPAL_ADMIN1_UID"
    pass="$ADM_PW"
    hexmethod="$OPAL_METHOD_GET"
    hexparms=""
    for seg in "${segments[@]}"; do
        hexparms+="$seg"
    done
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
        hexinvokingUID="$item"
        "$PROG" --rawCmd "$sp" "$hexauth" "$pass" "$hexinvokingUID" "$hexmethod" "$hexparms" "$DEVICE"
    done
}
