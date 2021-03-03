#import "WindowSize.h"

using namespace std;

WindowSize::WindowSize(int width, int height)
{
    this->width = width;
    this->height = height;
}

string WindowSize::ToString()
{
    return to_string(this->width) + ", " + to_string(this->height);
}
