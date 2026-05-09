//
//  ZLPairView.m
//  ZLInsetLabel
//
//  Created by admin on 2026/4/23.
//

#import "ZLPairView.h"
#import "ZLUI.h"
@interface ZLPairView ()
@property (nonatomic, strong,readwrite) UIView*  first;
@property (nonatomic, strong,readwrite) UIView* second;
- (void)addArrangedSubview:(UIView *)view;
@end
@implementation ZLPairView
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self first];
    [self second];
}
- (UIView *)first {
    if (!_first) {
        _first = [self makeFirstView];
        [self addArrangedSubview:_first];
    }
    return _first;
}
- (UIView *)second {
    if (!_second) {
        _second = [self makeSecondView];
        [self addArrangedSubview:_second];
    }
    return _second;
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

- (id  _Nonnull (^)(void (^ _Nonnull)(UIView * _Nonnull)))thenFirst {
    return ^(void (^block)(UIView *)){
        if (block) block(self.first);
        return self;
    };
}
- (id  _Nonnull (^)(void (^ _Nonnull)(UIView * _Nonnull)))thenSecond {
    return ^(void (^block)(UIView *)){
        if (block) block(self.second);
        return self;
    };
}

- (id  _Nonnull (^)(CGFloat))minSpace {
    return ^(CGFloat spacing){
        self.first.zl_layoutCfg.minSpacing = spacing;
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat))maxSpace {
    return ^(CGFloat spacing){
        self.first.zl_layoutCfg.maxSpacing = spacing;
        return self;
    };
}
- (id  _Nonnull (^)(BOOL))flexSpace {
    return ^(BOOL flexible){
        self.first.zl_layoutCfg.isFlexSpace = flexible;
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat))firstStartSpace {
    return ^(CGFloat spacing){
        self.first.zl_layoutCfg.startSpacing = spacing;
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat))firstEndSpace {
    return ^(CGFloat spacing){
        self.first.zl_layoutCfg.endSpacing = spacing;
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat))secondStartSpace {
    return ^(CGFloat spacing){
        self.second.zl_layoutCfg.startSpacing = spacing;
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat))secondEndSpace {
    return ^(CGFloat spacing){
        self.second.zl_layoutCfg.endSpacing = spacing;
        return self;
    };
}
@end

@implementation ZLPairLabelView
- (UIView *)makeFirstView {
    return ZLLabel.new;
}
- (UIView *)makeSecondView {
    ZLLabel *label = ZLLabel.new.systemFont(14).color(UIColor.grayColor).lines(0);
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


