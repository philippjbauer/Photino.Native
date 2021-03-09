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
        char buffer[100];

        std::sprintf(
            buffer,
            "WindowSize(%i, %i)",
            this->width,
            this->height);

        std::string result(buffer);

        return result;
    }
}
