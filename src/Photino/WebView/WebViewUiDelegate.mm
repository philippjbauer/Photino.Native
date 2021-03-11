#include "WebViewUiDelegate.h"

using namespace Photino;

@implementation WebViewUiDelegate : NSObject
    - (void)userContentController: (WKUserContentController *)userContentController 
            didReceiveScriptMessage: (WKScriptMessage *)scriptMessage
    {
        std::string message = [scriptMessage.body UTF8String];
        photinoWebView->Events()->EmitEvent(WebViewEvents::DidReceiveScriptMessage, &message);
    }

    - (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)scriptMessage initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
    {
        std::string message = [scriptMessage UTF8String];
        photinoWebView->Events()->EmitEvent(WebViewEvents::OpenScriptAlert, &message);

        NSAlert* alert = [[NSAlert alloc] init];

        [alert setAlertStyle: NSAlertStyleInformational];
        [alert setMessageText: @"Alert Message"];
        [alert setInformativeText: [NSString stringWithUTF8String: message.c_str()]];
        [alert addButtonWithTitle: @"OK"];

        [alert
            beginSheetModalForWindow: nativeWindow
            completionHandler:^void (NSModalResponse response) {
                photinoWebView->Events()->EmitEvent(WebViewEvents::CloseScriptAlert);
                completionHandler();
                [alert release];
            }
        ];
    }

    - (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)scriptMessage initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
    {
        std::string message = [scriptMessage UTF8String];
        photinoWebView->Events()->EmitEvent(WebViewEvents::OpenScriptConfirm, &message);
    }

    // - (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *result))completionHandler
    // {

    // }
@end
