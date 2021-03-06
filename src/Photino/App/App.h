#pragma once
#include <vector>
#include <Cocoa/Cocoa.h>

#include "../Structs/Monitor.h"
#include "../Structs/MonitorFrame.h"
#include "../Window/Window.h"

#include "AppDelegate.h"

namespace Photino
{
    class App
    {
        private:
            NSAutoreleasePool* _pool;
            NSApplication* _application;

            std::vector<Window*> _windows;

            App* Init();

        public:
            App();
            ~App();

            void Run();

            std::vector<Monitor> GetMonitors();

            App* AddWindow(Window* window);
    };
}
