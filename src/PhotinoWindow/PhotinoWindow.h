#import <cstdio>
#import <string>
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#import "../PhotinoWebView/PhotinoWebView.h"
#import "../Structs/WindowLocation.h"
#import "../Structs/WindowSize.h"

using namespace std;

class PhotinoWindow
{
    private:
        NSWindow* _nativeWindow;
        PhotinoWebView* _photinoWebView;

        PhotinoWindow* _parent;

        string _title;
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
        PhotinoWindow(
            string windowTitle,
            int width = 800,
            int height = 600,
            int left = 20,
            int top = 20,
            bool resizable = true,
            bool fullscreen = false);

        ~PhotinoWindow();

        /**
         * Class Methods
         */
        void Open();
        void Close();

        PhotinoWindow* Show();
        PhotinoWindow* Hide();

        bool IsResizable();
        PhotinoWindow* IsResizable(bool value);

        bool IsFullscreen();
        PhotinoWindow* IsFullscreen(bool value);

        /**
         * Getters & Setters
         */
        // Window
        NSWindow* GetNativeWindow();

        // WebView
        PhotinoWebView* GetPhotinoWebView();

        // Parent
        PhotinoWindow* GetParent();
        PhotinoWindow* SetParent(PhotinoWindow *value);

        // Title
        string GetTitle();
        PhotinoWindow* SetTitle(string value);

        // Size
        WindowSize GetSize();
        PhotinoWindow* SetSize(WindowSize value);

        // Location
        WindowLocation GetLocation();
        PhotinoWindow* SetLocation(WindowLocation value);
};
