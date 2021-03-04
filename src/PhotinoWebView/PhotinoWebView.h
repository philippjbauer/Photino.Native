#pragma once
#include <string>
#include <Cocoa/Cocoa.h>
#include <WebKit/WebKit.h>

class PhotinoWebView
{
    private:
        WKWebViewConfiguration* _configuration;
        WKWebView* _nativeWebView;

        bool _hasEnabledDevTools;

        /**
         * Class Methods
         */
        PhotinoWebView* Init(NSWindow* nativeWindow);
        WKWebViewConfiguration* CreateConfiguration();
        WKWebView* CreateNativeWebView(
            NSWindow* nativeWindow,
            WKWebViewConfiguration* configuration);

        /**
         * Getters & Setters
         */
        // Configuration
        WKWebViewConfiguration* GetConfiguration();

    public:
        /**
         *  Constructor / Destructor
         */
        PhotinoWebView(
            NSWindow* nativeWindow,
            bool enableDevTools = false);

        ~PhotinoWebView();

        /**
         * Class Methods
         */
        PhotinoWebView* LoadResource(std::string url);
        PhotinoWebView* LoadHtmlString(std::string content);

        /**
         * Getters & Setters
         */
        // WebView
        WKWebView* GetNativeWebView();

        // HasEnabledDevTools
        bool HasEnabledDevTools();
        PhotinoWebView *HasEnabledDevTools(bool value);
};
