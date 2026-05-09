#import "ZLViewDecorator.h"
#import "ZLUI.h"

@interface ZLViewDecorator ()
/// 背景填充层，作为 view.layer 的 sublayer[0]，负责圆角背景色
@property (nonatomic, strong) CAShapeLayer *backgroundShapeLayer;
/// 绑定目标 view，设置后立即应用当前所有属性
@property (nonatomic, weak, nullable) UIView *view;
///是否需要重绘
@property (nonatomic, assign) BOOL needsUpdate;
@property (nonatomic,strong)CAGradientLayer *gradLayer;

@end

@implementation ZLViewDecorator
- (instancetype)initWithView:(UIView *)view {
    self.view = view;
    self = [self init];
    return self;
}
- (instancetype)init {
    self = [super init];
    if (self) [self _commonInit];
    return self;
}

- (void)_commonInit {
    // 圆角默认值（-1 表示未单独设置，跟随 cornerRadius）
    _cornerRadius      = 0;
    _topLeftRadius     = -1;
    _topRightRadius    = -1;
    _bottomLeftRadius  = -1;
    _bottomRightRadius = -1;

    // 阴影默认值
    _shadowColor   = nil;
    _shadowOpacity = 0.15;
    _shadowRadius  = 6;
    _shadowOffset  = CGSizeMake(0, 2);
    
    _fillColor = self.view.backgroundColor;

    _backgroundShapeLayer = [CAShapeLayer layer];
}
- (CAGradientLayer *)gradLayer {
    if (!_gradLayer) {
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.startPoint = CGPointMake(0, 0); //左上
        layer.endPoint = CGPointMake(1, 1); // 右下
        _gradLayer = layer;
    }
    return _gradLayer;
}
- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (selected) {
        if (self.selectStyleBlock) {
            self.selectStyleBlock(self.view);
        }
    }else {
        if (self.active) {
            if (self.activeStyleBlock) {
                self.activeStyleBlock(self.view);
            }
        }else {
            if (self.inactiveStyleBlock) {
                self.inactiveStyleBlock(self.view);
            }
        }
    }
}
- (void)setActive:(BOOL)active {
    _active = active;
    if (active) {
        if (self.activeStyleBlock) {
            self.activeStyleBlock(self.view);
        }
    }else {
        if (self.inactiveStyleBlock) {
            self.inactiveStyleBlock(self.view);
        }
    }
}
- (void)setGradColors:(NSArray *)gradColors {
    
    if (!gradColors || gradColors.count == 0) {
        [_gradLayer removeFromSuperlayer];
        return;
    }
    if([gradColors isEqualToArray:_gradColors]) return;
    
    _gradColors = gradColors;
    NSMutableArray *cgColors = NSMutableArray.array;
    for (id color in gradColors) {
        UIColor *c = ZLColorFromObj(color);
        if (c) [cgColors addObject:(id)c.CGColor];
    }
    self.gradLayer.colors = cgColors;
    self.needsUpdate = YES;
    [self.view setNeedsLayout];
}
- (void)setGradStartPoint:(CGPoint)gradStartPoint {
    if (CGPointEqualToPoint(gradStartPoint, _gradStartPoint)) {
        return;
    }
    _gradStartPoint = gradStartPoint;
    self.gradLayer.startPoint = gradStartPoint;
    self.needsUpdate = YES;
    [self.view setNeedsLayout];
}
- (void)setGradEndPoint:(CGPoint)gradEndPoint {
    if (CGPointEqualToPoint(gradEndPoint, _gradEndPoint)) {
        return;
    }
    _gradEndPoint = gradEndPoint;
    self.gradLayer.endPoint = gradEndPoint;
    self.needsUpdate = YES;
    [self.view setNeedsLayout];
}
// MARK: - view 绑定

- (void)setView:(UIView *)view {
    // 旧 view 清理
    if (_view) {
        [_backgroundShapeLayer removeFromSuperlayer];
        _view.layer.masksToBounds = NO;
        _view.layer.shadowOpacity = 0;
        _view.layer.shadowPath    = nil;
    }
    _view = view;

    if (!view) return;

    // 新 view 初始化
    view.layer.masksToBounds = NO; // 必须 NO，否则阴影被裁
    [self update]; // 立即应用当前属性
}
- (BOOL)needsUpdate {
    if (!CGRectEqualToRect(self.view.frame, self.backgroundShapeLayer.frame)) {
        return YES;
    }
    return _needsUpdate;
}
- (void)setCircle:(NSNumber *)circle {
    if ([circle isEqual:_circle]) return;
    _circle = circle;
    self.needsUpdate = YES;
    [self.view setNeedsLayout];
    
}
// MARK: - 手动触发更新（view 的 layoutSubviews 里调用，或属性变化后调用）

- (void)update {
    UIView *view = _view;
    if (!view) return;

    CGRect bounds = view.bounds;
    if (CGRectIsEmpty(bounds)) return;
    
    if (!self.needsUpdate) return;
    
    self.needsUpdate = NO;
    
    
    
    CGFloat tl = _topLeftRadius      >= 0 ? _topLeftRadius      : _cornerRadius;
    CGFloat tr = _topRightRadius     >= 0 ? _topRightRadius     : _cornerRadius;
    CGFloat bl = _bottomLeftRadius   >= 0 ? _bottomLeftRadius   : _cornerRadius;
    CGFloat br = _bottomRightRadius  >= 0 ? _bottomRightRadius  : _cornerRadius;

    if (self.circle){
        if (self.circle.boolValue) {
            tl = tr = bl = br = MIN(bounds.size.width, bounds.size.height) / 2;
        }else {
            tl = tr = bl = br = 0;
        }
    }
    
    UIBezierPath *path = [self _bezierPathWithRect:bounds tl:tl tr:tr bl:bl br:br];

    // 1. 圆角背景色（sublayer 绘制，不影响 shadow）
    _backgroundShapeLayer.frame     = bounds;
    _backgroundShapeLayer.path      = path.CGPath;
    // 同步背景色：若 view.backgroundColor 有值，迁移到 fillColor
    UIColor *bgColor = view.backgroundColor;

    if (bgColor && ![bgColor isEqual:UIColor.clearColor]) {
        _backgroundShapeLayer.fillColor = bgColor.CGColor;
        [self setViewBgColor:UIColor.clearColor];
    }else {
        _backgroundShapeLayer.fillColor = UIColor.whiteColor.CGColor;
    }
    
    if (_gradLayer) {
        _gradLayer.frame = self.view.bounds;
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = _gradLayer.bounds;
        maskLayer.path = path.CGPath;
         _gradLayer.mask = maskLayer;
        [self.view.layer insertSublayer:_gradLayer atIndex:0];
    }
    
    // 2. 阴影（shadowPath 贴合圆角路径，无需 masksToBounds）
    if (_shadowColor) {
        view.layer.shadowColor   = _shadowColor.CGColor;
        view.layer.shadowOpacity = _shadowOpacity;
        view.layer.shadowRadius  = _shadowRadius;
        view.layer.shadowOffset  = _shadowOffset;
        view.layer.shadowPath    = path.CGPath;
    }
    [view.layer insertSublayer:_backgroundShapeLayer atIndex:0];
}
- (void)setViewBgColor:(UIColor *)color {
    if (!_view) return;
    self.viewBgColorByDecorator = YES;
    _view.backgroundColor = color;
    self.viewBgColorByDecorator = NO;
}
// MARK: - 背景色便捷方法

- (void)setFillColor:(UIColor *)color {
    _fillColor = color;
    _backgroundShapeLayer.fillColor = color.CGColor;
    [self setViewBgColor:UIColor.clearColor];
}



// MARK: - 贝塞尔路径

- (UIBezierPath *)_bezierPathWithRect:(CGRect)rect
                                   tl:(CGFloat)tl tr:(CGFloat)tr
                                   bl:(CGFloat)bl br:(CGFloat)br {
    CGFloat minX = CGRectGetMinX(rect), minY = CGRectGetMinY(rect);
    CGFloat maxX = CGRectGetMaxX(rect), maxY = CGRectGetMaxY(rect);

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(minX + tl, minY)];

    [path addLineToPoint:CGPointMake(maxX - tr, minY)];
    [path addArcWithCenter:CGPointMake(maxX - tr, minY + tr) radius:tr startAngle:-M_PI_2 endAngle:0 clockwise:YES];

    [path addLineToPoint:CGPointMake(maxX, maxY - br)];
    [path addArcWithCenter:CGPointMake(maxX - br, maxY - br) radius:br startAngle:0 endAngle:M_PI_2 clockwise:YES];

    [path addLineToPoint:CGPointMake(minX + bl, maxY)];
    [path addArcWithCenter:CGPointMake(minX + bl, maxY - bl) radius:bl startAngle:M_PI_2 endAngle:M_PI clockwise:YES];

    [path addLineToPoint:CGPointMake(minX, minY + tl)];
    [path addArcWithCenter:CGPointMake(minX + tl, minY + tl) radius:tl startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];

    [path closePath];
    return path;
}

// MARK: - Setters

- (void)setCornerRadius:(CGFloat)v      {
    if (_cornerRadius == v) return;
    _cornerRadius = v;
    self.needsUpdate = YES;
    [self.view setNeedsLayout];
}
- (void)setTopLeftRadius:(CGFloat)v     {
    if (_topLeftRadius == v) return;
    _topLeftRadius = v;
    self.needsUpdate = YES;
    [self.view setNeedsLayout];
}
- (void)setTopRightRadius:(CGFloat)v    {
    if (_topRightRadius == v) return;
    _topRightRadius = v;
    self.needsUpdate = YES;
    [self.view setNeedsLayout];
}
- (void)setBottomLeftRadius:(CGFloat)v  {
    if (_bottomLeftRadius == v) return;
    _bottomLeftRadius = v;
    self.needsUpdate = YES;
    [self.view setNeedsLayout];
}
- (void)setBottomRightRadius:(CGFloat)v {
    if (_bottomRightRadius == v) return;
    _bottomRightRadius = v;
    self.needsUpdate = YES;
    [self.view setNeedsLayout];
}
- (void)setShadowColor:(UIColor *)v     {
    if ([_shadowColor isEqual:v]) return;
    _shadowColor = v;
    self.needsUpdate = YES;
    [self.view setNeedsLayout];
}
- (void)setShadowOpacity:(CGFloat)v     {
    if (_shadowOpacity == v) return;
    _shadowOpacity = v;
    self.needsUpdate = YES;
    [self.view setNeedsLayout];
}
- (void)setShadowRadius:(CGFloat)v      {
    if (_shadowRadius == v) return;
    _shadowRadius = v;
    self.needsUpdate = YES;
    [self.view setNeedsLayout];
}
- (void)setShadowOffset:(CGSize)v       {
    if (CGSizeEqualToSize(_shadowOffset, v)) return;
    _shadowOffset = v;
    self.needsUpdate = YES;
    [self.view setNeedsLayout];
}

// MARK: - 链式 API

- (ZLViewDecorator *(^)(CGFloat))corner {
    return ^(CGFloat r) { self.cornerRadius = r; return self; };
}
- (ZLViewDecorator *(^)(CGFloat, CGFloat, CGFloat, CGFloat))corners {
    return ^(CGFloat tl, CGFloat tr, CGFloat bl, CGFloat br) {
        self.topLeftRadius = tl; self.topRightRadius = tr;
        self.bottomLeftRadius = bl; self.bottomRightRadius = br;
        return self;
    };
}
- (ZLViewDecorator *(^)(UIColor *, CGFloat, CGFloat, CGSize))shadow {
    return ^(UIColor *color, CGFloat opacity, CGFloat radius, CGSize offset) {
        self.shadowColor = color; self.shadowOpacity = opacity;
        self.shadowRadius = radius; self.shadowOffset = offset;
        return self;
    };
}
@end
