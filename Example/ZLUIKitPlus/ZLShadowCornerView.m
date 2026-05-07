#import "ZLShadowCornerView.h"

@interface ZLShadowCornerView ()
/// 背景填充层，作为 view.layer 的 sublayer[0]，负责圆角背景色
@property (nonatomic, strong) CAShapeLayer *backgroundShapeLayer;
@end

@implementation ZLShadowCornerView

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
    _shadowColor   = UIColor.blackColor;
    _shadowOpacity = 0.3;
    _shadowRadius  = 4;
    _shadowOffset  = CGSizeMake(0, 2);

    _backgroundShapeLayer = [CAShapeLayer layer];
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
    [view.layer insertSublayer:_backgroundShapeLayer atIndex:0];
    [self update]; // 立即应用当前属性
}

// MARK: - 手动触发更新（view 的 layoutSubviews 里调用，或属性变化后调用）

- (void)update {
    UIView *view = _view;
    if (!view) return;

    CGRect bounds = view.bounds;
    if (CGRectIsEmpty(bounds)) return;

    CGFloat tl = _topLeftRadius      >= 0 ? _topLeftRadius      : _cornerRadius;
    CGFloat tr = _topRightRadius     >= 0 ? _topRightRadius     : _cornerRadius;
    CGFloat bl = _bottomLeftRadius   >= 0 ? _bottomLeftRadius   : _cornerRadius;
    CGFloat br = _bottomRightRadius  >= 0 ? _bottomRightRadius  : _cornerRadius;

    UIBezierPath *path = [self _bezierPathWithRect:bounds tl:tl tr:tr bl:bl br:br];

    // 1. 圆角背景色（sublayer 绘制，不影响 shadow）
    _backgroundShapeLayer.frame     = bounds;
    _backgroundShapeLayer.path      = path.CGPath;
    // 同步背景色：若 view.backgroundColor 有值，迁移到 fillColor
    UIColor *bgColor = view.backgroundColor;
    if (bgColor && ![bgColor isEqual:UIColor.clearColor]) {
        _backgroundShapeLayer.fillColor = bgColor.CGColor;
        view.backgroundColor = UIColor.clearColor;
    }

    // 2. 阴影（shadowPath 贴合圆角路径，无需 masksToBounds）
    view.layer.shadowColor   = _shadowColor.CGColor;
    view.layer.shadowOpacity = _shadowOpacity;
    view.layer.shadowRadius  = _shadowRadius;
    view.layer.shadowOffset  = _shadowOffset;
    view.layer.shadowPath    = path.CGPath;
}

// MARK: - 背景色便捷方法

- (void)setFillColor:(UIColor *)color {
    _backgroundShapeLayer.fillColor = color.CGColor;
    if (_view) _view.backgroundColor = UIColor.clearColor;
}

- (UIColor *)fillColor {
    return [UIColor colorWithCGColor:_backgroundShapeLayer.fillColor];
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

- (void)setCornerRadius:(CGFloat)v      { _cornerRadius = v;      [self update]; }
- (void)setTopLeftRadius:(CGFloat)v     { _topLeftRadius = v;     [self update]; }
- (void)setTopRightRadius:(CGFloat)v    { _topRightRadius = v;    [self update]; }
- (void)setBottomLeftRadius:(CGFloat)v  { _bottomLeftRadius = v;  [self update]; }
- (void)setBottomRightRadius:(CGFloat)v { _bottomRightRadius = v; [self update]; }
- (void)setShadowColor:(UIColor *)v     { _shadowColor = v;       [self update]; }
- (void)setShadowOpacity:(CGFloat)v     { _shadowOpacity = v;     [self update]; }
- (void)setShadowRadius:(CGFloat)v      { _shadowRadius = v;      [self update]; }
- (void)setShadowOffset:(CGSize)v       { _shadowOffset = v;      [self update]; }

// MARK: - 链式 API

- (ZLShadowCornerView *(^)(CGFloat))corner {
    return ^(CGFloat r) { self.cornerRadius = r; return self; };
}

- (ZLShadowCornerView *(^)(CGFloat, CGFloat, CGFloat, CGFloat))corners {
    return ^(CGFloat tl, CGFloat tr, CGFloat bl, CGFloat br) {
        self.topLeftRadius = tl; self.topRightRadius = tr;
        self.bottomLeftRadius = bl; self.bottomRightRadius = br;
        return self;
    };
}

- (ZLShadowCornerView *(^)(UIColor *, CGFloat, CGFloat, CGSize))shadow {
    return ^(UIColor *color, CGFloat opacity, CGFloat radius, CGSize offset) {
        self.shadowColor = color; self.shadowOpacity = opacity;
        self.shadowRadius = radius; self.shadowOffset = offset;
        return self;
    };
}

@end
