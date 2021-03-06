#include "Monitor.h"

namespace Photino
{
    Monitor::Monitor()
    {
        MonitorFrame monitorArea;
        MonitorFrame workArea;

        Monitor(0, false, false, monitorArea, workArea);
    }

    Monitor::Monitor(
        int Id,
        bool isMain,
        bool hasFocus,
        MonitorFrame monitorArea,
        MonitorFrame workArea)
    {
        this->Id = Id;
        this->isMain = isMain;
        this->hasFocus = hasFocus;
        this->monitorArea = monitorArea;
        this->workArea = workArea;
    }
}
