//
//  ZLFlexItem.m
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/5/4.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLFlexItem.h"
#import "ZLStackView.h"
#import <objc/runtime.h>
#import "ZLLayout.h"
#import "ZLFlexManager.h"
#import "ZLConstraintItem.h"

@implementation UIView (Flex)
- (ZLFlexItem *)zl_flex {
    ZLFlexItem *cfg = objc_getAssociatedObject(self, _cmd);
    if (!cfg) {
        cfg = ZLFlexItem.new;
        objc_setAssociatedObject(self, _cmd, cfg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cfg;
}
@end
@interface ZLFlexItem()
///是否设置对齐方式
@property (nonatomic,assign)BOOL isSetAlign;
///记录已kvo
@property (nonatomic,assign)BOOL isKVOAdded;
@property (nonatomic,weak)ZLStackView *stackView;
@property (nonatomic,weak,readwrite)UIView *view;
@end
@implementation ZLFlexItem
@synthesize alignSelf = _alignSelf;
@synthesize spacing = _spacing;
- (void)setAlignSelf:(ZLAlign)alignSelf {
    self.isSetAlign = YES;
    if (alignSelf == _alignSelf) return;
    _alignSelf = alignSelf;
    [self setStackViewNeedsUpdateConstraints];
}
- (ZLAlign)alignSelf {
    return self.isSetAlign ? _alignSelf : self.stackView.alignment;
}


- (void)setSpacing:(CGFloat)spacing {
    if (spacing == _spacing) return;
    _spacing = spacing;
    [self setStackViewNeedsUpdateConstraints];
}
- (CGFloat)spacing {
    if (_spacing > 0) return _spacing;
    return self.stackView.spacing;
}
- (NSArray<NSLayoutConstraint *> *)filterConstraintWithBlock:(BOOL(^)(NSLayoutConstraint *constraint))block {
    if (!self.stackView) return nil;
    ZLFlexManager *manager = [self.stackView valueForKey:@"layoutManager"];
    if (manager.constraints.count == 0) {
        return nil;
    }
    return [manager.constraints filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSLayoutConstraint*  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if (block) return block(evaluatedObject);
        return NO;
    }]];
}

- (void)setStartSpacing:(CGFloat)startSpacing {
    if (startSpacing == _startSpacing) return;
    _startSpacing = startSpacing;
    NSArray<NSLayoutConstraint *> * arr = [self filterConstraintWithBlock:^BOOL(NSLayoutConstraint *constraint) {
        ZLConstraintItem *cfg = constraint.item;
        return [cfg.view isEqual:self.view] && cfg.type == ZLLayoutConTypeStart;
    }];
    NSLayoutConstraint *cons = arr.firstObject;
    if (cons) {
        CGFloat insetStart = self.stackView.axis == ZLStackViewAxisHorizontal ? self.stackView.insets.top : self.stackView.insets.left;
        cons.constant = startSpacing + insetStart;
        if (self.alignSelf == ZLAlignCenter) {
            NSLayoutConstraint *centerCons = [self filterConstraintWithBlock:^BOOL(NSLayoutConstraint *constraint) {
                ZLConstraintItem *cfg = constraint.item;
                return [cfg.view isEqual:self.view] && cfg.type == ZLLayoutConTypeCenter;
            }].firstObject;
            if (centerCons) {
                centerCons.constant = (startSpacing - self.endSpacing) * 0.5;
            }
        }
    }else {
        [self setStackViewNeedsUpdateConstraints];
    }
}
- (void)setEndSpacing:(CGFloat)endSpacing {
    if (endSpacing == _endSpacing) return;
    _endSpacing = endSpacing;
    NSArray<NSLayoutConstraint *> * arr = [self filterConstraintWithBlock:^BOOL(NSLayoutConstraint *constraint) {
        ZLConstraintItem *cfg = constraint.item;
        return [cfg.view isEqual:self.view] && cfg.type == ZLLayoutConTypeEnd;
    }];
    
    NSLayoutConstraint *cons = arr.firstObject;
    if (cons) {
        CGFloat insetEnd = self.stackView.axis == ZLStackViewAxisHorizontal ? self.stackView.insets.bottom : self.stackView.insets.right;
        cons.constant = -endSpacing - insetEnd;
        if (self.alignSelf == ZLAlignCenter) {
            NSLayoutConstraint *centerCons = [self filterConstraintWithBlock:^BOOL(NSLayoutConstraint *constraint) {
                ZLConstraintItem *cfg = constraint.item;
                return [cfg.view isEqual:self.view] && cfg.type == ZLLayoutConTypeCenter;
            }].firstObject;
            if (centerCons) {
                centerCons.constant = (self.startSpacing - endSpacing) * 0.5;
            }
        }
    }else {
        [self setStackViewNeedsUpdateConstraints];
    }
}
- (void)setIsFlexSpace:(BOOL)isFlexSpace {
    if (isFlexSpace == _isFlexSpace) return;
    _isFlexSpace = isFlexSpace;
    [self setStackViewNeedsUpdateConstraints];
}

- (void)setFlexValue:(NSInteger)flexValue {
    if (flexValue == _flexValue) return;
    _flexValue = flexValue;
    [self setStackViewNeedsUpdateConstraints];
}
- (void)setView:(UIView *)view {
    _view = view;
    if (!self.isKVOAdded) {
        self.isKVOAdded = YES;
        [view addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}
- (void)setWidth:(CGFloat)width {
    if (width == _width) return;
    _width = width;
    
}
- (void)setHeight:(CGFloat)height {
    if (height == _height) return;
    _height = height;
}
- (void)setMinWidth:(CGFloat)minWidth {
    if (minWidth == _minWidth) return;
    _minWidth = minWidth;
}
- (void)setMaxWidth:(CGFloat)maxWidth {
    if (maxWidth == _maxWidth) return;
    _maxWidth = maxWidth;
}
- (void)setMinHeight:(CGFloat)minHeight {
    if (minHeight == _minHeight) return;
    _minHeight = minHeight;
}
- (void)setMaxHeight:(CGFloat)maxHeight {
    if (maxHeight == _maxHeight) return;
    _maxHeight = maxHeight;
}
- (void)setStackViewNeedsUpdateConstraints {
    if (!self.view.superview || !self.stackView || ![self.stackView isEqual:self.view.superview]) return;
    [self.stackView setValue:@(YES) forKey:@"markedDirty"];
    [self.stackView setNeedsUpdateConstraints];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
        if ([keyPath isEqualToString:@"hidden"]) {
            BOOL oldHidden = [change[NSKeyValueChangeOldKey] boolValue];
            BOOL newHidden = [change[NSKeyValueChangeNewKey] boolValue];
            if (oldHidden == newHidden) return;
            [self setStackViewNeedsUpdateConstraints];
        }
}
- (void)dealloc
{
    if (self.isKVOAdded) {
        [self.view removeObserver:self forKeyPath:@"hidden"];
    }
}

- (ZLFlexItem * _Nonnull (^)(CGFloat))start {
    return ^(CGFloat spacing) {
        self.startSpacing = spacing;
        return self;
    };
}
- (ZLFlexItem * _Nonnull (^)(CGFloat))end {
    return ^(CGFloat spacing) {
        self.endSpacing = spacing;
        return self;
    };
}
- (ZLFlexItem * _Nonnull (^)(CGFloat))minSpace {
    return ^(CGFloat spacing) {
        self.minSpacing = spacing;
        return self;
    };
}
- (ZLFlexItem * _Nonnull (^)(CGFloat))maxSpace {
    return ^(CGFloat spacing) {
        self.maxSpacing = spacing;
        return self;
    };
}
- (ZLFlexItem * _Nonnull (^)(NSInteger))flex {
    return ^(NSInteger flexValue) {
        self.flexValue = flexValue;
        return self;
    };
}
- (ZLFlexItem * _Nonnull (^)(BOOL))flexSpace {
    return ^(BOOL isFlexSpace) {
        self.isFlexSpace = isFlexSpace;
        return self;
    };
}
- (ZLFlexItem * _Nonnull (^)(ZLAlign))align {
    return ^(ZLAlign align) {
        self.alignSelf = align;
        return self;
    };
}
- (instancetype)alignStart {
    self.alignSelf = ZLAlignStart;
    return self;
}
- (instancetype)alignEnd {
    self.alignSelf = ZLAlignEnd;
    return self;
}
- (instancetype)alignCenter {
    self.alignSelf = ZLAlignCenter;
    return self;
}
- (instancetype)alignFill {
    self.alignSelf = ZLAlignFill;
    return self;
}
- (ZLFlexItem * _Nonnull (^)(CGFloat))h {
    return ^(CGFloat h) {
        self.height = h;
        return self;
    };
}
- (ZLFlexItem * _Nonnull (^)(CGFloat))w {
    return ^(CGFloat w) {
        self.width = w;
        return self;
    };
}

- (ZLFlexItem * _Nonnull (^)(CGFloat))minW {
    return ^(CGFloat w) {
        self.minWidth = w;
        return self;
    };
}


- (ZLFlexItem * _Nonnull (^)(CGFloat))minH {
    return ^(CGFloat h) {
        self.minHeight = h;
        return self;
    };
}


- (ZLFlexItem * _Nonnull (^)(CGFloat))maxW {
    return ^(CGFloat w) {
        self.maxWidth = w;
        return self;
    };
}


- (ZLFlexItem * _Nonnull (^)(CGFloat))maxH {
    return ^(CGFloat h) {
        self.maxHeight = h;
        return self;
    };
}


@end
