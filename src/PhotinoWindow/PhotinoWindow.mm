#import "PhotinoWindow.h"

using namespace std;

/**
 * Construct PhotinoWindow
 */
PhotinoWindow::PhotinoWindow(
    string windowTitle,
    int width,
    int height,
    int left,
    int top,
    bool resizable,
    bool fullscreen)
{
    this->Init()
        ->SetTitle(windowTitle)
        ->SetSize(WindowSize(width, height))
        ->SetLocation(WindowLocation(left, top))
        ->IsResizable(resizable)
        ->IsFullscreen(fullscreen)
        ->Open();
}

PhotinoWindow::~PhotinoWindow()
{
    _photinoWebView->~PhotinoWebView();
    [_nativeWindow release];
}

/**
 * Class Methods
 */
PhotinoWindow* PhotinoWindow::Init()
{
    _nativeWindow = this->CreateNativeWindow();
    _photinoWebView = this->CreatePhotinoWebView(_nativeWindow);

    return this;
}

NSWindow* PhotinoWindow::CreateNativeWindow()
{
    WindowSize size = this->GetSize();
    WindowLocation location = this->GetLocation();

    NSRect windowContentRect = NSMakeRect(size.width, size.height, location.left, location.top);
    
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
    [_nativeWindow close];
}

PhotinoWindow* PhotinoWindow::Show()
{
    if (_nativeWindow.miniaturized)
    {
        [_nativeWindow deminiaturize: nil];
    }

    [_nativeWindow makeKeyAndOrderFront: nil];

    return this;
}

PhotinoWindow* PhotinoWindow::Hide()
{
    [_nativeWindow miniaturize: nil];

    return this;
}

bool PhotinoWindow::IsResizable() { return _isResizable; }
PhotinoWindow* PhotinoWindow::IsResizable(bool value)
{
    if (value == true)
    {
        _nativeWindow.styleMask |= NSWindowStyleMaskResizable;
    }
    else
    {
        _nativeWindow.styleMask &= ~NSWindowStyleMaskResizable;
    }
    
    _isResizable = value;

    return this;
}

bool PhotinoWindow::IsFullscreen() { return _isFullscreen; }
PhotinoWindow* PhotinoWindow::IsFullscreen(bool value)
{
    if (_isFullscreen != value)
    {
        _isFullscreen = value;
        [_nativeWindow toggleFullScreen: nil];
    }

    return this;
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
string PhotinoWindow::GetTitle() { return _title; }
PhotinoWindow* PhotinoWindow::SetTitle(string value)
{
    _title = value;

    NSString* windowTitle = [[
        NSString
        stringWithUTF8String: value.c_str()
    ] autorelease];

    [_nativeWindow setTitle: windowTitle];

    return this;
}

// Size
WindowSize PhotinoWindow::GetSize() { return _size; }
PhotinoWindow* PhotinoWindow::SetSize(WindowSize value)
{
    _size = value;

    CGFloat width = (CGFloat)value.width;
    CGFloat height = (CGFloat)value.height;

    NSRect windowContentRect = [_nativeWindow frame];
    windowContentRect.size = CGSizeMake(width, height);

    [
        _nativeWindow
        setFrame: windowContentRect
        display: YES
    ];

    return this;
}

// Location
WindowLocation PhotinoWindow::GetLocation() { return _location; }
PhotinoWindow* PhotinoWindow::SetLocation(WindowLocation value)
{
    _location = value;

    CGFloat top = (CGFloat)value.top;
    CGFloat left = (CGFloat)value.left;

    NSRect windowContentRect = [_nativeWindow frame];
    windowContentRect.origin.y = windowContentRect.size.height - top;
    windowContentRect.origin.x = left;

    [
        _nativeWindow
        setFrame: windowContentRect
        display: YES
    ];

    return this;
}
