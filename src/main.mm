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
            WindowSize size = sender->GetSize();

            char buffer[100];
            std::sprintf(buffer, "{\"width\":%d,\"height\":%d}", size.width, size.height);
            std::string data(buffer);

            Log::WriteLine("Window did resize to: " + size.ToString());

            sender->WebView()->SendScriptEvent("window-did-resize", data);
        })
        ->AddEventAction(WindowEvents::WindowDidMove, [](Window *sender, std::string *empty)
        {
            WindowLocation location = sender->GetLocation();

            char buffer[100];
            std::sprintf(buffer, "{\"left\":%d,\"top\":%d}", location.left, location.top);
            std::string data(buffer);

            Log::WriteLine("Window did move to: " + location.ToString());

            sender->WebView()->SendScriptEvent("window-did-move", data);
        })
        ->AddEventAction(WindowEvents::WindowShouldClose, [](Window *sender, std::string *shouldClose)
        {
            Log::WriteLine("Window should close soon.");

            *shouldClose = "NO"; // prevent default

            Alert *alert = new Alert(
                sender->NativeWindow(),
                "Are you sure you want to close the app?",
                "Warning",
                NSAlertStyleWarning,
                "Close",
                "close");
            
            alert->AddButton("Cancel", "cancel");
            
            alert->Open([=](std::string response)
            {
                if (response == "close")
                {
                    sender->ForceClose();
                    delete sender;
                }
                
                delete alert;
            });
        })
        ->AddEventAction(WindowEvents::WindowWillClose, [](Window *sender, std::string *empty)
        {
            Log::WriteLine("Window will close now.");
        });

    Photino::WebView *mainWindowWebView = mainWindow->WebView();

    mainWindowWebView
        ->Events()
        ->AddEventAction(WebViewEvents::WillLoadResource, [](Photino::WebView *sender, std::string *resourceURL)
        {
            Log::WriteLine("Resource will load: " + *resourceURL);
        })
        ->AddEventAction(WebViewEvents::DidLoadResource, [&](Photino::WebView *sender, std::string *empty)
        {
            Log::WriteLine("Resource did load.");
        })
        ->AddEventAction(WebViewEvents::DidReceiveScriptMessage, [](Photino::WebView *sender, std::string *message)
        {
            if (message->size() <= 30)
            {
                Log::WriteLine("Received message: " + *message);
                sender->SendScriptMessage("Hey " + *message + "!");
            }
            else
            {
                Alert *alert = new Alert(
                    sender->NativeWindow(),
                    "Your message is too long!",
                    "Warning",
                    NSAlertStyleCritical,
                    "Confirm",
                    "confirmed");
                
                alert->AddButton("Abort", "aborted");
                alert->AddButton("Report", "reported");
                
                alert
                    ->Events()
                    ->AddEventAction(AlertEvents::WillOpen, [](Alert *sender, std::string *empty)
                    {
                        Log::WriteLine("Alert will open.");
                    })
                    ->AddEventAction(AlertEvents::DidOpen, [](Alert *sender, std::string *empty)
                    {
                        Log::WriteLine("Alert did open.");
                    })
                    ->AddEventAction(AlertEvents::WillClose, [](Alert *sender, std::string *empty)
                    {
                        Log::WriteLine("Alert will close.");
                    });

                alert->Open([&alert](std::string response)
                {
                    Log::WriteLine("User " + response + " event.");
                    delete alert;
                });
            }
        })
        // ->AddEventAction(WebViewEvents::WillSendScriptMessage, [](Photino::WebView *sender, std::string *message)
        // {
        //     Log::WriteLine("Overwrite message: " + *message);
        //     *message = "Hi John!";
        //     Log::WriteLine("New message: " + *message);
        // })
        ->AddEventAction(WebViewEvents::CloseScriptConfirm, [](Photino::WebView *sender, std::string *isConfirmedString)
        {
            Log::WriteLine("Closed cofirmation dialog with: " + *isConfirmedString);
        });

    mainWindowWebView
        ->LoadResource("Assets/index.html");

    // Second Window
    // Window *secondWindow = new Window("Second Window");
    // secondWindow
    //     ->WebView()
    //     ->LoadResource("http://www.tryphotino.io");

    // app->AddWindow(mainWindow)
    //    ->AddWindow(secondWindow);

    app->Run();
    delete app;
    
    Log::WriteLine("Stopping execution");
    return 0;
}
