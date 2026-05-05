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
@interface ZLLayoutViewCfg()
///是否设置对齐方式
@property (nonatomic,assign)BOOL isSetAlign;
///记录已kvo
@property (nonatomic,assign)BOOL isKVOAdded;
@property (nonatomic,weak)ZLStackView *stackView;
@property (nonatomic,weak)UIView *view;
@end
@implementation ZLLayoutViewCfg
@synthesize alignSelf = _alignSelf;
@synthesize behindSpacing = _behindSpacing;
- (void)setAlignSelf:(ZLAlign)alignSelf {
    self.isSetAlign = YES;
    if (alignSelf == _alignSelf) return;
    _alignSelf = alignSelf;
    [self setStackViewNeedsUpdateConstraints];
}
- (ZLAlign)alignSelf {
    return self.isSetAlign ? _alignSelf : self.stackView.alignment;
}
- (void)setBehindSpacing:(CGFloat)behindSpacing {
    if (behindSpacing == _behindSpacing) return;
    _behindSpacing = behindSpacing;
    [self setStackViewNeedsUpdateConstraints];
}
- (CGFloat)behindSpacing {
    if (_behindSpacing > 0) return _behindSpacing;
    return self.stackView.spacing;
}
- (void)setStartSpacing:(CGFloat)startSpacing {
    if (startSpacing == _startSpacing) return;
    _startSpacing = startSpacing;
    [self setStackViewNeedsUpdateConstraints];
}
- (void)setIsFlexSpace:(BOOL)isFlexSpace {
    if (isFlexSpace == _isFlexSpace) return;
    _isFlexSpace = isFlexSpace;
    [self setStackViewNeedsUpdateConstraints];
}
- (void)setFlex:(NSInteger)flex {
    if (flex == _flex) return;
    _flex = flex;
    [self setStackViewNeedsUpdateConstraints];
}
- (void)setView:(UIView *)view {
    _view = view;
    if (!self.isKVOAdded) {
        self.isKVOAdded = YES;
        [view addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

- (void)setStackViewNeedsUpdateConstraints {
    if (!self.view.superview || !self.stackView || ![self.stackView isEqual:self.view.superview]) return;
    [self.stackView setValue:@(YES) forKey:@"markedDirty"];
    [self.stackView setNeedsUpdateConstraints];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
        if ([keyPath isEqualToString:@"hidden"]) {
            BOOL oldHidden = [change[NSKeyValueChangeOldKey] boolValue];
            BOOL newHidden = [change[NSKeyValueChangeNewKey] boolValue];
            if (oldHidden == newHidden) return;
            [self setStackViewNeedsUpdateConstraints];
        }
}
- (void)dealloc
{
    if (self.isKVOAdded) {
        [self.view removeObserver:self forKeyPath:@"hidden"];
    }
}
@end
