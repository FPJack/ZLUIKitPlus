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
///添加水平边侧约束
- (void)addHorizontalEdgeConstraint {
    if (self.horizontal) {
        switch (self.justify) {
            case ZlJustifyFill:
            case ZlJustifyFillEqually:
            case ZlJustifySpaceBetween:
                break;
            case ZLJustifyStart:
            {
                id cons = [self.trailingGuide addGreadThanWidthCons];
                 [self.widthConstraints addObject:cons];
            }
                break;
            case ZlJustifyEnd:
            {
                id cons = [self.leadingGuide addGreadThanWidthCons];
                [self.widthConstraints addObject:cons];
            }
                break;
            case ZLJustifyCenter:
            case ZlJustifySpaceAround:
            case ZlJustifySpaceEvenly:
                [self.horizontalEdgeDimensions addObject:self.leadingGuide.widthAnchor];
                [self.horizontalEdgeDimensions addObject:self.trailingGuide.widthAnchor];
                break;
            default:
                break;
        }
    }else {
        switch (self.align) {
            case ZLAlignStart:
            {
               id cons = [self.trailingGuide addGreadThanWidthCons];
               [self.widthConstraints addObject:cons];
            }
                break;
            case ZLAlignCenter:
                [self.horizontalEdgeDimensions addObject:self.leadingGuide.widthAnchor];
                [self.horizontalEdgeDimensions addObject:self.trailingGuide.widthAnchor];
                break;
            case ZLAlignEnd:
            {
               id cons = [self.leadingGuide addGreadThanWidthCons];
               [self.widthConstraints addObject:cons];
            }
                break;
            case ZLAlignFill:
                break;
            default:
                break;
        }
    }
}
///添加垂直边侧约束
- (void)addVerticalEdgeConstraint {
    
}
///添加水平约束
- (void)addHorizontalConstraint {
    [NSLayoutConstraint deactivateConstraints:self.constraints];
    [self.constraints removeAllObjects];
    if (self.horizontal) {
        NSLayoutXAxisAnchor *nextAnchor = self.guideMerge.leadingAnchor;
        NSInteger count = self.views.count;
        NSLayoutConstraint *cons;
        NSLayoutDimension  *widthDim;
        NSLayoutDimension *viewWidthDim;
       
        for (int i = 0; i < count; i ++) {
            UIView *view = self.views[i];
            
            //添加垂直约束
            {
               
                switch (self.align) {
                    case ZLAlignStart:
                        cons = [view.topAnchor constraintEqualToAnchor:self.guideMerge.alignTopAnchor];
                        [self.constraints addObject:cons];
                        cons = [view.bottomAnchor constraintLessThanOrEqualToAnchor:self.guideMerge.alignBottomAnchor];
                        [self.constraints addObject:cons];
                        break;
                    case ZLAlignCenter:
                        cons = [view.topAnchor constraintEqualToAnchor:self.guideMerge.alignTopAnchor];
                        [self.constraints addObject:cons];
                        
                        cons = [view.bottomAnchor constraintEqualToAnchor:self.guideMerge.alignBottomAnchor];
                        [self.constraints addObject:cons];
                        
                        break;
                    case ZLAlignEnd:
                            cons = [view.topAnchor constraintGreaterThanOrEqualToAnchor:self.guideMerge.alignTopAnchor];
                            [self.constraints addObject:cons];
                        
                            cons = [view.bottomAnchor constraintEqualToAnchor:self.guideMerge.alignBottomAnchor];
                            [self.constraints addObject:cons];
                    
                        break;
                    case ZLAlignFill:
                        cons = [view.topAnchor constraintEqualToAnchor:self.guideMerge.alignTopAnchor];
                        [self.constraints addObject:cons];
                        cons = [view.bottomAnchor constraintEqualToAnchor:self.guideMerge.alignBottomAnchor];
                        [self.constraints addObject:cons];
                        break;
                    default:
                        break;
                }
                
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
                    BOOL hasSpacing = YES;
                    if (hasSpacing && i < count - 1) {//添加间距
                        ZLLayoutGuide *spacingGuide = ZLLayoutGuide.new;
                        spacingGuide.stackView = self.stackView;
                        cons = [spacingGuide.leadingAnchor constraintEqualToAnchor:nextAnchor];
                        [self.constraints addObject:cons];
                        nextAnchor = spacingGuide.trailingAnchor;

                        cons = [spacingGuide.widthAnchor constraintEqualToConstant:10];
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
        
    }else {
        
    }
}



///添加垂直约束
- (void)addVerticalConstraint {
    
}
///添加宽度约束
- (void)addWidthConstraint {
    
}
///添加高度约束
- (void)addHeightConstraint {}
- (void)activateConstraints {
    [NSLayoutConstraint activateConstraints:self.constraints];
}

- (void)equalSpaceBetween {
    
}
- (void)equalSpaceEvenly {
    
    
}
- (void)equalSpaceAround {
    
}

@end
