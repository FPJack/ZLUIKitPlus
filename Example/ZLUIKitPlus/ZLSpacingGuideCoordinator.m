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
- (NSMutableSet<NSLayoutConstraint *> *)horizontalConstraints {
    if (!_horizontalConstraints) {
        _horizontalConstraints = [NSMutableSet set];
    }
    return _horizontalConstraints;
}
- (NSMutableSet<NSLayoutConstraint *> *)widthConstraints {
    if (!_widthConstraints) {
        _widthConstraints = NSMutableSet.set;
    }
    return _widthConstraints;
}
- (NSMutableSet<NSLayoutConstraint *> *)eqWidthConstraints {
    if (!_eqWidthConstraints) {
        _eqWidthConstraints = NSMutableSet.set;
    }
    return _eqWidthConstraints;
}
- (NSMutableSet<ZLSpacerGuide *> *)spacerGuides {
    if (!_spacerGuides) {
        _spacerGuides = NSMutableSet.set;
    }
    return _spacerGuides;
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
        __block NSLayoutXAxisAnchor *nextAnchor;
        nextAnchor = self.stackView.leadingAnchor;
        NSInteger count = self.views.count;
        [self.views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id cons = [obj.leadingAnchor constraintEqualToAnchor:nextAnchor];
            [self.horizontalConstraints addObject:cons];
            nextAnchor = obj.trailingAnchor;
            
            if (idx < count - 1) {
                ///如果有间隙
                ZLSpacerGuide *guide = [ZLSpacerGuide spacerWith:self.stackView];
                cons = [guide leadingConstraintEqualToAnchor:nextAnchor];
                [self.spacerGuides addObject:guide];
                [self.horizontalConstraints addObject:cons];
                nextAnchor = guide.trailingAnchor;
            }
        }];
      id cons =  [nextAnchor constraintEqualToAnchor:self.stackView.trailingAnchor];
      [self.horizontalConstraints addObject:cons];

    }else {
        
    }
}
///添加垂直约束
- (void)addVerticalConstraint {
    
}
///添加宽度约束
- (void)addWidthConstraint {
    NSArray<ZLSpacerGuide *> *arr = self.spacerGuides.allObjects;
    NSLayoutDimension *firstDimension = arr.firstObject.widthAnchor;
    for (int i = 0; i < arr.count; i ++) {
        ZLSpacerGuide *guide = arr[i];
        if (i > 0) {
            NSLayoutConstraint* widthCons;
            NSLayoutConstraint* eqWidthCons;
            switch (self.justify) {
                case ZlJustifyFill:
                case ZlJustifyFillEqually:
              
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
                    break;
                case ZlJustifySpaceBetween:
                case ZlJustifySpaceAround:
                case ZlJustifySpaceEvenly:
                {
                    eqWidthCons = [firstDimension constraintEqualToAnchor:guide.widthAnchor];
                    [self.eqWidthConstraints addObject:eqWidthCons];
                }
                    break;
                default:
                    break;
            }
        }
    }
}
///添加高度约束
- (void)addHeightConstraint {
    
}
- (void)activateConstraints {
    NSMutableArray *arr = NSMutableArray.array;
    
    [arr addObjectsFromArray:self.horizontalConstraints.allObjects];

    [arr addObjectsFromArray:self.eqWidthConstraints.allObjects];

    
    [NSLayoutConstraint activateConstraints:arr];
}

@end
