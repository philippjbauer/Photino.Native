#include "Photino/App/App.h"
#include "PhotinoShared/Log.h"

using namespace Photino;
using namespace PhotinoShared;

int main()
{
    Log::WriteLine("Starting execution");

    App *app = new App();
    app
        ->Events()
        ->AddEventAction(AppEvents::WillRun, [](App *sender, std::string *empty)
        {
            Log::WriteLine("Application is about to run.");
        });

    // Main Window
    Window *mainWindow = new Window("Main Window");
    mainWindow
        ->Events()
        ->AddEventAction(WindowEvents::WindowDidResize, [](Window *sender, std::string *empty)
        {
            Log::WriteLine("Window did resize to: " + sender->GetSize().ToString());
        })
        ->AddEventAction(WindowEvents::WindowDidMove, [](Window *sender, std::string *empty)
        {
            Log::WriteLine("Window did move to: " + sender->GetLocation().ToString());
        })
        ->AddEventAction(WindowEvents::WindowShouldClose, [](Window *sender, std::string *empty)
        {
            Log::WriteLine("Window should close soon.");
        })
        ->AddEventAction(WindowEvents::WindowWillClose, [](Window *sender, std::string *empty)
        {
            Log::WriteLine("Window will close now.");
        });

    Photino::WebView *mainWindowWebView = mainWindow->WebView();

    mainWindowWebView
        ->Events()
        ->AddEventAction(WebViewEvents::WillLoadResource, [](Photino::WebView *sender, std::string *empty)
        {
            Log::WriteLine("Resource will load.");
        })
        ->AddEventAction(WebViewEvents::DidLoadResource, [](Photino::WebView *sender, std::string *empty)
        {
            Log::WriteLine("Resource did load.");
        })
        ->AddEventAction(WebViewEvents::DidReceiveScriptMessage, [](Photino::WebView *sender, std::string *message)
        {
            Log::WriteLine("Received script message: " + *message);
        });

    mainWindowWebView
        // ->LoadHtmlString("<html><body><h1>Hello Photino</h1></body></html>");
        ->LoadResource("Assets/index.html");
        // ->LoadResource("http://www.tryphotino.io");
    
    // Second Window
    // Window *secondWindow = new Window("Second Window");
    // secondWindow
    //     ->WebView()
    //     ->LoadResource("http://www.tryphotino.io");

    // app->AddWindow(mainWindow)
    //    ->AddWindow(secondWindow);

    app->Run();
    
    Log::WriteLine("Stopping execution");
    return 0;
}
