#pragma once
#include "PhotinoApp/PhotinoApp.h"

#define EXPORTED

extern "C"
{
    EXPORTED PhotinoApp *PhotinoApp_ctor();
}
