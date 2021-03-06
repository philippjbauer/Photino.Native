#pragma once
#include <string>
#include <Cocoa/Cocoa.h>
#include <WebKit/WebKit.h>

typedef void (*WebViewMessageReceivedHandler) (std::string message);

@interface PhotinoWebKitUiDelegate : NSObject <WKUIDelegate, WKScriptMessageHandler>
{
    @public
        WebViewMessageReceivedHandler webViewMessageReceivedHandler;
}
@end
