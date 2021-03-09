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
        char buffer[100];

        std::sprintf(
            buffer,
            "WindowLocation(%i, %i)",
            this->left,
            this->top);

        std::string result(buffer);

        return result;
    }
}
