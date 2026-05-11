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
#import "ZLLayoutGuide.h"
#import "ZLStackView.h"

NS_ASSUME_NONNULL_BEGIN

@class ZLPairView;
///firstView和secondView的组合视图，firstView和secondView分别是两个view，firstView在secondView的左边或者上边，取决于horizontal属性
@interface ZLPairView<__covariant ObjectType,
                        __covariant FirstView : UIView *,
                        __covariant SecondView: UIView* > : ZLBaseStackView<ObjectType>

///firstView在secondView的左边或者上边，取决于horizontal属性
@property (nonatomic, strong,readonly) FirstView  first;

///seondView在firstView的右边或者下边，取决于horizontal属性
@property (nonatomic, strong,readonly) SecondView second;

/// 对象初始化后会保证调用一次，回调参数是当前对象，方便外部链式调用配置方法
@property (nonatomic,readonly) ObjectType (^then)(void (^)(ObjectType  pairView));

///配置第一个view
@property (nonatomic,readonly) ObjectType (^thenFirst)(void(^)(FirstView  first));

///配置第二个view
@property (nonatomic,readonly) ObjectType (^thenSecond)(void(^)(SecondView second));

/// 子类必须重写，创建主视图
- (FirstView)makeFirstView;

/// 子类必须重写，创建次视图
- (SecondView)makeSecondView;


@property (readonly)ObjectType (^minSpace)(CGFloat spacing);

@property (readonly)ObjectType (^maxSpace)(CGFloat spacing);

@property (readonly)ObjectType (^flexSpace)(BOOL flexible);

@property (readonly)ObjectType (^firstStartSpace)(CGFloat spacing);

@property (readonly)ObjectType (^firstEndSpace)(CGFloat spacing);

@property (readonly)ObjectType (^secondStartSpace)(CGFloat spacing);

@property (readonly)ObjectType (^secondEndSpace)(CGFloat spacing);

@property (readonly)ObjectType (^firstFlex)(NSInteger flex);

@property (readonly)ObjectType (^secondFlex)(NSInteger flex);




@property (nonatomic,readonly)ZLStackView * (^insertSpace)(CGFloat spacing) NS_UNAVAILABLE;
@property (nonatomic,readonly)ZLStackView * (^insertMinSpace)(CGFloat spacing)NS_UNAVAILABLE;
@property (nonatomic,readonly)ZLStackView * (^insertMaxSpace)(CGFloat spacing)NS_UNAVAILABLE;
@property (nonatomic,readonly)ZLStackView * (^insertFlexSpace)(BOOL flexible)NS_UNAVAILABLE;
@property (nonatomic, readonly)ZLStackView * (^add)(UIView *view) NS_UNAVAILABLE;
@property (nonatomic, readonly)ZLStackView * (^addLayout)(
    UIView *view,
    void(^)(__kindof UIView *view, ZLFlexItem *viewCfg)
)NS_UNAVAILABLE;
@property (nonatomic, readonly)ZLStackView * (^spacingAfter)(UIView *arrangedSubview,CGFloat spacing)
NS_UNAVAILABLE;
@property (nonatomic, readonly)ZLStackView * (^minSpacingAfter)(UIView *arrangedSubview,CGFloat minSpacing)
NS_UNAVAILABLE;
@property (nonatomic, readonly)ZLStackView * (^maxSpacingAfter)(UIView *arrangedSubview,CGFloat maxSpacing)
NS_UNAVAILABLE;
@property (nonatomic, readonly)ZLStackView * (^flexFor)(UIView *arrangedSubview,NSInteger flex)
NS_UNAVAILABLE;
@property (nonatomic, readonly)ZLStackView * (^flexSpacingAfter)(UIView *arrangedSubview,BOOL flexible)
NS_UNAVAILABLE;
@property (nonatomic, readonly)ZLStackView * (^alignFor)(UIView *arrangedSubview,ZLAlign alignment)
NS_UNAVAILABLE;
@property (nonatomic, readonly)ZLStackView * (^alignStartSpacingFor)(UIView *arrangedSubview,CGFloat spacing)
NS_UNAVAILABLE;
@property (nonatomic, readonly)ZLStackView * (^alignEndSpacingFor)(UIView *arrangedSubview,CGFloat spacing)
NS_UNAVAILABLE;
///水平排列还是垂直排列，默认水平排列 默认水平排列
@property (nonatomic,assign)ZLStackViewAxis axis NS_UNAVAILABLE;
///纵轴对齐方式
@property (nonatomic,assign)ZLAlign alignment NS_UNAVAILABLE;
///主轴对齐方式
@property (nonatomic,assign)ZLJustify justifyContent NS_UNAVAILABLE;
///内边距
@property(nonatomic,assign)UIEdgeInsets insets NS_UNAVAILABLE;
@property(nonatomic,strong) NSMutableArray<__kindof UIView *> *arrangedViews NS_UNAVAILABLE;
@property (nonatomic,assign)CGFloat spacing NS_UNAVAILABLE;
/// 添加view到stackView，默认添加到最后
- (void)addArrangedSubview:(UIView *)view NS_UNAVAILABLE;
///添加view并且配置view的布局属性
- (void)addArrangedSubview:(UIView *)view layout:(void(^)(__kindof UIView *view, ZLFlexItem *viewCfg))config NS_UNAVAILABLE;
///在某个位置插入view
- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex NS_UNAVAILABLE;
/// 移除view
- (void)removeArrangedSubview:(UIView *)view NS_UNAVAILABLE;
///设置view在主轴方向的间距
- (void)setCustomSpacing:(CGFloat)spacing afterView:(UIView *)arrangedSubview NS_UNAVAILABLE;
/// 设置view在主轴方向的最小间距
- (void)setCustomMinSpacing:(CGFloat)minSpacing afterView:(UIView *)arrangedSubview NS_UNAVAILABLE;
///设置view在主轴方向的最大间距
- (void)setCustomMaxSpacing:(CGFloat)maxSpacing afterView:(UIView *)arrangedSubview NS_UNAVAILABLE;
///设置view在主轴方向的权重
- (void)setFlex:(NSInteger)flex forView:(UIView *)arrangedSubview NS_UNAVAILABLE;
///在某个view后面设置是否弹性空间 只有justify  ==  ZLJustifyFill 才会有效
- (void)setFlexibleSpacing:(BOOL)flexible afterView:(UIView *)arrangedSubview NS_UNAVAILABLE;
///设置view的alignment，优先级高于stackView的alignment
- (void)setAlignment:(ZLAlign)alignment forView:(UIView *)arrangedSubview NS_UNAVAILABLE;
///设置view的alignment方向start间距
- (void)setAlignmentStartSpacing:(CGFloat)spacing forView:(UIView *)arrangedSubview NS_UNAVAILABLE;
///设置view的alignment方向end间距
- (void)setAlignmentEndSpacing:(CGFloat)spacing forView:(UIView *)arrangedSubview NS_UNAVAILABLE;

@end

@class ZLPairLabelView,ZLPairImageView
,ZLPairButtonView,ZLImgLabelView
,ZLImgButtonView,ZLButtonImgView
,ZLButtonLabView,ZLLabelImgView
,ZLLabButtonView,ZLButtonStackView,
ZLPairStackView,ZLStackViewButton;

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
@interface ZLImgLabelView : ZLPairView<ZLImgLabelView *,ZLImageView *,ZLLabel *>

@end

/// ImageView和Button的组合视图，firstView是ImageView，secondView是Button
@interface ZLImgButtonView : ZLPairView<ZLImgButtonView *,ZLImageView *,ZLButton *>

@end

/// Button和ImageView的组合视图，firstView是Button，secondView是ImageView
@interface ZLButtonImgView : ZLPairView<ZLButtonImgView *,ZLButton *,ZLImageView *>

@end
///Button和Label的组合视图，firstView是Button，secondView是Label
@interface ZLButtonLabView : ZLPairView<ZLButtonLabView *,ZLButton *,ZLLabel *>

@end
/// Label和ImageView的组合视图，firstView是Label，secondView是ImageView
@interface ZLLabelImgView : ZLPairView<ZLLabelImgView *,ZLLabel *,ZLImageView *>

@end
/// Label和Button的组合视图，firstView是Label，secondView是Button
@interface ZLLabButtonView : ZLPairView<ZLLabButtonView *,ZLLabel *,ZLButton *>
@end

/// Button和StackView的组合视图，firstView是Button，secondView是StackView
@interface ZLButtonStackView : ZLPairView<ZLButtonStackView *,ZLButton *,ZLStackView *>
@end

/// StackView和Button的组合视图，firstView是StackView，secondView是Button 
@interface ZLStackViewButton : ZLPairView<ZLStackViewButton *,ZLStackView *,ZLButton *>
@end

/// 两个StackView的组合视图，firstView和secondView分别是两个StackView，
@interface ZLPairStackView : ZLPairView<ZLPairStackView *,ZLStackView *,ZLStackView *>
@end


NS_ASSUME_NONNULL_END
