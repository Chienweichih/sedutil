//
//  ParseATIdentify.cpp
//
//  Created by Scott Marks on 8 Sept 2022.
//  Copyright © 2022 Bright Plaza Inc. All rights reserved.
//



#include "ParseATIdentify.h"

// Steal P_16_COPY, a very useful internal macro from db.h
#define __DBINTERFACE_PRIVATE
#include <db.h>
#undef __DBINTERFACE_PRIVATE
#include <string.h>

void parseATIdentifyResponse( const IDENTIFY_RESPONSE * presp, DTA_DEVICE_INFO * pdi)
{
    const IDENTIFY_RESPONSE & resp = *presp;
    DTA_DEVICE_INFO & di = *pdi;

#define P_16_COPY_RESP_TO_DI(respFieldName,diFieldName) \
    for (size_t i = 0; i < sizeof(resp.respFieldName); i += sizeof(uint16_t)) { \
        P_16_COPY(resp.respFieldName[i], di.diFieldName[i]); \
    }

    memset(&di.vendorID, 0, sizeof(di.vendorID));

    P_16_COPY_RESP_TO_DI(serialNumber    , serialNum    )
    P_16_COPY_RESP_TO_DI(serialNumber    , passwordSalt )  // save a copy before polishing
    P_16_COPY_RESP_TO_DI(firmwareRevision, firmwareRev  )
    P_16_COPY_RESP_TO_DI(modelNum        , modelNum     )
    P_16_COPY_RESP_TO_DI(worldWideName   , worldWideName)
}
