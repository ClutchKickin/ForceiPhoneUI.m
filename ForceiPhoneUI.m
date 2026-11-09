#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// 1. Force UIDevice.currentDevice.userInterfaceIdiom to return iPhone (0)
static UIUserInterfaceIdiom hooked_deviceIdiom(id self, SEL _cmd) {
    return UIUserInterfaceIdiomPhone;
}

// 2. Force UITraitCollection.userInterfaceIdiom to return iPhone (0)
static UIUserInterfaceIdiom hooked_traitIdiom(id self, SEL _cmd) {
    return UIUserInterfaceIdiomPhone;
}

// 3. Force UITraitCollection.horizontalSizeClass to return Compact (1)
static UIUserInterfaceSizeClass hooked_horizontalSizeClass(id self, SEL _cmd) {
    return UIUserInterfaceSizeClassCompact;
}

__attribute__((constructor))
static void initialize_ForceiPhoneUI(void) {
    @autoreleasepool {
        // Hook UIDevice
        Class deviceClass = [UIDevice class];
        Method origDeviceMethod = class_getInstanceMethod(deviceClass, @selector(userInterfaceIdiom));
        if (origDeviceMethod) {
            method_setImplementation(origDeviceMethod, (IMP)hooked_deviceIdiom);
        }

        // Hook UITraitCollection
        Class traitClass = [UITraitCollection class];
        Method origTraitIdiom = class_getInstanceMethod(traitClass, @selector(userInterfaceIdiom));
        if (origTraitIdiom) {
            method_setImplementation(origTraitIdiom, (IMP)hooked_traitIdiom);
        }

        Method origHorizSize = class_getInstanceMethod(traitClass, @selector(horizontalSizeClass));
        if (origHorizSize) {
            method_setImplementation(origHorizSize, (IMP)hooked_horizontalSizeClass);
        }
    }
}
