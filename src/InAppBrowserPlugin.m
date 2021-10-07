
#import "InAppBrowserPlugin.h"

#import <Foundation/Foundation.h>

#import "AppDelegate.h"
#import "InAppBrowser.h"

@interface InAppBrowserPlugin ()
@property InAppBrowserNavigationController *inAppBrowserNavigationController;
@end

@implementation InAppBrowserPlugin

// nexacro standard Object의 CallMethod에 의해 호출
-(void)callMethod:(NSString *)lid withDict:(NSMutableDictionary *)options
{
    [self printArgs:[NSString stringWithUTF8String:__func__] arg:options];
    
    self.nID = [lid integerValue];
    self.mSerivceId = [options strValueForKey:@"serviceid"];
    
    NSDictionary *dic = [options dicValueForKey:@"param"];
    NSString *startUrl = [dic strValueForKey:@"starturl"];
    
    if ([self.mSerivceId isEqualToString:@"show"]) {
        [self show:startUrl];
    }
}

- (void)show:(NSString *)url
{
    if (_inAppBrowserNavigationController == nil) {
        // InAppBrowse 초기화
        CGRect frame = [self.webView bounds];
        _inAppBrowserNavigationController =[[InAppBrowserNavigationController alloc] initWithFrame:frame
                                                                                       bridgeName:@"nexacro_iab"];
        [_inAppBrowserNavigationController setInAppBrowserDelegate:self];
    }
    
    // 우측 상단 닫기 버튼을 숨기고 싶을때 주석 제거
    // inAppBrowserNavigationController.navigationBarHidden = YES;
    
    [_inAppBrowserNavigationController open:url];
}

#pragma mark - InAppBrowserDelegate
- (void)onRightBarButton
{
    [self send:CODE_SUCCES withMsg:@"InAppBrowser navigationbar right button touched."];
}

- (void)viewDidDisappear
{
    [self send:CODE_SUCCES withMsg:@"InAppBrowser viewDidDisappear."];
}

// 웹페이지로 부터 전달 받은 메시지 처리
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message;
{
    NSLog(@"JavaScript Message:%@", message.body);
    
    if ([message.body isEqualToString:@"종료"]) {
        [_inAppBrowserNavigationController dismissViewControllerAnimated:YES completion:nil];
        [self send:CODE_SUCCES withMsg:@"창 닫기 버튼이 클릭되어 창이 InAppBrowser가 종료 되었습니다."];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"InAppBrowser message"
                                                          message:message.body
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [alert show];
    }
}

@end
