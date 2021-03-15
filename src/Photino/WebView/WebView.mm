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
        bool hasDeveloperExtrasEnabled)
        : _nativeWindow(nativeWindow),
          _hasDeveloperExtrasEnabled(hasDeveloperExtrasEnabled)
    {
        this->Init()
            ->HasDeveloperExtrasEnabled(hasDeveloperExtrasEnabled);
    }

    WebView::~WebView()
    {
        Log::WriteLine("Destructing WebView");
        delete _events;
    }

    /**
    * Class Methods
    */
    WebView *WebView::Init()
    {
        _events = new Photino::Events<WebView, WebViewEvents>(this);

        _configuration = this->CreateConfiguration();
        _nativeWebView = this->CreateNativeWebView(_nativeWindow, this->GetConfiguration());

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
        WebViewUiDelegate *uiDelegate = [[WebViewUiDelegate alloc] init];

        uiDelegate->nativeWindow = nativeWindow;
        uiDelegate->photinoWebView = this;

        // Setup user content script interop
        WKUserScript *userScript = this->GetUserScript();

        WKUserContentController *userContentController = [[WKUserContentController alloc] init];

        [userContentController addUserScript: userScript];
        
        [userContentController
            addScriptMessageHandler: uiDelegate
            name: @"photinoIPC"];

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
const PhotinoApp = {
    events: {
        handlers: {},
        addEventHandler: function (type, handler) {
            if (typeof type === 'string'
                && typeof handler === 'function'
            ) {
                if (Object.keys(PhotinoApp.events.handlers).indexOf(type) === -1) {
                    PhotinoApp.events.handlers[type] = [];
                }

                PhotinoApp.events.handlers[type].push(handler);
            }

            return PhotinoApp.events;
        },
        emitEvent: function (type, message) {
            if (typeof type === 'string'
                && typeof message === 'string'
            ) {
                const handlers = PhotinoApp.events.handlers[type];

                if (!handlers || handlers.length === 0) {
                    return true;
                }

                for (let i = 0; i < handlers.length; i++) {
                    if (message === undefined) {
                        handlers[i]();
                    }
                    else {
                        handlers[i](message);
                    }
                }

                return true;
            }

            return false;
        }
    },
    messages: {
        send: function(message) {
            if (typeof message === 'string') {
                window.webkit
                    .messageHandlers
                    .photinoIPC
                    .postMessage(message);
            }
        },
        receive: function(handler) {
            PhotinoApp.events.addEventHandler('message-received', handler);
            return PhotinoApp.messages;
        }
    }
};
)js";

        NSString *userScriptSource = [NSString stringWithUTF8String: webViewExtensions.c_str()];

        WKUserScript *userScript = [
            [WKUserScript alloc]
            initWithSource: userScriptSource
            injectionTime: WKUserScriptInjectionTimeAtDocumentStart
            forMainFrameOnly: YES
        ];

        return userScript;
    }

    NSURL *WebView::GetResourceURL(std::string resource)
    {
        NSURL *bundleURL = [[NSBundle mainBundle] resourceURL];
        NSString *resourceString = [NSString stringWithUTF8String: resource.c_str()];
        
        NSURL *resourceURL = [
            NSURL
            URLWithString: resourceString
            relativeToURL: bundleURL];

        return resourceURL;
    }

    Events<WebView, WebViewEvents> *WebView::Events() { return _events; }
    WKWebView *WebView::NativeWebView() { return _nativeWebView; }
    NSWindow *WebView::NativeWindow() { return _nativeWindow; }

    WebView *WebView::LoadResource(std::string resource)
    {
        WKWebView *webview = this->NativeWebView();
        NSURL *resourceURL = this->GetResourceURL(resource);
        std::string absoluteURL = [[resourceURL absoluteString] UTF8String];

        this->Events()->EmitEvent(WebViewEvents::WillLoadResource, &absoluteURL);

        NSURLRequest *request = [NSURLRequest requestWithURL: resourceURL];
        
        [webview loadRequest: request];

        this->Events()->EmitEvent(WebViewEvents::DidLoadResource);

        return this;
    }

    WebView *WebView::LoadHtmlString(std::string content)
    {
        this->Events()->EmitEvent(WebViewEvents::WillLoadHtmlString);

        WKWebView *webview = this->NativeWebView();

        NSString *htmlString = [NSString stringWithUTF8String: content.c_str()];

        [webview
            loadHTMLString: htmlString
            baseURL: nil];

        this->Events()->EmitEvent(WebViewEvents::DidLoadHtmlString);

        return this;
    }

    WebView *WebView::SendScriptEvent(std::string type, std::string message)
    {
        this->Events()->EmitEvent(WebViewEvents::WillSendScriptEvent, &message);

        WKWebView *webView = this->NativeWebView();

        // Unescape all escaped single-quotes to not
        // destroy a string that was escaped already.

        // ToDo:
        // It's late, this should probably get another
        // thought in order to catch more edge cases.
        std::string quote = "'";
        std::string escapedQuote = "\\'";

        // Escape event type
        StringReplace(type, escapedQuote, quote);
        StringReplace(type, quote, escapedQuote);
        
        // Escape event message
        if (message != "")
        {
            StringReplace(message, escapedQuote, quote);
            StringReplace(message, quote, escapedQuote);
        }

        NSString *evalString;
        if (message == "")
        {
            evalString = [
                NSString 
                stringWithFormat:@"PhotinoApp.events.emitEvent('%@')",
                [NSString stringWithUTF8String: type.c_str()]
            ];
        }
        else
        {
            evalString = [
                NSString 
                stringWithFormat:@"PhotinoApp.events.emitEvent('%@', '%@')",
                [NSString stringWithUTF8String: type.c_str()],
                [NSString stringWithUTF8String: message.c_str()]
            ];
        }

        Log::WriteLine([evalString UTF8String]);

        [webView
            evaluateJavaScript: evalString
            completionHandler: ^void (id response, NSError *error)
            {
                if (response != nil)
                {
                    NSLog(@"Evaluated JavaScript Response: %@", response);
                }
                else
                {
                    NSLog(@"%@: %@", [error localizedDescription], [error localizedFailureReason]);
                }
            }];

        this->Events()->EmitEvent(WebViewEvents::DidSendScriptEvent, &message);

        return this;
    }

    WebView *WebView::SendScriptMessage(std::string message)
    {
        return this->SendScriptEvent("message-received", message);
    }

    /**
    * Getters & Setters
    */
    // Configuration
    WKWebViewConfiguration *WebView::GetConfiguration() { return _configuration; }

    // HasDeveloperExtrasEnabled
    bool WebView::HasDeveloperExtrasEnabled() { return _hasDeveloperExtrasEnabled; }
    WebView *WebView::HasDeveloperExtrasEnabled(bool value)
    {
        [this->GetConfiguration().preferences
            setValue: value ? @YES : @NO
            forKey: @"developerExtrasEnabled"];

        _hasDeveloperExtrasEnabled = value;

        return this;
    }
}
