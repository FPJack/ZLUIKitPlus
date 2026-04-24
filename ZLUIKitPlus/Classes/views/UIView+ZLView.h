//
//  UIView+ZLView.h
//  ZLUIKitPlus
//
//  Created by admin on 2026/4/24.
//

#import <UIKit/UIKit.h>
#import "ZLPairView.h"

NS_ASSUME_NONNULL_BEGIN
@class ZLButton,ZLImageView,ZLLabel;

@interface UIView (ZLView)
//主
@property ( readonly) ZLButton    *zl_btn;
@property ( readonly) ZLLabel     *zl_lab;
@property ( readonly) ZLImageView *zl_imgView;

//第二组
@property ( readonly) ZLButton    *zl_altBtn;
@property ( readonly) ZLLabel     *zl_altLab;
@property ( readonly) ZLImageView *zl_altImgView;
//第三组
@property ( readonly) ZLButton    *zl_extraBtn;
@property ( readonly) ZLLabel     *zl_extraLab;
@property ( readonly) ZLImageView *zl_extraImgView;


@property ( readonly) ZLPairLabelView    *zl_pairLab;
@property ( readonly) ZLPairImageView    *zl_pairImg;
@property ( readonly) ZLPairButtonView   *zl_pairBtn;
@property ( readonly) ZLPairImgLabelView *zl_pairImgLab;
@property ( readonly) ZLPairImgButtonView *zl_pairImgBtn;
@property ( readonly) ZLPairButtonImgView *zl_pairBtnImg;

@end

NS_ASSUME_NONNULL_END
