#pragma once
#include <string>
#include <Cocoa/Cocoa.h>
#include <WebKit/WebKit.h>

#include "WebView.h"

using namespace Photino;

@interface WebViewUiDelegate : NSObject <WKUIDelegate, WKScriptMessageHandler>
{
    @public
        Photino::WebView *webView;
}
@end
