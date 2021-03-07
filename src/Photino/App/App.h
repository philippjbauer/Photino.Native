#pragma once
#include <vector>
#include <Cocoa/Cocoa.h>

#include "../Structs/Monitor.h"
#include "../Structs/MonitorFrame.h"
#include "../Window/Window.h"

#include "AppDelegate.h"

namespace Photino
{
    using Monitors = std::vector<Monitor>;
    using Windows = std::vector<Window*>;

    class App
    {
        private:
            NSAutoreleasePool *_pool;
            NSApplication *_application;

            Windows *_windows;

            App *Init();

        public:
            App();
            ~App();

            void Run();

            Monitors GetMonitors();

            App *AddWindow(Window *window);
    };
}
