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
        this->Events()->EmitEvent(AppEvents::WillDestruct);

        // for (Window *window : _windows)
        // {
        //     delete window;
        // }

        [_application release];
        [_pool release];

        delete this->Events();
    }

    App *App::Init()
    {
        _pool = [[NSAutoreleasePool alloc] init];
        
        AppDelegate *appDelegate = [[
            [AppDelegate alloc]
            init
        ] autorelease];

        _application = [NSApplication sharedApplication];
        [_application setDelegate: appDelegate];
        [_application setActivationPolicy: NSApplicationActivationPolicyRegular];

        _windows = new Windows();
        _events = new ::Events<App, AppEvents>(this);

        // id applicationName = [[NSProcessInfo processInfo] processName];

        return this;
    }

    void App::Run()
    {
        this->Events()->EmitEvent(AppEvents::WillRun);
        [_application run];
    }

    App *App::AddWindow(Window *window)
    {
        this->Events()->EmitEvent(AppEvents::WillAddWindow);
        
        _windows->push_back(window);

        this->Events()->EmitEvent(AppEvents::DidAddWindow);

        return this;
    }

    Monitors App::GetMonitors()
    {
        Monitors monitors;

        for (NSScreen *screen in [NSScreen screens])
        {
            bool isMain = monitors.size() == 0;
            
            Monitor monitor = MakeMonitor(screen, isMain);
            monitors.push_back(monitor);
        }

        return monitors;
    }

    Events<App, AppEvents> *App::Events()
    {
        return _events;
    }
}
