//
//  ZLStackView.m
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/4/25.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLStackView.h"
#import <objc/runtime.h>
#import "ZLLayoutManager.h"
#import "ZLLayoutViewCfg.h"


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
@interface ZLStackView()
@property (nonatomic,strong)ZLLayoutManager *layoutManager;
@end
@implementation ZLStackView
- (ZLLayoutManager *)layoutManager {
    if (!_layoutManager) {
        _layoutManager = [[ZLLayoutManager alloc] init];
        _layoutManager.stackView = self;
    }
    return _layoutManager;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.markedDirty = YES;
        self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

- (NSMutableArray<__kindof UIView *> *)arrangedViews {
    if (!_arrangedViews) {
        _arrangedViews = NSMutableArray.array;
    }
    return _arrangedViews;
}
- (NSMutableArray<__kindof UIView *> *)allViews {
    if (!_allViews) {
        _allViews = NSMutableArray.array;
    }
    return _allViews;
}
- (void)setHorizontal:(BOOL)horizontal {
    if (horizontal == _horizontal) return;
    _horizontal = horizontal;
    self.markedDirty = YES;
    [self setNeedsLayout];
}
- (void)setJustify:(ZLJustify)justify {
    if (justify == _justify) return;
    _justify = justify;
    self.markedDirty = YES;
    [self setNeedsLayout];
}
- (void)setAlignment:(ZLAlign)alignment {
    if (alignment == _alignment) return;
    _alignment = alignment;
    self.markedDirty = YES;
    [self setNeedsLayout];
}
- (void)setSpacing:(CGFloat)spacing {
    if (spacing == _spacing) return;
    _spacing = spacing;
    self.markedDirty = YES;
    [self setNeedsLayout];
}
- (void)addArrangedSubview:(UIView *)view{
    if ([view isKindOfClass:UIView.class]) {
        if ([self.allViews containsObject:view]) return;
        [self.allViews addObject:view];
        if (view.hidden) return;
        [self.arrangedViews addObject:view];
        ZLLayoutViewCfg *cfg = view.zl_layoutCfg;
        cfg.view = view;
        cfg.stackView = self;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        self.markedDirty = YES;
        [self setNeedsLayout];
    }
}
- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex {
    if ([view isKindOfClass:UIView.class]) {
        if ([self.allViews containsObject:view]) return;
        [self.allViews insertObject:view atIndex:stackIndex];
        if (view.hidden) return;
        self.markedDirty = YES;
        [self setNeedsLayout];
    }
}
- (void)refreshArrangedSubviews {
    [self.arrangedViews removeAllObjects];
    [self.allViews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.hidden) [self.arrangedViews addObject:obj];
    }];
}
- (void)removeArrangedSubview:(UIView *)view {
    if (![self.arrangedViews containsObject:view]) return;
    [view removeFromSuperview];
    [self.arrangedViews removeObject:view];
    [self.allViews removeObject:view];
    view.zl_layoutCfg.stackView = nil;
    self.markedDirty = YES;
    [self setNeedsLayout];
}
- (void)setFlexibleSpacing:(BOOL)flexible afterView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    if (flexible == arrangedSubview.zl_layoutCfg.isFlexSpace) return;
    arrangedSubview.zl_layoutCfg.isFlexSpace = flexible;
    self.markedDirty = YES;
    [self setNeedsLayout];
}
- (void)setCustomSpacing:(CGFloat)spacing afterView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    arrangedSubview.zl_layoutCfg.behindSpacing = spacing;
}

- (void)setAlignment:(ZLAlign)alignment forView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    ZLLayoutViewCfg *cfg = arrangedSubview.zl_layoutCfg;
    if (alignment == cfg.alignSelf) return;
    cfg.isSetAlign = YES;
    cfg.alignSelf = alignment;
    self.markedDirty = YES;
    [self setNeedsLayout];
}
///设置view的alignment方向start间距
- (void)setAlignmentStartSpacing:(CGFloat)spacing forView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    ZLLayoutViewCfg *cfg = arrangedSubview.zl_layoutCfg;
    if (spacing == cfg.startSpacing) return;
    cfg.startSpacing = spacing;
    self.markedDirty = YES;
    [self setNeedsLayout];
}
///设置view的alignment方向end间距
- (void)setAlignmentEndSpacing:(CGFloat)spacing forView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    ZLLayoutViewCfg *cfg = arrangedSubview.zl_layoutCfg;
    if (cfg.endSpacing == spacing) return;
    cfg.endSpacing = spacing;
    self.markedDirty = YES;
    [self setNeedsLayout];
}
- (void)updateConstraints {
    [super updateConstraints];
    [self.layoutManager addHorizontalLayoutConstraints];
    [self.layoutManager addVerticalLayoutConstraints];
    [self.layoutManager activateConstraints];
}

///至关重要
- (CGSize)intrinsicContentSize {
    //返回自适应
    return CGSizeZero;
}
@end
