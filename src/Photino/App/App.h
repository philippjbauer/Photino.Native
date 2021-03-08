#pragma once
#include <vector>
#include <Cocoa/Cocoa.h>

#include "../Events/Events.h"
#include "../Structs/Monitor.h"
#include "../Structs/MonitorFrame.h"
#include "../Window/Window.h"

#include "AppDelegate.h"

namespace Photino
{
    enum AppEvents
    {
        WillDestruct,
        WillRun,
        WillAddWindow,
        DidAddWindow,
    };

    class App
    {
        private:
            NSAutoreleasePool *_pool;
            NSApplication *_application;

            Windows *_windows;
            Events<App, AppEvents> *_events;

            App *Init();

        public:
            App();
            ~App();

            void Run();

            App *AddWindow(Window *window);

            Monitors GetMonitors();

            Events<App, AppEvents> *Events();
    };
}
