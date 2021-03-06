#pragma once
#include <string>

namespace Photino
{
    struct WindowLocation
    {
        int left;
        int top;

        WindowLocation(
            int left = 0,
            int top = 0);

        std::string ToString();
    };
}
