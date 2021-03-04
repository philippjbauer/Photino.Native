#include <memory>
#include <Cocoa/Cocoa.h>

#include "PhotinoApp/PhotinoApp.h"

static Metrics AppMetrics;

void* operator new(size_t size) _THROW_BAD_ALLOC
{
    AppMetrics.UsedInstances++;
    AppMetrics.UsedMemory += size;
    
    return malloc(size);
}

void operator delete(void* memory, size_t size)
{
    AppMetrics.FreedInstances++;
    AppMetrics.FreedMemory += size;
    
    free(memory);
}

int main() {
    Log::WriteLine("Starting execution");

    PhotinoApp* app = new PhotinoApp();
    Log::WriteMetrics(AppMetrics);

    PhotinoWindow* mainWindow = new PhotinoWindow("Main Window");
    Log::WriteMetrics(AppMetrics);

    mainWindow
        ->GetPhotinoWebView()
        ->LoadHtmlString("<html><body><h1>Hello Photino!</h1></body></html>");
    Log::WriteMetrics(AppMetrics);

    PhotinoWindow* secondWindow = new PhotinoWindow("Second Window");
    Log::WriteMetrics(AppMetrics);

    secondWindow
        ->SetParent(mainWindow)
        ->GetPhotinoWebView()
        ->LoadHtmlString("Second Window");
    Log::WriteMetrics(AppMetrics);

    app->Run();
    delete app;

    Log::WriteLine("Stopping execution");
    return 0;
}
