#include "Photino/App/App.h"
#include "PhotinoShared/Log.h"

using namespace Photino;
using namespace PhotinoShared;

int main()
{
    App *app = new App();

    Window *window = new Window("Main Window");
    window
        ->WebView()
        ->LoadHtmlString("Hello World!");

    app->Run();

    return 0;
}
