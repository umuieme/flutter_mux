#import "FlutterMuxPlugin.h"
#if __has_include(<flutter_mux/flutter_mux-Swift.h>)
#import <flutter_mux/flutter_mux-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_mux-Swift.h"
#endif

@implementation FlutterMuxPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterMuxPlugin registerWithRegistrar:registrar];
}
@end
