#include "../Helpers/Log.h"
#include "../Helpers/Monitor.h"
#include "PhotinoApp.h"

PhotinoApp::PhotinoApp()
{
    this->Init();
}

PhotinoApp::~PhotinoApp()
{
    // Release memory after window was closed
    Log::WriteLine("Release resources");
    [_application release];
    [_pool release];
}

PhotinoApp* PhotinoApp::Init()
{
    Log::WriteLine("Init resources");
    _pool = [[NSAutoreleasePool alloc] init];
    
    _appDelegate = [[
        [PhotinoAppDelegate alloc]
        init
    ] autorelease];

    _application = [NSApplication sharedApplication];
    [_application setDelegate: _appDelegate];
    [_application setActivationPolicy: NSApplicationActivationPolicyRegular];

    // id applicationName = [[NSProcessInfo processInfo] processName];

    return this;
}

void PhotinoApp::Run()
{
    Log::WriteLine("Run application");
    [_application run];
}

std::vector<Monitor> PhotinoApp::GetMonitors()
{
    std::vector<Monitor> monitors;

    for (NSScreen* screen in [NSScreen screens])
    {
        bool isMain = monitors.size() == 0;
        
        Monitor monitor = MakeMonitor(screen, isMain);
        monitors.push_back(monitor);
    }

    return monitors;
}
