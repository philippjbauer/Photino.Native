#pragma once
#include <string>
#include <Cocoa/Cocoa.h>

#include "../Helpers/Monitor.h"
#include "../PhotinoWebView/PhotinoWebView.h"
#include "../Structs/Monitor.h"
#include "../Structs/WindowLocation.h"
#include "../Structs/WindowSize.h"

class PhotinoWindow
{
    private:
        NSWindow* _nativeWindow;
        PhotinoWebView* _photinoWebView;

        PhotinoWindow* _parent;

        std::string _title;

        Monitor _monitor;
        WindowSize _size;
        WindowLocation _location;

        bool _isResizable;
        bool _isFullscreen;

        /**
         * Class Methods
         */
        PhotinoWindow* Init();
        NSWindow* CreateNativeWindow();
        PhotinoWebView* CreatePhotinoWebView(NSWindow* nativeWindow);

    public:
        /**
         *  Constructor / Destructor
         */
        PhotinoWindow(std::string title);

        PhotinoWindow(
            std::string title,
            Monitor monitor,
            int width = 800,
            int height = 600,
            int left = 20,
            int top = 20,
            bool isResizable = true,
            bool isfullscreen = false);

        ~PhotinoWindow();

        /**
         * Class Methods
         */
        void Open();
        void Close();

        PhotinoWindow* Show();
        PhotinoWindow* Hide();

        PhotinoWindow* Center();

        /**
         * Getters & Setters
         */
        // Window
        NSWindow* GetNativeWindow();

        // WebView
        PhotinoWebView* GetPhotinoWebView();

        // Parent
        PhotinoWindow* GetParent();
        PhotinoWindow* SetParent(PhotinoWindow* value);

        // Title
        std::string GetTitle();
        PhotinoWindow* SetTitle(std::string value);

        // Monitor
        Monitor GetMonitor();
        PhotinoWindow* SetMonitor(Monitor value);

        // Size
        WindowSize GetSize();
        PhotinoWindow* SetSize(WindowSize value);
        PhotinoWindow* SetSize(int width, int height);

        // Location
        WindowLocation GetLocation();
        PhotinoWindow* SetLocation(WindowLocation value);
        PhotinoWindow* SetLocation(int left, int top);

        // IsResizable
        bool IsResizable();
        PhotinoWindow* IsResizable(bool value);

        // IsFullscreen
        bool IsFullscreen();
        PhotinoWindow* IsFullscreen(bool value);
};
