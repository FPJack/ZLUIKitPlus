//
//  ZLView.m
//  ZLUIKitPlus
//
//  Created by admin on 2026/5/11.
//

#import "ZLView.h"
#import "ZLUI.h"
#import <objc/runtime.h>
@interface ZLView()
@property (nonatomic, strong) CAShapeLayer *backgroundShapeLayer;
@property (nonatomic,strong)  CAGradientLayer *gradLayer;
///是否需要重绘
@property (nonatomic, assign) BOOL needsUpdate;
@property (nonatomic, assign)UIEdgeInsets cornerRadiiValue;
@property (nonatomic, assign) CGFloat radiusValue;
@property (nonatomic, copy) NSNumber* circleTag;
@property (nonatomic, copy) UIColor* bgColorValue;
@property (nonatomic,copy)void (^activeStyleBlock)(id );
@property (nonatomic,copy)void (^inactiveStyleBlock)(id );
@property (nonatomic,copy)void (^selectStyleBlock)(id );
@end
@implementation ZLView
- (CAShapeLayer *)backgroundShapeLayer {
    if (!_backgroundShapeLayer) {
        _backgroundShapeLayer = [CAShapeLayer layer];
    }
    return _backgroundShapeLayer;
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

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.bgColorValue = backgroundColor;
    self.backgroundShapeLayer.fillColor = backgroundColor.CGColor;
}
- (UIColor *)backgroundColor {
    return self.bgColorValue ?: [super backgroundColor];
}
- (BOOL)needsUpdate {
    if (!CGRectEqualToRect(self.bounds, self.backgroundShapeLayer.bounds)) {
        return YES;
    }
    return _needsUpdate;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self update];
}
- (void)update {
    CGRect bounds = self.bounds;
    if (CGRectIsEmpty(bounds)) return;
    if (!self.needsUpdate) return;
    self.needsUpdate = NO;
    CGFloat topLeft, topRight, bottomLeft, bottomRight;
    if ([self _zl_isRTL]) {
        topLeft = self.cornerRadiiValue.left;      // original topRight
        topRight = self.cornerRadiiValue.top;       // original topLeft
        bottomLeft = self.cornerRadiiValue.right;   // original bottomRight
        bottomRight = self.cornerRadiiValue.bottom;  // original bottomLeft
    } else {
        topLeft = self.cornerRadiiValue.top;
        topRight = self.cornerRadiiValue.left;
        bottomLeft = self.cornerRadiiValue.bottom;
        bottomRight = self.cornerRadiiValue.right;
    }
    
    CGFloat tl = topLeft  >= 0 ? topLeft : _radiusValue;
    CGFloat tr = topRight >= 0 ? topRight     : _radiusValue;
    CGFloat bl = bottomLeft   >= 0 ? bottomLeft   : _radiusValue;
    CGFloat br = bottomRight  >= 0 ? bottomRight  : _radiusValue;

    if (self.circleTag){
        if (self.circleTag.boolValue) {
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
    UIColor *bgColor = self.bgColorValue;
    if (bgColor) {
        _backgroundShapeLayer.fillColor = bgColor.CGColor;
        [super setBackgroundColor:UIColor.clearColor];
    }else {
        _backgroundShapeLayer.fillColor = UIColor.whiteColor.CGColor;
    }
    
    if (_gradLayer) {
        _gradLayer.frame = self.bounds;
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = _gradLayer.bounds;
        maskLayer.path = path.CGPath;
         _gradLayer.mask = maskLayer;
        [self.layer insertSublayer:_gradLayer atIndex:0];
    }
    
    // 2. 阴影（shadowPath 贴合圆角路径，无需 masksToBounds）
    if (self.layer.shadowColor) {
        self.layer.shadowPath = path.CGPath;
    }
   
    [self.layer insertSublayer:_backgroundShapeLayer atIndex:0];
}
- (void)setNeedLayoutIfNeed {
    if (self.needsUpdate) return;
    self.needsUpdate = YES;
    [self setNeedsLayout];
}
- (ZLView * _Nonnull (^)(BOOL))userActive {
    return ^ZLView* (BOOL active) {
        self.userInteractionEnabled = active;
        if (active) {
            if (self.activeStyleBlock) self.activeStyleBlock(self);
        }else {
            if (self.inactiveStyleBlock) self.inactiveStyleBlock(self);
        }
        return self;
    };
}
- (ZLView * _Nonnull (^)(BOOL))visibility {
    return ^ZLView* (BOOL visible) {
        self.hidden = !visible;
        return self;
    };
}
- (ZLView * _Nonnull (^)(CGFloat))alphaValue {
    return ^ZLView* (CGFloat alpha) {
        self.alpha = alpha;
        return self;
    };
}
- (ZLView *_Nonnull (^)(ZLView * _Nullable __autoreleasing * _Nullable))assignToPtr {
    return ^(ZLView **ptr){
        if (ptr) *ptr = self;
        return self;
    };
}
- (ZLView *_Nonnull (^)(id _Nonnull))bgColor {
    return ^(id color) {
        self.backgroundColor = ZLColorFromObj(color);
        return self;
    };
}
- (ZLView * _Nonnull (^)(NSArray * _Nonnull))gradColors {
    return ^ZLView* (NSArray *colors) {
        NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:colors.count];
        for (id color in colors) {
            [cgColors addObject:(__bridge id)ZLColorFromObj(color).CGColor];
        }
        if (!(self -> _gradLayer)) {
            self.gradLayer.colors = cgColors;
            [self setNeedLayoutIfNeed];
            return self;
        }
        self.gradLayer.colors = cgColors;
        return self;
    };
}
- (ZLView * _Nonnull (^)(CGPoint, CGPoint))gradDirection {
    return ^ZLView* (CGPoint start, CGPoint end) {
        self.gradLayer.startPoint = start;
        self.gradLayer.endPoint = end;
        if (!(self -> _gradLayer)) {
            [self setNeedLayoutIfNeed];
        }
        return self;
    };
}
- (ZLView *_Nonnull (^)(CGFloat))corner {
    return ^ZLView*(CGFloat radius){
        if (radius == self.radiusValue) return self;
        self.radiusValue = radius;
        [self setNeedLayoutIfNeed];
        return self;
    };
}
- (ZLView *_Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))cornerRadii {
    return ^ZLView*(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight){
        UIEdgeInsets radii = UIEdgeInsetsMake(topLeft, topRight, bottomLeft, bottomRight);
        if (UIEdgeInsetsEqualToEdgeInsets(radii, self.cornerRadiiValue)) {
            return self;
        }
        self.cornerRadiiValue = UIEdgeInsetsMake(topLeft, topRight, bottomLeft, bottomRight);
        [self setNeedLayoutIfNeed];
        return self;
    };
}
- (BOOL)_zl_isRTL {
    if (@available(iOS 10.0, *)) {
        return self.effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
    }
    return [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
}

- (ZLView *_Nonnull (^)(BOOL))circle {
    return ^ZLView*(BOOL clip) {
        if (clip == self.circleTag.boolValue) return self;
        self.circleTag = @(clip);
        [self setNeedLayoutIfNeed];
        return self;
    };
}

- (ZLView *(^)(id ))borderColor {
    return  ^ZLView*(id color){
        self.backgroundShapeLayer.strokeColor = ZLColorFromObj(color).CGColor;
        return self;
    };
}
- (ZLView *(^)(CGFloat ))borderWidth {
    return  ^ZLView*(CGFloat width){
        self.backgroundShapeLayer.lineWidth = width;
        return self;
    };
}
- (ZLView *_Nonnull (^)(CGFloat, id _Nonnull))border {
    return ^ZLView*(CGFloat width, id color){
        self.borderWidth(width);
        self.borderColor(color);
        return self;
    };
}
- (ZLView * _Nonnull (^)(id _Nonnull))shColor {
    return ^ZLView* (id color) {
        self.layer.shadowColor = ZLColorFromObj(color).CGColor;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowRadius = 8;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.masksToBounds = NO;
        return self;
    };
}


- (ZLView * _Nonnull (^)(CGFloat, CGFloat))shOffset {
    return ^ZLView* (CGFloat width, CGFloat height) {
        self.layer.shadowOffset = CGSizeMake(width, height);
        return self;
    };
}


- (ZLView * _Nonnull (^)(CGFloat))shRadius {
    return ^ZLView* (CGFloat radius) {
        self.layer.shadowRadius = radius;
        return self;
    };
}

- (ZLView * _Nonnull (^)(CGFloat))shOpacity {
    return ^ZLView* (CGFloat opacity) {
        self.layer.shadowOpacity = opacity;
        return self;
    };
}
- (ZLView * _Nonnull (^)(BOOL))masksToBounds {
    return ^ZLView* (BOOL masks) {
        self.layer.masksToBounds = masks;
        return self;
    };
}
- (ZLView * _Nonnull (^)(CGFloat))centerX {
    return ^(CGFloat centerX){
         self.KFC.centerX(centerX);
        return self;
    };
}
- (ZLView * _Nonnull (^)(CGFloat))centerY {
    return ^(CGFloat centerY){
         self.KFC.centerY(centerY);
         return self;
    };
}

- (ZLView * _Nonnull (^)(CGFloat, CGFloat))centerOffset {
    return ^(CGFloat centerX, CGFloat centerY){
        return self.centerX(centerX).centerY(centerY);
    };
}
- (ZLView * _Nonnull (^)(CGFloat))top {
    return ^(CGFloat top){
        self.KFC.top(top);
        return self;
    };
}
- (ZLView * _Nonnull (^)(CGFloat))leading {
    return ^(CGFloat leading){
        self.KFC.leading(leading);
        return self;
    };
}
- (ZLView * _Nonnull (^)(CGFloat))bottom {
    return ^(CGFloat bottom){
        self.KFC.bottom(bottom);
        return self;
    };
}
- (ZLView * _Nonnull (^)(CGFloat))trailing {
    return ^(CGFloat trailling){
        self.KFC.trailing(trailling);
        return self;
    };
}
- (ZLView *_Nonnull (^)(CGFloat))height {
    return ^(CGFloat height) {
        self.KFC.height(height);
        return self;
    };
}
- (ZLView *_Nonnull (^)(CGFloat))width {
    return ^(CGFloat width) {
        self.KFC.width(width);
        return self;
    };
}
- (ZLView *_Nonnull (^)(CGFloat, CGFloat))size {
    return ^(CGFloat width, CGFloat height) {
        self.KFC.size(width, height);
        return self;
    };
}
- (ZLView *_Nonnull (^)(CGFloat))square {
    return ^(CGFloat side) {
        self.KFC.square(side);
        return self;
    };
}
- (ZLView *_Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))edge {
    return ^(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing) {
        self.KFC.edge(top, leading, bottom, trailing);
        return self;
    };
}
- (ZLView *_Nonnull (^)(void))edgesZero {
    return ^() {
        self.KFC.edgesZero();
        return self;
    };
}
- (ZLView *_Nonnull (^)(UIView * _Nonnull))addTo {
    return ^(UIView *superview){
        if ([superview isKindOfClass:UIView.class]) {
            [superview addSubview:self];
        }
        return self;
    };
}

- (ZLView *_Nonnull (^)(UIView * _Nonnull))addToFull {
    return ^(UIView *superview){
        if ([superview isKindOfClass:UIView.class]) {
            [superview addSubview:self];
            self.KFC.edgesZero();
        }
        return self;
    };
}
- (ZLView *_Nonnull (^)(UIView * _Nonnull))addSubview {
    return ^(UIView *subview){
        if ([subview isKindOfClass:UIView.class]) {
            [self addSubview:subview];
        }
        return self;
    };
}
- (ZLView * _Nonnull (^)(UIView * _Nonnull, void (^ _Nonnull)(ZLView * _Nonnull, __kindof UIView * _Nonnull)))addSubviewLayout {
    return ^(UIView *subview, void (^block)(ZLView *, UIView *)) {
        if ([subview isKindOfClass:UIView.class]) {
            [self addSubview:subview];
            if (block) block(self, subview);
        }
        return self;
    };
}
- (ZLView* (^)(void (^ _Nonnull)(ZLView * _Nonnull)))activeStyle {
    return ^(void (^block)(ZLView *)) {
        self.activeStyleBlock = block;
        if (self.userInteractionEnabled) if (block) block(self);
        return self;
    };
}
- (ZLView* (^)(void (^ _Nonnull)(ZLView * _Nonnull)))inactiveStyle {
    return ^(void (^block)(ZLView *)) {
        self.inactiveStyleBlock = block;
        if (!self.userInteractionEnabled) if (block) block(self);
        return self;
    };
}
- (ZLView * _Nonnull (^)(void (^ _Nonnull)(ZLView * _Nonnull)))then {
    return ^(void (^block)(ZLView *)) {
        if (block) block(self);
        return self;
    };
}
- (ZLView * _Nonnull (^)(void (^ _Nonnull)(ZLView * _Nonnull)))tapAction {
    return ^(void (^block)(ZLView *)) {
        self.KFC.tapAction(block);
        return self;
    };
}
@end
@interface ZLWrapperView()
@property (nonatomic, weak,readwrite) UIView *contentView;
@property (nonatomic, strong)NSArray *constraintsArr;
@end
@implementation ZLWrapperView
- (NSArray *)constraintsArr {
    if (!_constraintsArr) {
        _constraintsArr = NSArray.array;
    }
    return _constraintsArr;
}
+ (instancetype)wrapWithView:(UIView *)view {
    ZLWrapperView *wrap = [[ZLWrapperView alloc] initWithFrame:view.frame];
    wrap.contentView = view;
    [wrap addSubview:view];
    return wrap;
}
- (instancetype)insetsZero {
    return self.insets(0, 0, 0, 0);
}
- (ZLWrapperView * _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))insets {
    return ^(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing) {
        [NSLayoutConstraint deactivateConstraints:self.constraintsArr];
        self.constraintsArr = @[[self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor constant:top],
                                [self.contentView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:leading],
                                [self.contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-bottom],
                                [self.contentView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-trailing]];
        [NSLayoutConstraint activateConstraints:self.constraintsArr];
        return self;
    };
}
@end

