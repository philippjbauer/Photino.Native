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
        window->Events()->EmitEvent(WindowEvents::WindowShouldClose, &shouldClose);
        Log::WriteLine("Window should close: " + shouldClose);
        return shouldClose == "YES";
    }

    - (void)windowWillClose: (NSWindow *)sender
    {
        window->Events()->EmitEvent(WindowEvents::WindowWillClose);
    }
@end
