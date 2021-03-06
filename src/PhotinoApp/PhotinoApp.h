#pragma once
#include <vector>
#include <Cocoa/Cocoa.h>

#include "../Shared/Log.h"
#include "../Structs/Monitor.h"
#include "../Structs/MonitorFrame.h"
#include "../PhotinoWindow/PhotinoWindow.h"

#include "AppDelegate.h"

class PhotinoApp
{
    private:
        NSAutoreleasePool* _pool;
        NSApplication* _application;

        std::vector<PhotinoWindow*> _photinoWindows;

        PhotinoApp* Init();

    public:
        PhotinoApp();
        ~PhotinoApp();

        void Run();

        std::vector<Monitor> GetMonitors();

        PhotinoApp* AddPhotinoWindow(PhotinoWindow* photinoWindow);
};
