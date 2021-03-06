#pragma once
#include <Cocoa/Cocoa.h>

#include "PhotinoWindow.h"

@interface PhotinoWindowDelegate : NSObject <NSWindowDelegate>
{
    @public
        PhotinoWindow* photinoWindow;
}
@end
