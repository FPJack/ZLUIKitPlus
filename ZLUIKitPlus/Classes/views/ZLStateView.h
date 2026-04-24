//
//  ZLStateView.h
//  ZLStateView
//
//  Created by admin on 2025/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZLStateView;

@protocol IZLStateViewDelegate <NSObject>
@optional

/// 刷新空白视图的时候调用,第一次realod的时候stateView还未创建，stateView为nil
- (void)zl_reloadStateView:(ZLStateView *)stateView;

///是否需要展示ImageView，默认是YES
- (BOOL )zl_imageViewShouldDisplayInStateView:(ZLStateView *)stateView;

///是否需要展示TitleLabel，默认是YES
- (BOOL )zl_titleLabelShouldDisplayInStateView:(ZLStateView *)stateView;
///是否需要展示DetailLabel，默认是NO
- (BOOL )zl_detailLabelShouldDisplayInStateView:(ZLStateView *)stateView;
///是否需要展示Button，默认是NO
- (BOOL )zl_buttonShouldDisplayInStateView:(ZLStateView *)stateView;
///是否需要展示状态视图，默认是NO,(UITableView,UICollectionView内部会自动判断数据源是否为空)
- (BOOL )zl_stateViewShouldDisplay;
/// 是否需要淡入效果，默认是YES
- (BOOL)zl_stateViewShouldFadeIn:(ZLStateView *)stateView;


/// 初始化stateView
- (void)zl_initializeStateView:(ZLStateView *)stateView;
///初始化TitleLabel
- (void)zl_initializeTitleLabel:(UILabel *)titleLabel inStateView:(ZLStateView *)stateView;
///初始化DetailLabel
- (void)zl_initializeDetailLabel:(UILabel *)detailLabel inStateView:(ZLStateView *)stateView;
///初始化ImageView
- (void)zl_initializeImageView:(UIImageView *)imageView inStateView:(ZLStateView *)stateView;
///初始化Button
- (void)zl_initializeButton:(UIButton *)button inStateView:(ZLStateView *)stateView;

/// 配置TitleLabel
- (void)zl_configureTitleLabel:(UILabel *)titleLabel inStateView:(ZLStateView *)stateView;
/// 配置DetailLabel
- (void)zl_configureDetailLabel:(UILabel *)detailLabel inStateView:(ZLStateView *)stateView;
/// 配置ImageView
- (void)zl_configureImageView:(UIImageView *)imageView inStateView:(ZLStateView *)stateView;
/// 配置Button
- (void)zl_configureButton:(UIButton *)button inStateView:(ZLStateView *)stateView;

///TitleLabel 后面的间距
- (CGFloat)zl_spacingAfterTitleLabelInStateView:(ZLStateView *)stateView;
///DetailLabel 后面的间距
- (CGFloat)zl_spacingAfterDetailLabelInStateView:(ZLStateView *)stateView;
///ImageView 后面的间距
- (CGFloat)zl_spacingAfterImageViewInStateView:(ZLStateView *)stateView;
///Button 后面的间距
- (CGFloat)zl_spacingAfterButtonInStateView:(ZLStateView *)stateView;

/// 垂直偏移量
- (CGFloat)zl_verticalOffsetInStateView:(ZLStateView *)stateView;

/// 是否使用自定义视图，返回YES则走自定义视图代理方法
- (BOOL)zl_useCustomViewInStateView:(ZLStateView *)stateView;
/// 自定义视图
- (UIView *)zl_customViewForStateView:(ZLStateView *)stateView;

/// Super view to add state view,控制器默认添加到self.view，如果是View默认添加到自身身上
- (UIView *)zl_superViewForStateView:(ZLStateView *)stateView;

/// stateView的frame，默认中心布局，高度自适应，宽度等于父视图宽度
- (CGRect)zl_frameForStateView:(ZLStateView *)stateView;
/// stateView的内边距，默认UIEdgeInsets(20,20,20,20)
- (UIEdgeInsets)zl_insetsForStateView:(ZLStateView *)stateView;
/// 按钮点击事件
- (void)zl_stateView:(ZLStateView *)stateView didTapButton:(UIButton *)button;
///如果是scrollview是否可以允许滑动
- (BOOL)zl_stateViewScrollEnabled:(ZLStateView *)stateView;
@end


typedef NSString * ZLStateViewStatus NS_STRING_ENUM;

FOUNDATION_EXPORT ZLStateViewStatus const ZLStateViewStatusNoNetwork;
FOUNDATION_EXPORT ZLStateViewStatus const ZLStateViewStatusError;
FOUNDATION_EXPORT ZLStateViewStatus const ZLStateViewStatusNoData;


@interface ZLStateView : UIView
/*
 如果要调整view的排列顺序，修改tag值即可，tag值越小，排列越靠前
 */

@property (nonatomic, strong, nullable,readonly) UIImageView *imageView; ///tag 10
@property (nonatomic, strong, nullable,readonly) UILabel *titleLabel; ///tag 11
@property (nonatomic, strong, nullable,readonly) UILabel *detailLabel; ///tag 12
@property (nonatomic, strong, nullable,readonly) UIButton *button; ///tag 13

@property (nonatomic, strong, nullable,readonly) UIView *customView;
///default is ZLStateViewStatusNoData
@property (nonatomic, copy,readonly) ZLStateViewStatus status;

@end

@interface NSObject (ZLStateView)
/// State view delegate
@property (nonatomic, weak, nullable) id<IZLStateViewDelegate> zl_stateViewDelegate;
///  Current state view status
@property (nonatomic, copy, nullable) ZLStateViewStatus zl_stateViewStatus;
/// Reload state view
- (void)zl_reloadStateView;
@end

NS_ASSUME_NONNULL_END
