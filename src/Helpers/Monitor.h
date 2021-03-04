#pragma once
#include <Cocoa/Cocoa.h>
#include "../Structs/Monitor.h"

int GetWindowNumber(NSScreen* screen);
Monitor MakeMonitor(NSScreen* screen, bool isMain);
MonitorFrame MakeMonitorFrame(NSRect frame);
