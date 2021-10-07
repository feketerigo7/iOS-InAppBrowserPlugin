
#ifndef InAppBrowserPlugin_h
#define InAppBrowserPlugin_h

#import "PluginCommon.h"
#import "InAppBrowserDelegate.h"

// nexacro Standard Object와의 통신을 위한 인터페이스
//

@interface InAppBrowserPlugin : PluginCommon <InAppBrowserDelegate>

@end

#endif /* InAppBrowserPlugin_h */
