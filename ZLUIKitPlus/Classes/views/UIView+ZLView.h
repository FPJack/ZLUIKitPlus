//
//  UIView+ZLView.h
//  ZLUIKitPlus
//
//  Created by admin on 2026/4/24.
//

#import <UIKit/UIKit.h>
#import "ZLView.h"
#import "ZLPairView.h"
NS_ASSUME_NONNULL_BEGIN
@class ZLButton,ZLImageView,ZLLabel,ZLView;

@interface UIView (ZLView)
//主
@property (readonly) ZLButton    *zl_btn;
@property (readonly) ZLLabel     *zl_lab;
@property (readonly) ZLImageView *zl_imgView;
@property (readonly) ZLStackView *zl_stackView;

//第二组
@property (readonly) ZLButton    *zl_altBtn;
@property (readonly) ZLLabel     *zl_altLab;
@property (readonly) ZLImageView *zl_altImgView;
@property (readonly) ZLStackView *zl_altStackView;

//第三组
@property (readonly) ZLButton    *zl_extraBtn;
@property (readonly) ZLLabel     *zl_extraLab;
@property (readonly) ZLImageView *zl_extraImgView;
@property (readonly) ZLStackView *zl_extraStackView;

/// 成对的标签和图片，按钮和标签，按钮和图片，按钮和标签和图片等组合视图，提供常用的布局方式（水平/垂直，图文顺序等），并且支持在同一视图上切换不同的布局方式
@property (readonly) ZLPairLabelView    *zl_pairLab;
@property (readonly) ZLPairImageView    *zl_pairImg;
@property (readonly) ZLPairButtonView   *zl_pairBtn;
@property (readonly) ZLPairStackView    *zl_pairStackView;

/// 常用的图文混排视图，提供常用的布局方式（水平/垂直，图文顺序等），并且支持在同一视图上切换不同的布局方式
@property (readonly) ZLImgLabelView     *zl_imgViewLab;
@property (readonly) ZLImgButtonView    *zl_imgViewBtn;
@property (readonly) ZLButtonImgView    *zl_btnImgView;
@property (readonly) ZLButtonLabView    *zl_btnLabel;
@property (readonly) ZLLabButtonView    *zl_labelBtn;
@property (readonly) ZLLabelImgView     *zl_labImgView;

/// 返回被包裹的view 提供圆角、边框、阴影、渐变等装饰功能
@property (readonly) ZLWrapperView   *zl_wrapView;

///一次性回调 可做初始化操作,每个实例对象多次调用也之后只会回调一次，适合在初始化时进行一些配置操作
- (instancetype)zl_init:(void (^)(__kindof UIView * view))block;
@end

NS_ASSUME_NONNULL_END
