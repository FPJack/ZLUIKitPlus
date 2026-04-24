//
//  ZLImageView.h
//  GMListKit
//
//  Created by admin on 2026/4/22.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
#define ZLImgView [ZLImageView new]
@interface ZLImageView : UIImageView
@property (nonatomic, copy, readonly) ZLImageView* (^img)(id _Nullable image);
///高亮图片
@property (nonatomic, copy, readonly) ZLImageView* (^hlImg)(id _Nullable highlightImage);
///设置高亮状态
@property (nonatomic, copy, readonly) ZLImageView* (^highlight)(BOOL highlighted);
@property (nonatomic, copy, readonly) ZLImageView* (^mode)(UIViewContentMode mode);
- (instancetype)aspectFill;
- (instancetype)aspectFit;
@property (nonatomic, copy, readonly) ZLImageView* (^corner)(CGFloat radius);
@property (nonatomic, copy, readonly) ZLImageView* (^circle)(BOOL isCircel);
@property (nonatomic, copy, readonly) ZLImageView* (^border)(CGFloat width, id _Nullable color);
@property (nonatomic, copy, readonly) ZLImageView* (^bgColor)(id _Nullable color);
@property (nonatomic, copy, readonly) ZLImageView* (^visibility)(BOOL visible);
@property (nonatomic, copy, readonly) ZLImageView* (^alphaValue)(CGFloat alpha);
@property (nonatomic, copy, readonly) ZLImageView* (^url)(id _Nullable url,id _Nullable placeholder);

@property (nonatomic, copy, readonly) ZLImageView* (^tapAction)(void(^)(ZLImageView *imgView));

///立即触发block回调，适用于需要在初始化时立即配置样式的场景
@property (nonatomic,readonly) ZLImageView* (^then)(void (^)(ZLImageView * lab));
@property (nonatomic, copy, readonly) ZLImageView* (^toPtr)(ZLImageView *_Nullable* _Nullable ptr);



@property (nonatomic,  readonly) ZLImageView* (^z_centerX)(CGFloat x);

@property (nonatomic,  readonly) ZLImageView* (^z_centerY)(CGFloat y);

@property (nonatomic,  readonly) ZLImageView* (^z_center)(void);

@property (nonatomic,  readonly) ZLImageView* (^z_centerOffset)(CGFloat x,CGFloat y);

@property (nonatomic,  readonly) ZLImageView* (^z_top)(CGFloat top);

@property (nonatomic,  readonly) ZLImageView* (^z_leading)(CGFloat leading);

@property (nonatomic,  readonly) ZLImageView* (^z_bottom)(CGFloat bottom);

@property (nonatomic,  readonly) ZLImageView* (^z_trailing)(CGFloat trailling);

///设置高度
@property (nonatomic, copy, readonly) ZLImageView* (^z_height)(CGFloat height);
///设置宽度
@property (nonatomic, copy, readonly) ZLImageView* (^z_width)(CGFloat width);
///同时设置宽高
@property (nonatomic, copy, readonly) ZLImageView* (^z_size)(CGFloat width,CGFloat height);
///设置宽高相等
@property (nonatomic, copy, readonly) ZLImageView* (^z_square)(CGFloat wh);
///贴紧父视图四边(参数布局)
@property (nonatomic, copy, readonly) ZLImageView* (^z_edge)(CGFloat top,CGFloat leading, CGFloat bottom, CGFloat trailing);
 // ⭐高频
///贴紧父视图四边布局
@property (nonatomic, copy, readonly) ZLImageView* (^z_edgesZero)(void);

///添加到父视图，参数是父视图
@property (nonatomic, copy, readonly) ZLImageView* (^addTo)(UIView *superview);
///添加到父视图 并且贴紧父视图四边布局，参数是父视图
@property (nonatomic, copy, readonly) ZLImageView* (^addToFull)(UIView *superview);
@end


NS_ASSUME_NONNULL_END
