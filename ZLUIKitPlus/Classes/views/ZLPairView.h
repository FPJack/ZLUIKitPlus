//
//  ZLPairLabelView.h
//  ZLInsetLabel
//
//  Created by admin on 2026/4/23.
//

#import <UIKit/UIKit.h>
#import "ZLImageView.h"
#import "ZLLabel.h"
#import "ZLButton.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ZLAlign) {
    ZLAlignStart,
    ZLAlignCenter,
    ZLAlignEnd
};
typedef NS_ENUM(NSInteger, ZLJustify) {
   ZlJustifyFill,
   ZlJustifyFillEqually,
   ZLJustifyStart,
   ZLJustifyCenter,
   ZlJustifyEnd,
  
};
@class ZLPairView;
///firstView和secondView的组合视图，firstView和secondView分别是两个view，firstView在secondView的左边或者上边，取决于horizontal属性
@interface ZLPairView<__covariant ObjectType,
                        __covariant FirstView : UIView *,
                        __covariant SecondView: UIView* > : UIView
///firstView在secondView的左边或者上边，取决于horizontal属性
@property (nonatomic, strong,readonly) FirstView  first;
///seondView在firstView的右边或者下边，取决于horizontal属性
@property (nonatomic, strong,readonly) SecondView second;
/// 间距，默认4
@property (nonatomic, readonly) ObjectType (^spacing)(CGFloat spacing);

///是否可弹性空间 主轴方向为ZlJustifyFill 的时候可以设置可弹性空间，默认NO
@property (nonatomic, readonly) ObjectType (^flexibleSpacing)(BOOL flexible);

/// 水平排列还是垂直排列，默认水平排列
@property (nonatomic, readonly) ObjectType (^horizontal)(BOOL horizontal);
/// 纵轴（交叉轴）对齐，默认 center
@property (nonatomic, readonly) ObjectType (^align)(ZLAlign alignment);
/// 水平轴（主轴）对齐，默认 fill
@property (nonatomic, readonly) ObjectType (^hJustify)(ZLJustify justify);
/// 纵轴（交叉轴）对齐，默认 fill
@property (nonatomic, readonly) ObjectType (^vJustify)(ZLJustify justify);

///相对于justify 边距
@property (nonatomic, readonly) ObjectType (^marge)(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing);
///marge上叠加边距
@property (nonatomic, readonly) ObjectType (^insets)(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing);
/// 对象初始化后会保证调用一次，回调参数是当前对象，方便外部链式调用配置方法
@property (nonatomic,readonly) ObjectType (^then)(void (^)(ObjectType  pairView));
///配置第一个view
@property (nonatomic,readonly) ObjectType (^thenFirst)(void(^)(FirstView  first));
///配置第二个view
@property (nonatomic,readonly) ObjectType (^thenSecond)(void(^)(SecondView second));

///渐变层，外部可直接访问进行配置，例如设置渐变颜色、方向
@property (nonatomic,strong,readonly)CAGradientLayer *gradLayer;
///设置圆角
@property (nonatomic, copy, readonly) ObjectType (^corner)(CGFloat radius);

@property (nonatomic,readonly) ObjectType (^tapAction)(void(^)(__kindof ZLPairView *view));





///布局相关
@property (nonatomic,  readonly) ObjectType (^z_centerX)(CGFloat x);

@property (nonatomic,  readonly) ObjectType (^z_centerY)(CGFloat y);

@property (nonatomic,  readonly) ObjectType (^z_center)(void);

@property (nonatomic,  readonly) ObjectType (^z_centerOffset)(CGFloat x,CGFloat y);

@property (nonatomic,  readonly) ObjectType (^z_top)(CGFloat top);

@property (nonatomic,  readonly) ObjectType (^z_leading)(CGFloat leading);

@property (nonatomic,  readonly) ObjectType (^z_bottom)(CGFloat bottom);

@property (nonatomic,  readonly) ObjectType (^z_trailing)(CGFloat trailling);

///设置高度
@property (nonatomic, copy, readonly) ObjectType (^z_height)(CGFloat height);
///设置宽度
@property (nonatomic, copy, readonly) ObjectType (^z_width)(CGFloat width);
///同时设置宽高
@property (nonatomic, copy, readonly) ObjectType (^z_size)(CGFloat width,CGFloat height);
///设置宽高相等
@property (nonatomic, copy, readonly) ObjectType (^z_square)(CGFloat wh);
///贴紧父视图四边(参数布局)
@property (nonatomic, copy, readonly) ObjectType (^z_edge)(CGFloat top,CGFloat leading, CGFloat bottom, CGFloat trailing);
 // ⭐高频
///贴紧父视图四边布局
@property (nonatomic, copy, readonly) ObjectType (^z_edgesZero)(void);

///添加到父视图，参数是父视图
@property (nonatomic, copy, readonly) ObjectType (^addTo)(UIView *superview);
///添加到父视图 并且贴紧父视图四边布局，参数是父视图
@property (nonatomic, copy, readonly) ObjectType (^addToFull)(UIView *superview);
///返回包裹好的一个view返回
@property (nonatomic, copy, readonly) UIView *(^wrapEdges)(CGFloat top,CGFloat leading, CGFloat bottom, CGFloat trailing);

/// 子类必须重写，创建主视图
- (FirstView)makeFirstView;
/// 子类必须重写，创建次视图
- (SecondView)makeSecondView;
@end

@class ZLPairLabelView,ZLPairImageView
,ZLPairButtonView,ZLPairImgLabelView
,ZLPairImgButtonView,ZLPairButtonImgView;

///两个Label的组合视图，firstView和secondView分别是两个Label，
@interface ZLPairLabelView : ZLPairView<ZLPairLabelView *,ZLLabel *,ZLLabel *>

@end

///两个ImageView的组合视图，firstView和secondView分别是两个ImageView，
@interface ZLPairImageView : ZLPairView<ZLPairImageView *,ZLImageView *,ZLImageView *>

@end

///两个Button的组合视图，firstView和secondView分别是两个Button，
@interface ZLPairButtonView : ZLPairView<ZLPairButtonView *,ZLButton *,ZLButton *>

@end

/// ImageView和Label的组合视图，firstView是ImageView，secondView是Label
@interface ZLPairImgLabelView : ZLPairView<ZLPairImgLabelView *,ZLImageView *,ZLLabel *>

@end

/// ImageView和Button的组合视图，firstView是ImageView，secondView是Button
@interface ZLPairImgButtonView : ZLPairView<ZLPairImgButtonView *,ZLImageView *,ZLButton *>

@end

/// Button和ImageView的组合视图，firstView是Button，secondView是ImageView
@interface ZLPairButtonImgView : ZLPairView<ZLPairButtonImgView *,ZLButton *,ZLImageView *>

@end
NS_ASSUME_NONNULL_END
