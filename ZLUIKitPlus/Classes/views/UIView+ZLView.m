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
@implementation UIView (ZLView)
- (ZLLabel *)zl_lab {
    ZLLabel *label = objc_getAssociatedObject(self, _cmd);
    if (!label) {
        label = ZLLabel.new;
        [self addSubview:label];
        objc_setAssociatedObject(self, _cmd, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return label;
}
- (ZLImageView *)zl_imgView {
    ZLImageView *imgView = objc_getAssociatedObject(self, _cmd);
    if (!imgView) {
        imgView = ZLImageView.new;
        [self addSubview:imgView];
        objc_setAssociatedObject(self, _cmd, imgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return imgView;
}
- (ZLButton *)zl_btn {
    ZLButton *button = objc_getAssociatedObject(self, _cmd);
    if (!button) {
        button = ZLButton.horizontal;
        [self addSubview:button];
        objc_setAssociatedObject(self, _cmd, button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return button;
}

@end
