#include <functional>
#include <memory>
#include <Cocoa/Cocoa.h>

#include "Photino/App/App.h"
#include "Photino/Events/Events.h"
#include "PhotinoHelpers/Metrics.h"
#include "PhotinoShared/Log.h"

using namespace Photino;
using namespace PhotinoHelpers;
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

enum class WindowEventTypes
{
    WillCreate,
    DidCreate,
    WillOpen,
    DidOpen,
    WillClose,
    WillLoad,
    DidLoad,
};

void WillCreateEventAction()
{
    Log::WriteLine("Window will close.");
};

int main()
{
    Log::WriteLine("Starting execution");

    // Log::WriteLine("WillCreate: " + std::to_string(WindowEventTypes::WillCreate));

    Events<WindowEventTypes> *windowEvents = new Events<WindowEventTypes>();

    EventAction willCreateEventAction = &WillCreateEventAction;

    windowEvents->AddEventAction(WindowEventTypes::WillCreate, willCreateEventAction);

    delete windowEvents;

    // windowEvents.EmitEvent(WindowEventTypes::WillCreate);

    // App *app = new App();
    // Log::WriteMetrics(AppMetrics);

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

    // app->Run();
    // delete app;

    Log::WriteLine("Stopping execution");
    return 0;
}
