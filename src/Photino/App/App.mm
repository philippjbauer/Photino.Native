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
        Log::WriteLine("Destructing App");
        this->Events()->EmitEvent(AppEvents::WillDestruct);

        delete _events;
        delete _windows;
    }

    App *App::Init()
    {
        _events = new Photino::Events<App, AppEvents>(this);
        
        AppDelegate *appDelegate = [AppDelegate new];

        _application = [NSApplication sharedApplication];
        [_application setDelegate: appDelegate];
        [_application setActivationPolicy: NSApplicationActivationPolicyRegular];

        _windows = new Windows();

        return this;
    }

    Events<App, AppEvents> *App::Events() { return _events; }

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
}
