#include "../Helpers/Log.h"
#include "../Structs/WindowSize.h"
#include "../Structs/WindowLocation.h"

#include "PhotinoWebViewUiDelegate.h"

@implementation PhotinoWebViewUiDelegate : NSObject
- (void)windowDidResize: (NSNotification *)notification
{
    NSRect windowContentRect = [_nativeWindow frame];
    NSSize windowSize = windowContentRect.size;

    WindowSize size = WindowSize(windowSize.width, windowSize.height);
    Log::WriteLine("Window sized to: " + size.ToString());
}

- (void)windowDidMove: (NSNotification *)notification
{
    NSRect windowContentRect = [_nativeWindow frame];
    NSPoint windowLocation = windowContentRect.origin;

    WindowLocation location = WindowLocation(windowLocation.x, windowLocation.y);
    Log::WriteLine("Window moved to: " + location.ToString());
}

- (void)windowWillClose: (NSWindow *)sender
{
    Log::WriteLine("Window will close");
}
@end