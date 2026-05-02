//
//  ZLStackView.m
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/4/25.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLStackView.h"
#import <objc/runtime.h>
#import "ZLSpacingGuideCoordinator.h"

#define kViewAlignStartConsId @"kViewAlignStartConsId"
#define kViewAlignEndConsId @"kViewAlignEndConsId"

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
            cons = [self.leadingAnchor constraintEqualToAnchor:self.stackView.leadingGuide.trailingAnchor constant:leadingInset];
        }else {
            cons = [self.leadingAnchor constraintEqualToAnchor:fCfg.trailingAnchor constant:fCfg.behindSpacing];
        }
    }else {
        cons = [self.leadingAnchor constraintEqualToAnchor:self.stackView.leadingGuide.trailingAnchor constant:self.startSpacing + leadingInset];
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
            cons = [self.topAnchor constraintEqualToAnchor:self.stackView.topGuide.bottomAnchor constant:insetTop];

        }else {
            cons = [self.topAnchor constraintEqualToAnchor:fCfg.bottomAnchor constant:fCfg.behindSpacing];
        }
    }else {
        cons = [self.topAnchor constraintEqualToAnchor:self.stackView.topGuide.bottomAnchor constant:self.startSpacing + insetTop];
    }
    _topCons = cons;
    return _topCons;
}


- (NSLayoutConstraint *)addTrailingCons {
    if (_trailingCons) return _trailingCons;
    NSLayoutConstraint *cons;
    CGFloat insetTrailing = self.insets.right;
    if (!self.stackView.horizontal) {
        cons = [self.trailingAnchor constraintEqualToAnchor:self.stackView.trailingGuide.leadingAnchor constant:-self.endSpacing - insetTrailing];
    }else {
        if (self.isLastView) {
            cons = [self.trailingAnchor constraintEqualToAnchor:self.stackView.trailingGuide.leadingAnchor constant:-insetTrailing];
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
        cons = [self.bottomAnchor constraintEqualToAnchor:self.stackView.bottomGuide.topAnchor constant:-self.endSpacing - insetBottom];
    }else {
        if (self.isLastView) {
            cons = [self.bottomAnchor constraintEqualToAnchor:self.stackView.bottomGuide.topAnchor constant:-insetBottom];
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
    if (!self.isKVOAdded) {
        self.isKVOAdded = YES;
        [view addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [view addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
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
    if ([keyPath isEqualToString:@"bounds"]) {
        CGRect oldBounds = [change[NSKeyValueChangeOldKey] CGRectValue];
        CGRect newBounds = [change[NSKeyValueChangeNewKey] CGRectValue];
        if (CGSizeEqualToSize(oldBounds.size, newBounds.size)) return;
        if (self.stackView &&
            [self.view.superview isEqual:self.stackView]) {
            self.stackView.markedDirty = YES;
//            [self.stackView setNeedsLayout];
        }
    }
}
- (void)dealloc
{
    if (self.isKVOAdded) {
        [self.view removeObserver:self forKeyPath:@"hidden"];
        [self.view removeObserver:self forKeyPath:@"bounds"];
    }
}

- (CGFloat)widthOrHeightPlusBehindSpacing {
    if (_isFirstView) return 0;
    if (self.stackView.horizontal) {
        return CGRectGetWidth(self.view.frame) + self.behindSpacing;
    }else {
        return CGRectGetHeight(self.view.frame) + self.behindSpacing;
    }
}
- (CGFloat)leadingOrTopContant {
    UIView *frontView = self.frontView;
    UIView *frontViewFrontView = frontView.zl_layoutCfg.frontView;
    return  frontViewFrontView.zl_layoutCfg.widthOrHeightPlusBehindSpacing + frontView.zl_layoutCfg
        .widthOrHeightPlusBehindSpacing;
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
    _leadingCons = nil;
    _topCons = nil;
    _trailingCons = nil;
    _bottomCons = nil;
    _centerXCons = nil;
    _centerYCons = nil;
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


@implementation ZLLayoutGuide
- (instancetype)initWithStackView:(ZLStackView *)stackView direction:(int)direction {
    self.stackView = stackView;
    self.direction = direction;
    return self;
}
- (void)setStackView:(ZLStackView *)stackView{
    _stackView = stackView;
    if (stackView) {
        [stackView addLayoutGuide:self];
    }
}
- (void)addGreadThanWidthCons {
    if (_widthCons) {
        _widthCons.active = NO;
    }
   [self.stackView addLayoutGuide:self];
   self.widthCons = [self.widthAnchor constraintGreaterThanOrEqualToConstant:0];
    self.widthCons.active = YES;
}
- (void)addGreadThanHeightCons {
    if (_heightCons) {
        _heightCons.active = NO;
    }
    [self.stackView addLayoutGuide:self];
    self.heightCons = [self.heightAnchor constraintGreaterThanOrEqualToConstant:0];
    self.heightCons.active = YES;
}
- (void)addZeroHeightCons {
    if (_heightCons) {
        _heightCons.active = NO;
    }
    [self.stackView addLayoutGuide:self];
    self.heightCons = [self.heightAnchor constraintEqualToConstant:0];
    self.heightCons.active = YES;

}
- (void)addZeroWidthCons {
    if (_widthCons) {
        _widthCons.active = NO;
    }
   [self.stackView addLayoutGuide:self];
   self.widthCons = [self.widthAnchor constraintEqualToConstant:0];
    self.widthCons.active = YES;
}
- (void)deactivateConstraints {
    _heightCons.active = NO;
    _heightCons = nil;
    _widthCons.active = NO;
    _widthCons = nil;
}
@end



@interface ZLTopGuide : ZLLayoutGuide
@end
@implementation ZLTopGuide
@end
@interface ZLLeadingGuide : ZLLayoutGuide
@end
@implementation ZLLeadingGuide
@end
@interface ZLBottomGuide : ZLLayoutGuide
@end
@implementation ZLBottomGuide
@end
@interface ZLTrailingGuide : ZLLayoutGuide
@end
@implementation ZLTrailingGuide
@end
@implementation ZLLayoutGuideMerge

- (NSLayoutXAxisAnchor *)leadingAnchor {
    switch (self.stackView.justify) {
        case ZLJustifyCenter:
        case ZlJustifySpaceAround:
        case ZlJustifySpaceEvenly:
        {
            return self.leadingGuide.trailingAnchor;
        }
            break;
        default:
            break;
    }
    return self.stackView.leadingAnchor;
}

- (NSLayoutXAxisAnchor *)trailingAnchor {
    switch (self.stackView.justify) {
        case ZLJustifyCenter:
        case ZlJustifySpaceAround:
        case ZlJustifySpaceEvenly:
        {
            return self.trailingGuide.leadingAnchor;
        }
            break;
        default:
            break;
    }
    return self.stackView.trailingAnchor;
}

- (NSLayoutYAxisAnchor *)topAnchor {
    switch (self.stackView.justify) {
        case ZLJustifyCenter:
        case ZlJustifySpaceAround:
        case ZlJustifySpaceEvenly:
        {
            return self.topGuide.bottomAnchor;
        }
            break;
        default:
            break;
    }
    return self.stackView.topAnchor;
}
- (NSLayoutYAxisAnchor *)bottomAnchor {
    switch (self.stackView.justify) {
        case ZLJustifyCenter:
        case ZlJustifySpaceAround:
        case ZlJustifySpaceEvenly:
        {
            return self.bottomGuide.topAnchor;
        }
            break;
        default:
            break;
    }
    return self.stackView.bottomAnchor;
}
- (NSLayoutYAxisAnchor *)alignTopAnchor {
    switch (self.stackView.alignment) {
        case ZLAlignCenter:
            return self.topGuide.bottomAnchor;
        case ZLAlignStart:
        case ZLAlignFill:
        case ZLAlignEnd:
        default:
            break;
    }
    return self.stackView.topAnchor;
}
- (NSLayoutYAxisAnchor *)alignBottomAnchor {
    switch (self.stackView.alignment) {
        case ZLAlignCenter:
            return self.bottomGuide.topAnchor;
        case ZLAlignEnd:
        case ZLAlignFill:
        case ZLAlignStart:
        default:
            break;
    }
    return self.stackView.bottomAnchor;
}
- (NSLayoutXAxisAnchor *)alignLeadingAnchor {
    switch (self.stackView.alignment) {
        case ZLAlignCenter:
            return self.leadingGuide.trailingAnchor;
        case ZLAlignStart:
        case ZLAlignFill:
        case ZLAlignEnd:
        default:
            break;
    }
        return self.stackView.leadingAnchor;
    
}
- (NSLayoutXAxisAnchor *)alignTrailingAnchor {
    switch (self.stackView.alignment) {
        case ZLAlignCenter:
            return self.trailingGuide.leadingAnchor;
        case ZLAlignEnd:
        case ZLAlignFill:
        case ZLAlignStart:
        default:
            break;
    }
    return self.stackView.trailingAnchor;

}

- (NSArray<NSLayoutDimension *> *)widthAnchors {
    return @[
        self.leadingGuide.widthAnchor,
        self.trailingGuide.widthAnchor
    ];
}
- (NSArray<NSLayoutDimension *> *)heightAnchors {
    return @[
        self.topGuide.heightAnchor,
        self.bottomGuide.heightAnchor
    ];
}
- (UILayoutGuide *)topGuide {
    if (!_topGuide) {
        _topGuide = [[ZLTopGuide alloc] initWithStackView:self.stackView direction:0];
        [self.stackView addLayoutGuide:_topGuide];
        [_topGuide.topAnchor constraintEqualToAnchor:self.stackView.topAnchor].active = YES;
    }
    return _topGuide;
}
- (UILayoutGuide *)leadingGuide {
    if (!_leadingGuide) {
        _leadingGuide = [[ZLLeadingGuide alloc] initWithStackView:self.stackView direction:1];
        [self.stackView addLayoutGuide:_leadingGuide];
        [_leadingGuide.leadingAnchor constraintEqualToAnchor:self.stackView.leadingAnchor].active = YES;
    }
    return _leadingGuide;
}
- (UILayoutGuide *)bottomGuide {
    if (!_bottomGuide) {
        _bottomGuide = [[ZLBottomGuide alloc] initWithStackView:self.stackView direction:2];
        [self.stackView addLayoutGuide:_bottomGuide];
        [_bottomGuide.bottomAnchor constraintEqualToAnchor:self.stackView.bottomAnchor].active = YES;
    }
    return _bottomGuide;
}

- (UILayoutGuide *)trailingGuide {
    if (!_trailingGuide) {
        _trailingGuide = [[ZLTrailingGuide alloc] initWithStackView:self.stackView direction:3];
        [self.stackView addLayoutGuide:_trailingGuide];
        [_trailingGuide.trailingAnchor constraintEqualToAnchor:self.stackView.trailingAnchor].active = YES;
    }
    return _trailingGuide;
}
- (void)addJustifyConstraints {
    if (self.stackView.horizontal) {
        switch (self.stackView.justify) {
            case ZlJustifyFill:
            case ZlJustifyFillEqually:
            case ZlJustifySpaceBetween:
                [self.leadingGuide addZeroWidthCons];
                [self.trailingGuide addZeroWidthCons];
                break;
            case ZLJustifyStart:
                [self.trailingGuide addGreadThanWidthCons];
                [self.leadingGuide addZeroWidthCons];
                break;
            case ZlJustifyEnd:
                [self.leadingGuide addGreadThanWidthCons];
                [self.trailingGuide addZeroWidthCons];
                break;
            case ZLJustifyCenter:
            case ZlJustifySpaceAround:
            case ZlJustifySpaceEvenly:
                [self addEqualWidthConstraint];
                break;
            default:
                break;
        }
    }else {
        switch (self.stackView.justify) {
            case ZlJustifyFill:
            case ZlJustifyFillEqually:
            case ZlJustifySpaceBetween:
                [self.bottomGuide addZeroHeightCons];
                [self.topGuide addZeroHeightCons];
                break;
            case ZLJustifyStart:
                [self.bottomGuide addGreadThanHeightCons];
                [self.topGuide addZeroHeightCons];
                break;
            case ZlJustifyEnd:
                [self.topGuide addGreadThanHeightCons];
                [self.bottomGuide addZeroHeightCons];
                break;
            case ZLJustifyCenter:
            case ZlJustifySpaceAround:
            case ZlJustifySpaceEvenly:
                [self addEqualHeightConstraint];
                break;
            default:
                break;
        }
    }
}
- (void)addAlignConstraints {
    if (self.stackView.horizontal) {
        switch (self.stackView.alignment) {
            case ZLAlignStart:
                [self.topGuide addZeroHeightCons];
                [self.bottomGuide addGreadThanHeightCons];
                break;
            case ZLAlignCenter:
                [self addEqualHeightConstraint];
                break;
            case ZLAlignEnd:
                [self.topGuide addGreadThanHeightCons];
                [self.bottomGuide addZeroHeightCons];
                break;
            case ZLAlignFill:
                [self.bottomGuide addZeroHeightCons];
                [self.topGuide addZeroHeightCons];
                break;
            default:
                break;
        }
    }else {
        switch (self.stackView.alignment) {
            case ZLAlignStart:
                [self.trailingGuide addGreadThanWidthCons];
                [self.leadingGuide addZeroWidthCons];
                break;
            case ZLAlignCenter:
                [self addEqualWidthConstraint];
                break;
            case ZLAlignEnd:
                [self.leadingGuide addGreadThanWidthCons];
                [self.trailingGuide addZeroWidthCons];
                break;
            case ZLAlignFill:
                [self.trailingGuide addZeroWidthCons];
                [self.leadingGuide addZeroWidthCons];
                break;
            default:
                break;
        }
    }
}
- (void)addEqualWidthConstraint {
   self.eqWidthCons = [self.leadingGuide.widthAnchor constraintEqualToAnchor:self.trailingGuide.widthAnchor];
    self.eqWidthCons.active = YES;
}
- (void)addEqualHeightConstraint {
   self.eqHeightCons = [self.topGuide.heightAnchor constraintEqualToAnchor:self.bottomGuide.heightAnchor];
    self.eqHeightCons.active = YES;
}
- (void)setEqWidthConstant:(CGFloat)constant {
    self.leadingGuide.widthCons.constant = constant;
    self.trailingGuide.widthCons.constant = constant;
}
- (void)setEqHeightConstant:(CGFloat)constant {
    self.topGuide.heightCons.constant = constant;
    self.bottomGuide.heightCons.constant = constant;
}
- (void)setEqConstraintsValue:(CGFloat)constant {
    if (self.stackView.horizontal) {
        [self setEqWidthConstant:constant];
    }else {
        [self setEqHeightConstant:constant];
    }
}
- (void)deactivateConstraints {
    _eqWidthCons.active = NO;
    _eqHeightCons.active = NO;
    _eqWidthCons = nil;
    _eqHeightCons = nil;
    [_leadingGuide deactivateConstraints];
    [_trailingGuide deactivateConstraints];
    [_topGuide deactivateConstraints];
    [_bottomGuide deactivateConstraints];
}
@end

@interface ZLStackView()
@property (nonatomic, strong) NSMutableSet <NSLayoutConstraint *> *viewsWidthOrHeightConstraints;
@property (nonatomic, strong) NSMutableSet <NSLayoutConstraint *> *gapWidthOrHeightConstraints;
@property (nonatomic,strong)ZLLayoutGuideMerge *guideMerge;
@property (nonatomic,strong)ZLSpacingGuideCoordinator *spacingGuideCoordinator;
@end
@implementation ZLStackView
- (ZLSpacingGuideCoordinator *)spacingGuideCoordinator {
    if (!_spacingGuideCoordinator) {
        _spacingGuideCoordinator = [[ZLSpacingGuideCoordinator alloc] init];
        _spacingGuideCoordinator.stackView = self;
    }
    return _spacingGuideCoordinator;
}
- (ZLLayoutGuideMerge *)guideMerge {
    if (!_guideMerge) {
        _guideMerge = [[ZLLayoutGuideMerge alloc] init];
        _guideMerge.stackView = self;
    }
    return _guideMerge;
}
- (UILayoutGuide *)topGuide {
    return self.guideMerge.topGuide;
}
- (UILayoutGuide *)leadingGuide {
    return self.guideMerge.leadingGuide;
}
- (UILayoutGuide *)bottomGuide {
    
    return self.guideMerge.bottomGuide;
}
- (UILayoutGuide *)trailingGuide {
    return self.guideMerge.trailingGuide;
}

- (NSMutableSet<NSLayoutConstraint *> *)gapWidthOrHeightConstraints {
    if (!_gapWidthOrHeightConstraints) {
        _gapWidthOrHeightConstraints = [NSMutableSet set];
    }
    return _gapWidthOrHeightConstraints;
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
    self.markedDirty = YES;
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
    
    CGFloat totalValue = self.insets.left + self.insets.right;
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
    CGFloat totalValue = self.horizontal ? self.insets.left + self.insets.right : self.insets.top + self.insets.bottom;
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
        if (idx > 0 && obj.zl_layoutCfg.leadingCons) {
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
    [self.gapWidthOrHeightConstraints addObjectsFromArray:spaceCons];
    
    [self.guideMerge setEqConstraintsValue:itemGapValue];
    
}

///设置中心gap等宽或者等高，边界gap是中心gap的一半
- (void)gapEqualSpaceAround{
   if(self.justify != ZlJustifySpaceAround) return;
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
    
    
    
    
    if (spaceCons.count < 1) return;
    CGFloat gapValue = [self availableHeightOrWidth];
    CGFloat itemGapValue = gapValue / self.arrangedViews.count;
    itemGapValue = MAX(0, itemGapValue);
    [spaceCons enumerateObjectsUsingBlock:^(NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.constant = itemGapValue;
    }];
    [self.gapWidthOrHeightConstraints addObjectsFromArray:spaceCons];
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
    [self.spacingGuideCoordinator addHorizontalConstraint];
    [self.spacingGuideCoordinator activateConstraints];
    
    return;
    if (!self.markedDirty) {
//        [self updateCons];
        return;
    }
    [self refreshArrangedSubviews];
    
    if (_viewsWidthOrHeightConstraints.count > 0) {
        [NSLayoutConstraint deactivateConstraints:_viewsWidthOrHeightConstraints.allObjects];
        [_viewsWidthOrHeightConstraints removeAllObjects];
    }
    if (_gapWidthOrHeightConstraints.count > 0) {
        [NSLayoutConstraint deactivateConstraints:self.gapWidthOrHeightConstraints.allObjects];
        [self.gapWidthOrHeightConstraints removeAllObjects];
    }
    
    
    
    [self.guideMerge deactivateConstraints];
    NSInteger visibleCount = self.arrangedViews.count;
    for (int i = 0 ; i < visibleCount ; i ++) {
        UIView *view= self.arrangedViews[i];
        ZLViewLayoutCfg *cfg = view.zl_layoutCfg;
        cfg.isFirstView = i == 0;
        cfg.isLastView = i == visibleCount - 1;
        [cfg deactivateConstraints];
        [cfg addAllConstraints];
    }
    
    [self.guideMerge addJustifyConstraints];
    [self.guideMerge addAlignConstraints];
    
    [self updateCons];
    self.markedDirty = NO;
    
    
    
}
- (void)updateCons {
    [self gapEqualSpaceBetween];
    [self gapEqualSpaceEvenly];
    [self gapEqualSpaceAround];
    [self configJustifyFillEqually];
}

///至关重要
//- (CGSize)intrinsicContentSize {
//    //返回自适应
//    return CGSizeZero;
//}
@end
