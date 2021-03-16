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
        Log::WriteLine("Destructing Window");
        _nativeWindow = nil;
        delete _events;
        delete _webView;
    }

    /**
    * Class Methods
    */
    Window *Window::Init()
    {
        _events = new Photino::Events<Window, WindowEvents>(this);

        _nativeWindow = this->CreateNativeWindow();
        _webView = this->CreateWebView(this->NativeWindow());

        return this;
    }

    NSWindow *Window::CreateNativeWindow()
    {
        NSRect windowFrame = NSMakeRect(1, 1, 1, 1);
        
        NSWindowStyleMask windowStyleMask =
              NSWindowStyleMaskTitled
            | NSWindowStyleMaskClosable
            | NSWindowStyleMaskMiniaturizable
            | NSWindowStyleMaskResizable;
        
        NSWindow *window = [
            [NSWindow alloc]
            initWithContentRect: windowFrame
            styleMask: windowStyleMask
            backing: NSBackingStoreBuffered
            defer: YES
        ];

        // Add WindowDelegate
        WindowDelegate *windowDelegate = [WindowDelegate new];

        windowDelegate->window = this;

        window.delegate = windowDelegate;

        return window;
    }

    Photino::WebView *Window::CreateWebView(NSWindow *nativeWindow)
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

    void Window::ForceClose()
    {
        [this->NativeWindow() close];
    }

    Window *Window::Show()
    {
        this->Events()->EmitEvent(WindowEvents::WindowWillShow);

        if (this->NativeWindow().miniaturized)
        {
            [this->NativeWindow() deminiaturize: this->NativeWindow()];
        }

        [this->NativeWindow() makeKeyAndOrderFront: nil];

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

        NSString *windowTitle = [NSString stringWithUTF8String: value.c_str()];

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

        NSRect frame = [this->NativeWindow() frame];

        CGFloat oldHeight = frame.size.height;

        CGFloat width = (CGFloat)value.width;
        CGFloat height = (CGFloat)value.height;

        frame.size = CGSizeMake(width, height);
        frame.origin.y -= height - oldHeight;

        [
            this->NativeWindow()
            setFrame: frame
            display: true
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
        MonitorFrame workArea = this->GetMonitor().workArea;
        NSRect frame = [this->NativeWindow() frame];

        int left = (int)roundf(frame.origin.x);
        int bottom = (int)roundf(frame.origin.y);

        int top = workArea.height - (bottom + frame.size.height);

        WindowLocation windowLocation(left, top);
        
        return windowLocation;
    }

    Window *Window::SetLocation(WindowLocation value)
    {
        this->Events()->EmitEvent(WindowEvents::WindowWillSetLocation);

        WindowSize size = this->GetSize();
        MonitorFrame workArea = this->GetMonitor().workArea;

        CGFloat left = (CGFloat)value.left;
        CGFloat top = (CGFloat)(workArea.height - (value.top + size.height));

        CGPoint location = CGPointMake(left, top);

        [this->NativeWindow() setFrameOrigin: location];

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
