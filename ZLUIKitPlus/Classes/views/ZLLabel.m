#import "ZLLabel.h"
#import "objc/runtime.h"
#import "ZLButton.h"
#import "ZLImageView.h"
#import "ZLUI.h"

@interface ZLLabel ()
@property (nonatomic,copy)NSString *_txt;
@property (nonatomic,copy)UIColor *_txtColor;
@property (nonatomic,copy)NSString *_hilightedTxt;
@property (nonatomic,assign)UIEdgeInsets cornerRadiiValue;
@property (nonatomic,copy)NSNumber* isCircle;
@end
@implementation ZLLabel
- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    _insetTop = edgeInsets.top;
    _insetLeading = edgeInsets.left;
    _insetBottom = edgeInsets.bottom;
    _insetTrailing = edgeInsets.right;
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
}
- (ZLLabel *(^)(CGFloat, CGFloat))hInset {
    return ^(CGFloat leading, CGFloat trailing) {
        self.edgeInsets = UIEdgeInsetsMake(self.insetTop, leading, self.insetBottom, trailing);
        return self;
    };
}
- (ZLLabel *(^)(CGFloat, CGFloat))vInset {
    return ^(CGFloat top, CGFloat bottom) {
        self.edgeInsets = UIEdgeInsetsMake(top, self.insetLeading, bottom, self.insetTrailing);
        return self;
    };
}
- (UIEdgeInsets)edgeInsets {
    return UIEdgeInsetsMake(_insetTop, _insetLeading, _insetBottom, _insetTrailing);
}
- (ZLLabel *(^)(CGFloat, CGFloat, CGFloat, CGFloat))insets {
    return ^(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing) {
        self.edgeInsets = UIEdgeInsetsMake(top, leading, bottom, trailing);
        return self;
    };
}
- (void)setInsetTop:(CGFloat)insetTop {
    _insetTop = insetTop;
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
}
- (void)setInsetLeading:(CGFloat)insetLeading {
    _insetLeading = insetLeading;
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
}

- (void)setInsetBottom:(CGFloat)insetBottom {
    _insetBottom = insetBottom;
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
}

- (void)setInsetTrailing:(CGFloat)insetTrailing {
    _insetTrailing = insetTrailing;
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
}

- (UIEdgeInsets)effectiveInsets {
    BOOL isRTL = (self.effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft);
    CGFloat left  = isRTL ? _insetTrailing : _insetLeading;
    CGFloat right = isRTL ? _insetLeading  : _insetTrailing;
    return UIEdgeInsetsMake(_insetTop, left, _insetBottom, right);
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, [self effectiveInsets])];
}
- (void)setText:(NSString *)text {
    [super setText:text];
}
- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    size.width += _insetLeading + _insetTrailing;
    size.height += _insetTop + _insetBottom;
    return size;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize fitSize = [super sizeThatFits:CGSizeMake(size.width - _insetLeading - _insetTrailing, size.height - _insetTop - _insetBottom)];
    fitSize.width += _insetLeading + _insetTrailing;
    fitSize.height += _insetTop + _insetBottom;
    return fitSize;
}
- (ZLLabel * _Nonnull (^)(NSString * _Nonnull))txt {
    return ^(NSString *txt) {
        self._txt = txt;
        self.text = txt;
        return self;
    };
}

- (ZLLabel * _Nonnull (^)(CGFloat))systemFont {
    return ^(CGFloat fontSize) {
        self.font = [UIFont systemFontOfSize:fontSize];
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat, id _Nonnull))systemFontColor {
    return ^(CGFloat fontSize, id color) {
        return self.systemFont(fontSize).color(color);
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat))mediumFont {
    return ^(CGFloat fontSize) {
        self.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightMedium];
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat, id _Nonnull))mediumFontColor {
    return ^(CGFloat fontSize, id color) {
        return self.mediumFont(fontSize).color(color);
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat))semiboldFont {
    return ^(CGFloat fontSize) {
        self.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightSemibold];
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat))boldFont {
    return ^(CGFloat fontSize) {
        self.font = [UIFont boldSystemFontOfSize:fontSize];
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(id _Nonnull))color {
    return ^(id color) {
        self._txtColor =  self.textColor;
        self.textColor = ZLColorFromObj(color);
        return self;
    };
}

- (ZLLabel * _Nonnull (^)(NSString * _Nonnull))hlTxt {
    return ^(NSString *hilightedTxt) {
        self._hilightedTxt = hilightedTxt;
        return self;
    };
}

- (ZLLabel * _Nonnull (^)(id _Nonnull))hlColor {
    return ^(id color) {
        self.highlightedTextColor = ZLColorFromObj(color);
        return self;
    };
}

- (ZLLabel * _Nonnull (^)(BOOL))highlight {
    return ^(BOOL highlight) {
        self.highlighted = highlight;
        return self;
    };
}

- (ZLLabel * _Nonnull (^)(CGFloat))txtMaxWidth {
    return ^(CGFloat maxWidth) {
        self.preferredMaxLayoutWidth = maxWidth;
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(NSInteger))lines {
    return ^(NSInteger lines) {
        self.numberOfLines = lines;
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(id _Nonnull))bgColor {
    return ^(id color) {
        self.backgroundColor = ZLColorFromObj(color);
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(BOOL))visibility {
    return ^(BOOL visibility) {
        self.hidden = !visibility;
        return self;
    };
}

- (void)set_select:(BOOL)_select {
    _select = _select;
}
- (ZLLabel * _Nonnull (^)(CGFloat))alphaValue {
    return ^(CGFloat alpha) {
        self.alpha = alpha;
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(BOOL))userInteraction {
    return ^(BOOL userInteraction) {
        self.userInteractionEnabled = userInteraction;
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat))corner {
    return ^(CGFloat corner) {
        self.layer.cornerRadius = corner;
        self.layer.masksToBounds = corner > 0;
        return self;
    };
}
- (BOOL)_zl_isRTL {
    if (@available(iOS 10.0, *)) {
        return self.effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
    }
    return [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
}
- (ZLLabel * _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))cornerRadii {
    return ^ZLLabel*(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight){
        self.cornerRadiiValue = UIEdgeInsetsMake(topLeft, topRight, bottomLeft, bottomRight);
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(NSAttributedString * _Nonnull))attributeTxt {
    return ^(NSAttributedString *attributeTxt) {
        self.attributedText = attributeTxt;
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(NSAttributedString * _Nonnull (^ _Nonnull)(ZLLabel * _Nonnull)))attributeTxtBK {
    return ^(NSAttributedString * _Nonnull (^attributeTxtBK)(ZLLabel * _Nonnull)) {
        if (attributeTxtBK) {
            self.attributedText = attributeTxtBK(self);
        }
        return self;
    };
}
- (void)drawCornerRadii {
    if (UIEdgeInsetsEqualToEdgeInsets(self.cornerRadiiValue, UIEdgeInsetsZero)) {
        return;
    }
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
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGSize size = self.bounds.size;
    [path moveToPoint:CGPointMake(0, topLeft)];
    [path addQuadCurveToPoint:CGPointMake(topLeft, 0) controlPoint :CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(size.width - topRight, 0)];
    [path addQuadCurveToPoint:CGPointMake(size.width, topRight) controlPoint:CGPointMake(size.width, 0)];
    [path addLineToPoint:CGPointMake(size.width, size.height - bottomRight)];
    [path addQuadCurveToPoint:CGPointMake(size.width - bottomRight, size.height) controlPoint:CGPointMake(size.width, size.height)];
    [path addLineToPoint:CGPointMake(bottomLeft, size.height)];
    [path addQuadCurveToPoint:CGPointMake(0, size.height - bottomLeft) controlPoint:CGPointMake(0, size.height)];
    [path closePath];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}
- (ZLLabel * _Nonnull (^)(BOOL))circle {
    return ^(BOOL circle) {
        self.isCircle = @(YES);
        [self updateCircel];
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(NSTextAlignment))textAlign {
    return ^(NSTextAlignment textAlign) {
        self.textAlignment = textAlign;
        return self;
    };
}
- (instancetype)textAlignLeft {
    self.textAlignment = NSTextAlignmentLeft;
    return self;
}
- (instancetype)textAlignCenter {
    self.textAlignment = NSTextAlignmentCenter;
    return self;
}
- (instancetype)textAlignRight {
    self.textAlignment = NSTextAlignmentRight;
    return self;
}
- (void)updateCircel {
    if (self.isCircle) {
        if (self.isCircle.boolValue) {
            CGFloat minSide = MIN(self.bounds.size.width, self.bounds.size.height);
            self.layer.cornerRadius = minSide / 2;
            self.layer.masksToBounds = YES;
        }else {
            self.layer.cornerRadius = 0;
            self.layer.masksToBounds = NO;
        }
    }
}

- (ZLLabel* (^)(id ))borderColor {
    return  ^ZLLabel*(id color){
        self.layer.borderColor = ZLColorFromObj(color).CGColor;
        return self;
    };
}
- (ZLLabel* (^)(CGFloat ))borderWidth {
    return  ^ZLLabel*(CGFloat width){
        self.layer.borderWidth = width;
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat,id _Nonnull))border {
    return ^ZLLabel* (CGFloat width,id color) {
        self.layer.borderColor = ZLColorFromObj(color).CGColor;
        self.layer.borderWidth = width;
        return self;
    };
}

- (ZLLabel*  _Nonnull (^)(id _Nonnull))shColor {
    return ^ZLLabel* (id color) {
        self.layer.shadowColor = ZLColorFromObj(color).CGColor;
        return self.shOffset(0,2);
    };
}


- (ZLLabel*  _Nonnull (^)(CGFloat, CGFloat))shOffset {
    return ^ZLLabel* (CGFloat width, CGFloat height) {
        self.layer.shadowOffset = CGSizeMake(width, height);
        return self.shRadius(6);
    };
}


- (ZLLabel*  _Nonnull (^)(CGFloat))shRadius {
    return ^ZLLabel* (CGFloat radius) {
        self.layer.shadowRadius = radius;
        return self.shOpacity(0.2);
    };
}

- (ZLLabel*  _Nonnull (^)(CGFloat))shOpacity {
    return ^ZLLabel* (CGFloat opacity) {
        self.layer.shadowOpacity = opacity;
        return self.masksToBounds(NO);
    };
}
- (ZLLabel*  _Nonnull (^)(BOOL))masksToBounds {
    return ^ZLLabel* (BOOL masks) {
        self.layer.masksToBounds = masks;
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(void (^ _Nonnull)(ZLLabel * _Nonnull)))tapAction {
    return ^id(void (^action)(ZLLabel *label)) {
        return self.KFC.tapAction(action).view;
    };
}

- (ZLLabel * _Nonnull (^)(ZLLabel * _Nullable __autoreleasing * _Nullable))toPtr {
    return ^id(ZLLabel **ptr) {
        if (ptr) *ptr = self;
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(void (^ _Nonnull)(ZLLabel * _Nonnull)))then {
    return ^id(void (^action)(ZLLabel *label)) {
        if (action) action(self);
        return self;
    };
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self drawCornerRadii];
    [self updateCircel];
}



- (ZLLabel * _Nonnull (^)(CGFloat))z_centerX {
    return ^(CGFloat centerX) {
        self.KFC.centerX(centerX);
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat))z_centerY {
    return ^(CGFloat centerY) {
        self.KFC.centerY(centerY);
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(void))z_center {
    return ^() {
        self.KFC.center();
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat, CGFloat))z_centerOffset {
    return ^(CGFloat offsetX, CGFloat offsetY) {
        self.KFC.centerOffset(offsetX, offsetY);
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat))z_top {
    return ^(CGFloat top) {
        self.KFC.top(top);
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat))z_leading {
    return ^(CGFloat leading) {
        self.KFC.leading(leading);
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat))z_bottom {
    return ^(CGFloat bottom) {
        self.KFC.bottom(bottom);
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat))z_trailing {
    return ^(CGFloat trailing) {
        self.KFC.trailing(trailing);
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat))z_height {
    return ^(CGFloat height) {
        self.KFC.height(height);
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat))z_width {
    return ^(CGFloat width) {
        self.KFC.width(width);
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat, CGFloat))z_size {
    return ^(CGFloat width, CGFloat height) {
        self.KFC.size(width, height);
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat))z_square {
    return ^(CGFloat side) {
        self.KFC.square(side);
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))z_edge {
    return ^(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing) {
        self.KFC.edge(top, leading, bottom, trailing);
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(void))z_edgesZero {
    return ^() {
        self.KFC.edgesZero();
        return self;
    };
}
- (ZLLabel* _Nonnull (^)(UIView * _Nonnull))addTo {
    return ^(UIView *superview){
        if ([superview isKindOfClass:UIView.class]) {
            [superview addSubview:self];
        }
        return self;
    };
}

- (ZLLabel* _Nonnull (^)(UIView * _Nonnull))addToFull {
    return ^(UIView *superview){
        if ([superview isKindOfClass:UIView.class]) {
            [superview addSubview:self];
            self.KFC.edgesZero();
        }
        return self;
    };
}

@end





@implementation UIView (ZLView)
- (ZLLabel *)zl_lab {
    ZLLabel *label = objc_getAssociatedObject(self, _cmd);
    if (!label) {
        label = ZLLabel.new;
        [self addSubview:label];
        objc_setAssociatedObject(self, _cmd, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return label;
}
- (ZLImageView *)zl_imgView {
    ZLImageView *imgView = objc_getAssociatedObject(self, _cmd);
    if (!imgView) {
        imgView = ZLImageView.new;
        [self addSubview:imgView];
        objc_setAssociatedObject(self, _cmd, imgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return imgView;
}
- (ZLButton *)zl_btn {
    ZLButton *button = objc_getAssociatedObject(self, _cmd);
    if (!button) {
        button = ZLButton.horizontal;
        [self addSubview:button];
        objc_setAssociatedObject(self, _cmd, button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return button;
}
- (ZLLabel *)zl_altLab {
    ZLLabel *label = objc_getAssociatedObject(self, _cmd);
    if (!label) {
        label = ZLLabel.new;
        [self addSubview:label];
        objc_setAssociatedObject(self, _cmd, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return label;
}
- (ZLImageView *)zl_altImgView {
    ZLImageView *imgView = objc_getAssociatedObject(self, _cmd);
    if (!imgView) {
        imgView = ZLImageView.new;
        [self addSubview:imgView];
        objc_setAssociatedObject(self, _cmd, imgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return imgView;
}
- (ZLButton *)zl_altBtn {
    ZLButton *button = objc_getAssociatedObject(self, _cmd);
    if (!button) {
        button = ZLButton.horizontal;
        [self addSubview:button];
        objc_setAssociatedObject(self, _cmd, button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return button;
}

- (ZLLabel *)zl_extraLab {
    ZLLabel *label = objc_getAssociatedObject(self, _cmd);
    if (!label) {
        label = ZLLabel.new;
        [self addSubview:label];
        objc_setAssociatedObject(self, _cmd, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return label;
}
- (ZLImageView *)zl_extraImgView {
    ZLImageView *imgView = objc_getAssociatedObject(self, _cmd);
    if (!imgView) {
        imgView = ZLImageView.new;
        [self addSubview:imgView];
        objc_setAssociatedObject(self, _cmd, imgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return imgView;
}
- (ZLButton *)zl_extraBtn {
    ZLButton *button = objc_getAssociatedObject(self, _cmd);
    if (!button) {
        button = ZLButton.horizontal;
        [self addSubview:button];
        objc_setAssociatedObject(self, _cmd, button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return button;
}

@end
