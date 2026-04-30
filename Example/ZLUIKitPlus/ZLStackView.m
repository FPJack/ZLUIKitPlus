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
@property (nonatomic,assign)BOOL    isFlexSpace;
@property (nonatomic,assign)ZLAlign alignSelf;


@property (nonatomic,weak)NSLayoutConstraint *leadingCons;
@property (nonatomic,weak)NSLayoutConstraint *trailingCons;
@property (nonatomic,weak)NSLayoutConstraint *topCons;
@property (nonatomic,weak)NSLayoutConstraint *bottomCons;
@property (nonatomic,weak)NSLayoutConstraint *centerXCons;
@property (nonatomic,weak)NSLayoutConstraint *centerYCons;
@property (nonatomic,weak)NSLayoutConstraint *widthCons;
@property (nonatomic,weak)NSLayoutConstraint *heightCons;

///是否设置对齐方式
@property (nonatomic,assign)BOOL isSetAlign;
@property (nonatomic,weak)ZLStackView *stackView;


@property (nonatomic,weak)UIView *view;
@property(nonatomic,readonly)NSLayoutXAxisAnchor
    *leadingAnchor;
@property(nonatomic,readonly)NSLayoutXAxisAnchor *trailingAnchor;
@property(nonatomic,readonly)NSLayoutYAxisAnchor
    *topAnchor;
@property(nonatomic,readonly)NSLayoutYAxisAnchor
    *bottomAnchor;
@property(nonatomic,readonly)NSLayoutXAxisAnchor
    *centerXAnchor;
@property(nonatomic,readonly)NSLayoutYAxisAnchor
    *centerYAnchor;

@property(nonatomic,readonly)NSLayoutDimension
    *widthAnchor;
@property(nonatomic,readonly)NSLayoutDimension
    *heightAnchor;
@property (nonatomic,readonly)UIEdgeInsets insets;
@property(nonatomic,assign)BOOL isFirstView;
@property(nonatomic,assign)BOOL isLastView;
@property(nonatomic,readonly)ZLJustify justify;
@property(nonatomic,readonly)CGFloat spacing;
@end
@implementation ZLViewLayoutCfg
- (UIView *)frontView {
    NSInteger idx = [self.stackView.arrangedViews indexOfObject:self.view];
    if (idx > 0 && idx < self.stackView.arrangedViews.count) {
        return self.stackView.arrangedViews[idx - 1];
        
    }
    return self.stackView;
}
- (UIView *)behindView {
    NSInteger idx = [self.stackView.arrangedViews indexOfObject:self.view];
    if (idx < self.stackView.arrangedViews.count - 1 && idx >= 0) {
        return self.stackView.arrangedViews[idx + 1];
    }
    return self.stackView;
}

- (void)addAllConstraints {
    [self addTopCons];
    [self addLeadingCons];
    [self addBottomCons];
    [self addTrailingCons];
    [self addCenterXCons];
    [self addCenterYCons];
    
    NSMutableArray *mArr = NSMutableArray.array;
    if (self.leadingCons) [mArr addObject:self.leadingCons];
    if (self.topCons) [mArr addObject:self.topCons];
    if (self.trailingCons) [mArr addObject:self.trailingCons];
    if (self.bottomCons) [mArr addObject:self.bottomCons];
    if (self.centerXCons) [mArr addObject:self.centerXCons];
    if (self.centerYCons) [mArr addObject:self.centerYCons];
    [NSLayoutConstraint activateConstraints:mArr];
}

- (NSLayoutConstraint *)addLeadingCons {
    if (_leadingCons) return _leadingCons;
    UIView *frontView = self.frontView;
    ZLViewLayoutCfg *fCfg = frontView.zl_layoutCfg;
    NSLayoutConstraint *cons;
    CGFloat leadingInset = self.insets.left;
    if (self.stackView.horizontal) {
        if (self.isFirstView) {
            switch (self.justify) {
                case ZLJustifyCenter:
                case ZlJustifyEnd:
                    cons = [self.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.stackView.leadingAnchor constant:leadingInset];
                    break;
                default:
                    cons = [self.leadingAnchor constraintEqualToAnchor:self.stackView.leadingAnchor constant:leadingInset];
                    break;
            }
        }else {
            if (self.isFlexSpace) {
                cons = [self.leadingAnchor constraintGreaterThanOrEqualToAnchor:fCfg.trailingAnchor constant:fCfg.behindSpacing];
            }else {
                cons = [self.leadingAnchor constraintEqualToAnchor:fCfg.trailingAnchor constant:fCfg.behindSpacing];
            }
        }
    }else {
        switch (self.alignSelf) {
            case ZLAlignStart:
            case ZLAlignFill:
                cons = [self.leadingAnchor constraintEqualToAnchor:self.stackView.leadingAnchor constant:self.startSpacing + leadingInset];
                break;
            case ZLAlignCenter:
            case ZLAlignEnd:
                cons = [self.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.stackView.leadingAnchor constant:self.startSpacing + leadingInset];
                break;
            default:
                break;
        }
    }
    _leadingCons = cons;
    return _leadingCons;
}
- (NSLayoutConstraint *)addTopCons {
    if (_topCons) return _topCons;
    UIView *frontView = self.frontView;
    ZLViewLayoutCfg *fCfg = frontView.zl_layoutCfg;
    NSLayoutConstraint *cons;
    CGFloat insetTop = self.insets.top;
    if (!self.stackView.horizontal) {
        if (self.isFirstView) {
            switch (self.justify) {
                case ZLJustifyCenter:
                case ZlJustifyEnd:
                    cons = [self.topAnchor constraintGreaterThanOrEqualToAnchor:self.stackView.topAnchor constant:insetTop];
                    break;
                default:
                    cons = [self.topAnchor constraintEqualToAnchor:self.stackView.topAnchor constant:insetTop];
                    break;
            }
        }else {
            if (self.isFlexSpace) {
                cons = [self.topAnchor constraintGreaterThanOrEqualToAnchor:fCfg.bottomAnchor constant:fCfg.behindSpacing];
            }else {
                cons = [self.topAnchor constraintEqualToAnchor:fCfg.bottomAnchor constant:fCfg.behindSpacing];
            }
        }
    }else {
        switch (self.alignSelf) {
            case ZLAlignStart:
            case ZLAlignFill:
                cons = [self.topAnchor constraintEqualToAnchor:self.stackView.topAnchor constant:self.startSpacing + insetTop];
                break;
            case ZLAlignCenter:
            case ZLAlignEnd:
                cons = [self.topAnchor constraintGreaterThanOrEqualToAnchor:self.stackView.topAnchor constant:self.startSpacing + insetTop];
                break;
            default:
                break;
        }
    }
    _topCons = cons;
    return _topCons;
}

- (NSLayoutConstraint *)addTrailingCons {
    if (_trailingCons) return _trailingCons;
    NSLayoutConstraint *cons;
    CGFloat insetTrailing = self.insets.right;
    if (!self.stackView.horizontal) {
        switch (self.alignSelf) {
            case ZLAlignStart:
            case ZLAlignCenter:
                cons = [self.trailingAnchor constraintLessThanOrEqualToAnchor:self.stackView.trailingAnchor constant:-self.endSpacing - insetTrailing];;
                break;
            case ZLAlignFill:
            case ZLAlignEnd:
                cons = [self.trailingAnchor constraintEqualToAnchor:self.stackView.trailingAnchor constant:-self.endSpacing - insetTrailing];
                break;
            default:
                break;
        }
    }else {
        if (self.isLastView) {

            if (self.justify == ZlJustifyFillEqually || self.justify == ZlJustifyFill) {
                cons = [self.trailingAnchor constraintEqualToAnchor:self.stackView.trailingAnchor constant:-insetTrailing];
            }else {
                cons = [self.trailingAnchor constraintLessThanOrEqualToAnchor:self.stackView.trailingAnchor constant:-insetTrailing];
                cons.priority = UILayoutPriorityDefaultHigh;
            }
           
        }
    }
    _trailingCons = cons;
    return _trailingCons;
}
- (NSLayoutConstraint *)addBottomCons {
    if (_bottomCons) return _bottomCons;
    NSLayoutConstraint *cons;
    CGFloat insetBottom = self.insets.bottom;
    if (self.stackView.horizontal) {//水平才添加底部约束
        switch (self.alignSelf) {
            case ZLAlignStart:
            case ZLAlignCenter:
                cons = [self.bottomAnchor constraintLessThanOrEqualToAnchor:self.stackView.bottomAnchor constant:-self.endSpacing - insetBottom];;
                break;
            case ZLAlignFill:
            case ZLAlignEnd:
                cons = [self.bottomAnchor constraintEqualToAnchor:self.stackView.bottomAnchor constant:-self.endSpacing - insetBottom];
                break;
            default:
                break;
        }
    }else {
        if (self.isLastView) {
            if (self.justify == ZlJustifyFillEqually ||
                self.justify == ZlJustifyFill) {
                cons = [self.bottomAnchor constraintEqualToAnchor:self.stackView.bottomAnchor constant:-insetBottom];
            }else {
                cons = [self.bottomAnchor constraintLessThanOrEqualToAnchor:self.stackView.bottomAnchor constant:-insetBottom];
                cons.priority = UILayoutPriorityDefaultHigh;
            }
        }
    }
    _bottomCons = cons;
    return _bottomCons;
}
- (NSLayoutConstraint *)addCenterXCons {
    if (_centerXCons) return _centerXCons;
    NSLayoutConstraint *cons;
    if(!self.stackView.horizontal) {
        if (self.alignSelf == ZLAlignCenter) {
            cons = [self.centerXAnchor constraintEqualToAnchor:self.stackView.centerXAnchor];
        }
    }
    _centerXCons = cons;
    return _centerXCons;
}
- (NSLayoutConstraint *)addCenterYCons {
    if (_centerYCons) return _centerYCons;
    NSLayoutConstraint *cons;
    if(self.stackView.horizontal) {
        if (self.alignSelf == ZLAlignCenter) {
            cons = [self.centerYAnchor constraintEqualToAnchor:self.stackView.centerYAnchor];
        }
    }
    _centerYCons = cons;
    return _centerYCons;
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
    if (self.isLastView) return 0;
    if (_behindSpacing > 0) return _behindSpacing;
    return self.spacing;
}

- (void)setView:(UIView *)view {
    _view = view;
    [view addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//    [view addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

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
//    if ([keyPath isEqualToString:@"bounds"]) {
//        CGRect oldBounds = [change[NSKeyValueChangeOldKey] CGRectValue];
//        CGRect newBounds = [change[NSKeyValueChangeNewKey] CGRectValue];
//        if (CGSizeEqualToSize(oldBounds.size, newBounds.size)) return;
//        if (self.stackView &&
//            [self.view.superview isEqual:self.stackView]) {
//            self.stackView.markedDirty = YES;
//            [self.stackView setNeedsLayout];
//        }
//    }
}
- (void)dealloc
{
    [self.view removeObserver:self forKeyPath:@"hidden"];
//    [self.view removeObserver:self forKeyPath:@"bounds"];

}

- (NSLayoutXAxisAnchor *)leadingAnchor {
    return self.view.leadingAnchor;
}
- (NSLayoutXAxisAnchor *)trailingAnchor {
    return self.view.trailingAnchor;
}
- (NSLayoutYAxisAnchor *)topAnchor {
    return self.view.topAnchor;
}
- (NSLayoutYAxisAnchor *)bottomAnchor {
    return self.view.bottomAnchor;
}
- (NSLayoutXAxisAnchor *)centerXAnchor {
    return self.view.centerXAnchor;
}
- (NSLayoutYAxisAnchor *)centerYAnchor {
    return self.view.centerYAnchor;
}
- (NSLayoutDimension *)widthAnchor {
    return self.view.widthAnchor;
}
- (NSLayoutDimension *)heightAnchor {
    return self.view.heightAnchor;
}
- (UIEdgeInsets)insets {
    return self.stackView.insets;
}
///取消view和布局引导之间的所有约束
- (void)deactivateConstraints {
    NSMutableArray *mArr = NSMutableArray.array;
    if (self.leadingCons) [mArr addObject:self.leadingCons];
    if (self.topCons) [mArr addObject:self.topCons];
    if (self.trailingCons) [mArr addObject:self.trailingCons];
    if (self.bottomCons) [mArr addObject:self.bottomCons];
    if (self.centerXCons) [mArr addObject:self.centerXCons];
    if (self.centerYCons) [mArr addObject:self.centerYCons];
    [NSLayoutConstraint deactivateConstraints:mArr];
}
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
@property (nonatomic, strong) NSMutableSet <NSLayoutConstraint *> *viewsWidthOrHeightConstraints;

@end
@implementation ZLStackView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.markedDirty = YES;
        self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}
- (NSMutableSet<NSLayoutConstraint *> *)viewsWidthOrHeightConstraints {
    if (!_viewsWidthOrHeightConstraints) {
        _viewsWidthOrHeightConstraints = NSMutableSet.set;
    }
    return _viewsWidthOrHeightConstraints;
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
        ZLViewLayoutCfg *cfg = view.zl_layoutCfg;
        [cfg deactivateConstraints];
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
    [view.zl_layoutCfg deactivateConstraints];
    view.zl_layoutCfg.stackView = nil;
    self.markedDirty = YES;
    [self setNeedsLayout];
}
- (void)setFlexibleSpacing:(BOOL)flexible afterView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    if (flexible == arrangedSubview.zl_layoutCfg.isFlexSpace) return;
    arrangedSubview.zl_layoutCfg.isFlexSpace = flexible;
    [self setNeedsLayout];
}
- (void)setCustomSpacing:(CGFloat)spacing afterView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    arrangedSubview.zl_layoutCfg.behindSpacing = spacing;
}

- (void)setAlignment:(ZLAlign)alignment forView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    ZLViewLayoutCfg *cfg = arrangedSubview.zl_layoutCfg;
    if (alignment == cfg.alignSelf) return;
    cfg.isSetAlign = YES;
    cfg.alignSelf = alignment;
    self.markedDirty = YES;
    [self setNeedsLayout];
}
///设置view的alignment方向start间距
- (void)setAlignmentStartSpacing:(CGFloat)spacing forView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    ZLViewLayoutCfg *cfg = arrangedSubview.zl_layoutCfg;
    if (spacing == cfg.startSpacing) return;
    cfg.startSpacing = spacing;
    self.markedDirty = YES;
    [self setNeedsLayout];
}
///设置view的alignment方向end间距
- (void)setAlignmentEndSpacing:(CGFloat)spacing forView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    ZLViewLayoutCfg *cfg = arrangedSubview.zl_layoutCfg;
    if (cfg.endSpacing == spacing) return;
    cfg.endSpacing = spacing;
    self.markedDirty = YES;
    [self setNeedsLayout];
}
- (void)updateConstraints {
    [super updateConstraints];
    [self updateViewsConstraints];
}
- (void)updateViewsConstraints {
    
}

///设置中心gap等宽或者等高
- (void)gapEqualSpaceBetween{
    if (self.justify != ZlJustifySpaceBetween) return;
    if (self.arrangedViews.count < 2) return;
    NSMutableArray<NSLayoutConstraint *> *spaceCons = NSMutableArray.array;
    BOOL isHorizontal = self.horizontal;
    [self.arrangedViews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0 && obj.zl_layoutCfg.leadingCons) {
            if (isHorizontal) {
                [spaceCons addObject:obj.zl_layoutCfg.leadingCons];
            }else {
                [spaceCons addObject:obj.zl_layoutCfg.topCons];
            }
        }
    }];
    if (spaceCons.count < 2) return;
    
    CGFloat totalValue = self.layoutMargins.left + self.layoutMargins.right;
    for (UIView *view  in self.arrangedViews) {
        totalValue += self.horizontal ? view.frame.size.width : view.frame.size.height;
    }
    
    CGFloat gapValue = [self availableHeightOrWidth];
    CGFloat itemGapValue = gapValue / (self.arrangedViews.count - 1);
    itemGapValue = MAX(0, itemGapValue);
    [spaceCons enumerateObjectsUsingBlock:^(NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.constant = itemGapValue;
    }];
}
///view的可用空间
- (CGFloat)availableHeightOrWidthForView:(UIView *)view {
    CGFloat totalValue = self.horizontal ? self.layoutMargins.left + self.layoutMargins.right : self.layoutMargins.top + self.layoutMargins.bottom;
    return (self.horizontal ? self.frame.size.width : self.frame.size.height) - totalValue;
}
        
///剩余空间
- (CGFloat)availableHeightOrWidth {
    CGFloat totalValue = self.horizontal ? self.layoutMargins.left + self.layoutMargins.right : self.layoutMargins.top + self.layoutMargins.bottom;
    for (UIView *view  in self.arrangedViews) {
        CGFloat widthOrHeight = self.horizontal ? view.frame.size.width : view.frame.size.height;
        totalValue += widthOrHeight;
    }
    return (self.horizontal ? self.frame.size.width : self.frame.size.height) - totalValue;
}
///view的所有宽高
- (CGFloat)arrangedViewsTotalWidthOrHeight {
    CGFloat totalValue = 0;
    for (UIView *view  in self.arrangedViews) {
        totalValue += self.horizontal ? view.frame.size.width : view.frame.size.height;
    }
    return totalValue;
}
///view 的所有间距
- (CGFloat)arrangedViewsTotalSpacing {
    CGFloat totalValue = 0;
    for (UIView *view  in self.arrangedViews) {
        totalValue += view.zl_layoutCfg.behindSpacing;
    }
    return totalValue;
}
///设置中心和边界gap等宽或者等高
- (void)gapEqualSpaceEvenly{
    if (self.justify != ZlJustifySpaceEvenly) return;
    if (self.arrangedViews.count < 2) return;
    NSMutableArray<NSLayoutConstraint *> *spaceCons = NSMutableArray.array;
    BOOL isHorizontal = self.horizontal;
    [self.arrangedViews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.zl_layoutCfg.leadingCons) {
            if (isHorizontal) {
                [spaceCons addObject:obj.zl_layoutCfg.leadingCons];
            }else {
                [spaceCons addObject:obj.zl_layoutCfg.topCons];
            }
        }
    }];
    if (spaceCons.count < 1) return;
    CGFloat gapValue = [self availableHeightOrWidth];
    CGFloat itemGapValue = gapValue / (self.arrangedViews.count + 1);
    itemGapValue = MAX(0, itemGapValue);
    [spaceCons enumerateObjectsUsingBlock:^(NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.constant = itemGapValue;
    }];
    
}

///设置中心gap等宽或者等高，边界gap是中心gap的一半
- (void)gapEqualSpaceAround{
   if(self.justify != ZlJustifySpaceAround) return;
    if (self.arrangedViews.count < 2) return;
    NSMutableArray<NSLayoutConstraint *> *spaceCons = NSMutableArray.array;
    BOOL isHorizontal = self.horizontal;
    [self.arrangedViews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.zl_layoutCfg.leadingCons) {
            if (isHorizontal) {
                [spaceCons addObject:obj.zl_layoutCfg.leadingCons];
            }else {
                [spaceCons addObject:obj.zl_layoutCfg.topCons];
            }
        }
    }];
    if (spaceCons.count < 1) return;
    CGFloat gapValue = [self availableHeightOrWidth];
    CGFloat itemGapValue = gapValue / self.arrangedViews.count;
    itemGapValue = MAX(0, itemGapValue);
    [spaceCons enumerateObjectsUsingBlock:^(NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            obj.constant = itemGapValue / 2.0;
        }else {
            obj.constant = itemGapValue;
        }
    }];
}
///配置居中对齐
- (void)configCenterAlign {
    if (self.justify != ZLJustifyCenter) return;
    if (self.arrangedViews.count < 1) return;
    CGFloat gapValue = [self availableHeightOrWidth];
    CGFloat spacing = [self arrangedViewsTotalSpacing];
    CGFloat leadingOrTopGap = gapValue - spacing;
    leadingOrTopGap = MAX(0, leadingOrTopGap);
    if (self.horizontal) {
        self.arrangedViews.firstObject.zl_layoutCfg.leadingCons.constant = leadingOrTopGap / 2.0;
    }else {
        self.arrangedViews.firstObject.zl_layoutCfg.topCons.constant = leadingOrTopGap / 2.0;
    }
}
- (void)configJustifyEnd {
    if (self.justify != ZlJustifyEnd) return;
    if (self.arrangedViews.count < 1) return;
    CGFloat gapValue = [self availableHeightOrWidth];
    CGFloat spacing = [self arrangedViewsTotalSpacing];
    CGFloat leadingOrTopGap = gapValue - spacing;
    leadingOrTopGap = MAX(0, leadingOrTopGap);
    if (self.horizontal) {
        self.arrangedViews.firstObject.zl_layoutCfg.leadingCons.constant = leadingOrTopGap;
    }else {
        self.arrangedViews.firstObject.zl_layoutCfg.topCons.constant = leadingOrTopGap;
    }
}
- (void)configJustifyStart {
    if (self.justify != ZLJustifyStart) return;
    if (self.arrangedViews.count < 1) return;
    if (self.horizontal) {
        self.arrangedViews.firstObject.zl_layoutCfg.leadingCons.constant = 0;
    }else {
        self.arrangedViews.firstObject.zl_layoutCfg.topCons.constant = 0;
    }
}
- (void)configJustifyFillEqually {
    if (self.justify != ZlJustifyFillEqually) return;
    if (self.arrangedViews.count < 1) return;
    [NSLayoutConstraint deactivateConstraints:self.viewsWidthOrHeightConstraints.allObjects];
    [self.viewsWidthOrHeightConstraints removeAllObjects];
    NSLayoutDimension *firstAnchor = self.horizontal ? self.arrangedViews.firstObject.zl_layoutCfg.widthAnchor : self.arrangedViews.firstObject.zl_layoutCfg.heightAnchor;
    [self.arrangedViews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj > 0) {
            NSLayoutDimension *anchor = self.horizontal ? obj.zl_layoutCfg.widthAnchor : obj.zl_layoutCfg.heightAnchor;
           NSLayoutConstraint *cons = [firstAnchor constraintEqualToAnchor:anchor];
            [self.viewsWidthOrHeightConstraints addObject:cons];
        }
    }];
    [NSLayoutConstraint activateConstraints:self.viewsWidthOrHeightConstraints.allObjects];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.arrangedViews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       NSLog(@"view frame:%f",obj.frame.size.height);
    }];
    
    if (!self.markedDirty) return;
    
    [self refreshArrangedSubviews];
    
    if (_viewsWidthOrHeightConstraints.count > 0) {
        [NSLayoutConstraint deactivateConstraints:_viewsWidthOrHeightConstraints.allObjects];
        [_viewsWidthOrHeightConstraints removeAllObjects];
    }
   
    NSInteger visibleCount = self.arrangedViews.count;
    for (int i = 0 ; i < visibleCount ; i ++) {
        UIView *view= self.arrangedViews[i];
        ZLViewLayoutCfg *cfg = view.zl_layoutCfg;
        cfg.isFirstView = i == 0;
        cfg.isLastView = i == visibleCount - 1;
        [cfg deactivateConstraints];
        [cfg addAllConstraints];
    }
    [self gapEqualSpaceBetween];
    [self gapEqualSpaceEvenly];
    [self gapEqualSpaceAround];
    [self configCenterAlign];
    [self configJustifyEnd];
    [self configJustifyStart];
    [self configJustifyFillEqually];
    self.markedDirty = NO;
}
///至关重要
- (CGSize)intrinsicContentSize {
    return CGSizeZero;
}
@end
