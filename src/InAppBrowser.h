
#ifndef InAppBrowser_h
#define InAppBrowser_h

#import "PluginCommon.h"
#import "InAppBrowserDelegate.h"

// WKWebView로 만들어진 브라우저
//

@class InAppBrowserViewController;

@interface InAppBrowserNavigationController : UINavigationController

@property (nonatomic, retain) InAppBrowserViewController *inAppBrowserviewController;

- (instancetype)initWithFrame:(CGRect)frame bridgeName:(NSString *)bridgeName;
- (void)open:(NSString *)urlString;

- (void)setInAppBrowserDelegate:(id)delegate;

@end


@interface InAppBrowserViewController : UIViewController <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) id wkWebView;

@property (nonatomic, weak) id <InAppBrowserDelegate> inAppBrowserDelegate;

- (instancetype)initWithFrame:(CGRect)frame bridgeName:(NSString *)bridgeName;

@end

#endif /* InAppBrowser_h */
