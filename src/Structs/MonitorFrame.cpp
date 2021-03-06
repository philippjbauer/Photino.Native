#include "MonitorFrame.h"

MonitorFrame::MonitorFrame(){
    MonitorFrame(0, 0, 0, 0);
};

MonitorFrame::MonitorFrame(
    int width,
    int height,
    int x,
    int y)
{
    this->width = width;
    this->height = height;
    this->x = x;
    this->y = y;
}
