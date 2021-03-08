#pragma once
#include <string>
#include <vector>
#include <Cocoa/Cocoa.h>

#include "../Events/Events.h"
#include "../Structs/Monitor.h"
#include "../Structs/WindowLocation.h"
#include "../Structs/WindowSize.h"
#include "../WebView/WebView.h"

namespace Photino
{
    enum WindowEvents
    {
        WindowShouldClose,
        WindowWillClose,
        WindowWillShow,
        WindowDidShow,
        WindowWillHide,
        WindowDidHide,
        WindowDidResize,
        WindowDidMove,
        WindowWillSetSize,
        WindowDidSetSize,
        WindowWillSetLocation,
        WindowDidSetLocation,
    };

    class Window
    {
        private:
            NSWindow *_nativeWindow;
            WebView *_webView;
            
            Events<Window, WindowEvents> *_events;

            Window *_parent;

            std::string _title;

            Monitor _monitor;

            bool _isResizable;
            bool _isFullscreen;

            /**
             * Class Methods
             */
            Window *Init();
            NSWindow *CreateNativeWindow();
            WebView *CreateWebView(NSWindow *nativeWindow);

        public:
            /**
             *  Constructor / Destructor
             */
            Window(std::string title);

            Window(
                std::string title,
                Monitor monitor,
                int width = 800,
                int height = 600,
                int left = 20,
                int top = 20,
                bool isResizable = true,
                bool isfullscreen = false);

            ~Window();

            /**
             * Class Methods
             */
            NSWindow *NativeWindow();
            WebView *WebView();
            Events<Window, WindowEvents> *Events();

            void Open();
            void Close();

            Window *Show();
            Window *Hide();

            Window *Center();

            /**
             * Getters & Setters
             */
            // Parent
            Window *GetParent();
            Window *SetParent(Window *value);

            // Title
            std::string GetTitle();
            Window *SetTitle(std::string value);

            // Monitor
            Monitor GetMonitor();
            Window *SetMonitor(Monitor value);

            // Size
            WindowSize GetSize();
            Window *SetSize(WindowSize value);
            Window *SetSize(int width, int height);

            // Location
            WindowLocation GetLocation();
            Window *SetLocation(WindowLocation value);
            Window *SetLocation(int left, int top);

            // IsResizable
            bool IsResizable();
            Window *IsResizable(bool value);

            // IsFullscreen
            bool IsFullscreen();
            Window *IsFullscreen(bool value);
    };

    typedef std::vector<Window*> Windows;
}
