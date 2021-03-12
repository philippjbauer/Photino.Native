#pragma once
#include "Photino/App/App.h"

#define EXPORTED

extern "C"
{
    EXPORTED Photino::App *PhotinoApp_ctor();
}
