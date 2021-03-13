#pragma once
#include <cstdio>
#include <Cocoa/Cocoa.h>

namespace PhotinoHelpers
{
    void InvokeOnMainThread(dispatch_block_t block);
}
