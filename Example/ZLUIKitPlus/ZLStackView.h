//
//  ZLStackView.h
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/4/25.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLLayoutGuide.h"

NS_ASSUME_NONNULL_BEGIN

///按钮不会跟随文字撑开 titleLabel需要和button加相等高度约束
@class ZLStackView;

@interface ZLStackView : UIView
@property (nonatomic,assign)BOOL horizontal;

@property (nonatomic,assign)ZLAlign alignment;

@property (nonatomic,assign)ZLJustify justify;

@property(nonatomic,assign)UIEdgeInsets insets;

@property(nonatomic,strong) NSMutableArray<__kindof UIView *> *arrangedViews;

@property (nonatomic,assign)CGFloat spacing;

- (void)addArrangedSubview:(UIView *)view;

- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex;

- (void)removeArrangedSubview:(UIView *)view;

- (void)setCustomSpacing:(CGFloat)spacing afterView:(UIView *)arrangedSubview;

///设置view在主轴方向的权重
- (void)setFlex:(NSInteger)flex forView:(UIView *)arrangedSubview;
///在某个view后面设置是否弹性空间
- (void)setFlexibleSpacing:(BOOL)flexible afterView:(UIView *)arrangedSubview;
///设置view的alignment，优先级高于stackView的alignment
- (void)setAlignment:(ZLAlign)alignment forView:(UIView *)arrangedSubview;
///设置view的alignment方向start间距
- (void)setAlignmentStartSpacing:(CGFloat)spacing forView:(UIView *)arrangedSubview;
///设置view的alignment方向end间距
- (void)setAlignmentEndSpacing:(CGFloat)spacing forView:(UIView *)arrangedSubview;

@end

NS_ASSUME_NONNULL_END
