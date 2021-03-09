#pragma once
#include <string>

namespace Photino
{
    struct MonitorFrame
    {
        int x;
        int y;
        int width;
        int height;

        MonitorFrame();

        MonitorFrame(
            int x,
            int y,
            int width,
            int height);

        std::string ToString();
    };
}
