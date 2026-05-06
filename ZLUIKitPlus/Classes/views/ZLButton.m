//
//  ZLButton.m
//  ZLTagListView
//
//  Created by fanpeng on 2026/04/20.
//

#import "ZLButton.h"
#import "ZLUI.h"
#import <objc/runtime.h>
#define kInsetLeadingId @"kInsetLeadingId"
#define kInsetTrailingId @"kInsetTrailingId"
#define kInsetTopId @"kInsetTopId"
#define kInsetBottomId @"kInsetBottomId"
#define kSpacingId @"kSpacingId"


@interface ZLButton ()
@property (nonatomic,weak)UILabel *lab;
@property (nonatomic,weak)UIImageView *imgView;
@property (nonatomic,copy)NSNumber* isCircleClip;
@property (nonatomic,assign)UIEdgeInsets cornerRadiiValue;
@property (nonatomic,assign)BOOL imgTouchOnly;
@property (nonatomic,assign)UIEdgeInsets touchAreaEdgeInsets;
@property (nonatomic,assign)CGFloat tapInerval;
@property (nonatomic,copy)void (^activeStyleBlock)(ZLButton *);
@property (nonatomic,copy)void (^inactiveStyleBlock)(ZLButton *);
@property (nonatomic,strong)UILayoutGuide *middelGuide;
@property (nonatomic,strong)NSMutableArray *customContraints;
///图片和文字展示顺序的拼接字段
@property (nonatomic,copy)NSString *orderKey;
@end

@implementation ZLButton

- (UIEdgeInsets)_zl_effectiveInsets {
    UIEdgeInsets insets = _layoutEdgeInsets;
    if ([self _zl_isRTL]) {
        CGFloat tmp = insets.left;
        insets.left = insets.right;
        insets.right = tmp;
    }
    return insets;
}
- (NSMutableArray *)customContraints {
    if (!_customContraints) {
        _customContraints = NSMutableArray.array;
    }
    return _customContraints;
}
- (UILayoutGuide *)middelGuide {
    if (!_middelGuide) {
        _middelGuide = [[UILayoutGuide alloc] init];
        [self addLayoutGuide:_middelGuide];
    }
    return _middelGuide;
}
- (void)updateConstraints {
    [super updateConstraints];
    [self updateAllConstraints];
}

- (void)updateAllConstraints {
   ///刷选不是宽高的约束
    NSArray *filterConstraints = [self.constraints filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSLayoutConstraint * _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        BOOL res2 = [self.customContraints containsObject:evaluatedObject];
        if (res2) return NO;
        BOOL res1 = evaluatedObject.firstItem == self || evaluatedObject.secondItem == self;
        if (res1) {
            if (evaluatedObject.firstAttribute == NSLayoutAttributeWidth ||
                evaluatedObject.firstAttribute == NSLayoutAttributeHeight ||
                evaluatedObject.secondAttribute == NSLayoutAttributeWidth ||
                evaluatedObject.secondAttribute == NSLayoutAttributeHeight) {
                return NO;
            }
        }
        return YES;
    }]];

    [NSLayoutConstraint deactivateConstraints:filterConstraints];
    
    NSMutableArray<UIView *> *arr = NSMutableArray.array;
    NSLayoutXAxisAnchor *nextXAnchor;
    NSLayoutYAxisAnchor *nextYAnchor;
    if (self.lab) {
        ///判断size 是否宽高有一个为0
        NSString *title = [self titleForState:self.state];
        if (title.length > 0) {
            self.lab.translatesAutoresizingMaskIntoConstraints = NO;
            [arr addObject:self.lab];
        }
    }
    if (self.imgView) {
        UIImage *image = [self imageForState:self.state];
        CGSize size = image.size;
        if (size.width > 0 && size.height > 0) {
            [self.imgView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
            [self.imgView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
            self.imgView.translatesAutoresizingMaskIntoConstraints = NO;
            [arr addObject:self.imgView];
        }
    }
    if (arr.count > 1 && self.layoutOrder == ZLButtonOrderImageFirst) {
        [arr exchangeObjectAtIndex:0 withObjectAtIndex:arr.count - 1];
    }
    
    
    __block NSString *orderKey = @"";
    [arr enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        orderKey = [orderKey stringByAppendingFormat:@"%d", [obj isEqual:self.lab] ? 0 : 1];
    }];
    
    orderKey = [self generateOrderKeyWithStr:orderKey];
    if ([self.orderKey isEqualToString:orderKey]) {
        return;
    }
    self.orderKey = orderKey;
    
    [NSLayoutConstraint deactivateConstraints:self.customContraints];
    [self.customContraints removeAllObjects];
    nextXAnchor = arr.firstObject.leadingAnchor;
    nextYAnchor = arr.firstObject.topAnchor;

    NSLayoutConstraint *cons;
    NSInteger count = arr.count;
    UIEdgeInsets insets = [self _zl_effectiveInsets];
    CGFloat imgOffSet = 0;
    CGFloat titleOffset = 0;
    CGFloat space = self.layoutSpacing;
    if (count == 0) {
        cons = [self.widthAnchor constraintEqualToConstant: MAX(0, insets.left + insets.right)];
        [self.customContraints addObject:cons];
        cons = [self.heightAnchor constraintEqualToConstant:MAX(insets.top + insets.bottom, 0)];
        [self.customContraints addObject:cons];
    }
    
    for (int i = 0 ; i < count; i ++) {
        UIView *view = arr[i];
        CGFloat offset = [view isEqual:self.lab] ? titleOffset : imgOffSet;
        if (self.axis == ZLButtonAxisHorizontal) {
            if (i == 0) {
                cons = [nextXAnchor constraintEqualToAnchor:self.leadingAnchor constant:insets.left];
                cons.identifier = kInsetLeadingId;
                [self.customContraints addObject:cons];
                nextXAnchor = view.trailingAnchor;
            }else {
                if (self.flexibleSpacing) {
                    cons = [self.middelGuide.leadingAnchor constraintEqualToAnchor:nextXAnchor];
                    [self.customContraints addObject:cons];
                    nextXAnchor = self.middelGuide.trailingAnchor;
                }
                cons = [view.leadingAnchor constraintEqualToAnchor:nextXAnchor constant:space];
                cons.identifier = kSpacingId;
                [self.customContraints addObject:cons];
                nextXAnchor = view.trailingAnchor;
            }
            
            if (i  == count - 1) {
                cons = [self.trailingAnchor constraintEqualToAnchor:nextXAnchor constant:insets.right];
                cons.identifier = kInsetTrailingId;
                [self.customContraints addObject:cons];
            }
            
            switch (self.layoutContentAlignment) {
                case ZLButtonContentAlignmentStart:
                    cons = [view.topAnchor constraintEqualToAnchor:self.topAnchor constant:insets.top + offset];
                    [self.customContraints addObject:cons];
                    
                    cons = [view.bottomAnchor constraintLessThanOrEqualToAnchor:self.bottomAnchor constant:-insets.bottom];
                    [self.customContraints addObject:cons];
                    break;
                 case ZLButtonContentAlignmentCenter:
                    
                    cons = [view.topAnchor constraintGreaterThanOrEqualToAnchor:self.topAnchor constant:insets.top];
                    [self.customContraints addObject:cons];
                    
                    cons = [view.bottomAnchor constraintLessThanOrEqualToAnchor:self.bottomAnchor constant: - insets.bottom];
                    [self.customContraints addObject:cons];
                    
                    CGFloat offsetY = (insets.top - insets.bottom) / 2 + offset;
                    
                    cons = [view.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:offsetY];
                    [self.customContraints addObject:cons];
                    
                    break;
                 case ZLButtonContentAlignmentEnd:
                    
                    cons = [view.topAnchor constraintGreaterThanOrEqualToAnchor:self.topAnchor constant:insets.top];
                    [self.customContraints addObject:cons];
                    
                    cons = [self.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:insets.bottom];
                    [self.customContraints addObject:cons];
                        break;
                default:
                    break;
            }
        }else {
            if (i == 0) {
                cons = [nextYAnchor constraintEqualToAnchor:self.topAnchor constant:insets.top];
                cons.identifier = kInsetTopId;
                [self.customContraints addObject:cons];
                nextYAnchor = view.bottomAnchor;
            }else {
                if (self.flexibleSpacing) {
                    cons = [self.middelGuide.topAnchor constraintEqualToAnchor:nextYAnchor];
                    [self.customContraints addObject:cons];
                    nextYAnchor = self.middelGuide.bottomAnchor;
                }
                
                cons = [view.topAnchor constraintEqualToAnchor:nextYAnchor constant:space];
                cons.identifier = kSpacingId;
                [self.customContraints addObject:cons];
                nextYAnchor = view.bottomAnchor;
            }
            if (i  == count - 1) {
                cons = [self.bottomAnchor constraintEqualToAnchor:nextYAnchor constant:insets.bottom];
                cons.identifier = kInsetBottomId;
                [self.customContraints addObject:cons];
            }
            
            switch (self.layoutContentAlignment) {
                case ZLButtonContentAlignmentStart:
                    cons = [view.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:insets.left];
                    [self.customContraints addObject:cons];
                    
                    cons = [view.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor constant:-insets.right];
                    [self.customContraints addObject:cons];
                    
                    break;
                case ZLButtonContentAlignmentCenter:
                    cons = [view.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor constant:insets.left];
                    [self.customContraints addObject:cons];
                    cons = [self.trailingAnchor constraintGreaterThanOrEqualToAnchor:view.trailingAnchor constant:insets.right];
                    [self.customContraints addObject:cons];
                    
                    CGFloat offsetX = (insets.left - insets.right) / 2 + offset;

                    
                    cons = [view.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:offsetX];
                    [self.customContraints addObject:cons];
                    break;

                case ZLButtonContentAlignmentEnd:
                    cons = [view.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor constant:insets.left];
                    [self.customContraints addObject:cons];
                    cons = [self.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:insets.right];
                    [self.customContraints addObject:cons];
                        break;
                    
                default:
                    break;
            }
            
        }
    }
    [self.customContraints enumerateObjectsUsingBlock:^(NSLayoutConstraint*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.priority = UILayoutPriorityRequired - 1;
    }];
    [NSLayoutConstraint activateConstraints:self.customContraints];
}
///重新生成orderKey
- (NSString *)generateOrderKeyWithStr:(NSString *)str {
    NSString *orderKey = str ?: @"";
    orderKey = [orderKey stringByAppendingFormat:@"%ld", self.axis];
    orderKey = [orderKey stringByAppendingFormat:@"%ld", self.layoutContentAlignment];
    orderKey = [orderKey stringByAppendingFormat:@"%d", self.flexibleSpacing];
    UIEdgeInsets insets = [self _zl_effectiveInsets];
    if (self.axis == ZLButtonAxisHorizontal) {
        orderKey = [orderKey stringByAppendingFormat:@"%f-%f", insets.top,insets.bottom];
    }else {
        orderKey = [orderKey stringByAppendingFormat:@"%f-%f", insets.left,insets.right];
    }
    return orderKey;
}
///根据id获取约束对象
- (NSLayoutConstraint *)constraintWithIdentifier:(NSString *)identifier {
    return [self.customContraints filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSLayoutConstraint*  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject.identifier isEqualToString:identifier];
    }]].firstObject;
}
#pragma mark - RTL Support
- (void)addSubview:(UIView *)view {
    [super addSubview: view];
    [self saveView:view];
}
- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index {
    [super insertSubview:view atIndex:index];
    [self saveView:view];
}
- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview {
    [super insertSubview:view aboveSubview:siblingSubview];
    [self saveView:view];
}
- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview {
    [super insertSubview:view belowSubview:siblingSubview];
    [self saveView:view];
}
- (void)saveView:(UIView *)view {
    if ([self.titleLabel isEqual:view]) {
        self.lab = (UILabel*)view;
        self.lab.translatesAutoresizingMaskIntoConstraints = NO;
    }
    if ([self.imageView isEqual:view]) {
        self.imgView = (UIImageView *)view;
        self.imgView.translatesAutoresizingMaskIntoConstraints = NO;
    }
}
#pragma mark - Init
+ (instancetype)vertical {
    return [self buttonWithType:UIButtonTypeCustom].vertical;
}
+ (instancetype)horizontal {
    return [self buttonWithType:UIButtonTypeCustom].horizontal;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) [self _zl_setupDefaults];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) [self _zl_setupDefaults];
    return self;
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
- (void)_zl_setupDefaults {
    _axis = ZLButtonAxisHorizontal;
    _layoutOrder = ZLButtonOrderImageFirst;
    _layoutContentAlignment = ZLButtonContentAlignmentCenter;
    _layoutSpacing = 4;
    _flexibleSpacing = NO;
    _layoutEdgeInsets = UIEdgeInsetsZero;
    _layoutImageSize = CGSizeZero;
    _imageOffset = UIOffsetZero;
    _titleOffset = UIOffsetZero;
    [self setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
}

#pragma mark - Convenience Setters

- (void)setLayoutImage:(UIImage *)layoutImage {
    [self setImage:layoutImage forState:UIControlStateNormal];
}
- (UIImage *)imageWithObj:(id)image {
    UIImage *img = nil;
    if ([image isKindOfClass:UIImage.class]) {
        img = image;
    } else if ([image isKindOfClass:NSString.class]) {
        img = [UIImage imageNamed:image];
    }
    return img;
}
- (ZLButton * _Nonnull (^)(id _Nonnull))image {
    return ^(id img) {
        self.layoutImage = [self imageWithObj:img];
        return self;
    };
}
- (ZLButton * _Nonnull (^)(id _Nonnull))selectImage {
    return ^(id img) {
        [self setImage:[self imageWithObj:img] forState:UIControlStateSelected];

        return self;
    };
}
- (UIImage *)layoutImage {
    return [self imageForState:UIControlStateNormal];
}
- (ZLButton * _Nonnull (^)(id _Nonnull))bgImage {
    return ^(id img) {
        [self setBackgroundImage:[self imageWithObj:img] forState:UIControlStateNormal];
        return self;
    };
}
- (ZLButton * _Nonnull (^)(id _Nonnull))selectBgImage {
    return ^(id img) {
        [self setBackgroundImage:[self imageWithObj:img] forState:UIControlStateSelected];
        return self;
    };
}
- (void)setLayoutTitle:(NSString *)layoutTitle {
    [self setTitle:layoutTitle forState:UIControlStateNormal];
}

- (NSString *)layoutTitle {
    return [self titleForState:UIControlStateNormal];
}
- (ZLButton * _Nonnull (^)(NSString * _Nonnull))title {
    return ^(NSString *title) {
        self.layoutTitle = title;
        return self;
    };
}
- (ZLButton * _Nonnull (^)(NSString* _Nonnull))selectTitle {
    return ^(NSString* title) {
        if ([title isKindOfClass:NSString.class]) {
            [self setTitle:title forState:UIControlStateSelected];
        } else {
            [self setTitle:nil forState:UIControlStateSelected];
        }
        return self;
    };
}
- (void)setLayoutTitleFont:(UIFont *)layoutTitleFont {
    self.titleLabel.font = layoutTitleFont;
}
- (ZLButton * _Nonnull (^)(CGFloat))systemFont {
    return ^(CGFloat size) {
        self.layoutTitleFont = [UIFont systemFontOfSize:size];
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat))mediumFont {
    return ^(CGFloat size) {
        self.layoutTitleFont = [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat))semiboldFont {
    return ^(CGFloat size) {
        self.layoutTitleFont = [UIFont systemFontOfSize:size weight:UIFontWeightSemibold];
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat))boldFont {
    return ^(CGFloat size) {
        self.layoutTitleFont = [UIFont systemFontOfSize:size weight:UIFontWeightBold];
        return self;
    };
}
- (UIFont *)layoutTitleFont {
    return self.titleLabel.font;
}

- (void)setLayoutTitleColor:(UIColor *)layoutTitleColor {
    [self setTitleColor:layoutTitleColor forState:UIControlStateNormal];
}
- (ZLButton * _Nonnull (^)(id _Nonnull))titleColor {
    return ^(id color) {
        self.layoutTitleColor = ZLColorFromObj(color);
        return self;
    };
}

- (ZLButton * _Nonnull (^)(id _Nonnull))selectTitleColor {
    return ^(id color) {
        UIColor *c = ZLColorFromObj(color);
        [self setTitleColor:c forState:UIControlStateSelected];
        return self;
    };
}

- (ZLButton * _Nonnull (^)(CGFloat))titleMaxWidth {
    return ^(CGFloat maxWidth) {
        self.titleLabel.preferredMaxLayoutWidth = maxWidth;
        return self;
    };
}
- (ZLButton * _Nonnull (^)(NSInteger))titleLines {
    return ^(NSInteger lines) {
        self.titleLabel.numberOfLines = lines;
        return self;
    };
}
- (ZLButton * _Nonnull (^)(id _Nonnull))bgColor {
    return ^(id color) {
        self.backgroundColor = ZLColorFromObj(color);
        return self;
    };
}
- (UIColor *)layoutTitleColor {
    return [self titleColorForState:UIControlStateNormal];
}

#pragma mark - Layout Property Setters

- (void)setAxis:(ZLButtonAxis)layoutAxis {
    if (_axis != layoutAxis) {
        _axis = layoutAxis;
        [self setNeedsUpdateConstraints];
    }
}
- (instancetype)vertical {
    self.axis = ZLButtonAxisVertical;
    return self;
}
- (instancetype)horizontal {
    self.axis = ZLButtonAxisHorizontal;
    return self;
}
- (void)setLayoutOrder:(ZLButtonOrder)layoutOrder {
    if (_layoutOrder != layoutOrder) {
        _layoutOrder = layoutOrder;
        [self setNeedsUpdateConstraints];
    }
}
- (instancetype)imageFirst {
    self.layoutOrder = ZLButtonOrderImageFirst;
    return self;
}
- (instancetype)titleFirst {
    self.layoutOrder = ZLButtonOrderTitleFirst;
    return self;
}
- (void)setLayoutContentAlignment:(ZLButtonContentAlignment)layoutContentAlignment {
    if (_layoutContentAlignment != layoutContentAlignment) { _layoutContentAlignment = layoutContentAlignment;
        [self setNeedsUpdateConstraints];
    }
}
- (instancetype)alignCenter {
    self.layoutContentAlignment = ZLButtonContentAlignmentCenter;
    return self;
}
- (instancetype)alignStart {
    self.layoutContentAlignment = ZLButtonContentAlignmentStart;
    return self;
}
- (instancetype)alignEnd {
    self.layoutContentAlignment = ZLButtonContentAlignmentEnd;
    return self;
}
- (ZLButton * _Nonnull (^)(BOOL))imageTouchOnly {
    return ^(BOOL imageOnly) {
        self.imgTouchOnly = imageOnly;
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))touchAreaEdge {
    return ^(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing) {
        self.touchAreaEdgeInsets = UIEdgeInsetsMake(top, leading, bottom, trailing);
        return self;
    };
}

- (ZLButton * _Nonnull (^)(NSTimeInterval))debounce {
    return ^(NSTimeInterval interval) {
        self.tapInerval = interval;
        return self;
    };
}
- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (self.tapInerval > 0) {
        self.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.tapInerval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.userInteractionEnabled = YES;
        });
    }
    [super sendAction:action to:target forEvent:event];
}
- (void)setLayoutSpacing:(CGFloat)layoutSpacing {
    if (_layoutSpacing != layoutSpacing) {
        _layoutSpacing = layoutSpacing;
        NSLayoutConstraint *cons = [self constraintWithIdentifier:kSpacingId];
        if (cons) {
            cons.constant = layoutSpacing;
        }
    }
}
- (ZLButton * _Nonnull (^)(CGFloat))spacing {
    return ^(CGFloat spacing) {
        self.layoutSpacing = spacing;
        return self;
    };
}

- (void)setFlexibleSpacing:(BOOL)flexibleSpacing {
    if (_flexibleSpacing != flexibleSpacing) {
        _flexibleSpacing = flexibleSpacing;
        [self setNeedsUpdateConstraints];
    }
}

- (instancetype)flexSpacing{
    self.flexibleSpacing = YES;
    return self;
}
- (ZLButton * _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))inset {
    return ^(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing) {
        self.layoutEdgeInsets = UIEdgeInsetsMake(top, leading, bottom, trailing);
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat, CGFloat))hInset {
    return ^(CGFloat leading, CGFloat trailing) {
        self.layoutEdgeInsets = UIEdgeInsetsMake(self.layoutEdgeInsets.top, leading, self.layoutEdgeInsets.bottom, trailing);
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat, CGFloat))vInset {
    return ^(CGFloat top, CGFloat bottom) {
        self.layoutEdgeInsets = UIEdgeInsetsMake(top, self.layoutEdgeInsets.left, bottom, self.layoutEdgeInsets.right);
        return self;
    };
}
- (void)setLayoutEdgeInsets:(UIEdgeInsets)layoutEdgeInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(layoutEdgeInsets, _layoutEdgeInsets)) return;
    _layoutEdgeInsets = layoutEdgeInsets;
    NSLayoutConstraint *leadingCons = [self constraintWithIdentifier:kInsetLeadingId];
    if (leadingCons) leadingCons.constant = layoutEdgeInsets.left;
    NSLayoutConstraint *trailingCons = [self constraintWithIdentifier:kInsetTrailingId];
    if (trailingCons) trailingCons.constant = layoutEdgeInsets.right;
    NSLayoutConstraint *topCons = [self constraintWithIdentifier:kInsetTopId];
    if (topCons) topCons.constant = layoutEdgeInsets.top;
    NSLayoutConstraint *bottomCons = [self constraintWithIdentifier:kInsetBottomId];
    if (bottomCons) bottomCons.constant = layoutEdgeInsets.bottom;
    [self setNeedsUpdateConstraints];
}
- (void)setLayoutImageSize:(CGSize)layoutImageSize {
    _layoutImageSize = layoutImageSize;
//    [self.imgView.widthAnchor constraintEqualToConstant:layoutImageSize.width];
//    [self.imgView.heightAnchor constraintEqualToConstant:layoutImageSize.height];
    [self setNeedsUpdateConstraints];
}
- (ZLButton * _Nonnull (^)(CGFloat, CGFloat))imageSize {
    return ^(CGFloat width, CGFloat height) {
        self.layoutImageSize = CGSizeMake(width, height);
        return self;
    };
}

- (void)setImageOffset:(UIOffset)imageOffset {
    _imageOffset = imageOffset;
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];
}

- (ZLButton * _Nonnull (^)(CGFloat, CGFloat))imgOffset {
    return ^(CGFloat horizontal, CGFloat vertical) {
        self.imageOffset = UIOffsetMake(horizontal, vertical);
        return self;
    };
}

- (void)setTitleOffset:(UIOffset)titleOffset {
    _titleOffset = titleOffset;
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];
}

- (ZLButton * _Nonnull (^)(CGFloat, CGFloat))titOffset {
    return ^(CGFloat horizontal, CGFloat vertical) {
        self.titleOffset = UIOffsetMake(horizontal, vertical);
        return self;
    };
}
- (ZLButton * _Nonnull (^)(void (^ _Nonnull)(ZLButton *)))touchAction {
    return ^(void (^action)(ZLButton *)) {
        [self addTarget:self action:@selector(_zl_handleTouch) forControlEvents:UIControlEventTouchUpInside];
        objc_setAssociatedObject(self, @selector(_zl_handleTouch), action, OBJC_ASSOCIATION_COPY_NONATOMIC);
        return self;
    };
}
- (ZLButton * _Nonnull (^)(id _Nonnull, SEL _Nonnull))addTargetSel {
    return ^(id target, SEL action) {
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        return self;
    };
}
- (void)_zl_handleTouch {
    void (^action)(ZLButton *) = objc_getAssociatedObject(self, _cmd);
    if (action) action(self);
}


#pragma mark - Size Calculation


#pragma mark - layoutSubviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    /// 确保渐变层在最底层且尺寸正确
    if (_gradLayer
        && !CGRectEqualToRect(self.bounds, CGRectZero)
        && !CGRectEqualToRect(self.bounds, self.gradLayer.bounds)) {
        [self.layer insertSublayer:self.gradLayer atIndex:0];
        self.gradLayer.frame = self.bounds;
    }
    
    if (self.isCircleClip) self.circle(self.isCircleClip);
    
    [self callLayoutSubviewBlock];
}
- (void)callLayoutSubviewBlock {
    [self drawCornerRadii];
    if (self.layoutBlock) {
        self.layoutBlock(self);
    }
}
// Remove the old adjustImageOffset / adjustTitleOffset methods — inlined above


- (ZLButton * _Nonnull (^)(UIViewContentMode))imageMode {
    return ^(UIViewContentMode mode) {
        self.imageView.contentMode = mode;
        return self;
    };
}
- (ZLButton * _Nonnull (^)(BOOL))visibility {
    return ^(BOOL visible) {
        self.hidden = !visible;
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat))alphaValue {
    return ^(CGFloat alpha) {
        self.alpha = alpha;
        return self;
    };
}
- (instancetype)imageAspectFit {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    return self;
}
- (instancetype)imageAspectFill {
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    return self;
}
- (ZLButton * _Nonnull (^)(UIViewContentMode))bgImageMode {
    return ^(UIViewContentMode mode) {
        self.contentMode = mode;
        return self;
    };
}
- (instancetype)bgImageAspectFit {
    self.contentMode = UIViewContentModeScaleAspectFit;
    return self;
}
- (instancetype)bgImageAspectFill {
    self.contentMode = UIViewContentModeScaleAspectFill;
    return self;
}
- (ZLButton * _Nonnull (^)(BOOL))userActive {
    return ^(BOOL enabled) {
        self.userInteractionEnabled = enabled;
        if (enabled) {
            if (self.activeStyleBlock) self.activeStyleBlock(self);
        }else  {
            if (self.inactiveStyleBlock) self.inactiveStyleBlock(self);
        }
        return self;
    };
}
- (ZLButton * _Nonnull (^)(BOOL))select {
    return ^(BOOL selected) {
        self.selected = selected;
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat))corner {
    return ^ZLButton*(CGFloat radius){
        self.layer.cornerRadius = radius;
        self.layer.masksToBounds = radius > 0;
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))cornerRadii {
    return ^ZLButton*(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight){
        self.cornerRadiiValue = UIEdgeInsetsMake(topLeft, topRight, bottomLeft, bottomRight);
        return self;
    };
}
- (BOOL)_zl_isRTL {
    
    if (@available(iOS 10.0, *)) {
        return self.effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
    }
    return [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
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
- (ZLButton * _Nonnull (^)(BOOL))circle {
    return ^ZLButton*(BOOL clip) {
        self.isCircleClip = @(clip);
        if (clip) {
            CGFloat minSide = MIN(self.bounds.size.width, self.bounds.size.height);
            self.layer.cornerRadius = minSide / 2.0;
            self.layer.masksToBounds = YES;
        } else {
            self.layer.cornerRadius = 0;
            self.layer.masksToBounds = NO;
        }
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat))imageCorner {
    return ^ZLButton*(CGFloat radius){
        self.imageView.layer.cornerRadius = radius;
        self.imageView.layer.masksToBounds = radius > 0;
        return self;
    };
}
- (ZLButton* (^)(id ))borderColor {
    return  ^ZLButton*(id color){
        self.layer.borderColor = ZLColorFromObj(color).CGColor;
        return self;
    };
}
- (ZLButton* (^)(CGFloat ))borderWidth {
    return  ^ZLButton*(CGFloat width){
        self.layer.borderWidth = width;
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat, id _Nonnull))border {
    return ^ZLButton*(CGFloat width, id color){
        return self.borderWidth(width).borderColor(color);
    };
}
- (ZLButton*  _Nonnull (^)(id _Nonnull))shColor {
    return ^ZLButton* (id color) {
        self.layer.shadowColor = ZLColorFromObj(color).CGColor;
        return self.shOffset(0,2);
    };
}


- (ZLButton*  _Nonnull (^)(CGFloat, CGFloat))shOffset {
    return ^ZLButton* (CGFloat width, CGFloat height) {
        self.layer.shadowOffset = CGSizeMake(width, height);
        return self.shRadius(6);
    };
}


- (ZLButton*  _Nonnull (^)(CGFloat))shRadius {
    return ^ZLButton* (CGFloat radius) {
        self.layer.shadowRadius = radius;
        return self.shOpacity(0.2);
    };
}

- (ZLButton*  _Nonnull (^)(CGFloat))shOpacity {
    return ^ZLButton* (CGFloat opacity) {
        self.layer.shadowOpacity = opacity;
        return self.masksToBounds(NO);
    };
}
- (ZLButton*  _Nonnull (^)(BOOL))masksToBounds {
    return ^ZLButton* (BOOL masks) {
        self.layer.masksToBounds = masks;
        return self;
    };
}

- (ZLButton * _Nonnull (^)(ZLButton * _Nullable __autoreleasing * _Nullable))toPtr {
    return ^ZLButton*(ZLButton **ptr){
        if (ptr) *ptr = self;
        return self;
    };
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.userInteractionEnabled ||
        !self.enabled ||
        self.hidden ||
        self.alpha < 0.01) {
        return [super pointInside:point withEvent:event];
    }
    UIEdgeInsets edget = self.touchAreaEdgeInsets;
    if ([self _zl_isRTL]) {
        CGFloat tmp = edget.left;
        edget.left = edget.right;
        edget.right = tmp;
    }
    CGRect expandedRect;
    if (self.imgTouchOnly) {
       expandedRect = UIEdgeInsetsInsetRect(self.imageView.bounds, UIEdgeInsetsMake(-edget.top, -edget.left, -edget.bottom, -edget.right));
        // 将点转换到 imageView 的坐标系
        CGPoint pointInImageView = [self convertPoint:point toView:self.imageView];
        return CGRectContainsPoint(expandedRect, pointInImageView);
    }
    expandedRect = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(-edget.top, -edget.left, -edget.bottom, -edget.right));
    return CGRectContainsPoint(expandedRect, point);
}
- (ZLButton* (^)(void (^ _Nonnull)(ZLButton * _Nonnull)))activeStyle {
    return ^(void (^block)(ZLButton *)) {
        self.activeStyleBlock = block;
        if (self.userInteractionEnabled) if (block) block(self);
        return self;
    };
}
- (ZLButton* (^)(void (^ _Nonnull)(ZLButton * _Nonnull)))inactiveStyle {
    return ^(void (^block)(ZLButton *)) {
        self.inactiveStyleBlock = block;
        if (!self.userInteractionEnabled) if (block) block(self);
        return self;
    };
}
- (ZLButton * _Nonnull (^)(void (^ _Nonnull)(ZLButton * _Nonnull)))then {
    return ^(void (^block)(ZLButton *)) {
        if (block) block(self);
        return self;
    };
}

- (void)dealloc
{
    if (self.deallocBlock) self.deallocBlock(self);
}

- (ZLButton * _Nonnull (^)(CGFloat))z_centerX {
    return ^(CGFloat centerX) {
        self.KFC.centerX(centerX);
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat))z_centerY {
    return ^(CGFloat centerY) {
        self.KFC.centerY(centerY);
        return self;
    };
}
- (ZLButton * _Nonnull (^)(void))z_center {
    return ^() {
        self.KFC.center();
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat, CGFloat))z_centerOffset {
    return ^(CGFloat offsetX, CGFloat offsetY) {
        self.KFC.centerOffset(offsetX, offsetY);
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat))z_top {
    return ^(CGFloat top) {
        self.KFC.top(top);
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat))z_leading {
    return ^(CGFloat leading) {
        self.KFC.leading(leading);
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat))z_bottom {
    return ^(CGFloat bottom) {
        self.KFC.bottom(bottom);
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat))z_trailing {
    return ^(CGFloat trailing) {
        self.KFC.trailing(trailing);
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat))z_height {
    return ^(CGFloat height) {
        self.KFC.height(height);
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat))z_width {
    return ^(CGFloat width) {
        self.KFC.width(width);
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat, CGFloat))z_size {
    return ^(CGFloat width, CGFloat height) {
        self.KFC.size(width, height);
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat))z_square {
    return ^(CGFloat side) {
        self.KFC.square(side);
        return self;
    };
}
- (ZLButton * _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))z_edge {
    return ^(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing) {
        self.KFC.edge(top, leading, bottom, trailing);
        return self;
    };
}
- (ZLButton * _Nonnull (^)(void))z_edgesZero {
    return ^() {
        self.KFC.edgesZero();
        return self;
    };
}
- (ZLButton* _Nonnull (^)(UIView * _Nonnull))addTo {
    return ^(UIView *superview){
        if ([superview isKindOfClass:UIView.class]) {
            [superview addSubview:self];
        }
        return self;
    };
}

- (ZLButton* _Nonnull (^)(UIView * _Nonnull))addToFull {
    return ^(UIView *superview){
        if ([superview isKindOfClass:UIView.class]) {
            [superview addSubview:self];
            self.KFC.edgesZero();
        }
        return self;
    };
}
- (ZLButton* _Nonnull (^)(UIView * _Nonnull))addSubview {
    return ^(UIView *subview){
        if ([subview isKindOfClass:UIView.class]) {
            [self addSubview:subview];
        }
        return self;
    };
}
@end
