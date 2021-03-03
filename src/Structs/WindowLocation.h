#import <string>

using namespace std;

struct WindowLocation
{
    int left;
    int top;

    WindowLocation(int left = 0, int top = 0);

    string ToString();
};
