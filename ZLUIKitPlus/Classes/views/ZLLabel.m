#import "ZLLabel.h"
#import "ZLLayout.h"
@interface ZLLabel ()
@property (nonatomic,copy)void (^activeStyleBlock)(id );
@property (nonatomic,copy)void (^inactiveStyleBlock)(id );
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
- (ZLLabel * _Nonnull (^)(NSString * _Nonnull, CGFloat, id _Nonnull))systemTextFontColor {
    return ^(NSString *txt, CGFloat fontSize, id color) {
        return self.txt(txt).systemFont(fontSize).color(color);
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
- (ZLLabel * _Nonnull (^)(NSString * _Nonnull, CGFloat, id _Nonnull))mediumTextFontColor {
    return ^(NSString *txt, CGFloat fontSize, id color) {
        return self.txt(txt).mediumFont(fontSize).color(color);
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
        self.textColor = ZLColorFromObj(color);
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
- (ZLLabel * _Nonnull (^)(CGFloat))alphaValue {
    return ^(CGFloat alpha) {
        self.alpha = alpha;
        return self;
    };
}

- (ZLLabel * _Nonnull (^)(BOOL))userActive {
    return ^(BOOL enabled) {
        self.userInteractionEnabled = enabled;
        if (enabled) {
            if (self.activeStyleBlock) self.activeStyleBlock(self);
        }else {
            if (self.inactiveStyleBlock) self.inactiveStyleBlock(self);
        }
        return self;
    };
}
- (ZLLabel* (^)(void (^ _Nonnull)(ZLLabel * _Nonnull)))activeStyle {
    return ^(void (^block)(ZLLabel *)) {
        self.activeStyleBlock = block;
        if (self.userInteractionEnabled) if (block) block(self);
        return self;
    };
}

- (ZLLabel* (^)(void (^ _Nonnull)(ZLLabel * _Nonnull)))inactiveStyle {
    return ^(void (^block)(ZLLabel *)) {
        self.inactiveStyleBlock = block;
        if (!self.userInteractionEnabled) if (block) block(self);
        return self;
    };
}

- (BOOL)_zl_isRTL {
    if (@available(iOS 10.0, *)) {
        return self.effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
    }
    return [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
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
        return self.borderColor(color).borderWidth(width);
    };
}


- (ZLLabel * _Nonnull (^)(CGFloat))corner {
    return ^ZLLabel*(CGFloat radius){
        self.layer.cornerRadius = radius;
        self.layer.masksToBounds = YES;
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(CACornerMask))corners {
    return ^(CACornerMask corners) {
        self.layer.maskedCorners = (CACornerMask)corners;
        return self;
    };
}

- (ZLLabel * _Nonnull (^)(BOOL))masksToBounds {
    return ^ZLLabel* (BOOL masks) {
        self.layer.masksToBounds = masks;
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(void (^ _Nonnull)(ZLLabel * _Nonnull)))tapAction {
    return ^id(void (^action)(ZLLabel *label)) {
        return self.zl_layout.tapAction(action).view;
    };
}

- (ZLLabel * _Nonnull (^)(ZLLabel * _Nullable __autoreleasing * _Nullable))assignToPtr {
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
- (ZLLabel * _Nonnull (^)(CGFloat))height {
    return ^(CGFloat height) {
        self.zl_layout.height(height);
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat))width {
    return ^(CGFloat width) {
        self.zl_layout.width(width);
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat, CGFloat))size {
    return ^(CGFloat width, CGFloat height) {
        self.zl_layout.size(width, height);
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat))square {
    return ^(CGFloat side) {
        self.zl_layout.square(side);
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))edge {
    return ^(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing) {
        self.zl_layout.edge(top, leading, bottom, trailing);
        return self;
    };
}
- (ZLLabel * _Nonnull (^)(void))edgesZero {
    return ^() {
        self.zl_layout.edgesZero();
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
            self.zl_layout.edgesZero();
        }
        return self;
    };
}

@end






