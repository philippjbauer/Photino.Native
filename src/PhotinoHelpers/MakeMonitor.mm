#include "MakeMonitor.h"

using namespace Photino;

namespace PhotinoHelpers
{
    int GetWindowNumber(NSScreen *screen)
    {
        int windowNumber = [[
                [screen deviceDescription]
                objectForKey:@"NSScreenNumber"
            ] intValue];
        
        return windowNumber;
    }

    Monitor MakeMonitor(NSScreen *screen, bool isMain)
    {
        // Might need inspection in the future
        // See: https://stackoverflow.com/questions/8661001/nsscreennumber-changes-randomly        
        int windowNumber = GetWindowNumber(screen);
        int focusedWindowNumber = GetWindowNumber([NSScreen mainScreen]);
        
        bool hasFocus = windowNumber == focusedWindowNumber;
        MonitorFrame monitorArea = MakeMonitorFrame([screen frame]);
        MonitorFrame workArea = MakeMonitorFrame([screen visibleFrame]);
        
        Monitor monitor(
            windowNumber,
            isMain,
            hasFocus,
            monitorArea,
            workArea);
        
        return monitor;
    }

    MonitorFrame MakeMonitorFrame(NSRect frame)
    {
        MonitorFrame monitorFrame(
            (int)roundf(frame.size.width),
            (int)roundf(frame.size.height),
            (int)roundf(frame.origin.x),
            (int)roundf(frame.origin.y));
        
        return monitorFrame;
    }
}
