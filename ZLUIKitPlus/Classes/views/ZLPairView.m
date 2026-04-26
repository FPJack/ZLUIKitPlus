//
//  ZLPairView.m
//  ZLInsetLabel
//
//  Created by admin on 2026/4/23.
//

#import "ZLPairView.h"
#import "ZLUI.h"
@interface ZLPairView ()
@property (nonatomic,strong)UIStackView *stackView;
@property (nonatomic,assign)CGFloat spacingValue;
@property (nonatomic,assign)ZLJustify hJustifyValue;
@property (nonatomic,assign)ZLJustify vJustifyValue;
@property (nonatomic,strong)NSMutableArray *constraintsArray;
@property (nonatomic,strong)NSMutableArray *vConstraintsArray;
@property (nonatomic, strong,readwrite) UIView*  first;
@property (nonatomic, strong,readwrite) UIView* second;
///弹性view
@property (nonatomic, strong) UIView *flexableView;
@property (nonatomic, assign) BOOL flexable;
@property (nonatomic,strong,readwrite)CAGradientLayer *gradLayer;

@end
@implementation ZLPairView
- (NSMutableArray *)constraintsArray {
    if (!_constraintsArray) {
        _constraintsArray = NSMutableArray.new;
    }
    return _constraintsArray;
}
- (NSMutableArray *)vConstraintsArray {
    if (!_vConstraintsArray) {
        _vConstraintsArray = NSMutableArray.new;
    }
    return _vConstraintsArray;
}
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionFill;
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
        _stackView.backgroundColor = UIColor.orangeColor;
        self.backgroundColor = [UIColor.blueColor colorWithAlphaComponent:0.3];
        [self addSubview:_stackView];
    }
    return _stackView;
}
- (UIView *)flexableView {
    if (!_flexableView) {
        _flexableView = [[UIView alloc] init];
        _flexableView.backgroundColor = UIColor.clearColor;
        [_flexableView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [_flexableView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [_flexableView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        [_flexableView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    }
    return _flexableView;
}
- (id )first {
    if (!_first) {
        _first = [self makeFirstView];
        /// 添加bounds监听
        [_first addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
        [self.stackView insertArrangedSubview:_first atIndex:0];
    }
    return _first;
}
- (id )second {
    if (!_second) {
        _second = [self makeSecondView];
        [_second addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
        [self.stackView addArrangedSubview:_second];
    }
    return _second;
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
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"bounds"]) {
        /// 取新旧值
        CGRect newBounds = [change[NSKeyValueChangeNewKey] CGRectValue];
        CGRect oldBounds = [change[NSKeyValueChangeOldKey] CGRectValue];
        if ([object isEqual:_first] || [object isEqual:_second]) {
            /// 尺寸变化 方便设置view的隐藏达到间距为0的效果
            if (!CGSizeEqualToSize(newBounds.size, oldBounds.size)) {
                [self setNeedsLayout];
            }
        }
    }
}
- (void)dealloc
{
    if (_first) {
        [_first removeObserver:self forKeyPath:@"bounds"];
    }
    if (_second) {
        [_second removeObserver:self forKeyPath:@"bounds"];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaults];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (id  _Nonnull (^)(CGFloat))spacing {
    return ^id(CGFloat spacing){
        self.spacingValue = spacing;
        self.stackView.spacing = spacing;
        return self;
    };
}
- (id  _Nonnull (^)(BOOL))flexibleSpacing {
    return ^id(BOOL flexible){
        self.flexable = flexible;
        if (flexible) {
            [self insertFlexSpacing];
        }else {
            [self removeFlexSpacing];
        }
        return self;
    };
}
- (void)insertFlexSpacing {
    if (self.flexable ) {
        NSArray *views = self.stackView.arrangedSubviews;
        if ([views containsObject:_first] && [views containsObject:_second] ) {
            BOOL shouldInsert = NO;
            if (self.stackView.axis == UILayoutConstraintAxisHorizontal) {
                if (self.hJustifyValue == ZlJustifyFill) shouldInsert = YES;
            }else if (self.stackView.axis == UILayoutConstraintAxisVertical) {
                if (self.hJustifyValue == ZlJustifyFill) shouldInsert = YES;
            }
            if (shouldInsert) {
                [self.stackView insertArrangedSubview:self.flexableView atIndex:1];
                if (@available(iOS 11.0, *)) {
                    [self.stackView setCustomSpacing:0 afterView:_flexableView];
                } else {
                }
                _flexableView.hidden = NO;
                [self.stackView setNeedsLayout];
            }
        }
    }
}
- (void)removeFlexSpacing {
    if (_flexable && [self.stackView.arrangedSubviews containsObject:_flexableView]) {
        _flexableView.hidden = YES;
    }
}
    
    
- (id  _Nonnull (^)(BOOL))horizontal {
    return ^(BOOL horizontal){
        self.stackView.axis = horizontal ? UILayoutConstraintAxisHorizontal : UILayoutConstraintAxisVertical;
        return self;
    };
}
- (id  _Nonnull (^)(ZLJustify))hJustify {
    return ^(ZLJustify justify){
        switch (justify) {
            case ZLJustifyStart:
                [self hJustifyStart];
                break;
            case ZLJustifyCenter:
                [self hJustifyCenter];
                break;
            case ZlJustifyEnd:
                [self hJustifyEnd];
                break;
            case ZlJustifyFill:
                [self hJustifyFill];
                break;
            case ZlJustifyFillEqually:
                [self hJustifyFillEqually];
                break;
            default:
                break;
        }
        self.hJustifyValue = justify;
        return self;
    };
}

- (void)hJustifyStart {
    if (self.hJustifyValue == ZLJustifyStart) return;
    self.stackView.distribution = UIStackViewDistributionFill;
    [NSLayoutConstraint deactivateConstraints:self.constraintsArray];
    [self.constraintsArray removeAllObjects];
    [self.constraintsArray addObjectsFromArray:@[
            [self.stackView.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor],
            [self.stackView.trailingAnchor constraintLessThanOrEqualToAnchor:self.layoutMarginsGuide.trailingAnchor constant:0]
    ]];
    [NSLayoutConstraint activateConstraints:self.constraintsArray];
}
- (void)hJustifyCenter {
    if (self.hJustifyValue == ZLJustifyCenter) return;
    self.stackView.distribution = UIStackViewDistributionFill;
    [NSLayoutConstraint deactivateConstraints:self.constraintsArray];
    [self.constraintsArray removeAllObjects];
    [self.constraintsArray addObjectsFromArray:@[
            [self.stackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [self.stackView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.layoutMarginsGuide.leadingAnchor constant:0],
            [self.stackView.trailingAnchor constraintLessThanOrEqualToAnchor:self.layoutMarginsGuide.trailingAnchor constant:0],
    ]];
    [NSLayoutConstraint activateConstraints:self.constraintsArray];
}
- (void)hJustifyEnd {
    if (self.hJustifyValue == ZlJustifyEnd) return;
    self.stackView.distribution = UIStackViewDistributionFill;
    [NSLayoutConstraint deactivateConstraints:self.constraintsArray];
    [self.constraintsArray removeAllObjects];
    [self.constraintsArray addObjectsFromArray:@[
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor],
        [self.stackView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.layoutMarginsGuide.leadingAnchor constant:0],
    ]];
   
    [NSLayoutConstraint activateConstraints:self.constraintsArray];
}
- (void)hJustifyFill{
    if (self.hJustifyValue == ZlJustifyFill) return;
    self.stackView.distribution = UIStackViewDistributionFill;
    [NSLayoutConstraint deactivateConstraints:self.constraintsArray];
    [self.constraintsArray removeAllObjects];
    [self.constraintsArray addObjectsFromArray:@[
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor],
    ]];
    [NSLayoutConstraint activateConstraints:self.constraintsArray];
}
- (void)hJustifyFillEqually {
    if (self.hJustifyValue == ZlJustifyFillEqually) return;
    self.stackView.distribution = UIStackViewDistributionFillEqually;
    [NSLayoutConstraint deactivateConstraints:self.constraintsArray];
    [self.constraintsArray removeAllObjects];
    [self.constraintsArray addObjectsFromArray:@[
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor],
    ]];
    [NSLayoutConstraint activateConstraints:self.constraintsArray];
}
- (id  _Nonnull (^)(ZLAlign))align {
    return ^(ZLAlign alignment){
        switch (alignment) {
            case ZLAlignStart:
                self.stackView.alignment = UIStackViewAlignmentTop;
                break;
            case ZLAlignCenter:
                self.stackView.alignment = UIStackViewAlignmentCenter;
                break;
            case ZLAlignEnd:
                self.stackView.alignment = UIStackViewAlignmentBottom;
                break;
            default:
                break;
        }
        return self;
    };
}

- (id  _Nonnull (^)(ZLJustify))vJustify {
    return ^(ZLJustify justify){
        switch (justify) {
            case ZLJustifyStart:
                [self vJustifyStart];
                break;
            case ZLJustifyCenter:
                [self vJustifyCenter];
                break;
            case ZlJustifyEnd:
                [self vJustifyEnd];
                break;
            case ZlJustifyFill:
                [self vJustifyFill];
                break;
            case ZlJustifyFillEqually:
                [self vJustifyFillEqually];
                break;
            default:
                break;
        }
        self.vJustifyValue = justify;
        return self;
    };
}
- (void)vJustifyStart {
    if (self.vJustifyValue == ZLJustifyStart) return;
    self.stackView.distribution = UIStackViewDistributionFill;
    [NSLayoutConstraint deactivateConstraints:self.vConstraintsArray];
    [self.vConstraintsArray removeAllObjects];
    [self.vConstraintsArray addObjectsFromArray:@[
            [self.stackView.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor],
            [self.stackView.bottomAnchor constraintLessThanOrEqualToAnchor:self.layoutMarginsGuide.bottomAnchor constant:0]
    ]];
    [NSLayoutConstraint activateConstraints:self.vConstraintsArray];
}
- (void)vJustifyCenter {
    if (self.vJustifyValue == ZLJustifyCenter) return;
    self.stackView.distribution = UIStackViewDistributionFill;
    [NSLayoutConstraint deactivateConstraints:self.vConstraintsArray];
    [self.vConstraintsArray removeAllObjects];
    [self.vConstraintsArray addObjectsFromArray:@[
            [self.stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [self.stackView.topAnchor constraintGreaterThanOrEqualToAnchor:self.layoutMarginsGuide.topAnchor constant:0],
            [self.stackView.topAnchor constraintLessThanOrEqualToAnchor:self.layoutMarginsGuide.bottomAnchor constant:0],
    ]];
    [NSLayoutConstraint activateConstraints:self.vConstraintsArray];
}
- (void)vJustifyEnd {
    if (self.vJustifyValue == ZlJustifyEnd) return;
    self.stackView.distribution = UIStackViewDistributionFill;
    [NSLayoutConstraint deactivateConstraints:self.vConstraintsArray];
    [self.vConstraintsArray removeAllObjects];
    [self.vConstraintsArray addObjectsFromArray:@[
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor],
        [self.stackView.topAnchor constraintGreaterThanOrEqualToAnchor:self.layoutMarginsGuide.topAnchor constant:0],
    ]];
    [NSLayoutConstraint activateConstraints:self.vConstraintsArray];
}
- (void)vJustifyFill {
    if (self.vJustifyValue == ZlJustifyFill) return;
    self.stackView.distribution = UIStackViewDistributionFill;
    [NSLayoutConstraint deactivateConstraints:self.vConstraintsArray];
    [self.vConstraintsArray removeAllObjects];
    [self.vConstraintsArray addObjectsFromArray:@[
        [self.stackView.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor],
    ]];
    [NSLayoutConstraint activateConstraints:self.vConstraintsArray];
}

- (void)vJustifyFillEqually {
    if (self.vJustifyValue == ZlJustifyFillEqually) return;
    self.stackView.distribution = UIStackViewDistributionFillEqually;
    [NSLayoutConstraint deactivateConstraints:self.vConstraintsArray];
    [self.vConstraintsArray removeAllObjects];
    [self.vConstraintsArray addObjectsFromArray:@[
        [self.stackView.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor],
    ]];
    [NSLayoutConstraint activateConstraints:self.vConstraintsArray];
}


- (id  _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))insets {
    return ^(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailling){
        self.stackView.layoutMargins = UIEdgeInsetsMake(top, leading, bottom, trailling);
        self.stackView.layoutMarginsRelativeArrangement = YES;
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))marge {
    return ^(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailling){
        self.layoutMargins = UIEdgeInsetsMake(top, leading, bottom, trailling);
        return self;
    };
}
- (void)setupDefaults {
    self.vJustifyValue = -1;
    self.hJustifyValue = -1;
    self.align(ZLAlignCenter);
    self.hJustify(ZlJustifyFill);
    self.vJustify(ZlJustifyFill);
    self.spacing(4);
    self.marge(0, 0, 0, 0);
}
- (id  _Nonnull (^)(void (^ _Nonnull)(id _Nonnull)))then {
    return ^(void (^then)(id view)){
        if (then) then(self);
        return self;
    };
}
- (id  _Nonnull (^)(void (^ _Nonnull)(UIView * _Nonnull)))thenFirst {
    return ^(void (^then)(UIView *first)){
        if (then) then(self.first);
        return self;
    };
}
- (id  _Nonnull (^)(void (^ _Nonnull)(UIView * _Nonnull)))thenSecond {
    return ^(void (^then)(UIView *second)){
        if (then) then(self.second);
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat))corner {
    return ^(CGFloat radius){
        self.layer.cornerRadius = radius;
        self.layer.masksToBounds = radius > 0;
        return self;
    };
}
- (id  _Nonnull (^)(void (^ _Nonnull)(__kindof ZLPairView * _Nonnull)))tapAction {
    return ^(void (^tapAction)(__kindof ZLPairView *view)){
        self.KFC.tapAction(tapAction);
        return self;
    };
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return [super hitTest:point withEvent:event];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSLog(@"PairView layoutSubviews:");
    
    {
        /// 确保渐变层在最底层且尺寸正确
        if (_gradLayer
            && !CGRectEqualToRect(self.bounds, CGRectZero)
            && !CGRectEqualToRect(self.bounds, self.gradLayer.bounds)) {
            [self.layer insertSublayer:self.gradLayer atIndex:0];
            self.gradLayer.frame = self.bounds;
        }
    }
    
    //两个view都有尺寸
    
    BOOL firstHasSize = YES;
    BOOL secondHasSize = YES;
    
    {
        CGSize size = [_first intrinsicContentSize];
        CGFloat wh = self.stackView.axis == UILayoutConstraintAxisHorizontal ? size.width : size.height;
        if (wh <= 0.0) {
            firstHasSize = NO;
            _first.hidden = YES;
        }else {
            _first.hidden = NO;
        }
    }
    
    {
        CGSize size = [_second intrinsicContentSize];
        CGFloat wh = self.stackView.axis == UILayoutConstraintAxisHorizontal ? size.width : size.height;
        if (wh <= 0.0){
            secondHasSize = NO;
            _second.hidden = YES;
        }else {
            _second.hidden = NO;
        }
    }
    
    if (firstHasSize && secondHasSize) {
        [self insertFlexSpacing];
    }else {
        [self removeFlexSpacing];
    }
}
- (id)makeFirstView {
    ///子类重写返回对应类型的视图 抛出错误
    NSAssert(NO, @"子类必须重写first方法返回对应类型的视图");
    return nil;
}
- (id)makeSecondView {
    NSAssert(NO, @"子类必须重写second方法返回对应类型的视图");
    return nil;
}



- (id _Nonnull (^)(UIView * _Nonnull))addTo {
    return ^(UIView *superview){
        if ([superview isKindOfClass:UIView.class]) {
            [superview addSubview:self];
        }
        return self;
    };
}

- (id _Nonnull (^)(UIView * _Nonnull))addToFull {
    return ^(UIView *superview){
        if ([superview isKindOfClass:UIView.class]) {
            [superview addSubview:self];
            self.KFC.edgesZero();
        }
        return self;
    };
}
- (UIView * _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))wrapEdges {
    return ^(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing){
        return self.KFC.wrapEdges(top, leading, bottom, trailing);
    };
}
@end

@implementation ZLPairLabelView
- (UIView *)makeFirstView {

    return ZLLabel.new;
}
- (UIView *)makeSecondView {
    ZLLabel *label = ZLLabel.new.systemFont(14).color(UIColor.grayColor).lines(0);
    [label setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [label setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [label setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    [label setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    return label;
}
@end

@implementation ZLPairImageView
- (UIView *)makeFirstView {
    return ZLImageView.new;
}
- (UIView *)makeSecondView {
    return ZLImageView.new;
}
@end

@implementation ZLPairButtonView
- (UIView *)makeFirstView {
    return ZLButton.horizontal;
}
- (UIView *)makeSecondView {
    return ZLButton.horizontal;
}
@end
@implementation ZLImgLabelView
- (UIView *)makeFirstView {
    return ZLImageView.new;
}
- (UIView *)makeSecondView {
    return ZLLabel.new;
}
@end

@implementation ZLImgButtonView
- (UIView *)makeFirstView {
    return ZLImageView.new;
}
- (UIView *)makeSecondView {
    return ZLButton.horizontal;
}
@end
@implementation ZLButtonImgView
- (UIView *)makeFirstView {
    return ZLButton.horizontal;
}
- (UIView *)makeSecondView {
    return ZLImageView.new;
}
@end


