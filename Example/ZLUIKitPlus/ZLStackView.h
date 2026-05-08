//
//  ZLStackView.h
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/4/25.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLLayoutGuide.h"
#import "ZLLayoutViewCfg.h"

NS_ASSUME_NONNULL_BEGIN

///按钮不会跟随文字撑开 titleLabel需要和button加相等高度约束
@class ZLStackView;

@interface ZLStackView : UIView
///水平排列还是垂直排列，默认水平排列 默认水平排列
@property (nonatomic,assign)BOOL horizontal;
///纵轴对齐方式
@property (nonatomic,assign)ZLAlign alignment;
///主轴对齐方式
@property (nonatomic,assign)ZLJustify justify;
///内边距
@property(nonatomic,assign)UIEdgeInsets insets;

@property(nonatomic,strong) NSMutableArray<__kindof UIView *> *arrangedViews;

@property (nonatomic,assign)CGFloat spacing;
/// 添加view到stackView，默认添加到最后
- (void)addArrangedSubview:(UIView *)view;
///添加view并且配置view的布局属性
- (void)addArrangedSubview:(UIView *)view layout:(void(^)(__kindof UIView *view, ZLLayoutViewCfg *viewCfg))config;
///在某个位置插入view
- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex;
/// 移除view
- (void)removeArrangedSubview:(UIView *)view;
///设置view在主轴方向的间距
- (void)setCustomSpacing:(CGFloat)spacing afterView:(UIView *)arrangedSubview;
/// 设置view在主轴方向的最小间距
- (void)setCustomMinSpacing:(CGFloat)minSpacing afterView:(UIView *)arrangedSubview;
///设置view在主轴方向的最大间距
- (void)setCustomMaxSpacing:(CGFloat)maxSpacing afterView:(UIView *)arrangedSubview;
///设置view在主轴方向的权重
- (void)setFlex:(NSInteger)flex forView:(UIView *)arrangedSubview;
///在某个view后面设置是否弹性空间 只有justify  ==  ZlJustifyFill 才会有效
- (void)setFlexibleSpacing:(BOOL)flexible afterView:(UIView *)arrangedSubview;
///设置view的alignment，优先级高于stackView的alignment
- (void)setAlignment:(ZLAlign)alignment forView:(UIView *)arrangedSubview;
///设置view的alignment方向start间距
- (void)setAlignmentStartSpacing:(CGFloat)spacing forView:(UIView *)arrangedSubview;
///设置view的alignment方向end间距
- (void)setAlignmentEndSpacing:(CGFloat)spacing forView:(UIView *)arrangedSubview;
@end

NS_ASSUME_NONNULL_END
