//
//  ZLImageView.m
//  GMListKit
//
//  Created by admin on 2026/4/22.
//

#import "ZLImageView.h"
#import "ZLButton.h"
#import "ZLUI.h"
@interface ZLImageView()
@property (nonatomic,copy)NSNumber* isCircle;
@end
@implementation ZLImageView
- (ZLImageView * _Nonnull (^)(id _Nonnull))img {
    return ^(id img) {
        self.image = ZLImageFromObj(img);
        return self;
    };
}
- (ZLImageView * _Nonnull (^)(id _Nonnull))hlImg {
    return ^(id img) {
        self.highlightedImage = ZLImageFromObj(img);
        return self;
    };
}
- (ZLImageView * _Nonnull (^)(BOOL))highlight {
    return ^(BOOL highlighted) {
        self.highlighted = highlighted;
        return self;
    };
}
- (ZLImageView * _Nonnull (^)(UIViewContentMode))mode {
    return ^(UIViewContentMode mode) {
        self.contentMode = mode;
        return self;
    };
}
- (instancetype)aspectFit {
    return self.mode(UIViewContentModeScaleAspectFit);
}
- (instancetype)aspectFill {
    return self.mode(UIViewContentModeScaleAspectFill);
}
- (ZLImageView * _Nonnull (^)(CGFloat))corner {
    return ^(CGFloat corner) {
        self.layer.cornerRadius = corner;
        self.layer.masksToBounds = corner > 0;
        return self;
    };
}
- (ZLImageView * _Nonnull (^)(BOOL))circle {
    return ^(BOOL circle) {
        self.isCircle = @(YES);
        [self updateCircel];
        return self;
    };
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
- (ZLImageView * _Nonnull (^)(CGFloat, id _Nonnull))border {
    return ^(CGFloat width, id color) {
        self.layer.borderWidth = width;
        self.layer.borderColor = ZLColorFromObj(color).CGColor;
        return self;
    };
}
- (ZLImageView * _Nonnull (^)(id _Nonnull))bgColor {
    return ^(id color) {
        self.backgroundColor = ZLColorFromObj(color);
        return self;
    };
}

- (ZLImageView * _Nonnull (^)(BOOL))visibility {
    return ^(BOOL visible) {
        self.hidden = !visible;
        return self;
    };
}
- (ZLImageView * _Nonnull (^)(CGFloat))alphaValue {
    return ^(CGFloat alpha) {
        self.alpha = alpha;
        return self;
    };
}
- (ZLImageView * _Nonnull (^)(id  _Nullable,id _Nullable))url {
    return ^(id url,id placeholder) {
        NSURL *urlObj = nil;
        if ([url isKindOfClass:NSURL.class]) urlObj = url;
        if ([url isKindOfClass:NSString.class]) urlObj = [NSURL URLWithString:url];
        if (!url) return self;
        SEL sel = @selector(sd_setImageWithURL:placeholderImage:);
        if ([self respondsToSelector:sel]) {
            [self performSelector:sel withObject:url withObject:ZLImageFromObj(placeholder)];
        }
        return self;
    };
}
- (ZLImageView * _Nonnull (^)(void (^ _Nonnull)(ZLImageView * _Nonnull)))tapAction {
    return ^(void (^tapAction)(ZLImageView *imgView)) {
        if (tapAction) {
            self.userInteractionEnabled = YES;
            self.KFC.tapAction(^(UIView * _Nonnull view) {
                if (tapAction) tapAction(self);
            });
        } else {
            self.userInteractionEnabled = NO;
        }
        return self;
    };
}

- (ZLImageView * _Nonnull (^)(ZLImageView * _Nullable __autoreleasing * _Nullable))toPtr {
    return ^(ZLImageView **ptr) {
        if (ptr) *ptr = self;
        return self;
    };
}


- (ZLImageView * _Nonnull (^)(void (^ _Nonnull)(ZLImageView * _Nonnull)))then {
    return ^(void (^then)(ZLImageView *imgView)) {
        if (then) then(self);
        return self;
    };
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateCircel];
}



- (ZLImageView * _Nonnull (^)(CGFloat))z_centerX {
    return ^(CGFloat centerX) {
        self.KFC.centerX(centerX);
        return self;
    };
}
- (ZLImageView * _Nonnull (^)(CGFloat))z_centerY {
    return ^(CGFloat centerY) {
        self.KFC.centerY(centerY);
        return self;
    };
}
- (ZLImageView * _Nonnull (^)(void))z_center {
    return ^() {
        self.KFC.center();
        return self;
    };
}
- (ZLImageView * _Nonnull (^)(CGFloat, CGFloat))z_centerOffset {
    return ^(CGFloat offsetX, CGFloat offsetY) {
        self.KFC.centerOffset(offsetX, offsetY);
        return self;
    };
}
- (ZLImageView * _Nonnull (^)(CGFloat))z_top {
    return ^(CGFloat top) {
        self.KFC.top(top);
        return self;
    };
}
- (ZLImageView * _Nonnull (^)(CGFloat))z_leading {
    return ^(CGFloat leading) {
        self.KFC.leading(leading);
        return self;
    };
}
- (ZLImageView * _Nonnull (^)(CGFloat))z_bottom {
    return ^(CGFloat bottom) {
        self.KFC.bottom(bottom);
        return self;
    };
}
- (ZLImageView * _Nonnull (^)(CGFloat))z_trailing {
    return ^(CGFloat trailing) {
        self.KFC.trailing(trailing);
        return self;
    };
}
- (ZLImageView * _Nonnull (^)(CGFloat))z_height {
    return ^(CGFloat height) {
        self.KFC.height(height);
        return self;
    };
}
- (ZLImageView * _Nonnull (^)(CGFloat))z_width {
    return ^(CGFloat width) {
        self.KFC.width(width);
        return self;
    };
}
- (ZLImageView * _Nonnull (^)(CGFloat, CGFloat))z_size {
    return ^(CGFloat width, CGFloat height) {
        self.KFC.size(width, height);
        return self;
    };
}
- (ZLImageView * _Nonnull (^)(CGFloat))z_square {
    return ^(CGFloat side) {
        self.KFC.square(side);
        return self;
    };
}
- (ZLImageView * _Nonnull (^)(CGFloat, CGFloat, CGFloat, CGFloat))z_edge {
    return ^(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing) {
        self.KFC.edge(top, leading, bottom, trailing);
        return self;
    };
}
- (ZLImageView * _Nonnull (^)(void))z_edgesZero {
    return ^() {
        self.KFC.edgesZero();
        return self;
    };
}
- (ZLImageView* _Nonnull (^)(UIView * _Nonnull))addTo {
    return ^(UIView *superview){
        if ([superview isKindOfClass:UIView.class]) {
            [superview addSubview:self];
        }
        return self;
    };
}

- (ZLImageView* _Nonnull (^)(UIView * _Nonnull))addToFull {
    return ^(UIView *superview){
        if ([superview isKindOfClass:UIView.class]) {
            [superview addSubview:self];
            self.KFC.edgesZero();
        }
        return self;
    };
}

@end
