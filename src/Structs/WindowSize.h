#import <string>

using namespace std;

struct WindowSize
{
    int width;
    int height;

    WindowSize(int width = 0, int height = 0);

    string ToString();
};
