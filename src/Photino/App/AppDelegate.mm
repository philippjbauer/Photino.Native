#include "../../PhotinoShared/Log.h"

#include "AppDelegate.h"

using namespace PhotinoShared;

@implementation AppDelegate : NSObject
    - (AppDelegate *)init
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
