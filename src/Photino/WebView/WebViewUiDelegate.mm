#include "WebViewUiDelegate.h"

using namespace Photino;

@implementation WebViewUiDelegate : NSObject
    - (void)userContentController: (WKUserContentController *)userContentController 
            didReceiveScriptMessage: (WKScriptMessage *)scriptMessage
    {
        std::string message = [scriptMessage.body UTF8String];
        webView->Events()->EmitEvent(WebViewEvents::DidReceiveScriptMessage, &message);
    }
@end
