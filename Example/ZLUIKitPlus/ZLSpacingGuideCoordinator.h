//
//  ZLSpacingGuideCoordinator.h
//  ZLUIKitPlus_Example
//
//  Created by admin on 2026/5/1.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLSpacingGuide.h"
#import "ZLStackView.h"

NS_ASSUME_NONNULL_BEGIN
@interface ZLSpacingGuideCoordinator : NSObject
@property (nonatomic,weak)ZLStackView *stackView;
@property (nonatomic,strong)ZLSpacingGuide *topGuide;
@property (nonatomic,strong)ZLSpacingGuide *leadingGuide;
@property (nonatomic,strong)ZLSpacingGuide *bottomGuide;
@property (nonatomic,strong)ZLSpacingGuide *trailingGuide;

@property (nonatomic,readonly)NSArray<UIView *> *views;
@property (nonatomic,readonly)ZLJustify justify;
@property (nonatomic,readonly)ZLAlign align;
@property (nonatomic,readonly)BOOL horizontal;

///水平方向左右两侧的边侧的NSLayoutDimension集合，主要用于在调整水平间距时，更新这两个边侧的约束
@property (nonatomic,strong)NSMutableSet<NSLayoutDimension *> *horizontalEdgeDimensions;
///垂直方向上下两侧的边侧的NSLayoutDimension集合，主要用于
@property (nonatomic,strong)NSMutableSet<NSLayoutDimension *> *verticalEdgeDimensions;
///水平方向的间距NSLayoutDimension集合
@property (nonatomic,strong)NSMutableSet<NSLayoutDimension *> *horizontalSpacingDimensions;
///垂直方向的间距NSLayoutDimension集合
@property (nonatomic,strong)NSMutableSet<NSLayoutDimension *> *verticalSpacingDimensions;
///水平方向的所有约束
@property (nonatomic,strong)NSMutableSet<NSLayoutConstraint *> *horizontalConstraints;
///垂直方向的所有约束
@property (nonatomic,strong)NSMutableSet<NSLayoutConstraint *> *verticalConstraints;
///所有宽度约束
@property (nonatomic,strong)NSMutableSet<NSLayoutConstraint *> *widthConstraints;
///所有高度约束
@property (nonatomic,strong)NSMutableSet<NSLayoutConstraint *> *heightConstraints;

///添加水平边侧约束
- (void)addHorizontalEdgeConstraint;
///添加垂直边侧约束
- (void)addVerticalEdgeConstraint;
///添加水平约束
- (void)addHorizontalConstraint;
///添加垂直约束
- (void)addVerticalConstraint;
///添加宽度约束
- (void)addWidthConstraint;
///添加高度约束
- (void)addHeightConstraint;

@end

NS_ASSUME_NONNULL_END
