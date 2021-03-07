#pragma once
#include <Cocoa/Cocoa.h>

#include "Window.h"

using namespace Photino;

@interface WindowDelegate : NSObject <NSWindowDelegate>
{
    @public
        Window *window;
}
@end
