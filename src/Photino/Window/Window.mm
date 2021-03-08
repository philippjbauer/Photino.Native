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
        [this->NativeWindow() release];
    }

    /**
    * Class Methods
    */
    Window *Window::Init()
    {
        _events = new ::Events<Window, WindowEvents>(this);

        _nativeWindow = this->CreateNativeWindow();
        _webView = this->CreateWebView(this->NativeWindow());

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

    Photino::WebView *Window::CreateWebView( NSWindow *nativeWindow)
    {
        Photino::WebView *webview = new Photino::WebView(nativeWindow, true);

        return webview;
    }

    NSWindow *Window::NativeWindow() { return _nativeWindow; }
    WebView *Window::WebView() { return _webView; }
    Events<Window, WindowEvents> *Window::Events() { return _events; }

    void Window::Open()
    {
        this->Show();
    }

    void Window::Close()
    {
        [this->NativeWindow() performClose: this->NativeWindow()];
    }

    Window *Window::Show()
    {
        this->Events()->EmitEvent(WindowEvents::WindowWillShow);

        if (this->NativeWindow().miniaturized)
        {
            [this->NativeWindow() deminiaturize: this->NativeWindow()];
        }

        [this->NativeWindow() orderFrontRegardless];

        this->Events()->EmitEvent(WindowEvents::WindowDidShow);
        return this;
    }

    Window *Window::Hide()
    {
        this->Events()->EmitEvent(WindowEvents::WindowWillHide);

        [this->NativeWindow() miniaturize: this->NativeWindow()];

        this->Events()->EmitEvent(WindowEvents::WindowDidHide);
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
    // Parent
    Window *Window::GetParent() { return _parent; }
    Window *Window::SetParent(Window *value) {
        _parent = value;

        _nativeWindow.parentWindow = value->NativeWindow();

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

        [this->NativeWindow() setTitle: windowTitle];

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
    WindowSize Window::GetSize()
    {
        NSRect frame = [this->NativeWindow() frame];
        WindowSize windowSize(
            (int)roundf(frame.size.width),
            (int)roundf(frame.size.height));
        
        return windowSize;
    }

    Window *Window::SetSize(WindowSize value)
    {
        this->Events()->EmitEvent(WindowEvents::WindowWillSetSize);

        CGFloat width = (CGFloat)value.width;
        CGFloat height = (CGFloat)value.height;

        NSRect frame = [this->NativeWindow() frame];
        frame.size = CGSizeMake(width, height);

        [
            this->NativeWindow()
            setFrame: frame
            display: YES
        ];

        this->Events()->EmitEvent(WindowEvents::WindowDidSetSize);
        return this;
    }

    Window *Window::SetSize(int width, int height)
    {
        return this->SetSize(WindowSize(width, height));
    }

    // Location
    WindowLocation Window::GetLocation()
    {
        NSRect frame = [this->NativeWindow() frame];
        WindowLocation windowLocation(
            (int)roundf(frame.origin.x),
            (int)roundf(frame.origin.y));
        
        return windowLocation;
    }

    Window *Window::SetLocation(WindowLocation value)
    {
        this->Events()->EmitEvent(WindowEvents::WindowWillSetLocation);

        CGFloat left = (CGFloat)value.left;
        CGFloat top = (CGFloat)value.left;

        CGPoint location = CGPointMake(left, top);

        [this->NativeWindow() setFrameTopLeftPoint: location];

        this->Events()->EmitEvent(WindowEvents::WindowDidSetLocation);
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
            this->NativeWindow().styleMask |= NSWindowStyleMaskResizable;
        }
        else
        {
            this->NativeWindow().styleMask &= ~NSWindowStyleMaskResizable;
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
            [this->NativeWindow() toggleFullScreen: this->NativeWindow()];
        }

        return this;
    }
}
