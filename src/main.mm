#include <iostream>
#include <functional>
#include <memory>
// #include <Cocoa/Cocoa.h>

#include "Photino/App/App.h"
// #include "Photino/Events/Events.h"
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

    app->Events()->AddEventAction(AppEvents::WillRun, [](App *sender)
    {
        Log::WriteLine("Application is about to run.");
    });

    // Window *mainWindow = new Window("Main Window");
    // Log::WriteMetrics(AppMetrics);

    // mainWindow
    //     ->GetWebView()
    //     ->LoadHtmlString("<html><body><h1>Hello Photino!</h1></body></html>");
    // Log::WriteMetrics(AppMetrics);

    // Window *secondWindow = new Window("Second Window");
    // Log::WriteMetrics(AppMetrics);

    // secondWindow
    //     ->SetParent(mainWindow)
    //     ->GetWebView()
    //     ->LoadResource("http://www.tryphotino.io");
    // Log::WriteMetrics(AppMetrics);

    // app->AddWindow(mainWindow)
    //    ->AddWindow(secondWindow);
    // Log::WriteMetrics(AppMetrics);

    app->Run();
    delete app;
    Log::WriteMetrics(&AppMetrics);

    Log::WriteLine("Stopping execution");
    return 0;
}
