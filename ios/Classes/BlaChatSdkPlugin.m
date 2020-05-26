#import "BlaChatSdkPlugin.h"
#import <bla_chat_sdk/bla_chat_sdk-Swift.h>

@implementation BlaChatSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBlaChatSdkPlugin registerWithRegistrar:registrar];
}
@end
