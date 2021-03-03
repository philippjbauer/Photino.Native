#import "PhotinoWebView.h"
#import "PhotinoWebViewUiDelegate.h"

using namespace std;

/**
 * Construct PhotinoWebView
 */
PhotinoWebView::PhotinoWebView(
    NSWindow* nativeWindow,
    bool enableDevTools)
{
    this->Init(nativeWindow)
        ->HasEnabledDevTools(enableDevTools);
}

PhotinoWebView::~PhotinoWebView()
{
    [_configuration release];
    [_nativeWebView release];
}

/**
 * Class Methods
 */
PhotinoWebView* PhotinoWebView::Init(NSWindow* nativeWindow)
{
    _configuration = this->CreateConfiguration();
    _nativeWebView = this->CreateNativeWebView(nativeWindow, _configuration);

    return this;
}

WKWebViewConfiguration* PhotinoWebView::CreateConfiguration()
{
    WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
    
    return configuration;
}

WKWebView* PhotinoWebView::CreateNativeWebView(
    NSWindow* nativeWindow,
    WKWebViewConfiguration* configuration
)
{
    NSString* photinoWindowExtensions = @"\n"
    "   window.__receiveMessageCallbacks = [];\n"
    "   \n"
    "   window.__dispatchMessageCallback = function(message)\n"
    "   {\n"
    "       window.__receiveMessageCallbacks\n"
    "           .forEach(function(callback) \n"
    "           {\n"
    "               callback(message);\n"
    "           });\n"
    "   };\n"
    "   \n"
    "   window.external = {\n"
    "       postMessage: function(message)\n"
    "       {\n"
    "           window.webkit\n"
    "               .messageHandlers\n"
    "               .photinointerop\n"
    "               .postMessage(message);\n"
    "       },\n"
    "       receiveMessage: function(callback)\n"
    "       {\n"
    "           window.__receiveMessageCallbacks.push(callback);\n"
    "       }\n"
    "   };\n";

    WKUserScript* userScript = [
        [WKUserScript alloc]
        initWithSource: photinoWindowExtensions
        injectionTime: WKUserScriptInjectionTimeAtDocumentStart
        forMainFrameOnly: YES
    ];

    configuration.userContentController = [[WKUserContentController new] autorelease];
    [configuration.userContentController addUserScript: userScript];

    // Create WebViewUiDelegate
    PhotinoWebViewUiDelegate* uiDelegate = [[
        [PhotinoWebViewUiDelegate alloc]
        init
    ] autorelease];

    uiDelegate->_nativeWindow = nativeWindow;

    // Create native WebView
    WKWebView* nativeWebView = [
        [WKWebView alloc]
        initWithFrame: nativeWindow.contentView.frame
        configuration: configuration
    ];

    [nativeWebView setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];

    nativeWebView.UIDelegate = uiDelegate;

    [
        [NSNotificationCenter defaultCenter]
        addObserver: uiDelegate
        selector: @selector(windowDidResize:)
        name: NSWindowDidResizeNotification
        object: nativeWindow
    ];

    [
        [NSNotificationCenter defaultCenter]
        addObserver: uiDelegate
        selector: @selector(windowDidMove:)
        name: NSWindowDidMoveNotification
        object: nativeWindow
    ];

    [
        [NSNotificationCenter defaultCenter]
        addObserver: uiDelegate
        selector: @selector(windowWillClose:)
        name: NSWindowWillCloseNotification
        object: nativeWindow
    ];

    // Add native WebView to native Window
    [nativeWindow.contentView addSubview: nativeWebView];
    [nativeWindow.contentView setAutoresizesSubviews: YES];

    return nativeWebView;
}

PhotinoWebView* PhotinoWebView::LoadResource(string resource)
{
    WKWebView* webview = this->GetNativeWebView();

    NSString* resourceString = [[
        NSString stringWithUTF8String: resource.c_str()
    ] autorelease];
    
    NSURL* url= [[
        NSURL URLWithString: resourceString
    ] autorelease];

    NSURLRequest* request= [[
        NSURLRequest requestWithURL: url
    ] autorelease];
    
    [webview loadRequest: request];

    return this;
}

PhotinoWebView* PhotinoWebView::LoadHtmlString(string content)
{
    WKWebView* webview = this->GetNativeWebView();

    NSString* htmlString = [[
        NSString
        stringWithUTF8String: content.c_str()
    ] autorelease];

    [
        webview
        loadHTMLString: htmlString
        baseURL: nil
    ];

    return this;
}

/**
 * Getters & Setters
 */
// Configuration
WKWebView* PhotinoWebView::GetNativeWebView() { return _nativeWebView; }

// Configuration
WKWebViewConfiguration* PhotinoWebView::GetConfiguration() { return _configuration; }

// HasEnabledDevTools
bool PhotinoWebView::HasEnabledDevTools() { return _hasEnabledDevTools; }
PhotinoWebView* PhotinoWebView::HasEnabledDevTools(bool value)
{
    [
        _configuration.preferences
        setValue: value ? @YES : @NO
        forKey: @"developerExtrasEnabled"
    ];

    _hasEnabledDevTools = value;

    return this;
}
