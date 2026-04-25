//
//  ZLUI.m
//  Pods
//
//  Created by admin on 2026/4/24.
//

#import "ZLUI.h"
#import <objc/runtime.h>
@interface ZLUITapGestureRecognizer : UITapGestureRecognizer
@property (nonatomic, copy) void (^tapAction)(ZLUITapGestureRecognizer *tapGesture);
@end
@implementation ZLUITapGestureRecognizer
- (instancetype)init
{
    self = [super initWithTarget:self action:@selector(tapAction:)];
    return self;
}
- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (self.tapAction) self.tapAction(self);
}
@end

@interface ZLUI()

@end

@implementation ZLUI
- (ZLUI * _Nonnull (^)(CGFloat))centerX {
    return ^(CGFloat centerX){
        UIView *superview = self.view.superview;
        if (!superview) return self;
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.view.centerXAnchor constraintEqualToAnchor:superview.centerXAnchor constant:centerX],
        ]];
        return self;
    };
}
- (ZLUI * _Nonnull (^)(CGFloat))centerY {
    return ^(CGFloat centerY){
        UIView *superview = self.view.superview;
        if (!superview) return self;
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.view.centerYAnchor constraintEqualToAnchor:superview.centerYAnchor constant:centerY],
        ]];
        return self;
    };
}
- (ZLUI * _Nonnull (^)(void))center {
    return ^(){
        return self.centerX(0).centerY(0);
    };
}
- (ZLUI * _Nonnull (^)(CGFloat, CGFloat))centerOffset {
    return ^(CGFloat centerX, CGFloat centerY){
        return self.centerX(centerX).centerY(centerY);
    };
}
- (ZLUI * _Nonnull (^)(CGFloat))top {
    return ^(CGFloat top){
        UIView *superview = self.view.superview;
        if (!superview) return self;
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.view.topAnchor constraintEqualToAnchor:superview.topAnchor constant:top],
        ]];
        return self;
    };
}
- (ZLUI * _Nonnull (^)(CGFloat))leading {
    return ^(CGFloat leading){
        UIView *superview = self.view.superview;
        if (!superview) return self;
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.view.leadingAnchor constraintEqualToAnchor:superview.leadingAnchor constant:leading],
        ]];
        return self;
    };
}
- (ZLUI * _Nonnull (^)(CGFloat))bottom {
    return ^(CGFloat bottom){
        UIView *superview = self.view.superview;
        if (!superview) return self;
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.view.bottomAnchor constraintEqualToAnchor:superview.bottomAnchor constant:-bottom],
        ]];
        return self;
    };
}
- (ZLUI * _Nonnull (^)(CGFloat))trailing {
    return ^(CGFloat trailling){
        UIView *superview = self.view.superview;
        if (!superview) return self;
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.view.trailingAnchor constraintEqualToAnchor:superview.trailingAnchor constant:-trailling],
        ]];
        return self;
    };
}
- (ZLUI * _Nonnull (^)(CGFloat))height {
    return ^(CGFloat height){
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self deactivieConstraints:NSLayoutAttributeHeight relation:NSLayoutRelationEqual];
        [self.view.heightAnchor constraintEqualToConstant:height].active = YES;
        return self;
    };
}
- (ZLUI * _Nonnull (^)(CGFloat))width {
    return ^(CGFloat width){
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self deactivieConstraints:NSLayoutAttributeWidth relation:NSLayoutRelationEqual];
        [self.view.widthAnchor constraintEqualToConstant:width].active = YES;
        return self;
        };
}
- (ZLUI * _Nonnull (^)(CGFloat, CGFloat))size {
    return ^(CGFloat width, CGFloat height){
        return self.width(width).height(height);
    };
}
- (ZLUI * _Nonnull (^)(CGFloat))square {
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
- (ZLUI * _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))edge {
    return ^(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing){
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        UIView *superview = self.view.superview;
        if (!superview) return self;
        [NSLayoutConstraint activateConstraints:@[
            [self.view.topAnchor constraintEqualToAnchor:superview.topAnchor constant:top],
            [self.view.leadingAnchor constraintEqualToAnchor:superview.leadingAnchor constant:leading],
            [self.view.bottomAnchor constraintEqualToAnchor:superview.bottomAnchor constant:bottom],
            [self.view.trailingAnchor constraintEqualToAnchor:superview.trailingAnchor constant:trailing],
        ]];
        return self;
    };
}
- (ZLUI * _Nonnull (^)(CGFloat))inset {
    return ^(CGFloat inset){
        return self.edge(inset, inset, inset, inset);
    };
}
- (ZLUI * _Nonnull (^)(void))edgesZero {
    return ^(){
        return self.edge(0, 0, 0, 0);
    };
}

- (ZLUI * _Nonnull (^)(void (^ _Nonnull)(__kindof UIView * _Nonnull)))tapAction {
    return ^(void (^tapAction)(__kindof UIView *view)) {
        if (tapAction) {
            self.view.userInteractionEnabled = YES;
            ZLUITapGestureRecognizer *tapGes = objc_getAssociatedObject(self, _cmd);
            if (!tapGes) {
                tapGes = [[ZLUITapGestureRecognizer alloc] init];
                tapGes.tapAction = ^(ZLUITapGestureRecognizer *tapGesture) {
                    tapAction(self.view);
                };
                [self.view addGestureRecognizer:tapGes];
                objc_setAssociatedObject(self, _cmd, tapGes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }else {
            ZLUITapGestureRecognizer *tapGes = objc_getAssociatedObject(self, _cmd);
            if (tapGes) {
                [self.view removeGestureRecognizer:tapGes];
                objc_setAssociatedObject(self, _cmd, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return self;
    };
}
- (ZLUI * _Nonnull (^)(UIView * _Nonnull))addTo {
    return ^(UIView *superview){
        if ([superview isKindOfClass:UIView.class]) {
            [superview addSubview:self.view];
        }
        return self;
    };
}

- (ZLUI * _Nonnull (^)(UIView * _Nonnull))addToFull {
    return ^(UIView *superview){
        if ([superview isKindOfClass:UIView.class]) {
            [superview addSubview:self.view];
            self.edgesZero();
        }
        return self;
    };
}
- (ZLUI * _Nonnull (^)(UIView * _Nonnull))addSubview {
    return ^(UIView *subview){
        if ([subview isKindOfClass:UIView.class]) {
            [self.view addSubview:subview];
        }
        return self;
    };
}
- (UIView * _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))wrapEdges {
    return ^(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing){
        UIView *view = UIView.new;
        self.addTo(view).edge(top, leading, bottom, trailing);
        return view;
    };
}
@end

@implementation UIView (ZLUI)
- (ZLUI *)KFC {
    ZLUI *layoutObj = objc_getAssociatedObject(self, _cmd);
    if (!layoutObj) {
        layoutObj = ZLUI.new;
        layoutObj.view = self;
        objc_setAssociatedObject(self, _cmd, layoutObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return layoutObj;
}

@end
