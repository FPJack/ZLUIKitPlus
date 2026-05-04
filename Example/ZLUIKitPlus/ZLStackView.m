//
//  ZLStackView.m
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/4/25.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLStackView.h"
#import "ZLLayoutManager.h"
#import "ZLLayoutViewCfg.h"
#import "ZLConstraintsCfg.h"

@interface ZLStackView()
@property (nonatomic,strong)ZLLayoutManager *layoutManager;
@property(nonatomic,strong) NSMutableArray<__kindof UIView *> *allViews;
@property (nonatomic,assign)BOOL markedDirty;

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
- (void)setInsets:(UIEdgeInsets)insets {
    if (UIEdgeInsetsEqualToEdgeInsets(insets, _insets)) return;
    _insets = insets;
    [self setNeedsUpdateConstraints];
}
- (void)setHorizontal:(BOOL)horizontal {
    if (horizontal == _horizontal) return;
    _horizontal = horizontal;
    self.markedDirty = YES;
    [self setNeedsUpdateConstraints];
}
- (void)setJustify:(ZLJustify)justify {
    if (justify == _justify) return;
    _justify = justify;
    self.markedDirty = YES;
    [self setNeedsUpdateConstraints];
}
- (void)setAlignment:(ZLAlign)alignment {
    if (alignment == _alignment) return;
    _alignment = alignment;
    self.markedDirty = YES;
    [self setNeedsUpdateConstraints];
}
- (void)setSpacing:(CGFloat)spacing {
    if (spacing == _spacing) return;
    _spacing = spacing;
    self.markedDirty = YES;
    [self setNeedsUpdateConstraints];
}
- (void)addArrangedSubview:(UIView *)view{
    if ([view isKindOfClass:UIView.class]) {
        if ([self.allViews containsObject:view]) return;
        ZLLayoutViewCfg *cfg = view.zl_layoutCfg;
        cfg.view = view;
        cfg.stackView = self;
        [self.allViews addObject:view];
        if (view.hidden) return;
        [self.arrangedViews addObject:view];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        self.markedDirty = YES;
        [self setNeedsUpdateConstraints];
    }
}
- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex {
    if ([view isKindOfClass:UIView.class]) {
        if ([self.allViews containsObject:view]) return;
        [self.allViews insertObject:view atIndex:stackIndex];
        if (view.hidden) return;
        self.markedDirty = YES;
        [self setNeedsUpdateConstraints];
    }
}
- (void)refreshArrangedSubviews {
    [self.arrangedViews removeAllObjects];
    [self.allViews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.hidden) [self.arrangedViews addObject:obj];
    }];
}
- (void)removeArrangedSubview:(UIView *)view {
    if (![self.allViews containsObject:view]) return;
    [view removeFromSuperview];
    [self.allViews removeObject:view];
    view.zl_layoutCfg.stackView = nil;
    if (![self.arrangedViews containsObject:view]) return;
    [self.arrangedViews removeObject:view];
    self.markedDirty = YES;
    [self setNeedsUpdateConstraints];
}
- (void)setFlexibleSpacing:(BOOL)flexible afterView:(UIView *)arrangedSubview {
    if (![arrangedSubview isKindOfClass:UIView.class]) return;
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    if (flexible == arrangedSubview.zl_layoutCfg.isFlexSpace) return;
    arrangedSubview.zl_layoutCfg.isFlexSpace = flexible;
    if (arrangedSubview.hidden) return;
    self.markedDirty = YES;
    [self setNeedsUpdateConstraints];
}
- (void)setCustomSpacing:(CGFloat)spacing afterView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    if (![arrangedSubview isKindOfClass:UIView.class]) return;
    ZLLayoutViewCfg *viewCfg = arrangedSubview.zl_layoutCfg;
    if (viewCfg.behindSpacing == spacing) return;
    viewCfg.behindSpacing = spacing;
    if (arrangedSubview.hidden) return;
    if (self.layoutManager.constraints.count == 0) return;
    NSArray<NSLayoutConstraint *> * arr = [self.layoutManager.constraints filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSLayoutConstraint*  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        ZLConstraintsCfg *cfg = evaluatedObject.cfg;
        if ([cfg.view isEqual:arrangedSubview] && cfg.type == ZLLayoutConTypeSpacing
            ) {
            return YES;
        }
        return NO;
    }]];
    if (arr.count == 0) {
        self.markedDirty = YES;
        [self setNeedsUpdateConstraints];
    }else {
        arr.firstObject.constant = MAX(0, spacing);
    }
}

- (void)setAlignment:(ZLAlign)alignment forView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    ZLLayoutViewCfg *cfg = arrangedSubview.zl_layoutCfg;
    if (alignment == cfg.alignSelf) {
        cfg.isSetAlign = YES;
        return;
    }
    cfg.alignSelf = alignment;
    self.markedDirty = YES;
    [self setNeedsUpdateConstraints];
}
///设置view的alignment方向start间距
- (void)setAlignmentStartSpacing:(CGFloat)spacing forView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    ZLLayoutViewCfg *cfg = arrangedSubview.zl_layoutCfg;
    if (spacing == cfg.startSpacing) return;
    cfg.startSpacing = spacing;
    self.markedDirty = YES;
    [self setNeedsUpdateConstraints];
}
///设置view的alignment方向end间距
- (void)setAlignmentEndSpacing:(CGFloat)spacing forView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    ZLLayoutViewCfg *cfg = arrangedSubview.zl_layoutCfg;
    if (cfg.endSpacing == spacing) return;
    cfg.endSpacing = spacing;
    self.markedDirty = YES;
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [super updateConstraints];
    if (!self.markedDirty) return;
    [self refreshArrangedSubviews];
    [self.layoutManager removeAllSpacing];
    [self.layoutManager deactivateConstraints];
    [self.layoutManager addHorizontalLayoutConstraints];
    [self.layoutManager addVerticalLayoutConstraints];
    [self.layoutManager activateConstraints];
    self.markedDirty = NO;
}
///至关重要
- (CGSize)intrinsicContentSize {
    //返回自适应
    return CGSizeZero;
}
@end
