//
//  ZLSpacingGuideCoordinator.m
//  ZLUIKitPlus_Example
//
//  Created by admin on 2026/5/1.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLSpacingGuideCoordinator.h"
@interface ZLSpacingGuideCoordinator()
@property (nonatomic,strong)ZLLayoutGuideMerge *guideMerge;
@end
@implementation ZLSpacingGuideCoordinator
- (ZLLayoutGuideMerge *)guideMerge {
    if (!_guideMerge) {
        _guideMerge = [[ZLLayoutGuideMerge alloc] init];
        _guideMerge.stackView = self.stackView;
    }
    return _guideMerge;
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


///水平布局时添加所有约束
- (void)addHorizontalLayoutConstraints {
    [self deactivateConstraints];
    if (!self.horizontal) return;
    NSLayoutXAxisAnchor *nextAnchor = self.guideMerge.leadingAnchor;
    NSInteger count = self.views.count;
    NSLayoutConstraint *cons;
    NSLayoutDimension  *widthDim;
    NSLayoutDimension *viewWidthDim;
   
    for (int i = 0; i < count; i ++) {
        UIView *view = self.views[i];
        ZLViewLayoutCfg *cfg = view.zl_layoutCfg;
        
        //添加垂直约束
        CGFloat startSpacing = cfg.startSpacing;
        CGFloat endSpacing = cfg.endSpacing;
        CGFloat behindSpacing = cfg.behindSpacing;
        switch (self.align) {
            case ZLAlignStart:
            {
                cons = [view.topAnchor constraintEqualToAnchor:self.stackView.topAnchor constant:startSpacing];
                [self.constraints addObject:cons];
                cons = [view.bottomAnchor constraintLessThanOrEqualToAnchor:self.stackView.bottomAnchor constant:-endSpacing];
                [self.constraints addObject:cons];
            }
                break;
            case ZLAlignCenter:
            {
                CGFloat offsetY = (startSpacing - endSpacing) * 0.5;
                cons = [view.topAnchor constraintGreaterThanOrEqualToAnchor:self.stackView.topAnchor constant:startSpacing];
                [self.constraints addObject:cons];
                
                cons = [view.bottomAnchor constraintLessThanOrEqualToAnchor:self.stackView.bottomAnchor constant:endSpacing];
                [self.constraints addObject:cons];
                
                cons = [view.centerYAnchor constraintEqualToAnchor:self.stackView.centerYAnchor constant:offsetY];
                [self.constraints addObject:cons];
            }
                
                
                break;
            case ZLAlignEnd:
            {
                cons = [view.topAnchor constraintGreaterThanOrEqualToAnchor:self.stackView.topAnchor constant:startSpacing];
                [self.constraints addObject:cons];
            
                cons = [view.bottomAnchor constraintEqualToAnchor:self.stackView.bottomAnchor constant:-endSpacing];
                [self.constraints addObject:cons];
            }
            
                break;
            case ZLAlignFill:
            {
                cons = [view.topAnchor constraintEqualToAnchor:self.stackView.topAnchor constant:startSpacing];
                [self.constraints addObject:cons];
                cons = [view.bottomAnchor constraintEqualToAnchor:self.stackView.bottomAnchor constant:endSpacing];
                [self.constraints addObject:cons];
            }
                break;
            default:
                break;
        }
        
        
        if (self.stackView.justify == ZlJustifyEnd && i == 0) {
            cons = [view.leadingAnchor constraintGreaterThanOrEqualToAnchor:nextAnchor];
        }else {
            cons = [view.leadingAnchor constraintEqualToAnchor:nextAnchor];
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
            case ZLJustifyStart:
            case ZlJustifyEnd:
            case ZLJustifyCenter:
                
            {
                if (behindSpacing > 0.0 && i < count - 1) {//添加间距
                    ZLLayoutGuide *spacingGuide = ZLLayoutGuide.new;
                    spacingGuide.stackView = self.stackView;
                    cons = [spacingGuide.leadingAnchor constraintEqualToAnchor:nextAnchor];
                    [self.constraints addObject:cons];
                    nextAnchor = spacingGuide.trailingAnchor;
                    cons = [spacingGuide.widthAnchor constraintEqualToConstant:behindSpacing];
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
    
    
    if (self.justify == ZLJustifyStart) {
        cons = [nextAnchor constraintLessThanOrEqualToAnchor:self.guideMerge.trailingAnchor];
        [self.constraints addObject:cons];
    }else {
        cons = [nextAnchor constraintEqualToAnchor:self.guideMerge.trailingAnchor];
        [self.constraints addObject:cons];
    }
    
    if (widthDim) {///设置两边间距和中间距的关系
        NSLayoutConstraint *cons;
        NSLayoutDimension *guideLeadingDim = self.guideMerge.leadingGuide.widthAnchor;
        cons = [guideLeadingDim constraintEqualToAnchor:self.guideMerge.trailingGuide.widthAnchor];
        [self.constraints addObject:cons];
        if (self.justify == ZlJustifySpaceAround) {
             cons = [guideLeadingDim constraintEqualToAnchor:widthDim multiplier:0.5];
        }else if (self.justify == ZlJustifySpaceEvenly) {
            cons = [guideLeadingDim constraintEqualToAnchor:widthDim];
        }
        [self.constraints addObject:cons];
    }
    
    if (self.justify == ZLJustifyCenter) {//中心布局设置两边间距相等
        NSArray<NSLayoutDimension *> *widthDimens = self.guideMerge.widthAnchors;
        cons = [widthDimens.firstObject constraintEqualToAnchor:widthDimens.lastObject];
        [self.constraints addObject:cons];
    }
    
    if (self.align == ZLAlignCenter) {//中心布局设置两边间距相等
        NSArray<NSLayoutDimension *> *heightDimens = self.guideMerge.heightAnchors;
        cons = [heightDimens.firstObject constraintEqualToAnchor:heightDimens.lastObject];
        [self.constraints addObject:cons];
    }
}
- (void)addVerticalLayoutConstraints {
    [self deactivateConstraints];
    if (self.horizontal) return;
    NSLayoutYAxisAnchor *nextAnchor = self.guideMerge.topAnchor;
    NSInteger count = self.views.count;
    NSLayoutConstraint *cons;
    NSLayoutDimension  *heightDim;
    NSLayoutDimension *viewheightDim;
   
    for (int i = 0; i < count; i ++) {
        UIView *view = self.views[i];
        ZLViewLayoutCfg *cfg = view.zl_layoutCfg;
        
        //添加垂直约束
        CGFloat startSpacing = cfg.startSpacing;
        CGFloat endSpacing = cfg.endSpacing;
        CGFloat behindSpacing = cfg.behindSpacing;
        switch (self.align) {
            case ZLAlignStart:
            {
                cons = [view.leadingAnchor constraintEqualToAnchor:self.stackView.leadingAnchor constant:startSpacing];
                [self.constraints addObject:cons];
                cons = [view.trailingAnchor constraintLessThanOrEqualToAnchor:self.stackView.trailingAnchor constant:-endSpacing];
                [self.constraints addObject:cons];
            }
                break;
            case ZLAlignCenter:
            {
                CGFloat offsetY = (startSpacing - endSpacing) * 0.5;
                cons = [view.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.stackView.leadingAnchor constant:startSpacing];
                [self.constraints addObject:cons];
                
                cons = [view.trailingAnchor constraintLessThanOrEqualToAnchor:self.stackView.trailingAnchor constant:endSpacing];
                [self.constraints addObject:cons];
                
                cons = [view.centerXAnchor constraintEqualToAnchor:self.stackView.centerXAnchor constant:offsetY];
                [self.constraints addObject:cons];
            }
                
                
                break;
            case ZLAlignEnd:
            {
                cons = [view.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.stackView.leadingAnchor constant:startSpacing];
                [self.constraints addObject:cons];
            
                cons = [view.trailingAnchor constraintEqualToAnchor:self.stackView.trailingAnchor constant:-endSpacing];
                [self.constraints addObject:cons];
            }
            
                break;
            case ZLAlignFill:
            {
                cons = [view.leadingAnchor constraintEqualToAnchor:self.stackView.leadingAnchor constant:startSpacing];
                [self.constraints addObject:cons];
                cons = [view.trailingAnchor constraintEqualToAnchor:self.stackView.trailingAnchor constant:endSpacing];
                [self.constraints addObject:cons];
            }
                break;
            default:
                break;
        }
        
        
        if (self.stackView.justify == ZlJustifyEnd && i == 0) {
            cons = [view.topAnchor constraintGreaterThanOrEqualToAnchor:nextAnchor];
        }else {
            cons = [view.topAnchor constraintEqualToAnchor:nextAnchor];
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
            case ZLJustifyStart:
            case ZlJustifyEnd:
            case ZLJustifyCenter:
                
            {
                if (behindSpacing > 0.0 && i < count - 1) {//添加间距
                    ZLLayoutGuide *spacingGuide = ZLLayoutGuide.new;
                    spacingGuide.stackView = self.stackView;
                    cons = [spacingGuide.topAnchor constraintEqualToAnchor:nextAnchor];
                    [self.constraints addObject:cons];
                    nextAnchor = spacingGuide.bottomAnchor;
                    cons = [spacingGuide.heightAnchor constraintEqualToConstant:behindSpacing];
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
    
    
    if (self.justify == ZLJustifyStart) {
        cons = [nextAnchor constraintLessThanOrEqualToAnchor:self.guideMerge.bottomAnchor];
        [self.constraints addObject:cons];
    }else {
        cons = [nextAnchor constraintEqualToAnchor:self.guideMerge.bottomAnchor];
        [self.constraints addObject:cons];
    }
    
    if (heightDim) {///设置两边间距和中间距的关系
        NSLayoutConstraint *cons;
        NSLayoutDimension *guideLeadingDim = self.guideMerge.topGuide.heightAnchor;
        cons = [guideLeadingDim constraintEqualToAnchor:self.guideMerge.bottomGuide.heightAnchor];
        [self.constraints addObject:cons];
        if (self.justify == ZlJustifySpaceAround) {
             cons = [guideLeadingDim constraintEqualToAnchor:heightDim multiplier:0.5];
        }else if (self.justify == ZlJustifySpaceEvenly) {
            cons = [guideLeadingDim constraintEqualToAnchor:heightDim];
        }
        [self.constraints addObject:cons];
    }
    
    if (self.justify == ZLJustifyCenter) {//中心布局设置两边间距相等
        NSArray<NSLayoutDimension *> *heightsDimens = self.guideMerge.heightAnchors;
        cons = [heightsDimens.firstObject constraintEqualToAnchor:heightsDimens.lastObject];
        [self.constraints addObject:cons];
    }
    
    if (self.align == ZLAlignCenter) {//中心布局设置两边间距相等
        NSArray<NSLayoutDimension *> *heightDimens = self.guideMerge.heightAnchors;
        cons = [heightDimens.firstObject constraintEqualToAnchor:heightDimens.lastObject];
        [self.constraints addObject:cons];
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
