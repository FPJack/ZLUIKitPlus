//
//  ZLStackView.m
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/4/25.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLStackView.h"
#import <objc/runtime.h>
#define kViewAlignStartConsId @"kViewAlignStartConsId"
#define kViewAlignEndConsId @"kViewAlignEndConsId"
@interface ZLViewLayoutCfg: NSObject
@property (nonatomic,assign)CGFloat startSpacing;
@property (nonatomic,assign)CGFloat endSpacing;
@property (nonatomic,assign)CGFloat behindSpacing;
@property (nonatomic,assign)ZLAlign alignSelf;

@property (nonatomic,weak)NSLayoutConstraint *alignStartCons;
@property (nonatomic,weak)NSLayoutConstraint *alignEndCons;
///是否设置对齐方式
@property (nonatomic,assign)BOOL isSetAlign;
@property (nonatomic,weak)ZLStackView *stackView;
///view和UILayoutGuide之间的约束
@property (nonatomic,strong)NSMutableArray<NSLayoutConstraint *> *viewAndGuideConstraints;
///两边边界的宽度或者高度anchor数据
@property (nonatomic,strong)NSMutableArray<NSLayoutDimension *> *boundaryWithOrHeightGapAnchors;
///中心宽度或者高度anchor数据
@property (nonatomic,strong)NSMutableArray<NSLayoutDimension *> *centerWidthOrHeightGapAnchors;

@property (nonatomic,weak)UIView *view;
@property (nonatomic,strong)UILayoutGuide *endGapGuide;
@property (nonatomic,strong)UILayoutGuide *startGapGuide;
@property(nonatomic,readonly,strong)NSLayoutXAxisAnchor
    *leadingAnchor;
@property(nonatomic,readonly,strong)NSLayoutXAxisAnchor *trailingAnchor;
@property(nonatomic,readonly,strong)NSLayoutYAxisAnchor
    *topAnchor;
@property(nonatomic,readonly,strong)NSLayoutYAxisAnchor
    *bottomAnchor;


@property(nonatomic,readonly)BOOL isFirstView;
@property(nonatomic,readonly)BOOL isLastView;
@property(nonatomic,readonly)ZLJustify justify;
@property(nonatomic,readonly)CGFloat spacing;
@end
@implementation ZLViewLayoutCfg

- (BOOL)isFirstView {
    return [self.stackView.arrangedViews indexOfObject:self.view] == 0;
}
- (BOOL)isLastView {
    return [self.stackView.arrangedViews indexOfObject:self.view] == self.stackView.arrangedViews.count - 1;
}
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
    switch (self.justify) {
        case ZlJustifySpaceAround:
        case ZlJustifySpaceBetween:
        case ZlJustifySpaceEvenly:
            return 0;
        default:
            break;
    }
    if (_behindSpacing > 0) return _behindSpacing;
    return self.spacing;
}
- (NSMutableArray<NSLayoutConstraint *> *)viewAndGuideConstraints {
    if (!_viewAndGuideConstraints) {
        _viewAndGuideConstraints = NSMutableArray.array;
    }
    return _viewAndGuideConstraints;
}
- (NSMutableArray<NSLayoutDimension *> *)boundaryWithOrHeightGapAnchors {
    if (!_boundaryWithOrHeightGapAnchors) {
        _boundaryWithOrHeightGapAnchors = NSMutableArray.array;
    }
    return _boundaryWithOrHeightGapAnchors;
}
- (NSMutableArray<NSLayoutDimension *> *)centerWidthOrHeightGapAnchors {
    if (!_centerWidthOrHeightGapAnchors) {
        _centerWidthOrHeightGapAnchors = NSMutableArray.array;
    }
    return _centerWidthOrHeightGapAnchors;
}
- (void)setView:(UIView *)view {
    _view = view;
    [view addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
        if ([keyPath isEqualToString:@"hidden"]) {
            BOOL oldHidden = [change[NSKeyValueChangeOldKey] boolValue];
            BOOL newHidden = [change[NSKeyValueChangeNewKey] boolValue];
            if (oldHidden == newHidden) return;
            if (self.stackView) {
                [self.stackView setNeedsUpdateConstraints];
            }
        }
}
- (void)dealloc
{
    [self.view removeObserver:self forKeyPath:@"hidden"];
}
- (UILayoutGuide *)endGapGuide {
    if (!_endGapGuide) {
        _endGapGuide = [[UILayoutGuide alloc] init];
    }
    return _endGapGuide;
}
- (UILayoutGuide *)startGapGuide {
    if (!_startGapGuide) {
        _startGapGuide = [[UILayoutGuide alloc] init];
    }
    return _startGapGuide;
}
- (NSLayoutXAxisAnchor *)leadingAnchor {
    if (self.stackView.horizontal) {
        [self addStartGapGuide];
        ZLJustify justify = self.stackView.justify;
        if (justify ==  ZlJustifySpaceAround ||
            justify ==  ZlJustifySpaceEvenly ||
            justify ==  ZLJustifyCenter
            ) {
            if (self.isFirstView) {
                return self.startGapGuide.leadingAnchor;
            }
        }
    }
    return self.view.leadingAnchor;
}
- (NSLayoutXAxisAnchor *)trailingAnchor {
    if (self.stackView.horizontal) {
        [self addCenterGapGuide];
        [self addEndGapGuide];
        
        ZLJustify justify = self.stackView.justify;
        if (justify ==  ZlJustifySpaceAround ||
            justify ==  ZlJustifySpaceEvenly
            ) {
            return self.endGapGuide.trailingAnchor;
        }
        if (justify  == ZLJustifyCenter && self.isLastView) {
            return self.endGapGuide.trailingAnchor;
        }
        if (justify == ZlJustifySpaceBetween && !self.isLastView) {
            return self.endGapGuide.trailingAnchor;
        }
    }
    return self.view.trailingAnchor;
}
- (NSLayoutYAxisAnchor *)topAnchor {
    if (!self.stackView.horizontal) {
        [self addStartGapGuide];
        ZLJustify justify = self.stackView.justify;
        if (justify ==  ZlJustifySpaceAround ||
            justify ==  ZlJustifySpaceEvenly ||
            justify == ZLJustifyCenter
            ) {
                if (self.isFirstView) {
                    return self.startGapGuide.topAnchor;
                }
        }
    }
    return self.view.topAnchor;
}
- (NSLayoutYAxisAnchor *)bottomAnchor {
    if (!self.stackView.horizontal) {
        [self addCenterGapGuide];
        [self addEndGapGuide];
        
        ZLJustify justify = self.stackView.justify;
        if (justify ==  ZlJustifySpaceAround ||
            justify ==  ZlJustifySpaceEvenly
            ) {
            return self.endGapGuide.bottomAnchor;
        }
        if (justify  == ZLJustifyCenter && self.isLastView) {
            return self.endGapGuide.bottomAnchor;
        }
        if (justify == ZlJustifySpaceBetween && !self.isLastView) {
            return self.endGapGuide.bottomAnchor;
        }
    }
    return self.view.bottomAnchor;
}

///取消view和布局引导之间的所有约束
- (void)deactivateConstraints {
    if (_viewAndGuideConstraints && _viewAndGuideConstraints.count > 0) {
        [NSLayoutConstraint deactivateConstraints:self.viewAndGuideConstraints];
        [self.viewAndGuideConstraints removeAllObjects];
    }
}
- (void)addStartGapGuide  {
    ZLJustify justify = self.stackView.justify;
    if (justify == ZLJustifyCenter ||
        justify ==  ZlJustifySpaceAround ||
        justify ==  ZlJustifySpaceEvenly) {
        if (!self.isFirstView) return;
        if (self.stackView.horizontal) {
            [self.stackView addLayoutGuide:self.startGapGuide];
            NSLayoutConstraint *cons = [self.startGapGuide.trailingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
            cons.active = YES;
            [self.viewAndGuideConstraints addObject:cons];
            [self.boundaryWithOrHeightGapAnchors addObject:self.startGapGuide.widthAnchor];
        }else {
            [self.stackView addLayoutGuide:self.startGapGuide];
            NSLayoutConstraint *cons = [self.startGapGuide.bottomAnchor constraintEqualToAnchor:self.view.topAnchor];
            cons.active = YES;
            [self.viewAndGuideConstraints addObject:cons];
            [self.boundaryWithOrHeightGapAnchors addObject:self.startGapGuide.heightAnchor];
        }
    }
}
- (void)addEndGapGuide  {
    ZLJustify justify = self.stackView.justify;
    if (justify == ZLJustifyCenter ||
        justify ==  ZlJustifySpaceAround ||
        justify ==  ZlJustifySpaceEvenly) {
        if (!self.isLastView) return;
        if (self.stackView.horizontal) {
            [self.stackView addLayoutGuide:self.endGapGuide];
            NSLayoutConstraint *cons = [self.endGapGuide.leadingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
            cons.active = YES;
            [self.viewAndGuideConstraints addObject:cons];
            [self.boundaryWithOrHeightGapAnchors addObject:self.endGapGuide.widthAnchor];
        }else {
            [self.stackView addLayoutGuide:self.endGapGuide];
            NSLayoutConstraint *cons = [self.endGapGuide.topAnchor constraintEqualToAnchor:self.view.bottomAnchor];
            cons.active = YES;
            [self.viewAndGuideConstraints addObject:cons];
            [self.boundaryWithOrHeightGapAnchors addObject:self.endGapGuide.heightAnchor];
        }
    }
}
- (void)addCenterGapGuide  {
    ZLJustify justify = self.stackView.justify;
    if (justify == ZlJustifySpaceBetween ||
        justify ==  ZlJustifySpaceAround ||
        justify ==  ZlJustifySpaceEvenly) {
        if (self.isLastView ) return;
        if (self.stackView.horizontal) {
            [self.stackView addLayoutGuide:self.endGapGuide];
            NSLayoutConstraint *cons = [self.endGapGuide.leadingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
            cons.active = YES;
            [self.viewAndGuideConstraints addObject:cons];
            [self.centerWidthOrHeightGapAnchors addObject:self.endGapGuide.widthAnchor];
        }else {
            [self.stackView addLayoutGuide:self.endGapGuide];
            NSLayoutConstraint *cons = [self.endGapGuide.topAnchor constraintEqualToAnchor:self.view.bottomAnchor];
            cons.active = YES;
            [self.viewAndGuideConstraints addObject:cons];
            [self.centerWidthOrHeightGapAnchors addObject:self.endGapGuide.heightAnchor];
        }
    }
}
@end



@interface UIView (ZLView)
@property (nonatomic,readonly)ZLViewLayoutCfg *zl_layoutCfg;
@end
@implementation UIView (ZLView)
- (ZLViewLayoutCfg *)zl_layoutCfg {
    ZLViewLayoutCfg *cfg = objc_getAssociatedObject(self, _cmd);
    if (!cfg) {
        cfg = ZLViewLayoutCfg.new;
        objc_setAssociatedObject(self, _cmd, cfg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cfg;
}
@end

@interface ZLStackView()
@property (nonatomic, strong) NSMutableArray <NSLayoutConstraint *> *viewsWidthOrHeightConstraints;
@property (nonatomic, strong) NSMutableArray <NSLayoutConstraint *> *constraintsArr;

@end
@implementation ZLStackView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}
- (NSMutableArray<NSLayoutConstraint *> *)viewsWidthOrHeightConstraints {
    if (!_viewsWidthOrHeightConstraints) {
        _viewsWidthOrHeightConstraints = NSMutableArray.array;
    }
    return _viewsWidthOrHeightConstraints;
}
- (NSMutableArray<NSLayoutConstraint *> *)constraintsArr {
    if (!_constraintsArr) {
        _constraintsArr = NSMutableArray.array;
    }
    return _constraintsArr;
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
    [self setNeedsUpdateConstraints];
}
- (void)setJustify:(ZLJustify)justify {
    if (justify == _justify) return;
    _justify = justify;
    [self setNeedsUpdateConstraints];
}
- (void)setAlignment:(ZLAlign)alignment {
    if (alignment == _alignment) return;
    _alignment = alignment;
    [self setNeedsUpdateConstraints];
}
- (void)addArrangedSubview:(UIView *)view{
    if ([view isKindOfClass:UIView.class]) {
        if ([self.allViews containsObject:view]) return;
        [self.allViews addObject:view];
        if (view.hidden) return;
        [self.arrangedViews addObject:view];
        ZLViewLayoutCfg *cfg = view.zl_layoutCfg;
        [view.zl_layoutCfg deactivateConstraints];
        cfg.view = view;
        cfg.stackView = self;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
    }
}
- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex {
    if ([view isKindOfClass:UIView.class]) {
        if ([self.allViews containsObject:view]) return;
        [self.allViews insertObject:view atIndex:stackIndex];
        if (view.hidden) return;
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
    if (![self.arrangedViews containsObject:view]) return;
    [view removeFromSuperview];
    [self.arrangedViews removeObject:view];
    [view.zl_layoutCfg deactivateConstraints];
    view.zl_layoutCfg.stackView = nil;
    [self setNeedsUpdateConstraints];
}
- (void)setCustomSpacing:(CGFloat)spacing afterView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    arrangedSubview.zl_layoutCfg.behindSpacing = spacing;
}
- (void)setCustomAlignment:(ZLAlign)alignment forView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    arrangedSubview.zl_layoutCfg.isSetAlign = YES;
    arrangedSubview.zl_layoutCfg.alignSelf = alignment;
    [self setNeedsUpdateConstraints];
}
///设置view的alignment方向start间距
- (void)setCustomAlignmentStartSpacing:(CGFloat)spacing forView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    arrangedSubview.zl_layoutCfg.startSpacing = spacing;
    [self setNeedsUpdateConstraints];
    
    arrangedSubview.zl_layoutCfg.alignStartCons.constant = spacing;
    
    
}
///设置view的alignment方向end间距
- (void)setCustomAlignmentEndSpacing:(CGFloat)spacing forView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    arrangedSubview.zl_layoutCfg.endSpacing = spacing;
    [self setNeedsUpdateConstraints];
}
- (UIView *)frontViewWithView:(UIView *)view {
    NSInteger idx = [self.arrangedViews indexOfObject:view];
    if (idx > 0 && idx < self.arrangedViews.count) {
        return self.arrangedViews[idx - 1];
    }
    return self;
}
- (UIView *)behindViewWithView:(UIView *)view {
    NSInteger idx = [self.arrangedViews indexOfObject:view];
    if (idx < self.arrangedViews.count - 1 && idx >= 0) {
        return self.arrangedViews[idx + 1];
    }
    return self;
}
- (void)updateConstraints {
    [super updateConstraints];
    [self updateViewsConstraints];
}
- (void)updateViewsConstraints {
    [self refreshArrangedSubviews];

    [NSLayoutConstraint deactivateConstraints:_constraintsArr];
    [_constraintsArr removeAllObjects];
    
    [NSLayoutConstraint deactivateConstraints:_viewsWidthOrHeightConstraints];
    [_viewsWidthOrHeightConstraints removeAllObjects];
    
    for (int i = 0 ; i < self.arrangedViews.count ; i ++) {
        UIView *view= self.arrangedViews[i];
        [view.zl_layoutCfg deactivateConstraints];
        [self addTop:view index:i];
        [self addBottom:view index:i];
        [self addLeading:view index:i];
        [self addTrailing:view index:i];
        [self addCenterX:view index:i];
        [self addCenterY:view index:i];
    }
    
    [self equalViewWidthOrHeightAnchors];

    if (self.justify == ZlJustifySpaceBetween) {
        [self gapEqualSpaceBetween];
    }else if (self.justify == ZlJustifySpaceAround) {
        [self gapEqualSpaceAround];
    }else if (self.justify == ZlJustifySpaceEvenly) {
        [self gapEqualSpaceEvenly];
    }else if (self.justify == ZLJustifyCenter) {
        [self boundryGapEqualWidthOrHeight];
    }
}
///设置等宽或者等高
- (void)equalViewWidthOrHeightAnchors {
    if (self.justify != ZlJustifyFillEqually) return;
    if (self.arrangedViews.count <= 1) return;
    NSMutableArray *arr = NSMutableArray.array;
    [self.arrangedViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         [arr addObject:self.horizontal ? obj.widthAnchor : obj.heightAnchor];
    }];
    NSLayoutDimension *first = arr.firstObject;
    [arr enumerateObjectsUsingBlock:^(NSLayoutDimension * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > 0) {
                NSLayoutConstraint *cons = [first constraintEqualToAnchor:obj];
                cons.active = YES;
                [self.viewsWidthOrHeightConstraints addObject:cons];
            }
    }];
}
//设置边界的gap等宽或者等高
- (void)boundryGapEqualWidthOrHeight {
    NSMutableArray<NSLayoutDimension *>  *arr = NSMutableArray.array;
    for (int i = 0 ; i < self.arrangedViews.count ; i ++) {
        UIView *view= self.arrangedViews[i];
        [arr addObjectsFromArray:view.zl_layoutCfg.boundaryWithOrHeightGapAnchors];
    }
    NSLayoutConstraint *cons = [arr.firstObject constraintEqualToAnchor:arr.lastObject];
    cons.active = YES;
    [self.constraintsArr addObject:cons];
}

///设置中心gap等宽或者等高
- (void)gapEqualSpaceBetween{
    NSMutableArray  *arr = NSMutableArray.array;
    for (int i = 0 ; i < self.arrangedViews.count ; i ++) {
        UIView *view= self.arrangedViews[i];
        [arr addObjectsFromArray:view.zl_layoutCfg.centerWidthOrHeightGapAnchors];

    }
    NSLayoutDimension *first = arr.firstObject;
    [arr enumerateObjectsUsingBlock:^(NSLayoutDimension*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0) {
            NSLayoutConstraint *cons = [first constraintEqualToAnchor:obj];
            cons.active = YES;
            [self.constraintsArr addObject:cons];
        }
    }];
}

///设置中心和边界gap等宽或者等高
- (void)gapEqualSpaceEvenly{
    NSMutableArray  *arr = NSMutableArray.array;
    for (int i = 0 ; i < self.arrangedViews.count ; i ++) {
        UIView *view= self.arrangedViews[i];
        [arr addObjectsFromArray:view.zl_layoutCfg.boundaryWithOrHeightGapAnchors];
        [arr addObjectsFromArray:view.zl_layoutCfg.centerWidthOrHeightGapAnchors];

    }
    NSLayoutDimension *first = arr.firstObject;
    [arr enumerateObjectsUsingBlock:^(NSLayoutDimension*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0) {
            NSLayoutConstraint *cons = [first constraintEqualToAnchor:obj];
            cons.active = YES;
            [self.constraintsArr addObject:cons];
        }
    }];
}

///设置中心gap等宽或者等高，边界gap是中心gap的一半
- (void)gapEqualSpaceAround{
    
    NSMutableArray<NSLayoutDimension*>  *arr1 = NSMutableArray.array;
    NSMutableArray<NSLayoutDimension*>  *arr2 = NSMutableArray.array;

    for (int i = 0 ; i < self.arrangedViews.count ; i ++) {
        UIView *view= self.arrangedViews[i];
        [arr1 addObjectsFromArray:view.zl_layoutCfg.boundaryWithOrHeightGapAnchors];
        [arr2 addObjectsFromArray:view.zl_layoutCfg.centerWidthOrHeightGapAnchors];

    }
   
    
    {
        NSLayoutConstraint *cons = [arr1.firstObject constraintEqualToAnchor:arr1.lastObject];
        cons.active = YES;
        [self.constraintsArr addObject:cons];
    }
    
    {
        NSLayoutDimension *first1 = arr2.firstObject;
        [arr2 enumerateObjectsUsingBlock:^(NSLayoutDimension*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > 0) {
                NSLayoutConstraint *cons = [first1 constraintEqualToAnchor:obj];
                cons.active = YES;
                [self.constraintsArr addObject:cons];
            }
        }];
    }
    {
        NSLayoutConstraint *cons = [arr1.firstObject constraintEqualToAnchor:arr2.firstObject multiplier:0.5];
        cons.active = YES;
        [self.constraintsArr addObject:cons];
    }
}


- (void)addCenterX:(UIView *)view index:(NSInteger)index {
    if (self.horizontal) return;
    if (view.zl_layoutCfg.alignSelf == ZLAlignCenter) {
        NSLayoutConstraint *cons = [view.centerXAnchor constraintEqualToAnchor:self.layoutMarginsGuide.centerXAnchor];
        cons.active = YES;
        [self.constraintsArr addObject:cons];
    }
}
- (void)addCenterY:(UIView *)view index:(NSInteger)index {
    if (!self.horizontal) return;
    if (view.zl_layoutCfg.alignSelf == ZLAlignCenter) {
        NSLayoutConstraint *cons = [view.centerYAnchor constraintEqualToAnchor:self.layoutMarginsGuide.centerYAnchor];
        cons.active = YES;
        [self.constraintsArr addObject:cons];
    }
}

- (void)addTop:(UIView *)view index:(NSInteger)index {
    BOOL isFirst = index == 0;
    UIView *fView = [self frontViewWithView:view];
    NSLayoutConstraint *cons;
    if (self.horizontal) {
        switch (view.zl_layoutCfg.alignSelf) {
            case ZLAlignStart:
            case ZLAlignFill:
            cons = [view.zl_layoutCfg.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor constant:view.zl_layoutCfg.startSpacing];
                break;
            case ZLAlignCenter:
            case ZLAlignEnd:
            default:
                cons = [view.zl_layoutCfg.topAnchor constraintGreaterThanOrEqualToAnchor:self.layoutMarginsGuide.topAnchor constant:view.zl_layoutCfg.startSpacing];
                break;
        }
        view.zl_layoutCfg.alignStartCons = cons;
    }else {
        switch (self.justify) {
            case ZlJustifyFill:
            case ZlJustifyFillEqually:
            case ZLJustifyStart:
            case ZlJustifySpaceBetween:
            case ZlJustifySpaceAround:
            case ZlJustifySpaceEvenly:
                if (isFirst) {
                    cons = [view.zl_layoutCfg.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor constant:0];
                }else {
                    cons = [view.zl_layoutCfg.topAnchor constraintEqualToAnchor:fView.zl_layoutCfg.bottomAnchor constant:fView.zl_layoutCfg.behindSpacing];
                }
                break;
            case ZLJustifyCenter:
                if (isFirst) {
                    cons = [view.zl_layoutCfg.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor constant:0];
                }else {
                    cons = [view.zl_layoutCfg.topAnchor constraintEqualToAnchor:fView.zl_layoutCfg.bottomAnchor constant:fView.zl_layoutCfg.behindSpacing];
                }
                break;
            case ZlJustifyEnd:
                if (isFirst) {
                    cons = [view.zl_layoutCfg.topAnchor constraintGreaterThanOrEqualToAnchor:self.layoutMarginsGuide.topAnchor constant:0];
                }else {
                    cons = [view.zl_layoutCfg.topAnchor constraintEqualToAnchor:fView.zl_layoutCfg.bottomAnchor constant:fView.zl_layoutCfg.behindSpacing];
                }
                break;
            default:
                break;
        }
    }
    cons.active = YES;
    if (cons) {
        [self.constraintsArr addObject:cons];
    }
}
- (void)addBottom:(UIView *)view index:(NSInteger)index {
    BOOL isLast = index == self.arrangedViews.count - 1;
    NSLayoutConstraint *cons;
    if (self.horizontal) {
        switch (view.zl_layoutCfg.alignSelf) {
            case ZLAlignEnd:
            case ZLAlignFill:
            cons = [view.zl_layoutCfg.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor constant:-view.zl_layoutCfg.endSpacing];
                break;
            case ZLAlignStart:
            case ZLAlignCenter:
            default:
                cons = [view.zl_layoutCfg.bottomAnchor constraintLessThanOrEqualToAnchor:self.layoutMarginsGuide.bottomAnchor constant:-view.zl_layoutCfg.endSpacing];
                break;
        }
        view.zl_layoutCfg.alignEndCons = cons;
    }else {
        switch (self.justify) {
            case ZlJustifyFill:
            case ZlJustifyFillEqually:
            case ZlJustifyEnd:
            case ZlJustifySpaceBetween:
            case ZlJustifySpaceAround:
            case ZlJustifySpaceEvenly:
                if (isLast) {
                    cons = [view.zl_layoutCfg.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor constant:0];
                }
                break;
            case ZLJustifyCenter:
                if (isLast) {
                    cons = [view.zl_layoutCfg.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor constant:0];
                }
                break;
            case ZLJustifyStart:
                if (isLast) {
                    cons = [view.zl_layoutCfg.bottomAnchor constraintLessThanOrEqualToAnchor:self.layoutMarginsGuide.bottomAnchor constant:0];
                }
                break;
            default:
                break;
        }
    }
    cons.active = YES;
    if (cons) {
        [self.constraintsArr addObject:cons];
    }
}
- (void)addLeading:(UIView *)view index:(NSInteger)index {
    
    BOOL isFirst = index == 0;
    UIView *fView = [self frontViewWithView:view];
    NSLayoutConstraint *cons;
    if (self.horizontal) {
        switch (self.justify) {
            case ZlJustifyFill:
            case ZlJustifyFillEqually:
            case ZLJustifyStart:
            case ZlJustifySpaceBetween:
            case ZlJustifySpaceAround:
            case ZlJustifySpaceEvenly:
                if (isFirst) {
                    cons = [view.zl_layoutCfg.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor constant:0];
                }else {
                    cons = [view.zl_layoutCfg.leadingAnchor constraintEqualToAnchor:fView.zl_layoutCfg.trailingAnchor constant:fView.zl_layoutCfg.behindSpacing];
                }
                break;
            case ZLJustifyCenter:
                if (isFirst) {
                    cons = [view.zl_layoutCfg.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor constant:0];
                }else {
                    cons = [view.zl_layoutCfg.leadingAnchor constraintEqualToAnchor:fView.zl_layoutCfg.trailingAnchor constant:fView.zl_layoutCfg.behindSpacing];
                }
                break;
            case ZlJustifyEnd:
                if (isFirst) {
                    cons = [view.zl_layoutCfg.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.layoutMarginsGuide.leadingAnchor constant:0];
                }else {
                    cons = [view.zl_layoutCfg.leadingAnchor constraintEqualToAnchor:fView.zl_layoutCfg.trailingAnchor constant:fView.zl_layoutCfg.behindSpacing];
                }
                break;
            default:
                break;
        }
    }else {
        switch (view.zl_layoutCfg.alignSelf) {
            case ZLAlignStart:
            case ZLAlignFill:
            cons = [view.zl_layoutCfg.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor constant:view.zl_layoutCfg.startSpacing];
                break;
            case ZLAlignCenter:
            case ZLAlignEnd:
            default:
                cons = [view.zl_layoutCfg.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.layoutMarginsGuide.leadingAnchor constant:view.zl_layoutCfg.startSpacing];
                break;
        }
        view.zl_layoutCfg.alignStartCons = cons;
    }
    cons.active = YES;
    if (cons) {
        [self.constraintsArr addObject:cons];
    }
}
- (void)addTrailing:(UIView *)view index:(NSInteger)index {
    BOOL isLast = index == self.arrangedViews.count - 1;
    NSLayoutConstraint *cons;
    if (self.horizontal) {
        switch (self.justify) {
            case ZlJustifyFill:
            case ZlJustifyFillEqually:
            case ZlJustifyEnd:
            case ZlJustifySpaceBetween:
            case ZlJustifySpaceAround:
            case ZlJustifySpaceEvenly:
                if (isLast) {
                    cons = [view.zl_layoutCfg.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor constant:0];
                }
                break;
            case ZLJustifyCenter:
                if (isLast) {
                    cons = [view.zl_layoutCfg.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor constant:0];
                }
                break;
            case ZLJustifyStart:
                if (isLast) {
                    cons = [view.zl_layoutCfg.trailingAnchor constraintLessThanOrEqualToAnchor:self.layoutMarginsGuide.trailingAnchor constant:0];
                }
                break;
            default:
                break;
        }
    }else {
        switch (view.zl_layoutCfg.alignSelf) {
            case ZLAlignEnd:
            case ZLAlignFill:
                cons = [view.zl_layoutCfg.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor constant:-view.zl_layoutCfg.endSpacing];
                break;
            case ZLAlignStart:
            case ZLAlignCenter:
            default:
                cons = [view.zl_layoutCfg.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor constant:-view.zl_layoutCfg.endSpacing];
                break;
        }
        view.zl_layoutCfg.alignEndCons = cons;
    }
    cons.active = YES;
    if (cons) {
        [self.constraintsArr addObject:cons];
    }
}
@end
