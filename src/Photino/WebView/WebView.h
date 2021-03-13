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
            NSWindow *_nativeWindow;

            Events<WebView, WebViewEvents> *_events;

            bool _hasDeveloperExtrasEnabled;

            /**
             * Class Methods
             */
            WebView *Init();
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
            WKWebView *NativeWebView();
            NSWindow *NativeWindow();

            WebView *LoadResource(std::string resource);
            WebView *LoadHtmlString(std::string content);

            WebView *SendScriptMessage(std::string message);

            /**
             * Getters & Setters
             */

            // HasDeveloperExtrasEnabled
            bool HasDeveloperExtrasEnabled();
            WebView *HasDeveloperExtrasEnabled(bool value);
    };
}
