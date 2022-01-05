#import "ActigraphyPlugin.h"
#if __has_include(<actigraphy/actigraphy-Swift.h>)
#import <actigraphy/actigraphy-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "actigraphy-Swift.h"
#endif

@implementation ActigraphyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftActigraphyPlugin registerWithRegistrar:registrar];
}
@end
