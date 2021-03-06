#include "PhotinoApp.h"

PhotinoApp::PhotinoApp()
{
    this->Init();
}

PhotinoApp::~PhotinoApp()
{
    // Release memory after window was closed
    Log::WriteLine("Release resources");

    // for (PhotinoWindow* photinoWindow in _photinoWindows)
    // {
    //     delete photinoWindow;
    // }

    [_application release];
    [_pool release];
}

PhotinoApp* PhotinoApp::Init()
{
    Log::WriteLine("Init resources");
    _pool = [[NSAutoreleasePool alloc] init];
    
    PhotinoAppDelegate* appDelegate = [[
        [PhotinoAppDelegate alloc]
        init
    ] autorelease];

    _application = [NSApplication sharedApplication];
    [_application setDelegate: appDelegate];
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

PhotinoApp* PhotinoApp::AddPhotinoWindow(PhotinoWindow* photinoWindow)
{
    _photinoWindows.push_back(photinoWindow);

    return this;
}
