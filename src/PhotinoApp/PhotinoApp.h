#pragma once
#include <vector>

#include "../Helpers/Log.h"
#include "../Structs/Monitor.h"
#include "../Structs/MonitorFrame.h"
#include "../PhotinoWindow/PhotinoWindow.h"

#include "AppDelegate.h"

class PhotinoApp
{
    private:
        NSAutoreleasePool* _pool;
        PhotinoAppDelegate* _appDelegate;
        NSApplication* _application;

        PhotinoApp* Init();

    public:
        PhotinoApp();
        ~PhotinoApp();

        void Run();

        std::vector<Monitor> GetMonitors();

        void AddPhotinoWindow(PhotinoWindow* photinoWindow);
};
