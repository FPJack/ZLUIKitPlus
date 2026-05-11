//
//  ZLStackView.m
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/4/25.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLStackView.h"
#import "ZLLayoutManager.h"
#import "ZLLayoutViewFlex.h"
#import "ZLConstraintsCfg.h"
#import "ZLUI.h"
@interface ZLBaseStackView()
@property (nonatomic,strong)ZLLayoutManager *layoutManager;
@property(nonatomic,strong) NSMutableArray<__kindof UIView *> *allViews;
@property (nonatomic,assign)BOOL markedDirty;
@end

@implementation ZLBaseStackView


- (ZLLayoutManager *)layoutManager {
    if (!_layoutManager) {
        _layoutManager = [[ZLLayoutManager alloc] init];
        _layoutManager.stackView = self;
    }
    return _layoutManager;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.markedDirty = YES;
        self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}
- (NSMutableArray<__kindof UIView *> *)arrangedViews {
    if (!_arrangedViews) {
        _arrangedViews = NSMutableArray.array;
    }
    return _arrangedViews;
}
- (NSMutableArray<__kindof UIView *> *)allViews {
    if (!_allViews) {
        _allViews = NSMutableArray.array;
    }
    return _allViews;
}
- (void)setInsets:(UIEdgeInsets)insets {
    if (UIEdgeInsetsEqualToEdgeInsets(insets, _insets)) return;
    _insets = insets;
    self.markedDirty = YES;
    [self setNeedsUpdateConstraints];
}
- (void)setAxis:(ZLStackViewAxis)axis {
    if (axis == _axis) return;
    _axis = axis;
    self.markedDirty = YES;
    [self setNeedsUpdateConstraints];
}
- (void)setJustifyContent:(ZLJustify)justifyContent {
    if (justifyContent == _justifyContent) return;
    _justifyContent = justifyContent;
    self.markedDirty = YES;
    [self setNeedsUpdateConstraints];
}
- (void)setAlignment:(ZLAlign)alignment {
    if (alignment == _alignment) return;
    _alignment = alignment;
    self.markedDirty = YES;
    [self setNeedsUpdateConstraints];
}
- (void)setSpacing:(CGFloat)spacing {
    if (spacing == _spacing) return;
    _spacing = spacing;
    self.markedDirty = YES;
    [self setNeedsUpdateConstraints];
}
- (void)addArrangedSubview:(UIView *)view{
    if ([view isKindOfClass:UIView.class]) {
        if ([self.allViews containsObject:view]) return;
        ZLLayoutViewFlex *cfg = view.zl_flex;
        [cfg setValue:view forKey:@"view"];
        [cfg setValue:self forKey:@"stackView"];
        [self.allViews addObject:view];
        if (view.hidden) return;
        [self.arrangedViews addObject:view];
        [self adjustLabelCompression:view];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        self.markedDirty = YES;
        [self setNeedsUpdateConstraints];
    }
}
- (void)addArrangedSubview:(UIView *)view layout:(void(^)(__kindof UIView *view, ZLLayoutViewFlex *viewCfg))config{
    [self addArrangedSubview:view];
    if (config) config(view,view.zl_flex);
    
}
- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex {
    if ([view isKindOfClass:UIView.class]) {
        if ([self.allViews containsObject:view]) return;
        [self.allViews insertObject:view atIndex:stackIndex];
        [self adjustLabelCompression:view];
        if (view.hidden) return;
        self.markedDirty = YES;
        [self setNeedsUpdateConstraints];
    }
}
///防止换行的时候挤出右边下面的view
- (void)adjustLabelCompression:(UIView*)view {
    if (![view isKindOfClass:UILabel.class]) return;
    UILayoutConstraintAxis axis = self.axis == ZLStackViewAxisHorizontal ? UILayoutConstraintAxisHorizontal : UILayoutConstraintAxisVertical;
    UILayoutPriority priorit = [view contentCompressionResistancePriorityForAxis:axis];
    if (priorit == UILayoutPriorityDefaultHigh) {
        [view setContentCompressionResistancePriority:priorit - 0.1 forAxis:axis];
    }
}
- (void)refreshArrangedSubviews {
    [self.arrangedViews removeAllObjects];
    [self.allViews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.hidden) [self.arrangedViews addObject:obj];
    }];
}
- (void)removeArrangedSubview:(UIView *)view {
    if (![self.allViews containsObject:view]) return;
    [view removeFromSuperview];
    [self.allViews removeObject:view];
    if (![self.arrangedViews containsObject:view]) return;
    [self.arrangedViews removeObject:view];
    self.markedDirty = YES;
    [self setNeedsUpdateConstraints];
}
- (void)setFlexibleSpacing:(BOOL)flexible afterView:(UIView *)arrangedSubview {
    if (![arrangedSubview isKindOfClass:UIView.class]) return;
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    if (flexible == arrangedSubview.zl_flex.isFlexSpace) return;
    arrangedSubview.zl_flex.isFlexSpace = flexible;
    if (arrangedSubview.hidden) return;
    self.markedDirty = YES;
    [self setNeedsUpdateConstraints];
}
- (NSArray<NSLayoutConstraint *> *)filterConstraintWithBlock:(BOOL(^)(NSLayoutConstraint *constraint))block {
    return [self.layoutManager.constraints filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSLayoutConstraint*  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if (block) return block(evaluatedObject);
        return NO;
    }]];
}
- (void)setCustomSpacing:(CGFloat)spacing afterView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    if (![arrangedSubview isKindOfClass:UIView.class]) return;
    ZLLayoutViewFlex *viewCfg = arrangedSubview.zl_flex;
    if (viewCfg.spacing == spacing) return;
    viewCfg.spacing = spacing;
    if (arrangedSubview.hidden) return;
    if (self.layoutManager.constraints.count == 0) return;
    NSArray<NSLayoutConstraint *> * arr = [self filterConstraintWithBlock:^BOOL(NSLayoutConstraint *constraint) {
        ZLConstraintsCfg *cfg = constraint.cfg;
        return [cfg.view isEqual:arrangedSubview] && cfg.type == ZLLayoutConTypeSpacing;
    }];
    if (arr.count == 0) {
        self.markedDirty = YES;
        [self setNeedsUpdateConstraints];
    }else {
        arr.firstObject.constant = MAX(0, spacing);
    }
}
- (void)setCustomMinSpacing:(CGFloat)minSpacing afterView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    if (![arrangedSubview isKindOfClass:UIView.class]) return;
    ZLLayoutViewFlex *viewCfg = arrangedSubview.zl_flex;
    if (viewCfg.minSpacing == minSpacing) return;
    viewCfg.minSpacing = minSpacing;
    if (arrangedSubview.hidden) return;
    if (self.layoutManager.constraints.count == 0) return;
    NSArray<NSLayoutConstraint *> * arr = [self filterConstraintWithBlock:^BOOL(NSLayoutConstraint *constraint) {
        ZLConstraintsCfg *cfg = constraint.cfg;
        return [cfg.view isEqual:arrangedSubview] && cfg.type == ZLLayoutConTypeMinSpacing;
    }];
    if (arr.count > 0) {
        arr.firstObject.constant = MAX(0, minSpacing);
    }else {
        self.markedDirty = YES;
        [self setNeedsUpdateConstraints];
    }
}

- (void)setCustomMaxSpacing:(CGFloat)maxSpacing afterView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    if (![arrangedSubview isKindOfClass:UIView.class]) return;
    ZLLayoutViewFlex *viewCfg = arrangedSubview.zl_flex;
    if (viewCfg.maxSpacing == maxSpacing) return;
    viewCfg.maxSpacing = maxSpacing;
    if (arrangedSubview.hidden) return;
    if (self.layoutManager.constraints.count == 0) return;
    NSArray<NSLayoutConstraint *> * arr = [self filterConstraintWithBlock:^BOOL(NSLayoutConstraint *constraint) {
        ZLConstraintsCfg *cfg = constraint.cfg;
        return [cfg.view isEqual:arrangedSubview] && cfg.type == ZLLayoutConTypeMaxSpacing;
    }];
    if (arr.count > 0) {
        arr.firstObject.constant = MAX(0, maxSpacing);
    }else {
        self.markedDirty = YES;
        [self setNeedsUpdateConstraints];
    }
}
- (void)setFlex:(NSInteger)flex forView:(UIView *)arrangedSubview{
    ZLLayoutViewFlex *cfg = arrangedSubview.zl_flex;
    if (flex < 0 || cfg.flexValue == flex) return;
    cfg.flexValue = flex;
    self.markedDirty = YES;
    [self setNeedsUpdateConstraints];
    
}
- (void)setAlignment:(ZLAlign)alignment forView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    ZLLayoutViewFlex *cfg = arrangedSubview.zl_flex;
    if (alignment == cfg.alignSelf) return;
    cfg.alignSelf = alignment;
    self.markedDirty = YES;
    [self setNeedsUpdateConstraints];
}
///设置view的alignment方向start间距
- (void)setAlignmentStartSpacing:(CGFloat)spacing forView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    ZLLayoutViewFlex *cfg = arrangedSubview.zl_flex;
    if (spacing == cfg.startSpacing) return;
    cfg.startSpacing = spacing;
    self.markedDirty = YES;
    [self setNeedsUpdateConstraints];
}
///设置view的alignment方向end间距
- (void)setAlignmentEndSpacing:(CGFloat)spacing forView:(UIView *)arrangedSubview {
    if (![self.arrangedViews containsObject:arrangedSubview]) return;
    ZLLayoutViewFlex *cfg = arrangedSubview.zl_flex;
    if (cfg.endSpacing == spacing) return;
    cfg.endSpacing = spacing;
    self.markedDirty = YES;
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [super updateConstraints];
    if (!self.markedDirty) return;
    [self refreshArrangedSubviews];
    [self.layoutManager removeAllSpacing];
    [self.layoutManager deactivateConstraints];
    [self.layoutManager addHorizontalLayoutConstraints];
    [self.layoutManager addVerticalLayoutConstraints];
    [self.layoutManager activateConstraints];
    self.markedDirty = NO;
}
///至关重要
- (CGSize)intrinsicContentSize {
    //返回自适应
    return CGSizeZero;
}


#pragma block 调用
+ (instancetype)horizontal {
    ZLBaseStackView *stackView = [[self alloc] init];
    stackView.axis = ZLStackViewAxisHorizontal;
    return stackView;
}
+ (instancetype)vertical {
    ZLBaseStackView *stackView = [[self alloc] init];
    stackView.axis = ZLStackViewAxisVertical;
    return stackView;
}

- (instancetype)horizontal {
    if (self.axis == ZLStackViewAxisHorizontal) return self;
    self.axis = ZLStackViewAxisHorizontal;
    return self;
}
- (instancetype)vertical {
    if (self.axis == ZLStackViewAxisVertical) return self;
    self.axis = ZLStackViewAxisVertical;
    return self;
}
///纵轴对齐方式
- (instancetype)alignStart {
    if (self.alignment == ZLAlignStart) return self;
    self.alignment = ZLAlignStart;
    return self;
}
- (instancetype)alignCenter {
    if (self.alignment == ZLAlignCenter) return self;
    self.alignment = ZLAlignCenter;
    return self;
}
- (instancetype)alignEnd {
    if (self.alignment == ZLAlignEnd) return self;
    self.alignment = ZLAlignEnd;
    return self;
}
- (instancetype)alignFill {
    if (self.alignment == ZLAlignFill) return self;
    self.alignment = ZLAlignFill;
    return self;
}
///主轴对齐方式
- (instancetype)justifyStart {
    if (self.justifyContent == ZLJustifyStart) return self;
    self.justifyContent = ZLJustifyStart;
    return self;
}
- (instancetype)justifyCenter {
    if (self.justifyContent == ZLJustifyCenter) return self;
    self.justifyContent = ZLJustifyCenter;
    return self;
}
- (instancetype)justifyEnd {
    if (self.justifyContent == ZLJustifyEnd) return self;
    self.justifyContent = ZLJustifyEnd;
    return self;
}
- (instancetype)justifyFill {
    if (self.justifyContent == ZLJustifyFill) return self;
    self.justifyContent = ZLJustifyFill;
    return self;
}
- (instancetype)justifyFillEqually {
    if (self.justifyContent == ZLJustifyFillEqually) return self;
    self.justifyContent = ZLJustifyFillEqually;
    return self;
}
- (instancetype)justifySpaceBetween {
    if (self.justifyContent == ZLJustifySpaceBetween) return self;
    self.justifyContent = ZLJustifySpaceBetween;
    return self;
}
- (instancetype)justifySpaceAround {
    if (self.justifyContent == ZLJustifySpaceAround) return self;
    self.justifyContent = ZLJustifySpaceAround;
    return self;
}
- (instancetype)justifySpaceEvenly {
    if (self.justifyContent == ZLJustifySpaceEvenly) return self;
    self.justifyContent = ZLJustifySpaceEvenly;
    return self;
}
- (id _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))inset {
    return ^(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing){
        self.insets = UIEdgeInsetsMake(top, leading, bottom, trailing);
        return self;
    };
}
- (id _Nonnull (^)(CGFloat, CGFloat))hInset {
    return ^(CGFloat l, CGFloat t){
        self.insets = UIEdgeInsetsMake(self.insets.top, l, self.insets.bottom, t);
        return self;
    };
}
- (id _Nonnull (^)(CGFloat, CGFloat))vInset {
    return ^(CGFloat t, CGFloat b){
        self.insets = UIEdgeInsetsMake(t, self.insets.left, b, self.insets.right);
        return self;
    };
}
- (id _Nonnull (^)(CGFloat))space {
    return ^(CGFloat spacing){
        self.spacing = spacing;
        return self;
    };
}

- (id _Nonnull (^)(CGFloat))insertSpace {
    return ^(CGFloat spacing){
        self.allViews.lastObject.zl_flex.spacing = spacing;
        return self;
    };
}
- (id _Nonnull (^)(CGFloat))insertMinSpace {
    return ^(CGFloat spacing){
        self.allViews.lastObject.zl_flex.minSpacing = spacing;
        return self;
    };
}
- (id _Nonnull (^)(CGFloat))insertMaxSpace {
    return ^(CGFloat spacing){
        self.allViews.lastObject.zl_flex.maxSpacing = spacing;
        return self;
    };
}
- (id _Nonnull (^)(BOOL))insertFlexSpace {
    return ^(BOOL flexible){
        self.allViews.lastObject.zl_flex.isFlexSpace = flexible;
        return self;
    };
}
- (id _Nonnull (^)(UIView * _Nonnull))add {
    return ^(UIView *view){
        [self addArrangedSubview:view];
        return self;
    };
}
- (id _Nonnull (^)(UIView * _Nonnull, void (^ _Nonnull)(__kindof UIView * _Nonnull, ZLLayoutViewFlex * _Nonnull)))addLayout {
    return ^(UIView *view, void (^config)(__kindof UIView *, ZLLayoutViewFlex *)){
        [self addArrangedSubview:view layout:config];
        return self;
    };
}
- (id _Nonnull (^)(UIView * _Nonnull, CGFloat))spacingAfter {
    return ^(UIView *view, CGFloat spacing){
        [self setCustomSpacing:spacing afterView:view];
        return self;
    };
}
- (id _Nonnull (^)(UIView * _Nonnull, CGFloat))minSpacingAfter {
    return ^(UIView *view, CGFloat spacing){
        [self setCustomMinSpacing:spacing afterView:view];
        return self;
    };
}
- (id _Nonnull (^)(UIView * _Nonnull, CGFloat))maxSpacingAfter {
    return ^(UIView *view, CGFloat spacing){
        [self setCustomMaxSpacing:spacing afterView:view];
        return self;
    };
}
- (id _Nonnull (^)(UIView * _Nonnull, NSInteger))flexFor {
    return ^(UIView *view, NSInteger flex){
        [self setFlex:flex forView:view];
        return self;
    };
}
- (id _Nonnull (^)(UIView * _Nonnull, BOOL))flexSpacingAfter {
    return ^(UIView *view, BOOL flexible){
        [self setFlexibleSpacing:flexible afterView:view];
        return self;
    };
}
- (id _Nonnull (^)(UIView * _Nonnull, ZLAlign))alignFor {
    return ^(UIView *view, ZLAlign alignment){
        [self setAlignment:alignment forView:view];
        return self;
    };
}
- (id _Nonnull (^)(UIView * _Nonnull, CGFloat))alignStartSpacingFor {
    return ^(UIView *view, CGFloat spacing){
        [self setAlignmentStartSpacing:spacing forView:view];
        return self;
    };
}
- (id _Nonnull (^)(UIView * _Nonnull, CGFloat))alignEndSpacingFor {
    return ^(UIView *view, CGFloat spacing){
        [self setAlignmentEndSpacing:spacing forView:view];
        return self;
    };
}
- (id _Nonnull (^)(ZLBaseStackView * _Nullable __autoreleasing * _Nullable))assignToPtr {
    return ^(ZLBaseStackView **ptr){
        if (ptr) *ptr = self;
        return self;
    };
}
- (id  _Nonnull (^)(void (^ _Nonnull)(ZLBaseStackView * _Nonnull)))tapAction {
    return ^(void (^action)(ZLBaseStackView *stackView)){
        self.KFC.tapAction(action);
        return self;
    };
}
- (id  _Nonnull (^)(BOOL))visibility {
    return ^ZLBaseStackView* (BOOL visible) {
        self.hidden = !visible;
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat))alphaValue {
    return ^ZLBaseStackView* (CGFloat alpha) {
        self.alpha = alpha;
        return self;
    };
}
- (id  _Nonnull (^)(BOOL))userActive {
    return ^ZLBaseStackView* (BOOL userInteraction) {
        self.userInteractionEnabled = userInteraction;
        return self;
    };
}
- (id _Nonnull (^)(id _Nonnull))bgColor {
    return ^(id color) {
        self.backgroundColor = ZLColorFromObj(color);
        return self;
    };
}

- (id _Nonnull (^)(CGFloat))corner {
    return ^ZLBaseStackView*(CGFloat radius){
        self.layer.cornerRadius = radius;
        self.layer.masksToBounds = radius > 0;
        return self;
    };
}
- (id  _Nonnull (^)(CACornerMask))corners {
    return ^ZLBaseStackView* (CACornerMask corners) {
        self.layer.maskedCorners = corners;
        return self;
    };
}
- (BOOL)_zl_isRTL {
    
    if (@available(iOS 10.0, *)) {
        return self.effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
    }
    return [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
}



- (id (^)(id ))borderColor {
    return  ^ZLBaseStackView*(id color){
        self.layer.borderColor = ZLColorFromObj(color).CGColor;
        return self;
    };
}
- (id (^)(CGFloat ))borderWidth {
    return  ^ZLBaseStackView*(CGFloat width){
        self.layer.borderWidth = width;
        return self;
    };
}
- (id _Nonnull (^)(CGFloat, id _Nonnull))border {
    return ^ZLBaseStackView*(CGFloat width, id color){
        self.borderWidth(width);
        self.borderColor(color);
        return self;
    };
}
- (id  _Nonnull (^)(id _Nonnull))shColor {
    return ^ZLBaseStackView* (id color) {
        self.layer.shadowColor = ZLColorFromObj(color).CGColor;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowRadius = 8;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.masksToBounds = NO;
        return self;
    };
}


- (id  _Nonnull (^)(CGFloat, CGFloat))shOffset {
    return ^ZLBaseStackView* (CGFloat width, CGFloat height) {
        self.layer.shadowOffset = CGSizeMake(width, height);
        return self;
    };
}


- (id  _Nonnull (^)(CGFloat))shRadius {
    return ^ZLBaseStackView* (CGFloat radius) {
        self.layer.shadowRadius = radius;
        return self;
    };
}

- (id  _Nonnull (^)(CGFloat))shOpacity {
    return ^ZLBaseStackView* (CGFloat opacity) {
        self.layer.shadowOpacity = opacity;
        return self.masksToBounds(NO);
    };
}
- (id  _Nonnull (^)(BOOL))masksToBounds {
    return ^ZLBaseStackView* (BOOL masks) {
        self.layer.masksToBounds = masks;
        return self;
    };
}
- (id _Nonnull (^)(CGFloat))centerX {
    return ^(CGFloat centerX){
         self.KFC.centerX(centerX);
        return self;
    };
}
- (id _Nonnull (^)(CGFloat))centerY {
    return ^(CGFloat centerY){
         self.KFC.centerY(centerY);
         return self;
    };
}

- (id _Nonnull (^)(CGFloat, CGFloat))centerOffset {
    return ^(CGFloat centerX, CGFloat centerY){
        self.centerX(centerX);
        self.centerY(centerY);
        return self;
    };
}
- (id _Nonnull (^)(CGFloat))top {
    return ^(CGFloat top){
        self.KFC.top(top);
        return self;
    };
}
- (id _Nonnull (^)(CGFloat))leading {
    return ^(CGFloat leading){
        self.KFC.leading(leading);
        return self;
    };
}
- (id _Nonnull (^)(CGFloat))bottom {
    return ^(CGFloat bottom){
        self.KFC.bottom(bottom);
        return self;
    };
}
- (id _Nonnull (^)(CGFloat))trailing {
    return ^(CGFloat trailling){
        self.KFC.trailing(trailling);
        return self;
    };
}
- (id _Nonnull (^)(CGFloat))height {
    return ^(CGFloat height) {
        self.KFC.height(height);
        return self;
    };
}
- (id _Nonnull (^)(CGFloat))width {
    return ^(CGFloat width) {
        self.KFC.width(width);
        return self;
    };
}
- (id _Nonnull (^)(CGFloat, CGFloat))size {
    return ^(CGFloat width, CGFloat height) {
        self.KFC.size(width, height);
        return self;
    };
}
- (id _Nonnull (^)(CGFloat))square {
    return ^(CGFloat side) {
        self.KFC.square(side);
        return self;
    };
}
- (id _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))edge {
    return ^(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing) {
        self.KFC.edge(top, leading, bottom, trailing);
        return self;
    };
}
- (id _Nonnull (^)(void))edgesZero {
    return ^() {
        self.KFC.edgesZero();
        return self;
    };
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
- (id _Nonnull (^)(UIView * _Nonnull))addSubview {
    return ^(UIView *subview){
        if ([subview isKindOfClass:UIView.class]) {
            [self addSubview:subview];
        }
        return self;
    };
}
@end


@implementation ZLStackView

@end
