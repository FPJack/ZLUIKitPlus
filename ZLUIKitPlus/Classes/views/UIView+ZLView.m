//
//  UIView+ZLView.m
//  ZLUIKitPlus
//
//  Created by admin on 2026/4/24.
//

#import "UIView+ZLView.h"
#import "ZLButton.h"
#import "ZLImageView.h"
#import "ZLStateView.h"
#import "ZLLabel.h"
#import "ZLPairView.h"
#import "ZLTagListView.h"
#import <objc/runtime.h>


#define kPropertyGetterImplementation(type, propertyName) \
- (type *)propertyName { \
    NSString *key = NSStringFromSelector(_cmd); \
    type *view = [self.propertyObjs objectForKey:key]; \
    if (!view) { \
        view = [[type alloc] init]; \
        [self addSubview:view]; \
        [self.propertyObjs setObject:view forKey:key]; \
    } \
    return view; \
}

@implementation UIView (ZLView)


- (NSMutableDictionary *)propertyObjs {
    NSMutableDictionary *midc = objc_getAssociatedObject(self, _cmd);
    if (!midc) {
        midc = NSMutableDictionary.dictionary;
        objc_setAssociatedObject(self, _cmd, midc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return midc;
}
kPropertyGetterImplementation(ZLLabel, zl_lab)
kPropertyGetterImplementation(ZLImageView, zl_imgView)
kPropertyGetterImplementation(ZLButton, zl_btn)
@end
