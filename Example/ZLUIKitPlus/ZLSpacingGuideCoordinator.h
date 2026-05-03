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
@property (nonatomic,readonly)NSArray<UIView *> *views;
@property (nonatomic,readonly)ZLJustify justify;
@property (nonatomic,readonly)ZLAlign align;
@property (nonatomic,readonly)BOOL horizontal;
@property (nonatomic,strong)NSMutableArray<NSLayoutConstraint *> *constraints;



- (void)addHorizontalLayoutConstraints;
- (void)addVerticalLayoutConstraints;
///激活所有约束
- (void)activateConstraints;
- (void)deactivateConstraints;


@end

NS_ASSUME_NONNULL_END
