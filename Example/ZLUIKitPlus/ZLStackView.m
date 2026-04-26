//
//  ZLStackView.m
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/4/25.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLStackView.h"
@interface UIView (ZLView)
//主
@property (assign)CGFloat zl_frontSpacing;
@property (assign)CGFloat zl_startSpacing;
@property (assign)CGFloat zl_endSpacing;


@end
@implementation UIView (ZLView)

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
@property (nonatomic,strong)NSMutableArray<UIView *> *views;
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
            cons = [view.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor constant:view.zl_startSpacing];
                break;
            case ZLAlignCenter:
            case ZLAlignEnd:
            default:
                cons = [view.topAnchor constraintGreaterThanOrEqualToAnchor:self.layoutMarginsGuide.topAnchor constant:view.zl_startSpacing];
                break;
        }
    }else {
//        ZlJustifyFill,
//        ZlJustifyFillEqually,
//        ZLJustifyStart,
//        ZLJustifyCenter,
//        ZlJustifyEnd,
//        ZlJustifySpaceBetween,//两边没有间距，中间相等
//        ZlJustifySpaceAround,//两边是中间一半
//        ZlJustifySpaceEvenly,//所有间距都相等
        switch (self.justify) {
            case ZlJustifyFill:
            case ZlJustifyFillEqually:
            case ZLJustifyStart:
            case ZlJustifySpaceBetween:
            case ZlJustifySpaceAround:
            case ZlJustifySpaceEvenly:
                if (isFirst) {
                    cons = [view.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor constant:0];
                }else {
                    cons = [view.topAnchor constraintEqualToAnchor:fView.bottomAnchor constant:view.zl_frontSpacing];
                }
                break;
            case ZLJustifyCenter:
            case ZlJustifyEnd:
                if (isFirst) {
                    cons = [view.topAnchor constraintGreaterThanOrEqualToAnchor:self.layoutMarginsGuide.topAnchor constant:0];
                }else {
                    cons = [view.topAnchor constraintEqualToAnchor:fView.bottomAnchor constant:view.zl_frontSpacing];
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
            cons = [view.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor constant:view.zl_endSpacing];
                break;
            case ZLAlignStart:
            case ZLAlignCenter:
            default:
                cons = [view.bottomAnchor constraintLessThanOrEqualToAnchor:self.layoutMarginsGuide.bottomAnchor constant:-view.zl_endSpacing];
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
                    cons = [view.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor constant:0];
                }
                break;
            case ZLJustifyCenter:
            case ZLJustifyStart:
                if (isLast) {
                    cons = [view.bottomAnchor constraintLessThanOrEqualToAnchor:self.layoutMarginsGuide.bottomAnchor constant:0];
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
                    cons = [view.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor constant:0];
                }else {
                    cons = [view.leadingAnchor constraintEqualToAnchor:fView.trailingAnchor constant:view.zl_frontSpacing];
                }
                break;
            case ZLJustifyCenter:
            case ZlJustifyEnd:
                if (isFirst) {
                    cons = [view.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.layoutMarginsGuide.leadingAnchor constant:0];
                }else {
                    cons = [view.leadingAnchor constraintGreaterThanOrEqualToAnchor:fView.trailingAnchor constant:view.zl_frontSpacing];
                }
                break;
            default:
                break;
        }
    }else {
        switch (self.alignment) {
            case ZLAlignStart:
            case ZLAlignFill:
            cons = [view.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor constant:view.zl_startSpacing];
                break;
            case ZLAlignCenter:
            case ZLAlignEnd:
            default:
                cons = [view.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.layoutMarginsGuide.leadingAnchor constant:view.zl_startSpacing];
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
                    cons = [view.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor constant:0];
                }
                break;
            case ZLJustifyCenter:
            case ZLJustifyStart:
                if (isLast) {
                    cons = [view.trailingAnchor constraintLessThanOrEqualToAnchor:self.layoutMarginsGuide.trailingAnchor constant:0];
                }
                break;
            default:
                break;
        }
    }else {
        switch (self.alignment) {
            case ZLAlignEnd:
            case ZLAlignFill:
                cons = [view.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor constant:-view.zl_endSpacing];
                break;
            case ZLAlignStart:
            case ZLAlignCenter:
            default:
                cons = [view.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor constant:-view.zl_endSpacing];
                break;
        }
    }
    cons.active = YES;
}
@end
