#include <iostream>
#include "WebView.h"
#include "WebViewUiDelegate.h"

namespace Photino
{
    /**
    * Construct WebView
    */
    WebView::WebView(
        NSWindow *nativeWindow,
        bool developerExtrasEnabled)
    {
        this->Init(nativeWindow)
            ->HasDeveloperExtrasEnabled(developerExtrasEnabled);
    }

    WebView::~WebView()
    {
        [this->GetConfiguration() release];
        [this->GetNativeWebView() release];
    }

    /**
    * Class Methods
    */
    WebView *WebView::Init(NSWindow *nativeWindow)
    {
        _events = new Photino::Events<WebView, WebViewEvents>(this);

        _configuration = this->CreateConfiguration();
        _nativeWebView = this->CreateNativeWebView(nativeWindow, this->GetConfiguration());

        return this;
    }

    WKWebViewConfiguration *WebView::CreateConfiguration()
    {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        
        return configuration;
    }

    WKWebView *WebView::CreateNativeWebView(
        NSWindow *nativeWindow,
        WKWebViewConfiguration *configuration
    )
    {
        // Create WebViewUiDelegate
        WebViewUiDelegate *uiDelegate = [[
            [WebViewUiDelegate alloc]
            init
        ] autorelease];

        uiDelegate->webView = this;

        // Setup user content script interop
        WKUserScript *userScript = this->GetUserScript();

        WKUserContentController *userContentController = [[
            [WKUserContentController alloc] init
        ] autorelease];

        [userContentController addUserScript: userScript];
        
        [
            userContentController
            addScriptMessageHandler: uiDelegate
            name: @"photinointerop"
        ];

        configuration.userContentController = userContentController;

        // Create native WebView
        WKWebView *nativeWebView = [
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

    WKUserScript *WebView::GetUserScript()
    {
        // Future use of TextFile when I found a way to include from
        // application path / bundle path in a cross-platform fashion.
        // TextFile webViewExtensions(APP_PATH + "/Assets/WebViewExtensions.js");

        std::string webViewExtensions = R"js(
window.__receiveMessageCallbacks = [];

window.__dispatchMessageCallback = function(message)
{
    window.__receiveMessageCallbacks
        .forEach(function(callback) 
        {
            callback(message);
        });
};

window.external = {
    message: {
        send: function(message)
        {
            window.webkit
                .messageHandlers
                .photinointerop
                .postMessage(message);
        },
        receive: function(callback)
        {
            window.__receiveMessageCallbacks.push(callback);
        }
    }
};
)js";

        NSString *userScriptSource = [
            NSString
            stringWithUTF8String: webViewExtensions.c_str()
        ];

        WKUserScript *userScript = [[
            [WKUserScript alloc]
            initWithSource: userScriptSource
            injectionTime: WKUserScriptInjectionTimeAtDocumentStart
            forMainFrameOnly: YES
        ] autorelease];

        return userScript;
    }

    NSURL *WebView::GetResourceURL(std::string resource)
    {
        NSURL *bundleURL = [
            [NSBundle mainBundle]
            resourceURL
        ];

        NSString *resourceString = [[
            NSString stringWithUTF8String: resource.c_str()
        ] autorelease];
        
        NSURL *resourceURL = [[
            NSURL 
            URLWithString: resourceString
            relativeToURL: bundleURL
        ] autorelease];

        return resourceURL;
    }

    Events<WebView, WebViewEvents> *WebView::Events() { return _events; }

    WebView *WebView::LoadResource(std::string resource)
    {
        this->Events()->EmitEvent(WebViewEvents::WillLoadResource);

        WKWebView *webview = this->GetNativeWebView();

        NSURL *resourceURL = this->GetResourceURL(resource);

        NSLog(@"%@", [resourceURL absoluteString]);

        NSURLRequest *request = [[
            NSURLRequest
            requestWithURL: resourceURL
        ] autorelease];
        
        [webview loadRequest: request];

        this->Events()->EmitEvent(WebViewEvents::DidLoadResource);

        return this;
    }

    WebView *WebView::LoadHtmlString(std::string content)
    {
        this->Events()->EmitEvent(WebViewEvents::WillLoadHtmlString);

        WKWebView *webview = this->GetNativeWebView();

        NSString *htmlString = [[
            NSString
            stringWithUTF8String: content.c_str()
        ] autorelease];

        [
            webview
            loadHTMLString: htmlString
            baseURL: nil
        ];

        this->Events()->EmitEvent(WebViewEvents::DidLoadHtmlString);

        return this;
    }

    /**
    * Getters & Setters
    */
    // Configuration
    WKWebView *WebView::GetNativeWebView() { return _nativeWebView; }

    // Configuration
    WKWebViewConfiguration *WebView::GetConfiguration() { return _configuration; }

    // HasDeveloperExtrasEnabled
    bool WebView::HasDeveloperExtrasEnabled() { return _hasDeveloperExtrasEnabled; }
    WebView *WebView::HasDeveloperExtrasEnabled(bool value)
    {
        [
            this->GetConfiguration().preferences
            setValue: value ? @YES : @NO
            forKey: @"developerExtrasEnabled"
        ];

        _hasDeveloperExtrasEnabled = value;

        return this;
    }
}
