//
//  ZLLayoutManager.m
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/5/4.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLLayoutManager.h"
#import "ZLStackView.h"
#import "ZLLayoutViewCfg.h"
#import "ZLStackEdgeInsets.h"
#import "ZLConstraintsCfg.h"

@interface ZLLayoutManager()
@property (nonatomic,strong)ZLStackEdgeInsets *stackEdgeInsets;
@property (nonatomic,strong,readwrite)NSMutableArray<NSLayoutConstraint *> *constraints;
@property (nonatomic,readonly)NSArray<UIView *> *views;
@property (nonatomic,readonly)ZLJustify justify;
@property (nonatomic,readonly)ZLAlign align;
@property (nonatomic,readonly)BOOL horizontal;
@end
@implementation ZLLayoutManager
- (ZLStackEdgeInsets *)stackEdgeInsets {
    if (!_stackEdgeInsets) {
        _stackEdgeInsets = [[ZLStackEdgeInsets alloc] init];
        _stackEdgeInsets.stackView = self.stackView;
    }
    return _stackEdgeInsets;
}
- (NSMutableArray<NSLayoutConstraint *> *)constraints {
    if (!_constraints) {
        _constraints = NSMutableArray.array;
    }
    return _constraints;
}
- (NSArray<UIView *> *)views {
    return self.stackView.arrangedViews;
}
- (ZLJustify)justify {
    return self.stackView.justify;
}
- (ZLAlign)align {
    return self.stackView.alignment;
}
- (BOOL)horizontal {
    return self.stackView.horizontal;
}
- (void)removeAllSpacing {
    [self.stackEdgeInsets  removeEdgeInsets];
    [[self.stackView.layoutGuides filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UILayoutGuide*  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [evaluatedObject isKindOfClass:ZLLayoutGuide.class];
    }]] enumerateObjectsUsingBlock:^(__kindof ZLLayoutGuide * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromOwningView];
    }];
}
///水平布局时添加所有约束
- (void)addHorizontalLayoutConstraints {
    if (!self.horizontal) return;
    NSLayoutXAxisAnchor *nextAnchor = self.stackEdgeInsets.leadingAnchor;
    NSInteger count = self.views.count;
    NSLayoutConstraint *cons;
    NSLayoutDimension  *widthDim;
    NSLayoutDimension *viewWidthDim;
    NSLayoutDimension  *flexWidthDim;

    UIEdgeInsets inset = self.stackView.insets;
    NSMutableArray<UIView *> *flexViews = NSMutableArray.array;
    for (int i = 0; i < count; i ++) {
        UIView *view = self.views[i];
        ZLLayoutViewCfg *cfg = view.zl_layoutCfg;
        if (cfg.flex > 0 && self.justify != ZlJustifyFillEqually) {
            [flexViews addObject:view];
        }
        //添加垂直约束
        CGFloat startSpacing = cfg.startSpacing;
        CGFloat endSpacing = cfg.endSpacing;
        CGFloat behindSpacing = cfg.behindSpacing;
        switch (cfg.alignSelf) {
            case ZLAlignStart:
            {
                cons = [view.topAnchor constraintEqualToAnchor:self.stackView.topAnchor constant:startSpacing + inset.top];
                [self.constraints addObject:cons];
                cons = [view.bottomAnchor constraintLessThanOrEqualToAnchor:self.stackView.bottomAnchor constant:-endSpacing - inset.bottom];
                [self.constraints addObject:cons];
            }
                break;
            case ZLAlignCenter:
            {
                CGFloat offsetY = (startSpacing - endSpacing) * 0.5;
                cons = [view.topAnchor constraintGreaterThanOrEqualToAnchor:self.stackView.topAnchor constant:startSpacing + inset.top];
                [self.constraints addObject:cons];
                
                cons = [view.bottomAnchor constraintLessThanOrEqualToAnchor:self.stackView.bottomAnchor constant:-endSpacing - inset.bottom];
                [self.constraints addObject:cons];
                
                cons = [view.centerYAnchor constraintEqualToAnchor:self.stackView.centerYAnchor constant:offsetY];
                [self.constraints addObject:cons];
            }
                
                
                break;
            case ZLAlignEnd:
            {
                cons = [view.topAnchor constraintGreaterThanOrEqualToAnchor:self.stackView.topAnchor constant:startSpacing + inset.top];
                [self.constraints addObject:cons];
            
                cons = [view.bottomAnchor constraintEqualToAnchor:self.stackView.bottomAnchor constant:-endSpacing - inset.bottom];
                [self.constraints addObject:cons];
            }
            
                break;
            case ZLAlignFill:
            {
                cons = [view.topAnchor constraintEqualToAnchor:self.stackView.topAnchor constant:startSpacing + inset.top];
                [self.constraints addObject:cons];
                cons = [view.bottomAnchor constraintEqualToAnchor:self.stackView.bottomAnchor constant:-endSpacing - inset.bottom];
                [self.constraints addObject:cons];
            }
                break;
            default:
                break;
        }
        
        CGFloat leadingMarge = i == 0 ? inset.left : 0;
        
        if (self.stackView.justify == ZlJustifyEnd && i == 0) {
            cons = [view.leadingAnchor constraintGreaterThanOrEqualToAnchor:nextAnchor constant:leadingMarge];
        }else {
            cons = [view.leadingAnchor constraintEqualToAnchor:nextAnchor constant:leadingMarge];
        }
        nextAnchor = view.trailingAnchor;
        [self.constraints addObject:cons];
        switch (self.justify) {
            case ZlJustifyFillEqually:
            {
                if (viewWidthDim) {//设置每个view宽度相等
                    cons = [view.widthAnchor constraintEqualToAnchor:viewWidthDim];
                    [self.constraints addObject:cons];
                }
                viewWidthDim = view.widthAnchor;
            }
            case ZlJustifyFill:
                if (cfg.isFlexSpace) {
                    ZLLayoutGuide *spacingGuide = ZLLayoutGuide.new;
                    spacingGuide.stackView = self.stackView;
                    cons = [spacingGuide.leadingAnchor constraintEqualToAnchor:nextAnchor];
                    [self.constraints addObject:cons];
                    nextAnchor = spacingGuide.trailingAnchor;
                    cons =  [spacingGuide.widthAnchor constraintGreaterThanOrEqualToConstant:0];
                    [self.constraints addObject:cons];
                    
                    if (flexWidthDim) {
                        cons   = [flexWidthDim constraintEqualToAnchor:spacingGuide.widthAnchor];
                        [self.constraints addObject:cons];
                        
                    }
                    flexWidthDim  = spacingGuide.widthAnchor;
                }
            case ZLJustifyStart:
            case ZlJustifyEnd:
            case ZLJustifyCenter:
                
            {
                if (behindSpacing > 0.0 && i < count - 1 && !cfg.isFlexSpace) {//添加间距
                    ZLLayoutGuide *spacingGuide = ZLLayoutGuide.new;
                    spacingGuide.stackView = self.stackView;
                    cons = [spacingGuide.leadingAnchor constraintEqualToAnchor:nextAnchor];
                    [self.constraints addObject:cons];
                    nextAnchor = spacingGuide.trailingAnchor;
                    cons = [spacingGuide.widthAnchor constraintEqualToConstant:behindSpacing];
                    cons.cfg.type = ZLLayoutConTypeSpacing;
                    cons.cfg.view = view;
                    [self.constraints addObject:cons];
                }
                
            }
                break;
           
            case ZlJustifySpaceBetween:
            case ZlJustifySpaceAround:
            case ZlJustifySpaceEvenly:
            {
                if (i < count - 1) {
                    ZLLayoutGuide *spacingGuide = ZLLayoutGuide.new;
                    spacingGuide.stackView = self.stackView;
                    cons = [spacingGuide.leadingAnchor constraintEqualToAnchor:nextAnchor];
                    [self.constraints addObject:cons];
                    nextAnchor = spacingGuide.trailingAnchor;
                    if (widthDim) {
                       cons = [spacingGuide.widthAnchor  constraintEqualToAnchor:widthDim];
                        [self.constraints addObject:cons];
                    }
                    widthDim = spacingGuide.widthAnchor;
                }
            }
                break;
            default:
                break;
        }
    }
    
    CGFloat trailingMarge = inset.right;
    if (self.justify == ZLJustifyStart) {
        
        cons = [nextAnchor constraintLessThanOrEqualToAnchor:self.stackEdgeInsets.trailingAnchor constant:-trailingMarge] ;
        [self.constraints addObject:cons];
    }else {
        cons = [nextAnchor constraintEqualToAnchor:self.stackEdgeInsets.trailingAnchor constant:-trailingMarge];
        [self.constraints addObject:cons];
    }
    
    if (widthDim) {///设置两边间距和中间距的关系
        NSArray<NSLayoutDimension *> *widthAnchors = self.stackEdgeInsets.widthAnchors;
        NSLayoutDimension *guideLeadingDim = widthAnchors.firstObject;
        cons = [guideLeadingDim constraintEqualToAnchor:widthAnchors.lastObject];
        [self.constraints addObject:cons];
        if (self.justify == ZlJustifySpaceAround) {
             cons = [guideLeadingDim constraintEqualToAnchor:widthDim multiplier:0.5];
        }else if (self.justify == ZlJustifySpaceEvenly) {
            cons = [guideLeadingDim constraintEqualToAnchor:widthDim];
        }
        [self.constraints addObject:cons];
    }
    
    if (self.justify == ZLJustifyCenter) {//中心布局设置两边间距相等
        NSArray<NSLayoutDimension *> *widthDimens = self.stackEdgeInsets.widthAnchors;
        cons = [widthDimens.firstObject constraintEqualToAnchor:widthDimens.lastObject];
        [self.constraints addObject:cons];
    }
    
    if (self.align == ZLAlignCenter) {//中心布局设置两边间距相等
        NSArray<NSLayoutDimension *> *heightDimens = self.stackEdgeInsets.heightAnchors;
        cons = [heightDimens.firstObject constraintEqualToAnchor:heightDimens.lastObject];
        [self.constraints addObject:cons];
    }
    
    
    //设置宽度的相对权重
    NSLayoutDimension *firstWidthDim = flexViews.firstObject.widthAnchor;
    CGFloat firstFlex = flexViews.firstObject.zl_layoutCfg.flex * 1.0;
    for (int i = 0; i < flexViews.count; i ++) {
        UIView *view = flexViews[i];
        [view setContentHuggingPriority:UILayoutPriorityDefaultLow - 1 forAxis:UILayoutConstraintAxisHorizontal];
        [view setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh - 1 forAxis:UILayoutConstraintAxisHorizontal];
        if (i > 0) {
          cons = [view.widthAnchor constraintEqualToAnchor:firstWidthDim multiplier:view.zl_layoutCfg.flex / firstFlex];
          [self.constraints addObject:cons];
        }
    }
   
}
- (void)addVerticalLayoutConstraints {
    if (self.horizontal) return;
    NSLayoutYAxisAnchor *nextAnchor = self.stackEdgeInsets.topAnchor;
    NSInteger count = self.views.count;
    NSLayoutConstraint *cons;
    NSLayoutDimension  *heightDim;
    NSLayoutDimension *viewheightDim;
    NSLayoutDimension *flexHeightDim;
    UIEdgeInsets inset = self.stackView.insets;
    NSMutableArray<UIView *> *flexViews = NSMutableArray.array;

    for (int i = 0; i < count; i ++) {
        UIView *view = self.views[i];
        ZLLayoutViewCfg *cfg = view.zl_layoutCfg;
        if (cfg.flex > 0 && self.justify != ZlJustifyFillEqually) {
            [flexViews addObject:view];
        }
        //添加垂直约束
        CGFloat startSpacing = cfg.startSpacing;
        CGFloat endSpacing = cfg.endSpacing;
        CGFloat behindSpacing = cfg.behindSpacing;
        switch (cfg.alignSelf) {
            case ZLAlignStart:
            {
                cons = [view.leadingAnchor constraintEqualToAnchor:self.stackView.leadingAnchor constant:startSpacing + inset.left];
                [self.constraints addObject:cons];
                cons = [view.trailingAnchor constraintLessThanOrEqualToAnchor:self.stackView.trailingAnchor constant:-endSpacing - inset.right];
                [self.constraints addObject:cons];
            }
                break;
            case ZLAlignCenter:
            {
                CGFloat offsetY = (startSpacing - endSpacing) * 0.5;
                cons = [view.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.stackView.leadingAnchor constant:startSpacing + inset.left];
                [self.constraints addObject:cons];
                
                cons = [view.trailingAnchor constraintLessThanOrEqualToAnchor:self.stackView.trailingAnchor constant:-endSpacing - inset.right];
                [self.constraints addObject:cons];
                
                cons = [view.centerXAnchor constraintEqualToAnchor:self.stackView.centerXAnchor constant:offsetY];
                [self.constraints addObject:cons];
            }
                
                
                break;
            case ZLAlignEnd:
            {
                cons = [view.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.stackView.leadingAnchor constant:startSpacing + inset.left];
                [self.constraints addObject:cons];
            
                cons = [view.trailingAnchor constraintEqualToAnchor:self.stackView.trailingAnchor constant:-endSpacing - inset.right];
                [self.constraints addObject:cons];
            }
            
                break;
            case ZLAlignFill:
            {
                cons = [view.leadingAnchor constraintEqualToAnchor:self.stackView.leadingAnchor constant:startSpacing + inset.left];
                [self.constraints addObject:cons];
                cons = [view.trailingAnchor constraintEqualToAnchor:self.stackView.trailingAnchor constant:-endSpacing - inset.right];
                [self.constraints addObject:cons];
            }
                break;
            default:
                break;
        }
        
        CGFloat topMarge = i == 0 ? inset.top : 0;
        
        if (self.stackView.justify == ZlJustifyEnd && i == 0) {
            cons = [view.topAnchor constraintGreaterThanOrEqualToAnchor:nextAnchor constant:topMarge];
        }else {
            cons = [view.topAnchor constraintEqualToAnchor:nextAnchor constant:topMarge];
        }
        nextAnchor = view.bottomAnchor;
        [self.constraints addObject:cons];
        switch (self.justify) {
            case ZlJustifyFillEqually:
            {
                if (viewheightDim) {//设置每个view宽度相等
                    cons = [view.heightAnchor constraintEqualToAnchor:viewheightDim];
                    [self.constraints addObject:cons];
                }
                viewheightDim = view.heightAnchor;
            }
            case ZlJustifyFill:
                if (cfg.isFlexSpace) {
                    ZLLayoutGuide *spacingGuide = ZLLayoutGuide.new;
                    spacingGuide.stackView = self.stackView;
                    cons = [spacingGuide.topAnchor constraintEqualToAnchor:nextAnchor];
                    [self.constraints addObject:cons];
                    nextAnchor = spacingGuide.bottomAnchor;
                    cons =  [spacingGuide.heightAnchor constraintGreaterThanOrEqualToConstant:0];
                    [self.constraints addObject:cons];
                    
                    if (flexHeightDim) {
                        cons   = [flexHeightDim constraintEqualToAnchor:spacingGuide.heightAnchor];
                        [self.constraints addObject:cons];
                        
                    }
                    flexHeightDim  = spacingGuide.heightAnchor;
                }
            case ZLJustifyStart:
            case ZlJustifyEnd:
            case ZLJustifyCenter:
                
            {
                if (behindSpacing > 0.0 && i < count - 1 && !cfg.isFlexSpace) {//添加间距
                    ZLLayoutGuide *spacingGuide = ZLLayoutGuide.new;
                    spacingGuide.stackView = self.stackView;
                    cons = [spacingGuide.topAnchor constraintEqualToAnchor:nextAnchor];
                    [self.constraints addObject:cons];
                    nextAnchor = spacingGuide.bottomAnchor;
                    cons = [spacingGuide.heightAnchor constraintEqualToConstant:behindSpacing];
                    cons.cfg.type = ZLLayoutConTypeSpacing;
                    cons.cfg.view = view;
                    [self.constraints addObject:cons];
                }
                
            }
                break;
           
            case ZlJustifySpaceBetween:
            case ZlJustifySpaceAround:
            case ZlJustifySpaceEvenly:
            {
                if (i < count - 1) {
                    ZLLayoutGuide *spacingGuide = ZLLayoutGuide.new;
                    spacingGuide.stackView = self.stackView;
                    cons = [spacingGuide.topAnchor constraintEqualToAnchor:nextAnchor];
                    [self.constraints addObject:cons];
                    nextAnchor = spacingGuide.bottomAnchor;
                    if (heightDim) {
                       cons = [spacingGuide.heightAnchor  constraintEqualToAnchor:heightDim];
                        [self.constraints addObject:cons];
                    }
                    heightDim = spacingGuide.heightAnchor;
                }
            }
                break;
            default:
                break;
        }
    }
    
    CGFloat bottomMarge = inset.bottom;
    if (self.justify == ZLJustifyStart) {
        cons = [nextAnchor constraintLessThanOrEqualToAnchor:self.stackEdgeInsets.bottomAnchor constant:-bottomMarge];
        [self.constraints addObject:cons];
    }else {
        cons = [nextAnchor constraintEqualToAnchor:self.stackEdgeInsets.bottomAnchor constant:-bottomMarge];
        [self.constraints addObject:cons];
    }
    
    if (heightDim) {///设置两边间距和中间距的关系
        NSArray<NSLayoutDimension *> *heightAnchors = self.stackEdgeInsets.heightAnchors;
        NSLayoutDimension *guideLeadingDim = self.stackEdgeInsets.heightAnchors.firstObject;
        cons = [guideLeadingDim constraintEqualToAnchor:heightAnchors.lastObject];
        [self.constraints addObject:cons];
        if (self.justify == ZlJustifySpaceAround) {
             cons = [guideLeadingDim constraintEqualToAnchor:heightDim multiplier:0.5];
        }else if (self.justify == ZlJustifySpaceEvenly) {
            cons = [guideLeadingDim constraintEqualToAnchor:heightDim];
        }
        [self.constraints addObject:cons];
    }
    
    if (self.justify == ZLJustifyCenter) {//中心布局设置两边间距相等
        NSArray<NSLayoutDimension *> *heightsDimens = self.stackEdgeInsets.heightAnchors;
        cons = [heightsDimens.firstObject constraintEqualToAnchor:heightsDimens.lastObject];
        [self.constraints addObject:cons];
    }
    
    if (self.align == ZLAlignCenter) {//中心布局设置两边间距相等
        NSArray<NSLayoutDimension *> *widthDimens = self.stackEdgeInsets.widthAnchors;
        cons = [widthDimens.firstObject constraintEqualToAnchor:widthDimens.lastObject];
        [self.constraints addObject:cons];
    }
    
    
    //设置高度的相对权重
    NSLayoutDimension *firstHeightDim = flexViews.firstObject.heightAnchor;
    CGFloat firstFlex = flexViews.firstObject.zl_layoutCfg.flex * 1.0;
    for (int i = 0; i < flexViews.count; i ++) {
        UIView *view = flexViews[i];
        [view setContentHuggingPriority:UILayoutPriorityDefaultLow - 1 forAxis:UILayoutConstraintAxisVertical];
        if (i > 0) {
          cons = [view.heightAnchor constraintEqualToAnchor:firstHeightDim multiplier:view.zl_layoutCfg.flex / firstFlex];
            [view setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh - 1 forAxis:UILayoutConstraintAxisVertical];
          [self.constraints addObject:cons];
        }
    }
}
- (void)activateConstraints {
    [NSLayoutConstraint activateConstraints:self.constraints];
}
- (void)deactivateConstraints {
    [NSLayoutConstraint deactivateConstraints:self.constraints];
    [self.constraints removeAllObjects];
}
@end
