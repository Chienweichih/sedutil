#!/bin/bash
# SEDUTIL_CONFIG.sh
# sedutil-cli's own conventions/parameters — NOT defined by the TCG OPAL Core
# spec itself. Keep these separate from OPAL_CONFIG.sh, which should only
# contain constants that trace back to a spec table/section.

[[ -n "${SEDUTIL_CONFIG_SH_INCLUDED:-}" ]] && return
SEDUTIL_CONFIG_SH_INCLUDED=1

# SP index expected by `sedutil-cli --rawCmd <sp> ...`. The Core spec
# identifies SPs by UID (see OPAL_SP_ADMIN / OPAL_SP_LOCKING in
# OPAL_CONFIG.sh); these small integers are sedutil-cli's own argument
# convention for selecting one.
SEDUTIL_SP_ADMIN_NUM="2"
SEDUTIL_SP_LOCKING_NUM="3"

# "Anybody" authority UID, used as both hexauth and pass when a rawCmd call
# doesn't need to authenticate as anyone in particular.
SEDUTIL_ANYBODY="FFFFFFFFFFFFFFFF" # OPAL_UID::OPAL_UID_HEXFF
