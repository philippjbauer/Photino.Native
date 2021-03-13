#pragma once
#include <functional>
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
            Events<Alert, AlertEvents> *_events;

            NSAlert *_alert;
            NSWindow *_nativeWindow;
            std::string _title;
            std::string _message;
            NSAlertStyle _alertStyle;

            Alert *Init();

        public:
            /**
             *  Constructor / Destructor
             */
            Alert(
                NSWindow *nativeWindow,
                std::string title,
                std::string message,
                NSAlertStyle alertStyle = NSAlertStyleInformational);

            ~Alert();

            /**
             * Class Methods
             */
            Events<Alert, AlertEvents> *Events();
            NSAlert *NativeAlert();

            void Open(void completionHandler (Alert *alert) = nullptr);
    };
}
