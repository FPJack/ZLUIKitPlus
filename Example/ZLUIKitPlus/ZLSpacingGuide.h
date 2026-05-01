//
//  ZLSpacingGuide.h
//  ZLUIKitPlus_Example
//
//  Created by admin on 2026/5/1.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLStackView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZLSpacingGuide : UILayoutGuide
@property (nonatomic,weak)NSLayoutConstraint *widthCons;
@property (nonatomic,weak)NSLayoutConstraint *heightCons;
@property (nonatomic,weak)ZLStackView *stackView;
- (NSLayoutConstraint *)addGreadThanWidthCons;
- (NSLayoutConstraint *)addGreadThanHeightCons;
- (void)addZeroHeightCons;
- (void)addZeroWidthCons;
@end


@interface ZLSpacerGuide : UILayoutGuide
@property (nonatomic,weak)NSLayoutConstraint *widthCons;
@property (nonatomic,weak)NSLayoutConstraint *heightCons;
@property (nonatomic,copy)NSNumber *spacing;
@property (nonatomic,weak)UIView *view;
+ (instancetype)spacerWith:(UIView *)view;
- (NSLayoutConstraint *)leadingConstraintEqualToAnchor:(NSLayoutXAxisAnchor *)anchor;
- (NSLayoutConstraint *)topConstraintEqualToAnchor:(NSLayoutYAxisAnchor *)anchor;
- (NSLayoutConstraint *)widthConstraintEqualToConstant:(CGFloat )width;
- (NSLayoutConstraint *)heightConstraintEqualToConstant:(CGFloat )height;


@end

NS_ASSUME_NONNULL_END
