//
//  ZLLayoutViewCfg.m
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/5/4.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLLayoutViewCfg.h"
#import "ZLStackView.h"
#import <objc/runtime.h>

@implementation UIView (ZLView)
- (ZLLayoutViewCfg *)zl_layoutCfg {
    ZLLayoutViewCfg *cfg = objc_getAssociatedObject(self, _cmd);
    if (!cfg) {
        cfg = ZLLayoutViewCfg.new;
        objc_setAssociatedObject(self, _cmd, cfg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cfg;
}
@end
@implementation ZLLayoutViewCfg

- (ZLAlign)alignSelf {
    return self.isSetAlign ? _alignSelf : self.stackView.alignment;
}
- (CGFloat)behindSpacing {
    if (_behindSpacing > 0) return _behindSpacing;
    return self.stackView.spacing;
}
- (void)setView:(UIView *)view {
    _view = view;
    if (!self.isKVOAdded) {
        self.isKVOAdded = YES;
        [view addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
        if ([keyPath isEqualToString:@"hidden"]) {
            BOOL oldHidden = [change[NSKeyValueChangeOldKey] boolValue];
            BOOL newHidden = [change[NSKeyValueChangeNewKey] boolValue];
            if (oldHidden == newHidden) return;
            if (self.stackView &&
                [self.view.superview isEqual:self.stackView]) {
                [self.stackView setValue:@(YES) forKey:@"markedDirty"];
                [self.stackView setNeedsUpdateConstraints];
            }
        }
}
- (void)dealloc
{
    if (self.isKVOAdded) {
        [self.view removeObserver:self forKeyPath:@"hidden"];
    }
}
@end
