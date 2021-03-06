#include "WindowLocation.h"

namespace Photino
{
    WindowLocation::WindowLocation(
        int left,
        int top)
    {
        this->left = left;
        this->top = top;
    }

    std::string WindowLocation::ToString()
    {
        return std::to_string(this->left) + ", " + std::to_string(this->top);
    }
}
