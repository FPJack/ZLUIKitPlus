//
//  ZLPairView.m
//  ZLInsetLabel
//
//  Created by admin on 2026/4/23.
//

#import "ZLPairView.h"
#import "ZLLayout.h"
@interface ZLPairView ()
@property (nonatomic, strong,readwrite) UIView*  first;
@property (nonatomic, strong,readwrite) UIView* second;
- (void)addArrangedSubview:(UIView *)view;
- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex;
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
        [self insertArrangedSubview:_first atIndex:0];
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
- (id  _Nonnull (^)(void (^ _Nonnull)(id _Nonnull)))then {
    return ^(void (^block)(id)){
        if (block) block(self);
        return self;
    };
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
        self.first.zl_flex.minSpacing = spacing;
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat))maxSpace {
    return ^(CGFloat spacing){
        self.first.zl_flex.maxSpacing = spacing;
        return self;
    };
}
- (id  _Nonnull (^)(BOOL))flexSpace {
    return ^(BOOL flexible){
        self.first.zl_flex.isFlexSpace = flexible;
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat))firstStartSpace {
    return ^(CGFloat spacing){
        self.first.zl_flex.startSpacing = spacing;
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat))firstEndSpace {
    return ^(CGFloat spacing){
        self.first.zl_flex.endSpacing = spacing;
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat))secondStartSpace {
    return ^(CGFloat spacing){
        self.second.zl_flex.startSpacing = spacing;
        return self;
    };
}
- (id  _Nonnull (^)(CGFloat))secondEndSpace {
    return ^(CGFloat spacing){
        self.second.zl_flex.endSpacing = spacing;
        return self;
    };
}
- (id  _Nonnull (^)(NSInteger))firstFlex {
    return ^(NSInteger flex){
        self.first.zl_flex.flexValue = flex;
        return self;
    };
}
- (id  _Nonnull (^)(NSInteger))secondFlex {
    return ^(NSInteger flex){
        self.second.zl_flex.flexValue = flex;
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
@implementation ZLButtonLabView
- (UIView *)makeFirstView {
    return ZLButton.horizontal;
}
- (UIView *)makeSecondView {
    return [[ZLLabel alloc] init];
}
@end

@implementation ZLLabelImgView
- (UIView *)makeFirstView {
    return [[ZLLabel alloc] init];
}
- (UIView *)makeSecondView {
    return [[ZLImageView alloc] init];
}
@end

@implementation ZLLabButtonView
- (UIView *)makeFirstView {
    return [[ZLLabel alloc] init];
}
- (UIView *)makeSecondView {
    return [ZLButton horizontal];
}
@end

@implementation ZLButtonStackView
- (UIView *)makeFirstView {
    return [ZLButton horizontal];
}
- (UIView *)makeSecondView {
    return [ZLStackView vertical];
}
@end
@implementation ZLStackViewButton
- (UIView *)makeFirstView {
    return [ZLStackView vertical];
}
- (UIView *)makeSecondView {
    return [ZLButton horizontal];
}
@end



@implementation ZLPairStackView
- (UIView *)makeFirstView {
    return [ZLStackView horizontal];
}
- (UIView *)makeSecondView {
    return [ZLStackView horizontal];
}
@end
