#include "../../PhotinoShared/Log.h"
#include "../Structs/WindowSize.h"
#include "../Structs/WindowLocation.h"

#include "WindowDelegate.h"

using namespace Photino;
using namespace PhotinoShared;

@implementation WindowDelegate : NSObject
    - (void)windowDidResize: (NSNotification *)notification
    {
        window->Events()->EmitEvent(WindowEvents::WindowDidResize);
    }

    - (void)windowDidMove: (NSNotification *)notification
    {
        window->Events()->EmitEvent(WindowEvents::WindowDidMove);
    }

    - (BOOL)windowShouldClose: (NSWindow *)sender
    {
        std::string shouldClose = "YES";

        // The shouldClose value can be set to "NO"
        // in an event action and the performClose / 
        // user click can be aborted.
        window->Events()->EmitEvent(WindowEvents::WindowShouldClose, &shouldClose);

        return shouldClose == "YES";
    }

    - (void)windowWillClose: (NSWindow *)sender
    {
        window->Events()->EmitEvent(WindowEvents::WindowWillClose);
    }
@end
