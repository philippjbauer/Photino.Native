#include "WebView.h"
#include "WebViewUiDelegate.h"

namespace Photino
{
    /**
    * Construct WebView
    */
    WebView::WebView(
        NSWindow* nativeWindow,
        bool enableDevTools)
    {
        this->Init(nativeWindow)
            ->HasEnabledDevTools(enableDevTools);
    }

    WebView::~WebView()
    {
        [this->GetConfiguration() release];
        [this->GetNativeWebView() release];
    }

    /**
    * Class Methods
    */
    WebView* WebView::Init(NSWindow* nativeWindow)
    {
        _configuration = this->CreateConfiguration();
        _nativeWebView = this->CreateNativeWebView(nativeWindow, this->GetConfiguration());

        return this;
    }

    WKWebViewConfiguration* WebView::CreateConfiguration()
    {
        WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
        
        return configuration;
    }

    WKWebView* WebView::CreateNativeWebView(
        NSWindow* nativeWindow,
        WKWebViewConfiguration* configuration
    )
    {
        // Future use of TextFile when I found a way to include from
        // application path / bundle path in a cross-platform fashion.
        // TextFile webViewExtensions(APP_PATH + "/Assets/WebViewExtensions.js");

        std::string webViewExtensions = R"js(\
window.__receiveMessageCallbacks = [];\
\
window.__dispatchMessageCallback = function(message)\
{\
    window.__receiveMessageCallbacks\
        .forEach(function(callback) \
        {\
            callback(message);\
        });\
};\
\
window.external = {\
    postMessage: function(message)\
    {\
        window.webkit\
            .messageHandlers\
            .photinointerop\
            .postMessage(message);\
    },\
    receiveMessage: function(callback)\
    {\
        window.__receiveMessageCallbacks.push(callback);\
    }\
};\
)js";

        NSString* userScriptSource = [
            NSString
            stringWithUTF8String: webViewExtensions.c_str()
        ];

        WKUserScript* userScript =[ [
            [WKUserScript alloc]
            initWithSource: userScriptSource
            injectionTime: WKUserScriptInjectionTimeAtDocumentStart
            forMainFrameOnly: YES
        ] autorelease];

        configuration.userContentController = [[
            [WKUserContentController alloc] init
        ] autorelease];
        
        [configuration.userContentController addUserScript: userScript];

        // Create WebViewUiDelegate
        WebViewUiDelegate* uiDelegate = [[
            [WebViewUiDelegate alloc]
            init
        ] autorelease];
        
        [
            configuration.userContentController
            addScriptMessageHandler: uiDelegate
            name: @"photinointerop"
        ];

        // Create native WebView
        WKWebView* nativeWebView = [
            [WKWebView alloc]
            initWithFrame: nativeWindow.contentView.frame
            configuration: configuration
        ];

        [nativeWebView setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];

        nativeWebView.UIDelegate = uiDelegate;

        // Add native WebView to native Window
        [nativeWindow.contentView addSubview: nativeWebView];
        [nativeWindow.contentView setAutoresizesSubviews: YES];

        return nativeWebView;
    }

    WebView* WebView::LoadResource(std::string resource)
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

    WebView* WebView::LoadHtmlString(std::string content)
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
    WKWebView* WebView::GetNativeWebView() { return _nativeWebView; }

    // Configuration
    WKWebViewConfiguration* WebView::GetConfiguration() { return _configuration; }

    // HasEnabledDevTools
    bool WebView::HasEnabledDevTools() { return _hasEnabledDevTools; }
    WebView* WebView::HasEnabledDevTools(bool value)
    {
        [
            this->GetConfiguration().preferences
            setValue: value ? @YES : @NO
            forKey: @"developerExtrasEnabled"
        ];

        _hasEnabledDevTools = value;

        return this;
    }
}
