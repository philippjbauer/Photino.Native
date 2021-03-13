#include "Alert.h"

namespace Photino
{
    Alert::Alert(
        NSWindow *window,
        std::string message,
        std::string title,
        NSAlertStyle style,
        std::string buttonLabel,
        std::string buttonValue
        )
        : _window(window)
    {
        _events = new Photino::Events<Alert, AlertEvents>(this);

        _alert = [[NSAlert alloc] init];

        this->SetMessage(message)
            ->SetTitle(title)
            ->SetStyle(style)
            ->AddButton(buttonLabel, buttonValue);
    }

    Events<Alert, AlertEvents> *Alert::Events() { return _events; }

    void Alert::Open(std::function<void (std::string)> completionHandler)
    {
        this->Events()->EmitEvent(AlertEvents::WillOpen);

        [_alert
            beginSheetModalForWindow: _window
            completionHandler:^void (NSModalResponse responseCode) {
                this->Events()->EmitEvent(AlertEvents::WillClose);
                
                if (completionHandler != nullptr)
                {
                    completionHandler(_responseValues.at(responseCode));
                }

                [_alert release];
            }
        ];
        
        this->Events()->EmitEvent(AlertEvents::DidOpen);
    }

    Alert *Alert::SetStyle(NSAlertStyle style)
    {
        [_alert setAlertStyle: style];
        return this;
    }

    Alert *Alert::SetTitle(std::string title)
    {
        [_alert setMessageText: [NSString stringWithUTF8String: title.c_str()]];
        return this;
    }

    Alert *Alert::SetMessage(std::string message)
    {
        [_alert setInformativeText: [NSString stringWithUTF8String: message.c_str()]];
        return this;
    }

    Alert *Alert::AddButton(std::string label, std::string value)
    {
        NSModalResponse modalResponse = NSAlertFirstButtonReturn;
        if (_buttonCount == 1) { modalResponse = NSAlertSecondButtonReturn; }
        else if (_buttonCount == 2) { modalResponse = NSAlertThirdButtonReturn; }
        else if (_buttonCount > 2)
        {
            Log::WriteLine("Can't add more than 3 buttons.");
            return this;
        }
        
        _buttonCount++;

        _responseValues.insert(std::pair<NSModalResponse, std::string>(modalResponse, value));
        [_alert addButtonWithTitle: [NSString stringWithUTF8String: label.c_str()]];

        return this;
    }
}