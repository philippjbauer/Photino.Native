#pragma once
#include <vector>
#include "MonitorFrame.h"

namespace Photino
{
    struct Monitor
    {
        int Id;
        bool isMain;
        bool hasFocus;
        MonitorFrame monitorArea;
        MonitorFrame workArea;

        Monitor();
        
        Monitor(
            int Id,
            bool isMain,
            bool hasFocus,
            MonitorFrame monitorArea,
            MonitorFrame workArea);
    };

    typedef std::vector<Monitor> Monitors;
}
