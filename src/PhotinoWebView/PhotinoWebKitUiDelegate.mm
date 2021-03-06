#include "PhotinoWebKitUiDelegate.h"

@implementation PhotinoWebKitUiDelegate : NSObject

- (void)userContentController: (WKUserContentController *)userContentController 
        didReceiveScriptMessage: (WKScriptMessage *)message
{
    std::string messageString = [message.body UTF8String];
    webViewMessageReceivedHandler(messageString);
}

@end
