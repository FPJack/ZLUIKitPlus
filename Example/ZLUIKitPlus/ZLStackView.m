//
//  ZLStackView.m
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/4/25.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLStackView.h"
#import <objc/runtime.h>
@interface ZLViewLayoutCfg: NSObject
@property (nonatomic,assign)CGFloat startSpacing;
@property (nonatomic,assign)CGFloat endSpacing;
@property (nonatomic,assign)CGFloat behindSpacing;
@property (nonatomic,weak)ZLStackView *stackView;
@property (nonatomic,strong)NSMutableArray<NSLayoutConstraint *> *constraints;
@property (nonatomic,weak)UIView *view;
@property (nonatomic,strong)UILayoutGuide *gapGuide;
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
@end
@implementation ZLViewLayoutCfg
- (CGFloat)endSpacing {
    return 10;
}
- (CGFloat)startSpacing {
    return 10;
}
- (CGFloat)behindSpacing {
    return 20;
}

- (NSMutableArray *)constraints {
    if (!_constraints) {
        _constraints = NSMutableArray.array;
    }
    return _constraints;
}
- (UILayoutGuide *)gapGuide {
    if (!_gapGuide) {
        _gapGuide = [[UILayoutGuide alloc] init];
    }
    return _gapGuide;
}
- (NSLayoutXAxisAnchor *)leadingAnchor {
    if (self.stackView.horizontal) {
        ZLJustify justify = self.stackView.justify;
        if (justify == ZlJustifySpaceBetween ||
            justify ==  ZlJustifySpaceAround ||
            justify ==  ZlJustifySpaceEvenly
            ) {
            BOOL isFirstView = [self.stackView.views indexOfObject:self.view] == 0;
            if (isFirstView) {
                [self.stackView addLayoutGuide:self.gapGuide];
                NSLayoutConstraint *cons = [self.gapGuide.trailingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
                cons.active = YES;
                [self.constraints addObject:cons];
                return self.gapGuide.leadingAnchor;
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
            justify ==  ZlJustifySpaceEvenly
            ) {
            BOOL isFirstView = [self.stackView.views indexOfObject:self.view] == 0;
            if (isFirstView) {
                [self.stackView addLayoutGuide:self.gapGuide];
                NSLayoutConstraint *cons = [self.gapGuide.bottomAnchor constraintEqualToAnchor:self.view.topAnchor];
                cons.active = YES;
                [self.constraints addObject:cons];
                return self.gapGuide.topAnchor;
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
    return self.view.centerXAnchor;
}
- (void)deactivateConstraints {
    [NSLayoutConstraint deactivateConstraints:self.constraints];
    [self.constraints removeAllObjects];
}
- (NSLayoutYAxisAnchor *)bottomAnchor {
    if (!self.stackView.horizontal) {
        ZLJustify justify = self.stackView.justify;
        if (justify == ZlJustifySpaceBetween ||
            justify ==  ZlJustifySpaceAround ||
            justify ==  ZlJustifySpaceEvenly
            ) {
            [self.stackView addLayoutGuide:self.gapGuide];
            NSLayoutConstraint *cons = [self.gapGuide.topAnchor constraintEqualToAnchor:self.view.bottomAnchor];
            cons.active = YES;
            [self.constraints addObject:cons];
            return self.gapGuide.bottomAnchor;
        }
    }
    return self.view.bottomAnchor;
}
- (NSLayoutXAxisAnchor *)trailingAnchor {
    if (self.stackView.horizontal) {
        ZLJustify justify = self.stackView.justify;
        if (justify == ZlJustifySpaceBetween ||
            justify ==  ZlJustifySpaceAround ||
            justify ==  ZlJustifySpaceEvenly
            ) {
            [self.stackView addLayoutGuide:self.gapGuide];
            NSLayoutConstraint *cons = [self.gapGuide.leadingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
            cons.active = YES;
            [self.constraints addObject:cons];
            return self.gapGuide.trailingAnchor;
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
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    ZLViewLayoutCfg *cfg = view.zl_layoutCfg;
    [view.zl_layoutCfg deactivateConstraints];
    cfg.view = view;
    cfg.stackView = self;
    
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
