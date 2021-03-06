#pragma once

namespace Photino
{
    struct MonitorFrame
    {
        int width;
        int height;
        int x;
        int y;

        MonitorFrame();

        MonitorFrame(
            int width,
            int height,
            int x,
            int y);
    };
}
