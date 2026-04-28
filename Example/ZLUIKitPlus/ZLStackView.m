//
//  ZLStackView.m
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/4/25.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLStackView.h"
#import <objc/runtime.h>
#define kGapConsId @"kGapConsId"
@interface ZLViewLayoutCfg: NSObject
@property (nonatomic,assign)CGFloat startSpacing;
@property (nonatomic,assign)CGFloat endSpacing;
@property (nonatomic,assign)CGFloat behindSpacing;
@property (nonatomic,weak)ZLStackView *stackView;
///view和UILayoutGuide之间的约束
@property (nonatomic,strong)NSMutableArray<NSLayoutConstraint *> *viewAndGuideConstraints;
///两边边界的宽度或者高度anchor数据
@property (nonatomic,strong)NSMutableArray<NSLayoutDimension *> *boundaryWithOrHeightGapAnchors;
///中心宽度或者高度anchor数据
@property (nonatomic,strong)NSMutableArray<NSLayoutDimension *> *centerWidthOrHeightGapAnchors;

@property (nonatomic,strong)NSMutableArray<NSLayoutDimension *> *centerXConstraints;
@property (nonatomic,strong)NSMutableArray<NSLayoutDimension *> *centerYConstraints;

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
@property(nonatomic,readonly,strong)NSLayoutDimension
    *widthAnchor;
@property(nonatomic,readonly,strong)NSLayoutDimension
    *heightAnchor;
@property(nonatomic,readonly,strong)NSLayoutXAxisAnchor
    *centerXAnchor;
@property(nonatomic,readonly,strong)NSLayoutYAxisAnchor
    *centerYAnchor;

@property(nonatomic,readonly)BOOL isFirstView;
@property(nonatomic,readonly)BOOL isLastView;
@end
@implementation ZLViewLayoutCfg
- (BOOL)isFirstView {
    return [self.stackView.views indexOfObject:self.view] == 0;
}
- (BOOL)isLastView {
    return [self.stackView.views indexOfObject:self.view] == self.stackView.views.count - 1;
}
- (CGFloat)endSpacing {
    return 0;
}
- (CGFloat)startSpacing {
    return 0;
}
- (CGFloat)behindSpacing {
    return 0;
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
        ZLJustify justify = self.stackView.justify;
        if (justify == ZlJustifySpaceBetween ||
            justify ==  ZlJustifySpaceAround ||
            justify ==  ZlJustifySpaceEvenly ||
            justify ==  ZLJustifyCenter
            ) {
            if (self.isFirstView) {
                if (justify == ZlJustifySpaceBetween) {
                    return self.view.leadingAnchor;
                }
                [self.stackView addLayoutGuide:self.startGapGuide];
                NSLayoutConstraint *cons = [self.startGapGuide.trailingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
                cons.active = YES;
                [self.viewAndGuideConstraints addObject:cons];
                
                {
                  
                [self.boundaryWithOrHeightGapAnchors addObject:self.startGapGuide.widthAnchor];
                }
                
                return self.startGapGuide.leadingAnchor;
            }
        }
    }
    return self.view.leadingAnchor;
}
- (NSLayoutYAxisAnchor *)topAnchor {
    if (!self.stackView.horizontal) {
        ZLJustify justify = self.stackView.justify;
        if (justify == ZlJustifySpaceBetween ||
            justify ==  ZlJustifySpaceAround ||
            justify ==  ZlJustifySpaceEvenly ||
            justify ==  ZLJustifyCenter
            ) {
            BOOL isFirstView = [self.stackView.views indexOfObject:self.view] == 0;
            if (isFirstView) {
                if (justify == ZlJustifySpaceBetween) {
                    return self.view.topAnchor;
                }

                [self.stackView addLayoutGuide:self.startGapGuide];
                NSLayoutConstraint *cons = [self.startGapGuide.bottomAnchor constraintEqualToAnchor:self.view.topAnchor];
                cons.active = YES;
                [self.viewAndGuideConstraints addObject:cons];
                
                {
                   
                    [self.boundaryWithOrHeightGapAnchors addObject:self.startGapGuide.heightAnchor];
                }
                
                return self.startGapGuide.topAnchor;
            }
        }
    }
    return self.view.topAnchor;
}
- (NSLayoutDimension *)widthAnchor {
    return self.view.widthAnchor;
}
- (NSLayoutDimension *)heightAnchor {
    return self.view.heightAnchor;
}
- (NSLayoutYAxisAnchor *)centerYAnchor {
    return self.view.centerYAnchor;
}
- (NSLayoutXAxisAnchor *)centerXAnchor {
    if (self.stackView.horizontal) {
        ZLJustify justify = self.stackView.justify;
        if (justify == ZLJustifyCenter && self.isFirstView) {
            
        }
    }else {
            
    }
    return self.view.centerXAnchor;
}
- (void)deactivateConstraints {
    [NSLayoutConstraint deactivateConstraints:self.viewAndGuideConstraints];
    [self.viewAndGuideConstraints removeAllObjects];
}
- (NSLayoutYAxisAnchor *)bottomAnchor {
    if (!self.stackView.horizontal) {
        ZLJustify justify = self.stackView.justify;
        if (justify == ZlJustifySpaceBetween ||
            justify ==  ZlJustifySpaceAround ||
            justify ==  ZlJustifySpaceEvenly ||
            justify ==  ZLJustifyCenter
            ) {
            [self.stackView addLayoutGuide:self.endGapGuide];
            NSLayoutConstraint *cons = [self.endGapGuide.topAnchor constraintEqualToAnchor:self.view.bottomAnchor];
            cons.active = YES;
            [self.viewAndGuideConstraints addObject:cons];
            {
               
                if (self.isLastView) {
                    if (justify == ZlJustifySpaceBetween) {
                        return self.view.bottomAnchor;
                    }
                    [self.boundaryWithOrHeightGapAnchors addObject:self.endGapGuide.heightAnchor];
                }else {
                    [self.centerWidthOrHeightGapAnchors addObject:self.endGapGuide.heightAnchor];
                }
            }
            return self.endGapGuide.bottomAnchor;
        }
    }
    return self.view.bottomAnchor;
}
- (NSLayoutXAxisAnchor *)trailingAnchor {
    if (self.stackView.horizontal) {
        ZLJustify justify = self.stackView.justify;
        if (justify == ZlJustifySpaceBetween ||
            justify ==  ZlJustifySpaceAround ||
            justify ==  ZlJustifySpaceEvenly ||
            justify ==  ZLJustifyCenter
            ) {
            [self.stackView addLayoutGuide:self.endGapGuide];
            NSLayoutConstraint *cons = [self.endGapGuide.leadingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
            cons.active = YES;
            [self.viewAndGuideConstraints addObject:cons];
            {
                if (self.isLastView) {
                    if (justify == ZlJustifySpaceBetween) {
                        return self.view.trailingAnchor;
                    }
                    [self.boundaryWithOrHeightGapAnchors addObject:self.endGapGuide.widthAnchor];
                }else {
                    [self.centerWidthOrHeightGapAnchors addObject:self.endGapGuide.widthAnchor];
                }
            }
            return self.endGapGuide.trailingAnchor;
        }
    }
    return self.view.trailingAnchor;
}
@end



@interface UIView (ZLView)
//主
@property (assign)CGFloat zl_frontSpacing;
@property (assign)CGFloat zl_startSpacing;
@property (assign)CGFloat zl_endSpacing;

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
- (CGFloat)zl_frontSpacing {
    return 0;
}
- (CGFloat)zl_startSpacing {
    return 0;
}
- (CGFloat)zl_endSpacing {
    return 10;
}
@end

@interface ZLStackView()
@end
@implementation ZLStackView
- (NSMutableArray *)views {
    if (!_views) {
        self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
        _views = NSMutableArray.array;
    }
    return _views;
}
- (void)addArrandgeView:(UIView *)view {
    [self.views addObject:view];
    
    ZLViewLayoutCfg *cfg = view.zl_layoutCfg;
    [view.zl_layoutCfg deactivateConstraints];
    cfg.view = view;
    cfg.stackView = self;
    view.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:view];
}
- (UIView *)frontViewWithView:(UIView *)view {
    NSInteger idx = [self.views indexOfObject:view];
    if (idx > 0 && idx < self.views.count) {
        return self.views[idx - 1];
    }
    return self;
}
- (UIView *)behindViewWithView:(UIView *)view {
    NSInteger idx = [self.views indexOfObject:view];
    if (idx < self.views.count - 1 && idx >= 0) {
        return self.views[idx + 1];
    }
    return self;
}
- (void)updateViewsConstraints {
    for (int i = 0 ; i < self.views.count ; i ++) {
        UIView *view= self.views[i];
        [self addTop:view index:i];
        [self addBottom:view index:i];
        [self addLeading:view index:i];
        [self addTrailing:view index:i];
    }
    
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
- (void)boundryGapEqualWidthOrHeight {
    NSMutableArray<NSLayoutDimension *>  *arr = NSMutableArray.array;
    for (int i = 0 ; i < self.views.count ; i ++) {
        UIView *view= self.views[i];
        [arr addObjectsFromArray:view.zl_layoutCfg.boundaryWithOrHeightGapAnchors];
    }
    [arr.firstObject constraintEqualToAnchor:arr.lastObject].active = YES;

}
- (void)gapEqualSpaceBetween{
    NSMutableArray  *arr = NSMutableArray.array;
    for (int i = 0 ; i < self.views.count ; i ++) {
        UIView *view= self.views[i];
        [arr addObjectsFromArray:view.zl_layoutCfg.centerWidthOrHeightGapAnchors];

    }
    NSLayoutDimension *first = arr.firstObject;
    [arr enumerateObjectsUsingBlock:^(NSLayoutDimension*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0) {
            [first constraintEqualToAnchor:obj].active = YES;
        }
    }];
}
- (void)gapEqualSpaceEvenly{
    NSMutableArray  *arr = NSMutableArray.array;
    for (int i = 0 ; i < self.views.count ; i ++) {
        UIView *view= self.views[i];
        [arr addObjectsFromArray:view.zl_layoutCfg.boundaryWithOrHeightGapAnchors];
        [arr addObjectsFromArray:view.zl_layoutCfg.centerWidthOrHeightGapAnchors];

    }
    NSLayoutDimension *first = arr.firstObject;
    [arr enumerateObjectsUsingBlock:^(NSLayoutDimension*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0) {
            [first constraintEqualToAnchor:obj].active = YES;
        }
    }];
}
- (void)gapEqualSpaceAround{
    
    NSMutableArray<NSLayoutDimension*>  *arr1 = NSMutableArray.array;
    NSMutableArray<NSLayoutDimension*>  *arr2 = NSMutableArray.array;

    for (int i = 0 ; i < self.views.count ; i ++) {
        UIView *view= self.views[i];
        [arr1 addObjectsFromArray:view.zl_layoutCfg.boundaryWithOrHeightGapAnchors];
        [arr2 addObjectsFromArray:view.zl_layoutCfg.centerWidthOrHeightGapAnchors];

    }
    [arr1.firstObject constraintEqualToAnchor:arr1.lastObject].active = YES;
    
    {
        NSLayoutDimension *first1 = arr2.firstObject;
        [arr2 enumerateObjectsUsingBlock:^(NSLayoutDimension*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > 0) {
                [first1 constraintEqualToAnchor:obj].active = YES;
            }
        }];
    }
    
    [arr1.firstObject constraintEqualToAnchor:arr2.firstObject multiplier:0.5].active = YES;
   
}
- (void)addCenterX:(UIView *)view index:(NSInteger)index {
    BOOL isFirst = index == 0;
    BOOL isLast = index == self.views.count - 1;
    UIView *fView = [self frontViewWithView:view];
    UIView *bView = [self behindViewWithView:view];
    NSLayoutConstraint *cons;
    if (self.horizontal) {
        switch (self.alignment) {
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
}
- (void)addCenterY:(UIView *)view index:(NSInteger)index {
}
- (void)addTop:(UIView *)view index:(NSInteger)index {
    BOOL isFirst = index == 0;
    BOOL isLast = index == self.views.count - 1;
    UIView *fView = [self frontViewWithView:view];
    UIView *bView = [self behindViewWithView:view];
    NSLayoutConstraint *cons;
    if (self.horizontal) {
        switch (self.alignment) {
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
}
- (void)addBottom:(UIView *)view index:(NSInteger)index {
    BOOL isFirst = index == 0;
    BOOL isLast = index == self.views.count - 1;
    UIView *fView = [self frontViewWithView:view];
    UIView *bView = [self behindViewWithView:view];
    NSLayoutConstraint *cons;
    if (self.horizontal) {
        switch (self.alignment) {
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
}
- (void)addLeading:(UIView *)view index:(NSInteger)index {
    
    BOOL isFirst = index == 0;
    BOOL isLast = index == self.views.count - 1;
    UIView *fView = [self frontViewWithView:view];
    UIView *bView = [self behindViewWithView:view];
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
        switch (self.alignment) {
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
    }
    cons.active = YES;
}
- (void)addTrailing:(UIView *)view index:(NSInteger)index {
    BOOL isFirst = index == 0;
    BOOL isLast = index == self.views.count - 1;
    UIView *fView = [self frontViewWithView:view];
    UIView *bView = [self behindViewWithView:view];
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
            case ZLJustifyStart:
                if (isLast) {
                    cons = [view.zl_layoutCfg.trailingAnchor constraintLessThanOrEqualToAnchor:self.layoutMarginsGuide.trailingAnchor constant:0];
                }
                break;
            default:
                break;
        }
    }else {
        switch (self.alignment) {
            case ZLAlignEnd:
            case ZLAlignFill:
                cons = [view.zl_layoutCfg.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor constant:-view.zl_endSpacing];
                break;
            case ZLAlignStart:
            case ZLAlignCenter:
            default:
                cons = [view.zl_layoutCfg.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor constant:-view.zl_endSpacing];
                break;
        }
    }
    cons.active = YES;
}
@end
