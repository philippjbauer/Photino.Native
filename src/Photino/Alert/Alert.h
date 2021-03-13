#pragma once
#include <string>
#include <map>
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
                std::string buttonLabel = "OK",
                std::string buttonValue = "OK");

            Events<Alert, AlertEvents> *Events();

            void Open(void completionHandler(std::string response) = nullptr);

            Alert *SetStyle(NSAlertStyle style);
            Alert *SetTitle(std::string title);
            Alert *SetMessage(std::string message);
            Alert *AddButton(std::string label, std::string value);
    };
}
