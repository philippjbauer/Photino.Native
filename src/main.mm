#include <iostream>
#include <functional>
#include <memory>

#include "Photino/App/App.h"
#include "PhotinoShared/Metrics.h"
#include "PhotinoShared/Log.h"

using namespace Photino;
using namespace PhotinoShared;

static Metrics AppMetrics;

void *operator new(size_t size) _THROW_BAD_ALLOC
{
    AppMetrics.UsedInstances++;
    AppMetrics.UsedMemory += size;
    
    return malloc(size);
}

void operator delete(void *memory, size_t size) _NOEXCEPT
{
    AppMetrics.FreedInstances++;
    AppMetrics.FreedMemory += size;
    
    free(memory);
}

int main()
{
    Log::WriteLine("Starting execution");
    Log::WriteMetrics(&AppMetrics);

    App *app = new App();
    Log::WriteMetrics(&AppMetrics);

    app
        ->Events()
        ->AddEventAction(AppEvents::WillRun, [](App *sender)
        {
            Log::WriteLine("Application is about to run.");
        });
    Log::WriteMetrics(&AppMetrics);

    Window *mainWindow = new Window("Main Window");
    Log::WriteMetrics(&AppMetrics);

    mainWindow
        ->Events()
        ->AddEventAction(WindowEvents::WindowDidResize, [](Window *sender)
        {
            Log::WriteLine("Window did resize to: " + sender->GetSize().ToString());
        })
        ->AddEventAction(WindowEvents::WindowDidMove, [](Window *sender)
        {
            Log::WriteLine("Window did move to: " + sender->GetLocation().ToString());
        });
    Log::WriteMetrics(&AppMetrics);

    mainWindow
        ->WebView()
        ->LoadHtmlString("<html><body><h1>Hello Photino!</h1></body></html>");
    Log::WriteMetrics(&AppMetrics);

    // Window *secondWindow = new Window("Second Window");
    // Log::WriteMetrics(&AppMetrics);

    // secondWindow
    //     ->SetParent(mainWindow)
    //     ->WebView()
    //     ->LoadResource("http://www.tryphotino.io");
    // Log::WriteMetrics(&AppMetrics);

    // app->AddWindow(mainWindow)
    //    ->AddWindow(secondWindow);
    // Log::WriteMetrics(&AppMetrics);

    app->Run();

    // None of this is outside of app event loop
    // and is never fired because the app is terminated.
    delete app;
    Log::WriteMetrics(&AppMetrics);
    
    Log::WriteLine("Stopping execution");
    return 0;
}
