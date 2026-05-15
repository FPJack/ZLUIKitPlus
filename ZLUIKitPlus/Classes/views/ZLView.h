//
//  ZLBaseView.h
//  ZLUIKitPlus
//
//  Created by admin on 2026/5/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZLView,ZLWrapperView;
@interface ZLBaseView<__covariant ObjectType> : UIView
///立马回调一次，多次调用也只会调用一次
@property (readonly) ObjectType (^onInit)(void(^)(ZLBaseView* view));

///赋值当前对象到一个指针上
/// 例如：ZLBaseView *view;
///  ZLBaseView.new.assignToPtr(&view);
@property (readonly)ObjectType (^assignToPtr)(ZLBaseView *_Nullable* _Nullable buttonPtr);

///设置userinteractionEnabled 会触发activeStyle 或者 inactiveStyle 回调
@property (readonly) ObjectType (^userActive)(BOOL userInteractionEnabled);

@property (readonly) ObjectType (^visibility)(BOOL visible);

@property (readonly)ObjectType (^alphaValue)(CGFloat alpha);

@property (readonly)ObjectType (^bgColor)(id color);// 便捷设置背景色，支持 UIColor 或 UIColorHex
///设置圆角
@property (nonatomic, copy, readonly)ObjectType (^corner)(CGFloat radius);

///设置4个方向的圆角，传入不同的值
@property (readonly)ObjectType (^cornerRadii)(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight);
///设置是否圆形裁剪
@property (readonly)ObjectType (^circle)(BOOL circle);
///UIColor or #333333
@property (readonly)ObjectType (^borderColor)(id);

@property (readonly)ObjectType (^borderWidth)(CGFloat);

@property (readonly)ObjectType (^border)(CGFloat width,id color);

@property (readonly)ObjectType (^shColor)(id color);
//默认 （0,2）
@property (readonly)ObjectType (^shOffset)(CGFloat width,CGFloat height);
//默认0.2
@property (readonly)ObjectType (^shOpacity)(CGFloat opacity);
//默认6
@property (readonly)ObjectType (^shRadius)(CGFloat radius);

@property (readonly)ObjectType (^masksToBounds)(BOOL masksToBounds);

///渐变颜色
@property (readonly)ObjectType (^gradColors)(NSArray *colors);
///渐变方向，传入起点和终点坐标，范围0~1
@property (readonly)ObjectType (^gradDirection)(CGPoint startPoint, CGPoint endPoint);
///布局相关
@property (readonly) ObjectType (^centerX)(CGFloat x);

@property (readonly) ObjectType (^centerY)(CGFloat y);

@property (readonly) ObjectType (^centerOffset)(CGFloat x,CGFloat y);

@property (readonly) ObjectType (^top)(CGFloat top);

@property (readonly) ObjectType (^leading)(CGFloat leading);

@property (readonly) ObjectType (^bottom)(CGFloat bottom);

@property (readonly) ObjectType (^trailing)(CGFloat trailling);
///设置高度
@property (readonly)ObjectType (^height)(CGFloat height);
///设置宽度
@property (readonly)ObjectType (^width)(CGFloat width);
///同时设置宽高
@property (readonly)ObjectType (^size)(CGFloat width,CGFloat height);
///设置宽高相等
@property (readonly)ObjectType (^square)(CGFloat wh);
///贴紧父视图四边(参数布局)
@property (readonly)ObjectType (^edges)(CGFloat top,CGFloat leading, CGFloat bottom, CGFloat trailing);
 // ⭐高频
///贴紧父视图四边布局
@property (readonly)ObjectType (^edgesZero)(void);
///添加到父视图，参数是父视图
@property (readonly)ObjectType (^addTo)(UIView *superview);

///添加到父视图 并且贴紧父视图四边布局，参数是父视图
@property (readonly)ObjectType (^addToFull)(UIView *superview);
///添加子视图，参数是子视图
@property (readonly)ObjectType(^addSubview)(UIView *subview);
///添加子视图并且对子视图进行布局配置，参数是子视图和布局配置回调，回调参数是当前view和子视图，使用者在回调里对view进行布局配置即可
@property (readonly)ObjectType(^addSubviewLayout)(UIView *subview, void(^)(ZLBaseView *view,__kindof UIView *subview));
///可点击情况下进行相应配置 userActive(YES) 触发回调
@property (readonly) ObjectType (^activeStyle)(void (^)(ZLBaseView * view));
///不可点击情况下配置userActive(NO) 触发回调
@property (readonly) ObjectType (^inactiveStyle)(void (^)(ZLBaseView * view));
///立即触发block回调，每次调用都会回调出来，onInit只会调用一次
@property (readonly) ObjectType (^then)(void (^)(ZLBaseView * view));
///点击事件
@property (readonly) ObjectType (^tapAction)(void(^)(ZLBaseView *view));

@end

@interface ZLView : ZLBaseView<ZLView *>

@end


@interface ZLWrapperView : ZLBaseView<ZLWrapperView *>
@property (nonatomic, weak,readonly) UIView *contentView;
@property (readonly)ZLWrapperView *(^insets)(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing);
+ (instancetype)wrapWithView:(UIView *)view;
@end
NS_ASSUME_NONNULL_END
