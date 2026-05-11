//
//  ZLView.h
//  ZLUIKitPlus
//
//  Created by admin on 2026/5/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLView : UIView
///赋值当前对象到一个指针上
/// 例如：ZLView *view;
///  ZLView.new.assignToPtr(&view);
@property (nonatomic, copy, readonly) ZLView * (^assignToPtr)(ZLView *_Nullable* _Nullable buttonPtr);

///设置userinteractionEnabled 会触发activeStyle 或者 inactiveStyle 回调
@property (nonatomic, copy, readonly) ZLView* (^userActive)(BOOL userInteractionEnabled);

@property (readonly) ZLView* (^visibility)(BOOL visible);


@property (readonly) ZLView * (^alphaValue)(CGFloat alpha);

@property (nonatomic, copy,readonly) ZLView * (^bgColor)(id color);// 便捷设置背景色，支持 UIColor 或 UIColorHex
///设置圆角
@property (nonatomic, copy, readonly) ZLView * (^corner)(CGFloat radius);

///设置4个方向的圆角，传入不同的值
@property (nonatomic, copy, readonly) ZLView * (^cornerRadii)(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight);
///设置是否圆形裁剪
@property (nonatomic, copy, readonly) ZLView * (^circle)(BOOL circle);
///UIColor or #333333
@property (nonatomic,readonly) ZLView * (^borderColor)(id);

@property (nonatomic,readonly) ZLView * (^borderWidth)(CGFloat);

@property (nonatomic,readonly) ZLView * (^border)(CGFloat width,id color);

@property (nonatomic,readonly) ZLView * (^shColor)(id color);
//默认 （0,2）
@property (nonatomic,readonly) ZLView * (^shOffset)(CGFloat width,CGFloat height);
//默认0.2
@property (nonatomic,readonly) ZLView * (^shOpacity)(CGFloat opacity);
//默认6
@property (nonatomic,readonly) ZLView * (^shRadius)(CGFloat radius);

@property (nonatomic,readonly) ZLView * (^masksToBounds)(BOOL masksToBounds);

///渐变颜色
@property (nonatomic, readonly) ZLView * (^gradColors)(NSArray *colors);
///渐变方向，传入起点和终点坐标，范围0~1
@property (nonatomic, readonly) ZLView * (^gradDirection)(CGPoint startPoint, CGPoint endPoint);
///布局相关
@property (readonly) ZLView* (^centerX)(CGFloat x);

@property (readonly) ZLView* (^centerY)(CGFloat y);

@property (readonly) ZLView* (^centerOffset)(CGFloat x,CGFloat y);

@property (readonly) ZLView* (^top)(CGFloat top);

@property (readonly) ZLView* (^leading)(CGFloat leading);

@property (readonly) ZLView* (^bottom)(CGFloat bottom);

@property (readonly) ZLView* (^trailing)(CGFloat trailling);
///设置高度
@property (readonly) ZLView * (^height)(CGFloat height);
///设置宽度
@property (readonly) ZLView * (^width)(CGFloat width);
///同时设置宽高
@property (readonly) ZLView * (^size)(CGFloat width,CGFloat height);
///设置宽高相等
@property (readonly) ZLView * (^square)(CGFloat wh);
///贴紧父视图四边(参数布局)
@property (readonly) ZLView * (^edge)(CGFloat top,CGFloat leading, CGFloat bottom, CGFloat trailing);
 // ⭐高频
///贴紧父视图四边布局
@property (readonly) ZLView * (^edgesZero)(void);
///添加到父视图，参数是父视图
@property (readonly) ZLView * (^addTo)(UIView *superview);

///添加到父视图 并且贴紧父视图四边布局，参数是父视图
@property (readonly) ZLView * (^addToFull)(UIView *superview);

@property (readonly) ZLView *(^addSubview)(UIView *subview);
///可点击情况下进行相应配置 userActive(YES) 触发回调
@property (readonly) ZLView* (^activeStyle)(void (^)(ZLView * view));
///不可点击情况下配置userActive(NO) 触发回调
@property (readonly) ZLView* (^inactiveStyle)(void (^)(ZLView * view));

///立即触发block回调，适用于需要在初始化时立即配置样式的场景
@property (readonly) ZLView* (^then)(void (^)(ZLView * view));
///点击事件
@property (readonly) ZLView* (^tapAction)(void(^)(ZLView *view));

@end


@interface ZLWrapperView : ZLView
@property (nonatomic, weak,readonly) UIView *contentView;
@property (readonly)ZLWrapperView *(^insets)(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing);
+ (instancetype)wrapWithView:(UIView *)view;
- (instancetype)insetsZero;
@end




NS_ASSUME_NONNULL_END
