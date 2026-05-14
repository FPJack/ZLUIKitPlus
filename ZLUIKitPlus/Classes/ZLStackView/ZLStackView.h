//
//  ZLStackView.h
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/4/25.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLLayoutGuide.h"
#import "ZLFlexItem.h"
NS_ASSUME_NONNULL_BEGIN
@class ZLStackView,ZLScrollStackView;

@interface ZLBaseStackView<__covariant ObjectType> : UIView

///水平排列还是垂直排列，默认水平排列 默认水平排列
@property (nonatomic,assign)ZLStackViewAxis axis;
///纵轴对齐方式
@property (nonatomic,assign)ZLAlign alignment;
///主轴对齐方式
@property (nonatomic,assign)ZLJustify justifyContent;
///内边距
@property(nonatomic,assign)UIEdgeInsets insets;
@property(nonatomic,copy,readonly) NSArray<__kindof UIView *> *arrangedViews;
@property (nonatomic,assign)CGFloat spacing;

/// 添加view到stackView，默认添加到最后
- (void)addArrangedSubview:(UIView *)view;

///添加view并且配置view的布局属性
- (void)addArrangedSubview:(UIView *)view layout:(void(^)(__kindof UIView *view, ZLFlexItem *flexItem))config;

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

///在某个view后面设置是否弹性空间 只有justify  ==  ZLJustifyFill 才会有效
- (void)setFlexibleSpacing:(BOOL)flexible afterView:(UIView *)arrangedSubview;

///设置view的alignment，优先级高于stackView的alignment
- (void)setAlignment:(ZLAlign)alignment forView:(UIView *)arrangedSubview;

///设置view的alignment方向start间距
- (void)setAlignmentStartSpacing:(CGFloat)spacing forView:(UIView *)arrangedSubview;

///设置view的alignment方向end间距
- (void)setAlignmentEndSpacing:(CGFloat)spacing forView:(UIView *)arrangedSubview;



/// 链式API
+ (instancetype)horizontal;
+ (instancetype)vertical;
- (instancetype)horizontal;
- (instancetype)vertical;
- (instancetype)alignStart;
- (instancetype)alignCenter;
- (instancetype)alignEnd;
- (instancetype)alignFill;
- (instancetype)justifyStart;
- (instancetype)justifyCenter;
- (instancetype)justifyEnd;
- (instancetype)justifyFill;
- (instancetype)justifyFillEqually;
- (instancetype)justifySpaceBetween;
- (instancetype)justifySpaceAround;
- (instancetype)justifySpaceEvenly;


@property(nonatomic,readonly)ObjectType (^inset)(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing);
///水平方向的间距
@property(nonatomic,readonly)ObjectType (^hInset)(CGFloat leading, CGFloat trailing);
///垂直方向的间距
@property(nonatomic,readonly)ObjectType (^vInset)(CGFloat top, CGFloat bottom);
@property (nonatomic,readonly)ObjectType (^space)(CGFloat spacing);

@property (nonatomic,readonly)ObjectType (^insertSpace)(CGFloat spacing);
@property (nonatomic,readonly)ObjectType (^insertMinSpace)(CGFloat spacing);
@property (nonatomic,readonly)ObjectType (^insertMaxSpace)(CGFloat spacing);
@property (nonatomic,readonly)ObjectType (^insertFlexSpace)(BOOL flexible);

/// 添加一个已创建好的 view
@property (nonatomic, readonly)ObjectType (^addView)(UIView *view);


/// 根据条件决定是否添加 view，condition 为 YES 才添加
@property (nonatomic, readonly)ObjectType (^addViewIf)(BOOL condition, UIView *view);

/// 根据条件决定是否通过 block 创建并添加 view，condition 为 YES 才执行 block 并添加
@property (nonatomic, readonly)ObjectType (^addViewMakeIf)(BOOL condition, UIView *(^make)(ZLBaseStackView *stackView));

/// 添加 view 并同时配置其 FlexItem 布局属性
@property (nonatomic, readonly)ObjectType (^addViewLayout)(
    UIView *view,
    void(^)(__kindof UIView *view, ZLFlexItem *flexItem)
);

/// 通过 block 创建并添加 view（block 内返回要添加的 view）
@property (nonatomic, readonly)ObjectType (^addViewMake)(UIView *(^make)(ZLBaseStackView *stackView));


@property (nonatomic, readonly)ObjectType (^spacingAfter)(CGFloat spacing,UIView *arrangedSubview);

@property (nonatomic, readonly)ObjectType (^minSpacingAfter)(CGFloat minSpacing,UIView *arrangedSubview);
@property (nonatomic, readonly)ObjectType (^maxSpacingAfter)(CGFloat maxSpacing,UIView *arrangedSubview);
@property (nonatomic, readonly)ObjectType (^flexFor)(NSInteger flex,UIView *arrangedSubview);
@property (nonatomic, readonly)ObjectType (^flexSpacingAfter)(BOOL flexible,UIView *arrangedSubview);
@property (nonatomic, readonly)ObjectType (^alignFor)(ZLAlign alignment,UIView *arrangedSubview);
@property (nonatomic, readonly)ObjectType (^alignStartSpacingFor)(CGFloat spacing,UIView *arrangedSubview);
@property (nonatomic, readonly)ObjectType (^alignEndSpacingFor)(CGFloat spacing,UIView *arrangedSubview);
///赋值当前对象到一个指针上
/// 例如：ZLButton *btn;
///  ZLButton.new.assignToPtr(&btn);
@property (nonatomic, copy, readonly) ObjectType (^assignToPtr)(ZLBaseStackView *_Nullable* _Nullable buttonPtr);

///点击事件
@property (readonly) ObjectType (^tapAction)(void(^)(ZLBaseStackView *view));
///设置hidden
@property (readonly) ObjectType (^visibility)(BOOL visible);
///设置alpha
@property (readonly) ObjectType (^alphaValue)(CGFloat alpha);

///设置userinteractionEnabled 会触发activeStyle 或者 inactiveStyle 回调
@property (nonatomic, copy, readonly) ObjectType (^userActive)(BOOL userInteractionEnabled);

@property (nonatomic, copy,readonly) ObjectType (^bgColor)(id color);// 便捷设置背景色，支持 UIColor 或 UIColorHex

///设置圆角
@property (nonatomic, copy, readonly) ObjectType (^corner)(CGFloat radius);
///设置哪个方向圆角 CACornerMask
@property (nonatomic, copy, readonly) ObjectType (^corners)(CACornerMask corners);
///UIColor or #333333
@property (nonatomic,readonly) ObjectType (^borderColor)(id);

@property (nonatomic,readonly) ObjectType (^borderWidth)(CGFloat);

@property (nonatomic,readonly) ObjectType (^border)(CGFloat width,id color);

@property (nonatomic,readonly) ObjectType (^shColor)(id color);
//默认 （0,2）
@property (nonatomic,readonly) ObjectType (^shOffset)(CGFloat width,CGFloat height);
//默认0.2
@property (nonatomic,readonly) ObjectType (^shOpacity)(CGFloat opacity);
//默认6
@property (nonatomic,readonly) ObjectType (^shRadius)(CGFloat radius);

@property (nonatomic,readonly) ObjectType (^masksToBounds)(BOOL masksToBounds);

///布局相关
@property (readonly) ObjectType (^centerX)(CGFloat x);

@property (readonly) ObjectType (^centerY)(CGFloat y);

@property (readonly) ObjectType (^centerOffset)(CGFloat x,CGFloat y);

@property (readonly) ObjectType (^top)(CGFloat top);

@property (readonly) ObjectType (^leading)(CGFloat leading);

@property (readonly) ObjectType (^bottom)(CGFloat bottom);

@property (readonly) ObjectType (^trailing)(CGFloat trailling);
///设置高度
@property (readonly) ObjectType (^height)(CGFloat height);
///设置宽度
@property (readonly) ObjectType (^width)(CGFloat width);
///同时设置宽高
@property (readonly) ObjectType (^size)(CGFloat width,CGFloat height);
///设置宽高相等
@property (readonly) ObjectType (^square)(CGFloat wh);
///贴紧父视图四边(参数布局)
@property (readonly) ObjectType (^edge)(CGFloat top,CGFloat leading, CGFloat bottom, CGFloat trailing);
 // ⭐高频
///贴紧父视图四边布局
@property (readonly) ObjectType (^edgesZero)(void);
///添加到父视图，参数是父视图
@property (readonly) ObjectType (^addTo)(UIView *superview);
///添加到父视图 并且贴紧父视图四边布局，参数是父视图
@property (readonly) ObjectType (^addToFull)(UIView *superview);

@property (readonly) ObjectType (^addSubview)(UIView *subview);

///包裹一个scrollview，解决scrollview里面放stackview高度不自适应以及内容宽高超出容器宽高滑动的问题
- (UIScrollView *)wrapScrollView;

@end

///按钮不会跟随文字撑开 titleLabel需要和button加相等高度约束
@interface ZLStackView : ZLBaseStackView<ZLStackView *>

@end

///垂直排列的stackView
#define VStackView ZLStackView.vertical

///水平排列的stackView
#define HStackView ZLStackView.horizontal



NS_ASSUME_NONNULL_END
