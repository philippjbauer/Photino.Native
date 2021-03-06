#include "WebViewUiDelegate.h"

@implementation WebViewUiDelegate : NSObject
    - (void)userContentController: (WKUserContentController *)userContentController 
            didReceiveScriptMessage: (WKScriptMessage *)message
    {
        std::string messageString = [message.body UTF8String];
        webViewMessageReceivedHandler(messageString);
    }
@end
