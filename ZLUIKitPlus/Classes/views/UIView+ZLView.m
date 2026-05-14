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
#import "ZLView.h"


#define kPropertyGetterImplementation(type, propertyName) \
- (type *)propertyName { \
    NSString *key = NSStringFromSelector(_cmd); \
    type *view = [self.propertyObjs objectForKey:key]; \
    if (!view) { \
        view = [[type alloc] init]; \
        [self addSubview:view];   \
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
kPropertyGetterImplementation(ZLStackView, zl_stackView)

kPropertyGetterImplementation(ZLButton, zl_altBtn)
kPropertyGetterImplementation(ZLLabel, zl_altLab)
kPropertyGetterImplementation(ZLImageView, zl_altImgView)
kPropertyGetterImplementation(ZLStackView, zl_altStackView)

kPropertyGetterImplementation(ZLButton, zl_extraBtn)
kPropertyGetterImplementation(ZLLabel, zl_extraLab)
kPropertyGetterImplementation(ZLImageView, zl_extraImgView)
kPropertyGetterImplementation(ZLStackView, zl_extraStackView)

kPropertyGetterImplementation(ZLPairLabelView, zl_pairLab)
kPropertyGetterImplementation(ZLPairImageView, zl_pairImg)
kPropertyGetterImplementation(ZLPairButtonView, zl_pairBtn)
kPropertyGetterImplementation(ZLPairStackView, zl_pairStackView)

kPropertyGetterImplementation(ZLImgLabelView, zl_imgViewLab)
kPropertyGetterImplementation(ZLImgButtonView, zl_imgViewBtn)
kPropertyGetterImplementation(ZLButtonImgView, zl_btnImgView)
kPropertyGetterImplementation(ZLButtonLabView, zl_btnLabel)
kPropertyGetterImplementation(ZLLabButtonView, zl_labelBtn)
kPropertyGetterImplementation(ZLLabelImgView, zl_labImgView)

- (ZLWrapperView *)zl_wrapView {
    ZLWrapperView *wrap = self.propertyObjs[NSStringFromSelector(_cmd)];
    if (!wrap) {
        wrap = [ZLWrapperView wrapWithView:self];
        [self.propertyObjs setObject:wrap forKey:NSStringFromSelector(_cmd)];
    }
    return wrap;
}

- (UIView * _Nonnull (^)(void (^ _Nonnull)(__kindof UIView * _Nonnull)))zl_init {
    return ^(void (^initBlock)(__kindof UIView *view)) {
        NSString *key = NSStringFromSelector(_cmd);
        NSString *tag = self.propertyObjs[key];
        if (tag) return self;
        self.propertyObjs[key] = @"";
        if (initBlock) initBlock(self);
        return self;
    };
}
- (instancetype)zl_init:(void (^)(__kindof UIView * view))block {
    NSString *key = NSStringFromSelector(_cmd);
    NSString *tag = self.propertyObjs[key];
    if (tag) return self;
    self.propertyObjs[key] = @"";
    if (block) block(self);
    return self;
}
@end
