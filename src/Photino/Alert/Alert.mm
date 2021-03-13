#include "../../PhotinoHelpers/InvokeOnMainThread.h"
#include "Alert.h"

namespace Photino
{
    Alert::Alert(
        NSWindow *nativeWindow,
        std::string title,
        std::string message,
        NSAlertStyle alertStyle)
        : _nativeWindow(nativeWindow),
          _title(title),
          _message(message),
          _alertStyle(alertStyle)
    {
        this->Init();
    }

    Alert::~Alert()
    {
        // delete _events;
        // [_alert release];
    }

    Alert *Alert::Init()
    {
        _events = new Photino::Events<Alert, AlertEvents>(this);

        _alert = [[NSAlert alloc] init];

        [_alert setAlertStyle: _alertStyle];
        [_alert setMessageText: [[NSString stringWithUTF8String: _title.c_str()] autorelease]];
        [_alert setInformativeText: [[NSString stringWithUTF8String: _message.c_str()] autorelease]];
        [_alert addButtonWithTitle: @"OK"];

        return this;
    }

    Events<Alert, AlertEvents> *Alert::Events() { return _events; }
    NSAlert *Alert::NativeAlert() { return _alert; }

    void Alert::Open(void completionHandler (Alert *alert))
    {
        this->Events()->EmitEvent(AlertEvents::WillOpen);
        
        PhotinoHelpers::InvokeOnMainThread(^{
            [_alert
                beginSheetModalForWindow: _nativeWindow
                completionHandler: ^void (NSModalResponse response)
                {
                    this->Events()->EmitEvent(AlertEvents::WillClose);
                    
                    if (completionHandler != nullptr)
                    {
                        completionHandler(this);
                    }
                    
                    // [_alert release];
                }];
        });
        
        this->Events()->EmitEvent(AlertEvents::DidOpen);
    }
}