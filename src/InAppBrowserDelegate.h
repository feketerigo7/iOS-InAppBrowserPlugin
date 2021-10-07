#ifndef InAppBrowserDelegate_h
#define InAppBrowserDelegate_h

@protocol InAppBrowserDelegate <NSObject>

- (void)onRightBarButton; // 오른쪽 상단 닫기 버튼 이벤트
- (void)viewDidDisappear; // InAppBrowserr가 종료됐을때 호출
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message; // 웹페이지로 부터 Native로 전달 받은 메시지 처리

@end

#endif /* InAppBrowserDelegate_h */
