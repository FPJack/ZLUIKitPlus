//
//  ZLSpacingGuideCoordinator.m
//  ZLUIKitPlus_Example
//
//  Created by admin on 2026/5/1.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLSpacingGuideCoordinator.h"

@implementation ZLSpacingGuideCoordinator
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
    if (self.horizontal) {
        
        [self.views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
        }];
        
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
@end
