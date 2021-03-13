#include "../Alert/Alert.h"
#include "WebViewUiDelegate.h"

using namespace Photino;

@implementation WebViewUiDelegate : NSObject
    - (void)userContentController: (WKUserContentController *)userContentController 
            didReceiveScriptMessage: (WKScriptMessage *)scriptMessage
    {
        std::string message = [scriptMessage.body UTF8String];
        photinoWebView->Events()->EmitEvent(WebViewEvents::DidReceiveScriptMessage, &message);
    }

    - (void)webView: (WKWebView *)webView
            runJavaScriptAlertPanelWithMessage: (NSString *)scriptMessage
            initiatedByFrame: (WKFrameInfo *)frame
            completionHandler: (void (^)(void))completionHandler
    {
        // We don't use the (NSString *)scriptMessage directly
        // so that it can be mutated in the emitted event
        // before being used in the alert's info text.
        std::string message = [scriptMessage UTF8String];
        photinoWebView->Events()->EmitEvent(WebViewEvents::OpenScriptAlert, &message);

        Alert *alert = new Alert(nativeWindow, message);
        alert->Open([=](std::string response) -> void
        {
            photinoWebView->Events()->EmitEvent(WebViewEvents::CloseScriptAlert);
            completionHandler();
        });
    }

    - (void)webView:(WKWebView *)webView
            runJavaScriptConfirmPanelWithMessage: (NSString *)scriptMessage
            initiatedByFrame: (WKFrameInfo *)frame
            completionHandler: (void (^)(BOOL result))completionHandler
    {
        // We don't use the (NSString *)scriptMessage directly
        // so that it can be mutated in the emitted event
        // before being used in the alert's info text.
        std::string message = [scriptMessage UTF8String];
        photinoWebView->Events()->EmitEvent(WebViewEvents::OpenScriptConfirm, &message);

        Alert *alert = new Alert(nativeWindow, message, "Please Confirm");
        alert->AddButton("Cancel", "cancelled");
        alert->Open([=](std::string response)
        {
            // TODO:
            // The EmitEvent only takes a std::string* for its
            // second parameter. Use a string that evaluates to
            // bool to get around that limitation. Eventually
            // we want to have the option of passing more than
            // a string type to the method and then this can
            // be removed and replaced by the BOOL type.
            BOOL isConfirmed = response == "confirmed";
            std::string isConfirmedString = isConfirmed ? "true" : "false";
            photinoWebView->Events()->EmitEvent(WebViewEvents::CloseScriptConfirm, &isConfirmedString);
            completionHandler(isConfirmed);
        });
    }

    // - (void)webView:(WKWebView *)webView
    // runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt
    // defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame
    // completionHandler:(void (^)(NSString *result))completionHandler
    // { }
@end
