#pragma once
#include <string>
#include <Cocoa/Cocoa.h>
#include <WebKit/WebKit.h>

namespace Photino
{
    class WebView
    {
        private:
            WKWebViewConfiguration *_configuration;
            WKWebView *_nativeWebView;

            bool _hasEnabledDevTools;

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
            WebView *LoadResource(std::string url);
            WebView *LoadHtmlString(std::string content);

            /**
             * Getters & Setters
             */
            // WebView
            WKWebView *GetNativeWebView();

            // HasEnabledDevTools
            bool HasEnabledDevTools();
            WebView *HasEnabledDevTools(bool value);
    };
}
