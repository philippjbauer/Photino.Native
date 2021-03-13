#include "InvokeOnMainThread.h"

namespace PhotinoHelpers
{
    void InvokeOnMainThread(dispatch_block_t block)
    {
        if ([NSThread isMainThread])
        {
            block();
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), block);
        }
    }
}
