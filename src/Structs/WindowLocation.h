#pragma once
#include <string>

struct WindowLocation
{
    int left;
    int top;

    WindowLocation(
        int left = 0,
        int top = 0);

    std::string ToString();
};
