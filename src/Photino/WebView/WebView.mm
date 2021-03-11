#include "../../PhotinoShared/StringReplace.h"

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
window.external = {
    messages: {
        delegates: [],
        send: function(message)
        {
            if (typeof message === 'string')
            {
                window.webkit
                    .messageHandlers
                    .photinointerop
                    .postMessage(message);
            }
        },
        receive: function(delegate)
        {
            if (typeof delegate === 'function')
            {
                window.external.messages.delegates.push(delegate);
            }
        },
        dispatch: function(message)
        {
            const delegates = window.external.messages.delegates;
            for (let i = 0; i < delegates.length; i++)
            {
                delegates[i](message);
            }
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

    WebView *WebView::SendScriptMessage(std::string message)
    {
        this->Events()->EmitEvent(WebViewEvents::WillSendScriptMessage, &message);

        WKWebView *webView = this->GetNativeWebView();

        // Unescape all escaped single-quotes to not
        // destroy a string that was escaped already.
        // It's late, this should probably get another
        // thought in order to catch more edge cases.
        std::string quote = "'";
        std::string escapedQuote = "\\'";
        StringReplace(message, escapedQuote, quote);
        
        // Then escape all single quotes.
        StringReplace(message, quote, escapedQuote);

        NSString *evalString = [
            NSString 
            stringWithFormat:@"window.external.messages.dispatch('%@')",
            [NSString stringWithUTF8String: message.c_str()]
        ];

        [
            webView
            evaluateJavaScript: evalString
            completionHandler: nil
        ];

        this->Events()->EmitEvent(WebViewEvents::DidSendScriptMessage, &message);

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
