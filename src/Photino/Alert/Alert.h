#pragma once
#include <functional>
#include <map>
#include <string>
#include <Cocoa/Cocoa.h>
#include "../Events/Events.h"

namespace Photino
{
    enum AlertEvents
    {
        WillOpen,
        DidOpen,
        WillClose
    };

    class Alert
    {
        private:
            NSWindow *_window;
            NSAlert *_alert;
            Events<Alert, AlertEvents> *_events;

            unsigned char _buttonCount = 0;
            std::map<NSModalResponse, std::string> _responseValues;

        public:
            Alert(
                NSWindow *window,
                std::string message,
                std::string title = "Info",
                NSAlertStyle style = NSAlertStyleInformational,
                std::string buttonLabel = "Confirm",
                std::string buttonValue = "confirmed");

            Events<Alert, AlertEvents> *Events();

            void Open(std::function<void (std::string)> completionHandler = nullptr);

            Alert *SetStyle(NSAlertStyle style);
            Alert *SetTitle(std::string title);
            Alert *SetMessage(std::string message);
            Alert *AddButton(std::string label, std::string value);
    };
}
