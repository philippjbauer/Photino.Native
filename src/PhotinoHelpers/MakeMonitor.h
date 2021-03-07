#pragma once
#include <Cocoa/Cocoa.h>
#include "../Photino/Structs/Monitor.h"

using namespace Photino;

namespace PhotinoHelpers
{
    int GetWindowNumber(NSScreen *screen);
    Monitor MakeMonitor(NSScreen *screen, bool isMain);
    MonitorFrame MakeMonitorFrame(NSRect frame);
}
