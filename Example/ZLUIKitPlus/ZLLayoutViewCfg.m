//
//  ZLLayoutViewCfg.m
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/5/4.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLLayoutViewCfg.h"
#import "ZLStackView.h"

@implementation ZLLayoutViewCfg
- (ZLJustify)justify {
    return self.stackView.justify;
}
- (ZLAlign)alignSelf {
    return self.isSetAlign ? _alignSelf : self.stackView.alignment;
}
- (CGFloat)spacing {
    return self.stackView.spacing;
}
- (void)setStartSpacing:(CGFloat)startSpacing {
    _startSpacing = startSpacing;
}
- (void)setEndSpacing:(CGFloat)endSpacing {
    _endSpacing = endSpacing;
}
- (CGFloat)behindSpacing {
    if (self.isLastView) return 0;
    if (_behindSpacing > 0) return _behindSpacing;
    return self.spacing;
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
- (UIEdgeInsets)insets {
    return self.stackView.insets;
}
@end
