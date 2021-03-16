#include "Alert.h"

namespace Photino
{
    Alert::Alert(
        NSWindow *nativeWindow,
        std::string message,
        std::string title,
        NSAlertStyle style,
        std::string buttonLabel,
        std::string buttonValue
        )
        : _nativeWindow(nativeWindow)
    {
        _events = new Photino::Events<Alert, AlertEvents>(this);

        _nativeAlert = [NSAlert new];

        this->SetMessage(message)
            ->SetTitle(title)
            ->SetStyle(style)
            ->AddButton(buttonLabel, buttonValue);
    }

    Alert::~Alert()
    {
        _nativeAlert = nil;
        delete _events;
    }

    Events<Alert, AlertEvents> *Alert::Events() { return _events; }

    void Alert::Open(std::function<void (std::string)> callback)
    {
        this->Events()->EmitEvent(AlertEvents::WillOpen);

        [_nativeAlert
            beginSheetModalForWindow: _nativeWindow
            completionHandler: ^void (NSModalResponse responseCode)
            {
                this->Events()->EmitEvent(AlertEvents::WillClose);
                
                if (callback != nullptr)
                {
                    callback(_responseValues.at(responseCode));
                }
            }];
    
        this->Events()->EmitEvent(AlertEvents::DidOpen);
    }

    Alert *Alert::SetStyle(NSAlertStyle style)
    {
        [_nativeAlert setAlertStyle: style];
        return this;
    }

    Alert *Alert::SetTitle(std::string title)
    {
        [_nativeAlert setMessageText: [NSString stringWithUTF8String: title.c_str()]];
        return this;
    }

    Alert *Alert::SetMessage(std::string message)
    {
        [_nativeAlert setInformativeText: [NSString stringWithUTF8String: message.c_str()]];
        return this;
    }

    Alert *Alert::AddButton(std::string label, std::string value)
    {
        size_t modalResponse = 1000 + _responseValues.size();
 
        _responseValues.insert(std::pair<size_t, std::string>(modalResponse, value));
        [_nativeAlert addButtonWithTitle: [NSString stringWithUTF8String: label.c_str()]];

        return this;
    }
}