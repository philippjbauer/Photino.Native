#include <cmath>

#include "../../PhotinoHelpers/MakeMonitor.h"

#include "Window.h"
#include "WindowDelegate.h"

namespace Photino
{
    /**
    * Construct Window
    */
    Window::Window(std::string title)
    {
        NSScreen *mainScreen = [[NSScreen screens] objectAtIndex: 0];

        Monitor monitor = PhotinoHelpers::MakeMonitor(mainScreen, false);

        this->Init()
            ->SetTitle(title)
            ->SetMonitor(monitor)
            ->SetSize(800, 600)
            ->Center()
            ->IsResizable(true)
            ->IsFullscreen(false)
            ->Open();
    }

    Window::Window(
        std::string title,
        Monitor monitor,
        int width,
        int height,
        int left,
        int top,
        bool isResizable,
        bool isFullscreen)
    {
        this->Init()
            ->SetTitle(title)
            ->SetMonitor(monitor)
            ->SetSize(width, height)
            ->SetLocation(left, top)
            ->IsResizable(isResizable)
            ->IsFullscreen(isFullscreen)
            ->Open();
    }

    Window::~Window()
    {
        delete _webView;
        [this->GetNativeWindow() release];
    }

    /**
    * Class Methods
    */
    Window *Window::Init()
    {
        _nativeWindow = this->CreateNativeWindow();
        _webView = this->CreateWebView(this->GetNativeWindow());

        return this;
    }

    NSWindow *Window::CreateNativeWindow()
    {
        WindowSize size = this->GetSize();
        WindowLocation location = this->GetLocation();

        NSRect nsWindowFrame = NSMakeRect(
            size.width,
            size.height,
            location.left,
            location.top);
        
        NSWindowStyleMask nsWindowStyleMask =
            NSWindowStyleMaskTitled
            | NSWindowStyleMaskClosable
            | NSWindowStyleMaskMiniaturizable
            | NSWindowStyleMaskResizable;
        
        NSWindow *window = [
            [NSWindow alloc]
            initWithContentRect: nsWindowFrame
            styleMask: nsWindowStyleMask
            backing: NSBackingStoreBuffered
            defer: NO
        ];

        // Add WindowDelegate
        WindowDelegate *windowDelegate = [[
            [WindowDelegate alloc] init
        ] autorelease];

        windowDelegate->window = this;

        window.delegate = windowDelegate;

        return window;
    }

    WebView *Window::CreateWebView( NSWindow *nativeWindow)
    {
        WebView *webview = new WebView(nativeWindow, true);

        return webview;
    }

    void Window::Open()
    {
        this->Show();
    }

    void Window::Close()
    {
        [this->GetNativeWindow() performClose: this->GetNativeWindow()];
    }

    Window *Window::Show()
    {
        if (this->GetNativeWindow().miniaturized)
        {
            [this->GetNativeWindow() deminiaturize: this->GetNativeWindow()];
        }

        [this->GetNativeWindow() orderFrontRegardless];

        return this;
    }

    Window *Window::Hide()
    {
        [this->GetNativeWindow() miniaturize: this->GetNativeWindow()];

        return this;
    }

    Window *Window::Center()
    {
        Monitor monitor = this->GetMonitor();
        MonitorFrame workArea = monitor.workArea;

        WindowSize size = this->GetSize();

        int left = round((workArea.width / 2) - (size.width / 2));
        int top = round((workArea.height / 2) - (size.height / 2));

        return this->SetLocation(left, top);
    }

    /**
    * Getters & Setters
    */
    // Window
    NSWindow *Window::GetNativeWindow() { return _nativeWindow; }

    // WebView
    WebView *Window::GetWebView() { return _webView; }

    // Parent
    Window *Window::GetParent() { return _parent; }
    Window *Window::SetParent(Window *value) {
        _parent = value;

        _nativeWindow.parentWindow = value->GetNativeWindow();

        return this;
    }

    // Title
    std::string Window::GetTitle() { return _title; }
    Window *Window::SetTitle(std::string value)
    {
        _title = value;

        NSString *windowTitle = [[
            NSString
            stringWithUTF8String: value.c_str()
        ] autorelease];

        [this->GetNativeWindow() setTitle: windowTitle];

        return this;
    }

    // Monitor
    Monitor Window::GetMonitor() { return _monitor; }
    Window *Window::SetMonitor(Monitor value)
    {
        _monitor = value;

        return this;
    }

    // Size
    WindowSize Window::GetSize() { return _size; }

    Window *Window::SetSize(WindowSize value)
    {
        _size = value;

        CGFloat width = (CGFloat)value.width;
        CGFloat height = (CGFloat)value.height;

        NSRect frame = [this->GetNativeWindow() frame];
        frame.size = CGSizeMake(width, height);

        [
            this->GetNativeWindow()
            setFrame: frame
            display: YES
        ];

        return this;
    }

    Window *Window::SetSize(int width, int height)
    {
        return this->SetSize(WindowSize(width, height));
    }

    // Location
    WindowLocation Window::GetLocation() { return _location; }

    Window *Window::SetLocation(WindowLocation value)
    {
        _location = value;

        CGFloat left = (CGFloat)value.left;
        CGFloat top = (CGFloat)value.left;

        CGPoint location = CGPointMake(left, top);

        [this->GetNativeWindow() setFrameTopLeftPoint: location];

        return this;
    }

    Window *Window::SetLocation(int left, int top)
    {
        return this->SetLocation(WindowLocation(left, top));
    }

    // IsResizable
    bool Window::IsResizable() { return _isResizable; }
    Window *Window::IsResizable(bool value)
    {
        if (value == true)
        {
            this->GetNativeWindow().styleMask |= NSWindowStyleMaskResizable;
        }
        else
        {
            this->GetNativeWindow().styleMask &= ~NSWindowStyleMaskResizable;
        }
        
        _isResizable = value;

        return this;
    }

    // IsFullscreen
    bool Window::IsFullscreen() { return _isFullscreen; }
    Window *Window::IsFullscreen(bool value)
    {
        if (_isFullscreen != value)
        {
            _isFullscreen = value;
            [this->GetNativeWindow() toggleFullScreen: this->GetNativeWindow()];
        }

        return this;
    }
}
