#include "../../PhotinoHelpers/MakeMonitor.h"
#include "../../PhotinoShared/Log.h"

#include "App.h"

using namespace PhotinoHelpers;
using namespace PhotinoShared;

namespace Photino
{
    App::App()
    {
        this->Init();
    }

    App::~App()
    {
        // Release memory after window was closed
        Log::WriteLine("Release resources");

        // for (Window* photinoWindow in _windows)
        // {
        //     delete photinoWindow;
        // }

        [_application release];
        [_pool release];
    }

    App* App::Init()
    {
        Log::WriteLine("Init resources");
        _pool = [[NSAutoreleasePool alloc] init];
        
        AppDelegate* appDelegate = [[
            [AppDelegate alloc]
            init
        ] autorelease];

        _application = [NSApplication sharedApplication];
        [_application setDelegate: appDelegate];
        [_application setActivationPolicy: NSApplicationActivationPolicyRegular];

        // id applicationName = [[NSProcessInfo processInfo] processName];

        return this;
    }

    void App::Run()
    {
        Log::WriteLine("Run application");
        [_application run];
    }

    std::vector<Monitor> App::GetMonitors()
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

    App* App::AddWindow(Window* photinoWindow)
    {
        _windows.push_back(photinoWindow);

        return this;
    }
}
