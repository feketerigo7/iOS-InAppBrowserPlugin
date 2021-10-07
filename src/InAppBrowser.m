
#import "InAppBrowser.h"

#import <Foundation/Foundation.h>

@implementation InAppBrowserNavigationController

- (instancetype)initWithFrame:(CGRect)frame bridgeName:(NSString *)bridgeName
{
    self.inAppBrowserviewController = [[InAppBrowserViewController alloc] initWithFrame:frame
                                                                             bridgeName:bridgeName];
    if (self.inAppBrowserviewController) {
        self = [self initWithRootViewController:self.inAppBrowserviewController];
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"닫기"
                                                                        style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(onRightBarButton:)];
        
        self.inAppBrowserviewController.navigationItem.rightBarButtonItem = rightButton;
    }
    
    // Swipe down으로 InAppBrowser를 종료하는것을 막는 코드
    // Swipe down시 종료를 원할 경우 코드 제거
    if (@available(iOS 13.0, *)) {
        self.inAppBrowserviewController.modalInPresentation = true;
    }
    
    return self;
}

- (void)setInAppBrowserDelegate:(id)delegate
{
    self.inAppBrowserviewController.inAppBrowserDelegate = delegate;
}

- (void)open:(NSString *)urlString
{
    NSString *escapedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:escapedString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [(WKWebView*)self.inAppBrowserviewController.wkWebView loadRequest:request];

    UIViewController* viewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    
    [viewController presentViewController:self animated:YES completion:nil];
}

- (void)onRightBarButton:(UIBarButtonItem *)sender
{
    if (self.inAppBrowserviewController.inAppBrowserDelegate) {
        [self.inAppBrowserviewController.inAppBrowserDelegate onRightBarButton];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end /* InAppBrowserNavigationController */


@implementation InAppBrowserViewController

- (instancetype)initWithFrame:(CGRect)frame bridgeName:(NSString *)bridgeName
{
    if (self = [super init]) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        [[config userContentController] addScriptMessageHandler:self
                                                           name:bridgeName];

        frame.origin.y = 0;
        self.wkWebView = [[WKWebView alloc] initWithFrame:frame
                                            configuration:config];
        
        [self.wkWebView setNavigationDelegate:self];
        [self.wkWebView setUIDelegate:self];

        [self.view addSubview:self.wkWebView];
    }
    
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    SEL sel = @selector(viewDidDisappear);
    if (self.inAppBrowserDelegate && [self.inAppBrowserDelegate respondsToSelector:sel]) {
        [self.inAppBrowserDelegate viewDidDisappear];
    }
}

#pragma mark - WKWebView - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    SEL sel = @selector(userContentController:didReceiveScriptMessage:);
    if (self.inAppBrowserDelegate && [self.inAppBrowserDelegate respondsToSelector:sel]) {
        [self.inAppBrowserDelegate userContentController:userContentController
                                 didReceiveScriptMessage:message];
    }
}

#pragma mark - WKWebView - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *scheme = navigationAction.request.URL.scheme;
    
    NSArray *allowSchemes = [NSArray arrayWithObjects:@"http", @"https", nil];
    if ([allowSchemes containsObject:scheme]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
   
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
}

#pragma mark - WKWebView - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSString* title = NSLocalizedString(@"alert_title", @"title");
    if ([title isEqualToString:@"alert_title"])
        title = @"";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    __block BOOL bCompletionHandlerCalled = false;

    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
        if (bCompletionHandlerCalled == false)
        {
            bCompletionHandlerCalled = true;
            completionHandler();
        }
    }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{

}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
{

}

@end
