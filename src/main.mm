#import <Cocoa/Cocoa.h>

#import "Helpers/Log.h"
#import "PhotinoApp/AppDelegate.h"
#import "PhotinoWindow/PhotinoWindow.h"

using namespace std;

int main() {
    Log::WriteLine("Starting execution");

    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    PhotinoAppDelegate* applicationDelegate = [[
        [PhotinoAppDelegate alloc]
        init
    ] autorelease];

    [NSApplication sharedApplication];
    [NSApp setDelegate: applicationDelegate];
    [NSApp setActivationPolicy: NSApplicationActivationPolicyRegular];

    // id applicationName = [[NSProcessInfo processInfo] processName];

    PhotinoWindow* mainWindow = new PhotinoWindow("Main Window", 800, 600, 200, 200);

    mainWindow
        ->GetPhotinoWebView()
            ->LoadHtmlString("<html><body><h1>Hello Photino!</h1></body></html>");

    // PhotinoWindow* secondWindow = new PhotinoWindow("Second Window", 200, 200, 20, 20);

    // secondWindow
    //     ->SetParent(mainWindow)
    //     ->GetPhotinoWebView()
    //         ->LoadHtmlString("Second Window");

    // Run application
    Log::WriteLine("Run application");
    [NSApp run];

    // Release memory after window was closed
    Log::WriteLine("Release resources");
    [NSApp release];
    [pool release];

    Log::WriteLine("Exit application");
    return(EXIT_SUCCESS);

    return 0;
};
