#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

// typedef void (*WebMessageReceivedCallback) (char* message);

@interface PhotinoWebViewUiDelegate : NSObject <WKUIDelegate/*, WKScriptMessageHandler*/>
{
    @public
    NSWindow* _nativeWindow;
    // WebMessageReceivedCallback webMessageReceivedCallback;
}
@end
