#pragma once
#include <string>

struct WindowSize
{
    int width;
    int height;

    WindowSize(
        int width = 0,
        int height = 0);

    std::string ToString();
};
