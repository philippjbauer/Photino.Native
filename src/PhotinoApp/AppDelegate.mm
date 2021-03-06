#include "../Shared/Log.h"
#include "AppDelegate.h"

@implementation PhotinoAppDelegate : NSObject
- (PhotinoAppDelegate *)init
{
    if (self = [super init])
    {
        Log::WriteLine("PAD init");
    }
    
    return self;
}

- (void)applicationDidFinishLaunching: (NSNotification *)notification
{
    [NSApp activateIgnoringOtherApps: YES];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed: (NSApplication *)sender
{
    return true;
}

- (void)dealloc
{
    [super dealloc];
}
@end
