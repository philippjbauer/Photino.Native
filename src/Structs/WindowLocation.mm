#import "WindowLocation.h"

using namespace std;

WindowLocation::WindowLocation(int left, int top)
{
    this->left = left;
    this->top = top;
}

string WindowLocation::ToString()
{
    return to_string(this->left) + ", " + to_string(this->top);
}
