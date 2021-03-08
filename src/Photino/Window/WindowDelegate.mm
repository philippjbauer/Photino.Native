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
        window->Events()->EmitEvent(WindowEvents::WindowShouldClose);
        
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
        window->Events()->EmitEvent(WindowEvents::WindowWillClose);
    }
@end
