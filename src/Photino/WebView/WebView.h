#pragma once
#include <string>
#include <Cocoa/Cocoa.h>
#include <WebKit/WebKit.h>

#include "../Events/Events.h"

namespace Photino
{
    enum WebViewEvents
    {
        WillLoadResource,
        DidLoadResource,
        WillLoadHtmlString,
        DidLoadHtmlString,
        DidReceiveScriptMessage,
        WillSendScriptMessage,
        DidSendScriptMessage,
        OpenScriptAlert,
        CloseScriptAlert,
        OpenScriptConfirm,
        CloseScriptConfirm,
    };

    class WebView
    {
        private:
            WKWebViewConfiguration *_configuration;
            WKWebView *_nativeWebView;

            Events<WebView, WebViewEvents> *_events;

            bool _hasDeveloperExtrasEnabled;

            /**
             * Class Methods
             */
            WebView *Init(NSWindow *nativeWindow);
            WKWebViewConfiguration *CreateConfiguration();
            WKWebView *CreateNativeWebView(
                NSWindow *nativeWindow,
                WKWebViewConfiguration *configuration);

            /**
             * Getters & Setters
             */
            // Configuration
            WKWebViewConfiguration *GetConfiguration();
            WKUserScript *GetUserScript();
            NSURL *GetResourceURL(std::string resource);

        public:
            /**
             *  Constructor / Destructor
             */
            WebView(
                NSWindow *nativeWindow,
                bool enableDevTools = false);

            ~WebView();

            /**
             * Class Methods
             */
            Events<WebView, WebViewEvents> *Events();

            WebView *LoadResource(std::string resource);
            WebView *LoadHtmlString(std::string content);

            WebView *SendScriptMessage(std::string message);

            /**
             * Getters & Setters
             */
            // WebView
            WKWebView *GetNativeWebView();

            // HasDeveloperExtrasEnabled
            bool HasDeveloperExtrasEnabled();
            WebView *HasDeveloperExtrasEnabled(bool value);
    };
}
