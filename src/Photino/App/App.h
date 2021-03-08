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
        WillRun,
        WillDestruct,
        WillAddWindow,
        DidAddWindow,
    };

    class App
    {
        private:
            NSAutoreleasePool *_pool;
            NSApplication *_application;

            Events<App, AppEvents> *_events;
            Windows *_windows;

            App *Init();

        public:
            App();
            ~App();

            /**
             * Class Methods
             */
            Events<App, AppEvents> *Events();

            void Run();

            App *AddWindow(Window *window);
            
            Monitors GetMonitors();
    };
}
