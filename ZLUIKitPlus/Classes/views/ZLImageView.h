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
@property (nonatomic, copy, readonly) ZLImageView* (^corners)(CACornerMask corners);

@property (nonatomic, copy, readonly) ZLImageView* (^circle)(BOOL isCircel);

@property (nonatomic, copy, readonly) ZLImageView* (^border)(CGFloat width, id _Nullable color);
@property (nonatomic, copy, readonly) ZLImageView* (^bgColor)(id _Nullable color);
@property (nonatomic, copy, readonly) ZLImageView* (^visibility)(BOOL visible);

@property (nonatomic, copy, readonly) ZLImageView* (^alphaValue)(CGFloat alpha);

@property (nonatomic, copy, readonly) ZLImageView* (^url)(id _Nullable url,id _Nullable placeholder);

@property (nonatomic, copy, readonly) ZLImageView* (^assignToPtr)(ZLImageView *_Nullable* _Nullable ptr);

///布局相关
@property (readonly) ZLImageView* (^centerX)(CGFloat x);

@property (readonly) ZLImageView* (^centerY)(CGFloat y);

@property (readonly) ZLImageView* (^centerOffset)(CGFloat x,CGFloat y);

@property (readonly) ZLImageView* (^top)(CGFloat top);

@property (readonly) ZLImageView* (^leading)(CGFloat leading);

@property (readonly) ZLImageView* (^bottom)(CGFloat bottom);

@property (readonly) ZLImageView* (^trailing)(CGFloat trailling);
///设置高度
@property (readonly) ZLImageView* (^height)(CGFloat height);
///设置宽度
@property (readonly) ZLImageView* (^width)(CGFloat width);
///同时设置宽高
@property (readonly) ZLImageView* (^size)(CGFloat width,CGFloat height);
///设置宽高相等
@property (readonly) ZLImageView* (^square)(CGFloat wh);
///贴紧父视图四边(参数布局)
@property (readonly) ZLImageView* (^edge)(CGFloat top,CGFloat leading, CGFloat bottom, CGFloat trailing);
 // ⭐高频
///贴紧父视图四边布局
@property (readonly) ZLImageView* (^edgesZero)(void);
///添加到父视图，参数是父视图
@property (readonly) ZLImageView* (^addTo)(UIView *superview);

///添加到父视图 并且贴紧父视图四边布局，参数是父视图
@property (readonly) ZLImageView* (^addToFull)(UIView *superview);

@property (readonly) ZLImageView*(^addSubview)(UIView *subview);
///设置userinteractionEnabled
@property (nonatomic, copy, readonly) ZLImageView* (^userActive)(BOOL userInteractionEnabled);
///可点击情况下进行相应配置 userActive(YES) 触发回调
@property (readonly) ZLImageView* (^activeStyle)(void (^)(ZLImageView* view));
///不可点击情况下配置userActive(NO) 触发回调
@property (readonly) ZLImageView* (^inactiveStyle)(void (^)(ZLImageView* view));

///立即触发block回调，适用于需要在初始化时立即配置样式的场景
@property (readonly) ZLImageView* (^then)(void (^)(ZLImageView* view));
///点击事件
@property (readonly) ZLImageView* (^tapAction)(void(^)(ZLImageView*view));

@end


NS_ASSUME_NONNULL_END
