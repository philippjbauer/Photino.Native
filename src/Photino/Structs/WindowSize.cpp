#include "WindowSize.h"

namespace Photino
{
    WindowSize::WindowSize(
        int width,
        int height)
    {
        this->width = width;
        this->height = height;
    }

    std::string WindowSize::ToString()
    {
        return std::to_string(this->width) + ", " + std::to_string(this->height);
    }
}
