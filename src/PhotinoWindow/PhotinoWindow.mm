#include <cmath>
#include "PhotinoWindow.h"
#include "PhotinoWindowDelegate.h"

/**
 * Construct PhotinoWindow
 */
PhotinoWindow::PhotinoWindow(std::string title)
{
    NSScreen* mainScreen = [[NSScreen screens] objectAtIndex: 0];

    Monitor monitor = MakeMonitor(mainScreen, false);

    this->Init()
        ->SetTitle(title)
        ->SetMonitor(monitor)
        ->SetSize(800, 600)
        ->Center()
        ->IsResizable(true)
        ->IsFullscreen(false)
        ->Open();
}

PhotinoWindow::PhotinoWindow(
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

PhotinoWindow::~PhotinoWindow()
{
    delete _photinoWebView;
    [this->GetNativeWindow() release];
}

/**
 * Class Methods
 */
PhotinoWindow* PhotinoWindow::Init()
{
    _nativeWindow = this->CreateNativeWindow();
    _photinoWebView = this->CreatePhotinoWebView(this->GetNativeWindow());

    return this;
}

NSWindow* PhotinoWindow::CreateNativeWindow()
{
    WindowSize size = this->GetSize();
    WindowLocation location = this->GetLocation();

    NSRect windowContentRect = NSMakeRect(
        size.width,
        size.height,
        location.left,
        location.top);
    
    NSWindowStyleMask windowStyleMask =
        NSWindowStyleMaskTitled
        | NSWindowStyleMaskClosable
        | NSWindowStyleMaskMiniaturizable
        | NSWindowStyleMaskResizable;
    
    NSWindow* window = [
        [NSWindow alloc]
        initWithContentRect: windowContentRect
        styleMask: windowStyleMask
        backing: NSBackingStoreBuffered
        defer: NO
    ];

    // Add WindowDelegate
    PhotinoWindowDelegate* windowDelegate = [[
        [PhotinoWindowDelegate alloc] init
    ] autorelease];

    windowDelegate->photinoWindow = this;

    window.delegate = windowDelegate;

    return window;
}

PhotinoWebView* PhotinoWindow::CreatePhotinoWebView(NSWindow* nativeWindow)
{
    PhotinoWebView* webview = new PhotinoWebView(nativeWindow, true);

    return webview;
}

void PhotinoWindow::Open()
{
    this->Show();
}

void PhotinoWindow::Close()
{
    [this->GetNativeWindow() performClose: this->GetNativeWindow()];
}

PhotinoWindow* PhotinoWindow::Show()
{
    if (this->GetNativeWindow().miniaturized)
    {
        [this->GetNativeWindow() deminiaturize: this->GetNativeWindow()];
    }

    [this->GetNativeWindow() orderFrontRegardless];

    return this;
}

PhotinoWindow* PhotinoWindow::Hide()
{
    [this->GetNativeWindow() miniaturize: this->GetNativeWindow()];

    return this;
}

PhotinoWindow* PhotinoWindow::Center()
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
NSWindow* PhotinoWindow::GetNativeWindow() { return _nativeWindow; }

// WebView
PhotinoWebView* PhotinoWindow::GetPhotinoWebView() { return _photinoWebView; }

// Parent
PhotinoWindow* PhotinoWindow::GetParent() { return _parent; }
PhotinoWindow* PhotinoWindow::SetParent(PhotinoWindow *value) {
    _parent = value;

    _nativeWindow.parentWindow = value->GetNativeWindow();

    return this;
}

// Title
std::string PhotinoWindow::GetTitle() { return _title; }
PhotinoWindow* PhotinoWindow::SetTitle(std::string value)
{
    _title = value;

    NSString* windowTitle = [[
        NSString
        stringWithUTF8String: value.c_str()
    ] autorelease];

    [this->GetNativeWindow() setTitle: windowTitle];

    return this;
}

// Monitor
Monitor PhotinoWindow::GetMonitor() { return _monitor; }
PhotinoWindow* PhotinoWindow::SetMonitor(Monitor value)
{
    _monitor = value;

    return this;
}

// Size
WindowSize PhotinoWindow::GetSize() { return _size; }

PhotinoWindow* PhotinoWindow::SetSize(WindowSize value)
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

PhotinoWindow* PhotinoWindow::SetSize(int width, int height)
{
    return this->SetSize(WindowSize(width, height));
}

// Location
WindowLocation PhotinoWindow::GetLocation() { return _location; }

PhotinoWindow* PhotinoWindow::SetLocation(WindowLocation value)
{
    _location = value;

    CGFloat left = (CGFloat)value.left;
    CGFloat top = (CGFloat)value.left;

    CGPoint location = CGPointMake(left, top);

    [this->GetNativeWindow() setFrameTopLeftPoint: location];

    return this;
}

PhotinoWindow* PhotinoWindow::SetLocation(int left, int top)
{
    return this->SetLocation(WindowLocation(left, top));
}

// IsResizable
bool PhotinoWindow::IsResizable() { return _isResizable; }
PhotinoWindow* PhotinoWindow::IsResizable(bool value)
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
bool PhotinoWindow::IsFullscreen() { return _isFullscreen; }
PhotinoWindow* PhotinoWindow::IsFullscreen(bool value)
{
    if (_isFullscreen != value)
    {
        _isFullscreen = value;
        [this->GetNativeWindow() toggleFullScreen: this->GetNativeWindow()];
    }

    return this;
}