#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 为任意 UIView 添加圆角（每个角独立不同大小）+ 阴影的配置对象
/// 原理：圆角用 CAShapeLayer sublayer 绘制背景色，阴影用 shadowPath，两者互不干扰
/// 使用方式：
///   1. shadowCfg.view = self（绑定目标 view）
///   2. 在 view 的 layoutSubviews 末尾调用 [shadowCfg update]
@interface ZLViewDecorator : NSObject

@property (nonatomic,assign)BOOL selected;
@property (nonatomic,assign)BOOL active;
@property (nonatomic,copy)void (^activeStyleBlock)(id );
@property (nonatomic,copy)void (^inactiveStyleBlock)(id );
@property (nonatomic,copy)void (^selectStyleBlock)(id );


@property (nonatomic,copy)NSArray *gradColors;
@property (nonatomic,assign)CGPoint gradStartPoint;
@property (nonatomic,assign)CGPoint gradEndPoint;


- (instancetype)initWithView:(UIView *)view;
// MARK: - 圆角

/// 统一设置四个角（优先级低于单独设置）
@property (nonatomic, assign) CGFloat cornerRadius;


@property (nonatomic, copy) NSNumber* circle; // 是否圆形裁剪（设置为YES时自动计算半径为宽高较小值的一半）


/// 单独设置每个角（>= 0 时覆盖 cornerRadius）
@property (nonatomic, assign) CGFloat topLeftRadius;
@property (nonatomic, assign) CGFloat topRightRadius;
@property (nonatomic, assign) CGFloat bottomLeftRadius;
@property (nonatomic, assign) CGFloat bottomRightRadius;

///是否是decorator内部设置view的背景色
@property (nonatomic, assign) BOOL viewBgColorByDecorator;

// MARK: - 阴影

@property (nonatomic, strong, nullable) UIColor *shadowColor;
@property (nonatomic, assign) CGFloat shadowOpacity;  // 0~1，默认 0.3
@property (nonatomic, assign) CGFloat shadowRadius;   // 模糊半径，默认 4
@property (nonatomic, assign) CGSize  shadowOffset;   // 偏移，默认 (0, 2)

// MARK: - 背景色（等价于 view.backgroundColor，但走 shapeLayer 绘制以支持圆角裁剪）

@property (nonatomic, strong, nullable) UIColor *fillColor;

// MARK: - 刷新（在 view.layoutSubviews 末尾调用，bounds 变化时同步路径）

- (void)update;

// MARK: - 链式 API

- (ZLViewDecorator *(^)(CGFloat))corner;                               // 统一圆角
- (ZLViewDecorator *(^)(CGFloat, CGFloat, CGFloat, CGFloat))corners;   // TL TR BL BR
- (ZLViewDecorator *(^)(UIColor *, CGFloat, CGFloat, CGSize))shadow;   // color opacity radius offset

@end

NS_ASSUME_NONNULL_END
