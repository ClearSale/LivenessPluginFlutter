#import "CsLivenessFlutterPlugin.h"
#if __has_include(<cs_liveness_flutter/cs_liveness_flutter-Swift.h>)
#import <cs_liveness_flutter/cs_liveness_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "cs_liveness_flutter-Swift.h"
#endif

@implementation CsLivenessFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCsLivenessFlutterPlugin registerWithRegistrar:registrar];
}
@end
