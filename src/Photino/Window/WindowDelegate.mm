#include "../../PhotinoShared/Log.h"
#include "../Structs/WindowSize.h"
#include "../Structs/WindowLocation.h"

#include "WindowDelegate.h"

using namespace Photino;
using namespace PhotinoShared;

@implementation WindowDelegate : NSObject
    - (void)windowDidResize: (NSNotification *)notification
    {
        NSRect frame = [window->GetNativeWindow() frame];
        NSSize windowSize = frame.size;

        WindowSize size = WindowSize(windowSize.width, windowSize.height);
        Log::WriteLine("Window sized to: " + size.ToString());
    }

    - (void)windowDidMove: (NSNotification *)notification
    {
        NSRect frame = [window->GetNativeWindow() frame];
        NSPoint windowLocation = frame.origin;

        WindowLocation location = WindowLocation(windowLocation.x, windowLocation.y);
        Log::WriteLine("Window moved to: " + location.ToString());
    }

    - (BOOL)windowShouldClose: (NSWindow *)sender
    {
        Log::WriteLine("Window should close");
        // NSAlert *alert = [[NSAlert alloc] init];
        // [alert addButtonWithTitle:@"Yes"];
        // [alert addButtonWithTitle:@"No"];
        // [alert setMessageText:@"Are you sure you want to quit?"];
        // [alert setAlertStyle:NSAlertStyleWarning];
        // [alert setShowsSuppressionButton:YES];

        // NSInteger result = [alert runModal];

        // if (result == NSAlertFirstButtonReturn) {
            return YES;
        // } else {
        //     return NO;
        // }
    }

    - (void)windowWillClose: (NSWindow *)sender
    {
        Log::WriteLine("Window will close");
    }
@end
