#include "MonitorFrame.h"

namespace Photino
{
    MonitorFrame::MonitorFrame(){
        MonitorFrame(0, 0, 0, 0);
    };

    MonitorFrame::MonitorFrame(
        int x,
        int y,
        int width,
        int height)
    {
        this->x = x;
        this->y = y;
        this->width = width;
        this->height = height;
    }

    std::string MonitorFrame::ToString()
    {
        char buffer[100];

        std::sprintf(
            buffer,
            "MonitorFrame(%i, %i, %i, %i)",
            this->x,
            this->y,
            this->width,
            this->height);

        std::string result(buffer);

        return result;
    }
}
