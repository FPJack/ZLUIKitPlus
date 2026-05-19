//
//  ZLLayout.m
//  Pods
//
//  Created by admin on 2026/4/24.
//

#import "ZLLayout.h"
#import <objc/runtime.h>

@implementation UIView (ZLLayout)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method origin =
        class_getInstanceMethod(self, @selector(updateConstraints));
        Method swizzle =
        class_getInstanceMethod(self, @selector(zl_updateConstraints));
        method_exchangeImplementations(origin, swizzle);
    });
}

- (void)zl_updateConstraints {
    NSMutableArray<NSLayoutConstraint *> *constraints = self.zl_constraints;
    if ([constraints isKindOfClass:NSArray.class] && constraints.count > 0) {
         NSArray *arr = [constraints filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"active == NO"]];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:arr];
    }
    [self zl_updateConstraints];
}
- (NSMutableArray *)zl_constraints {
    return  objc_getAssociatedObject(self, _cmd);
}
- (void)set_zl_constraints:(NSMutableArray *)constraints {
    if ([constraints isKindOfClass:NSArray.class]) {
        objc_setAssociatedObject(self, @selector(zl_constraints), constraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
- (ZLLayout *)zl_layout {
    ZLLayout *layoutObj = objc_getAssociatedObject(self, _cmd);
    if (!layoutObj) {
        layoutObj = ZLLayout.new;
        layoutObj.view = self;
        objc_setAssociatedObject(self, _cmd, layoutObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return layoutObj;
}
@end




@interface ZLLayoutTapGestureRecognizer : UITapGestureRecognizer
@property (nonatomic, copy) void (^tapAction)(ZLLayoutTapGestureRecognizer *tapGesture);
@end
@implementation ZLLayoutTapGestureRecognizer
- (instancetype)init
{
    self = [super initWithTarget:self action:@selector(tapAction:)];
    return self;
}
- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (self.tapAction) self.tapAction(self);
}
@end

@interface ZLLayout()
@property (nonatomic,strong)NSMutableArray *constraints;
@end

@implementation ZLLayout
- (NSMutableArray *)constraints {
    if (!_constraints) {
        _constraints = [NSMutableArray array];
        [self.view set_zl_constraints:_constraints];
    }
    return _constraints;
}
- (ZLLayout * _Nonnull (^)(CGFloat))centerX {
    return ^(CGFloat centerX){
        return self.centerXTo(self.view.superview.centerXAnchor, centerX);
    };
}
- (ZLLayout * _Nonnull (^)(NSLayoutXAxisAnchor * _Nonnull, CGFloat))centerXTo {
    return ^(NSLayoutXAxisAnchor *anchor, CGFloat centerX){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view.centerXAnchor constraintEqualToAnchor:anchor constant:centerX].active = YES;
        if (anchor) {
            [self addConstraint:[self.view.centerXAnchor constraintEqualToAnchor:anchor constant:centerX]];
        }
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(NSLayoutXAxisAnchor * _Nonnull, CGFloat))centerXGreaterThanOrTo {
    return ^(NSLayoutXAxisAnchor *anchor, CGFloat centerX){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view.centerXAnchor constraintGreaterThanOrEqualToAnchor:anchor constant:centerX].active = YES;
        if (anchor) {
            [self addConstraint:[self.view.centerXAnchor constraintGreaterThanOrEqualToAnchor:anchor constant:centerX]];
        }
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(NSLayoutXAxisAnchor * _Nonnull, CGFloat))centerXLessThanOrTo {
    return ^(NSLayoutXAxisAnchor *anchor, CGFloat centerX){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view.centerXAnchor constraintLessThanOrEqualToAnchor:anchor constant:centerX].active = YES;
        if (anchor) {
            [self addConstraint:[self.view.centerXAnchor constraintLessThanOrEqualToAnchor:anchor constant:centerX]];
        }
       
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(CGFloat))centerY {
    return ^(CGFloat centerY){
        return self.centerYTo(self.view.superview.centerYAnchor, centerY);
    };
}
- (ZLLayout * _Nonnull (^)(NSLayoutYAxisAnchor * _Nonnull, CGFloat))centerYTo {
    return ^(NSLayoutYAxisAnchor *anchor, CGFloat centerY){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view.centerYAnchor constraintEqualToAnchor:anchor constant:centerY].active = YES;
        if (anchor) {
            [self addConstraint:[self.view.centerYAnchor constraintEqualToAnchor:anchor constant:centerY]];
        }
        
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(NSLayoutYAxisAnchor * _Nonnull, CGFloat))centerYGreaterThanOrTo {
    return ^(NSLayoutYAxisAnchor *anchor, CGFloat centerY){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view.centerYAnchor constraintGreaterThanOrEqualToAnchor:anchor constant:centerY].active = YES;
        if (anchor) {
            [self addConstraint:[self.view.centerYAnchor constraintGreaterThanOrEqualToAnchor:anchor constant:centerY]];
        }
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(NSLayoutYAxisAnchor * _Nonnull, CGFloat))centerYLessThanOrTo {
    return ^(NSLayoutYAxisAnchor *anchor, CGFloat centerY){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view.centerYAnchor constraintLessThanOrEqualToAnchor:anchor constant:centerY].active = YES;
        if (anchor) {
            [self addConstraint:[self.view.centerYAnchor constraintLessThanOrEqualToAnchor:anchor constant:centerY]];
        }
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(void))center {
    return ^(){
        return self.centerX(0).centerY(0);
    };
}
- (ZLLayout * _Nonnull (^)(CGFloat, CGFloat))centerOffset {
    return ^(CGFloat centerX, CGFloat centerY){
        return self.centerX(centerX).centerY(centerY);
    };
}
- (ZLLayout * _Nonnull (^)(CGFloat))top {
    return ^(CGFloat top){
        return self.topTo(self.view.superview.topAnchor, top);
    };
}
- (ZLLayout * _Nonnull (^)(NSLayoutYAxisAnchor * _Nonnull, CGFloat))topTo {
    return ^(NSLayoutYAxisAnchor *anchor, CGFloat top){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view.topAnchor constraintEqualToAnchor:anchor constant:top].active = YES;
        if (anchor) {
            [self addConstraint:[self.view.topAnchor constraintEqualToAnchor:anchor constant:top]];
        }
       
        return self;
    };
}
- (void)addConstraint:(NSLayoutConstraint *)constraint {
    if (constraint) {
        [self.constraints addObject:constraint];
        [self setNeedsUpdateConstraints];
    }
}
- (void)setNeedsUpdateConstraints {
    if (![self.view needsUpdateConstraints]) {
        [self.view setNeedsUpdateConstraints];
    }
}
- (ZLLayout * _Nonnull (^)(NSLayoutYAxisAnchor * _Nonnull, CGFloat))topGreaterThanOrTo {
    return ^(NSLayoutYAxisAnchor *anchor, CGFloat top){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view.topAnchor constraintGreaterThanOrEqualToAnchor:anchor constant:top].active = YES;
        if (anchor) {
            [self addConstraint:[self.view.topAnchor constraintGreaterThanOrEqualToAnchor:anchor constant:top]];
        }
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(NSLayoutYAxisAnchor * _Nonnull, CGFloat))topLessThanOrTo {
    return ^(NSLayoutYAxisAnchor *anchor, CGFloat top){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view.topAnchor constraintLessThanOrEqualToAnchor:anchor constant:top].active = YES;
        if (anchor) {
            [self addConstraint:[self.view.topAnchor constraintLessThanOrEqualToAnchor:anchor constant:top]];
        }
       
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(CGFloat))leading {
    return ^(CGFloat leading){
        return self.leadingTo(self.view.superview.leadingAnchor, leading);
    };
}
- (ZLLayout * _Nonnull (^)(NSLayoutXAxisAnchor * _Nonnull, CGFloat))leadingTo {
    return ^(NSLayoutXAxisAnchor *anchor, CGFloat leading){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view.leadingAnchor constraintEqualToAnchor:anchor constant:leading].active = YES;
        if (anchor) {
            [self addConstraint:[self.view.leadingAnchor constraintEqualToAnchor:anchor constant:leading]];
        }
      
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(NSLayoutXAxisAnchor * _Nonnull, CGFloat))leadingGreaterThanOrTo {
    return ^(NSLayoutXAxisAnchor *anchor, CGFloat leading){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view.leadingAnchor constraintGreaterThanOrEqualToAnchor:anchor constant:leading].active = YES;
        if (anchor) {
            [self addConstraint:[self.view.leadingAnchor constraintGreaterThanOrEqualToAnchor:anchor constant:leading]];
        }
       
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(NSLayoutXAxisAnchor * _Nonnull, CGFloat))leadingLessThanOrTo {
    return ^(NSLayoutXAxisAnchor *anchor, CGFloat leading){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view.leadingAnchor constraintLessThanOrEqualToAnchor:anchor constant:leading].active = YES;
        if (anchor) {
            [self addConstraint:[self.view.leadingAnchor constraintLessThanOrEqualToAnchor:anchor constant:leading]];
        }
       
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(CGFloat))bottom {
    return ^(CGFloat bottom){
        return self.bottomTo(self.view.superview.bottomAnchor, bottom);
    };
}
- (ZLLayout * _Nonnull (^)(NSLayoutYAxisAnchor * _Nonnull, CGFloat))bottomTo {
    return ^(NSLayoutYAxisAnchor *anchor, CGFloat bottom){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view.bottomAnchor constraintEqualToAnchor:anchor constant:bottom].active = YES;
        if (anchor) {
            [self addConstraint:[self.view.bottomAnchor constraintEqualToAnchor:anchor constant:bottom]];
        }
       
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(NSLayoutYAxisAnchor * _Nonnull, CGFloat))bottomGreaterThanOrTo {
    return ^(NSLayoutYAxisAnchor *anchor, CGFloat bottom){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view.bottomAnchor constraintGreaterThanOrEqualToAnchor:anchor constant:bottom].active = YES;
        if (anchor) {
            [self addConstraint:[self.view.bottomAnchor constraintGreaterThanOrEqualToAnchor:anchor constant:bottom]];
        }
        
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(NSLayoutYAxisAnchor * _Nonnull, CGFloat))bottomLessThanOrTo {
    return ^(NSLayoutYAxisAnchor *anchor, CGFloat bottom){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view.bottomAnchor constraintLessThanOrEqualToAnchor:anchor constant:bottom].active = YES;
        if (anchor) {
            [self addConstraint:[self.view.bottomAnchor constraintLessThanOrEqualToAnchor:anchor constant:bottom]];
        }
       
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(CGFloat))trailing {
    return ^(CGFloat trailling){
        return self.trailingTo(self.view.superview.trailingAnchor, trailling);
    };
}
- (ZLLayout * _Nonnull (^)(NSLayoutXAxisAnchor * _Nonnull, CGFloat))trailingTo {
    return ^(NSLayoutXAxisAnchor *anchor, CGFloat trailling){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view.trailingAnchor constraintEqualToAnchor:anchor constant:trailling].active = YES;
        if (anchor) {
            [self addConstraint:[self.view.trailingAnchor constraintEqualToAnchor:anchor constant:trailling]];
        }
        
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(CGFloat))height {
    return ^(CGFloat height){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self deactivieConstraints:NSLayoutAttributeHeight relation:NSLayoutRelationEqual];
//        [self.view.heightAnchor constraintEqualToConstant:height].active = YES;
        [self addConstraint:[self.view.heightAnchor constraintEqualToConstant:height]];
      
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(NSLayoutDimension * _Nonnull))heightTo {
    return ^(NSLayoutDimension *anchor){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self deactivieConstraints:NSLayoutAttributeHeight relation:NSLayoutRelationEqual];
//        [self.view.heightAnchor constraintEqualToAnchor:anchor].active = YES;
        [self addConstraint:[self.view.heightAnchor constraintEqualToAnchor:anchor]];
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(CGFloat))minHeight {
    return ^(CGFloat minHeight){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self deactivieConstraints:NSLayoutAttributeHeight relation:NSLayoutRelationGreaterThanOrEqual];
//        [self.view.heightAnchor constraintGreaterThanOrEqualToConstant:minHeight].active = YES;
        [self addConstraint:[self.view.heightAnchor constraintGreaterThanOrEqualToConstant:minHeight]];
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(CGFloat))maxHeight {
    return ^(CGFloat maxHeight){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self deactivieConstraints:NSLayoutAttributeHeight relation:NSLayoutRelationLessThanOrEqual];
//        [self.view.heightAnchor constraintLessThanOrEqualToConstant:maxHeight].active = YES;
        [self addConstraint:[self.view.heightAnchor constraintLessThanOrEqualToConstant:maxHeight]];
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(CGFloat))width {
    return ^(CGFloat width){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self deactivieConstraints:NSLayoutAttributeWidth relation:NSLayoutRelationEqual];
//        [self.view.widthAnchor constraintEqualToConstant:width].active = YES;
        [self addConstraint:[self.view.widthAnchor constraintEqualToConstant:width]];
        return self;
        };
}
- (ZLLayout * _Nonnull (^)(NSLayoutDimension * _Nonnull))widthTo {
    return ^(NSLayoutDimension *anchor){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self deactivieConstraints:NSLayoutAttributeWidth relation:NSLayoutRelationEqual];
//        [self.view.widthAnchor constraintEqualToAnchor:anchor].active = YES;
        [self addConstraint:[self.view.widthAnchor constraintEqualToAnchor:anchor]];
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(CGFloat))minWidth {
    return ^(CGFloat minWidth){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self deactivieConstraints:NSLayoutAttributeWidth relation:NSLayoutRelationGreaterThanOrEqual];
//        [self.view.widthAnchor constraintGreaterThanOrEqualToConstant:minWidth].active = YES;
        [self addConstraint: [self.view.widthAnchor constraintGreaterThanOrEqualToConstant:minWidth]];
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(CGFloat))maxWidth {
    return ^(CGFloat maxWidth){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [self deactivieConstraints:NSLayoutAttributeWidth relation:NSLayoutRelationLessThanOrEqual];
//        [self.view.widthAnchor constraintLessThanOrEqualToConstant:maxWidth].active = YES;
        [self addConstraint: [self.view.widthAnchor constraintLessThanOrEqualToConstant:maxWidth]];
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(CGFloat, CGFloat))size {
    return ^(CGFloat width, CGFloat height){
        return self.width(width).height(height);
    };
}
- (ZLLayout * _Nonnull (^)(CGFloat))square {
    return ^(CGFloat side){
        return self.size(side, side);
    };
}
- (void)deactivieConstraints:(NSLayoutAttribute)attribute relation:(NSLayoutRelation)relation {
    [self.view.constraints enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof NSLayoutConstraint * _Nonnull constraint, NSUInteger idx, BOOL * _Nonnull stop) {
        if (constraint.firstAttribute == attribute &&
            [constraint.firstItem isEqual:self] &&
            constraint.relation == relation &&
            constraint.secondItem == nil) {
            constraint.active = NO;
            [self.view removeConstraint:constraint];
        }
    }];
}
- (ZLLayout * _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))edges {
    return ^(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing){
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        UIView *superview = self.view.superview;
//        [NSLayoutConstraint activateConstraints:@[
//            [self.view.topAnchor constraintEqualToAnchor:superview.topAnchor constant:top],
//            [self.view.leadingAnchor constraintEqualToAnchor:superview.leadingAnchor constant:leading],
//            [self.view.bottomAnchor constraintEqualToAnchor:superview.bottomAnchor constant:-bottom],
//            [self.view.trailingAnchor constraintEqualToAnchor:superview.trailingAnchor constant:-trailing],
//        ]];
        [self addConstraint:[self.view.topAnchor constraintEqualToAnchor:superview.topAnchor constant:top]];
        [self addConstraint:[self.view.leadingAnchor constraintEqualToAnchor:superview.leadingAnchor constant:leading]];
        [self addConstraint:[self.view.bottomAnchor constraintEqualToAnchor:superview.bottomAnchor constant:-bottom]];
        [self addConstraint:[self.view.trailingAnchor constraintEqualToAnchor:superview.trailingAnchor constant:-trailing]];
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(CGFloat))allEdges {
    return ^(CGFloat inset){
        return self.edges(inset, inset, inset, inset);
    };
}
- (ZLLayout * _Nonnull (^)(void))edgesZero {
    return ^(){
        return self.edges(0, 0, 0, 0);
    };
}

- (ZLLayout * _Nonnull (^)(void (^ _Nonnull)(__kindof UIView * _Nonnull)))tapAction {
    return ^(void (^tapAction)(__kindof UIView *view)) {
        if (tapAction) {
            self.view.userInteractionEnabled = YES;
            ZLLayoutTapGestureRecognizer *tapGes = objc_getAssociatedObject(self, _cmd);
            if (!tapGes) {
                tapGes = [[ZLLayoutTapGestureRecognizer alloc] init];
                tapGes.tapAction = ^(ZLLayoutTapGestureRecognizer *tapGesture) {
                    tapAction(self.view);
                };
                [self.view addGestureRecognizer:tapGes];
                objc_setAssociatedObject(self, _cmd, tapGes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }else {
            ZLLayoutTapGestureRecognizer *tapGes = objc_getAssociatedObject(self, _cmd);
            if (tapGes) {
                [self.view removeGestureRecognizer:tapGes];
                objc_setAssociatedObject(self, _cmd, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(UIView * _Nonnull))addTo {
    return ^(UIView *superview){
        if ([superview isKindOfClass:UIView.class]) {
            [superview addSubview:self.view];
        }
        return self;
    };
}

- (ZLLayout * _Nonnull (^)(UIView * _Nonnull))addToFull {
    return ^(UIView *superview){
        if ([superview isKindOfClass:UIView.class]) {
            [superview addSubview:self.view];
            self.edgesZero();
        }
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(UIView * _Nonnull))addSubview {
    return ^(UIView *subview){
        if ([subview isKindOfClass:UIView.class]) {
            [self.view addSubview:subview];
        }
        return self;
    };
}
- (ZLLayout * _Nonnull (^)(UIView * _Nonnull, void (^ _Nonnull)(ZLLayout * _Nonnull)))addSubviewLayout {
    return ^(UIView *subview, void (^layout)(ZLLayout *layoutObj)) {
        if ([subview isKindOfClass:UIView.class]) {
            [self.view addSubview:subview];
            if (layout) {
                layout(subview.zl_layout);
            }
        }
        return self;
    };
}
- (instancetype)clear {
    [NSLayoutConstraint deactivateConstraints:self.constraints];
    [self.constraints removeAllObjects];
    return self;
}
@end



