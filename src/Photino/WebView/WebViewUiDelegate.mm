#include <iostream>
#include "WebViewUiDelegate.h"

using namespace Photino;

@implementation WebViewUiDelegate : NSObject
    - (void)userContentController: (WKUserContentController *)userContentController 
            didReceiveScriptMessage: (WKScriptMessage *)message
    {
        std::string messageString = [message.body UTF8String];
        webView->Events()->EmitEvent(WebViewEvents::DidReceiveScriptMessage);
        std::cout << messageString << std::endl;
    }
@end
