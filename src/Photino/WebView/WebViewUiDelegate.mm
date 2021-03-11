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
        // We don't use the (NSString *)scriptMessage directly
        // so that it can be mutated in the emitted event
        // before being used in the alert's info text.
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
        // We don't use the (NSString *)scriptMessage directly
        // so that it can be mutated in the emitted event
        // before being used in the alert's info text.
        std::string message = [scriptMessage UTF8String];
        photinoWebView->Events()->EmitEvent(WebViewEvents::OpenScriptConfirm, &message);

        NSAlert* alert = [[NSAlert alloc] init];

        [alert setMessageText: @"Please Confirm"];
        [alert setInformativeText: [NSString stringWithUTF8String: message.c_str()]];
        
        [alert addButtonWithTitle:@"OK"];
        [alert addButtonWithTitle:@"Cancel"];

        [alert
            beginSheetModalForWindow: nativeWindow
            completionHandler:^void (NSModalResponse response) {
                BOOL isConfirmed = response == NSAlertFirstButtonReturn;

                // TODO:
                // The EmitEvent only takes a std::string* for its
                // second parameter. Use a string that evaluates to
                // bool to get around that limitation. Eventually
                // we want to have the option of passing more than
                // a string type to the method and then this can
                // be removed and replaced by the BOOL type.
                std::string isConfirmedString = isConfirmed ? "true" : "false";
                photinoWebView->Events()->EmitEvent(WebViewEvents::CloseScriptConfirm, &isConfirmedString);

                completionHandler(isConfirmed);
                [alert release];
            }];
    }

    // - (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *result))completionHandler
    // {

    // }
@end
