//
//  ZLUI.h
//  Pods
//
//  Created by admin on 2026/4/24.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

#define kZLRGBHexColor(hex) [UIColor colorWithRed:((CGFloat)((hex >> 16) & 0xFF)/255.0) green:((CGFloat)((hex >> 8) & 0xFF)/255.0) blue:((CGFloat)(hex & 0xFF)/255.0) alpha:1.0]
#define kZLRGBAHexColor(hex) [UIColor colorWithRed:((CGFloat)((hex >> 16) & 0xFF)/255.0) green:((CGFloat)((hex >> 8) & 0xFF)/255.0) blue:((CGFloat)(hex & 0xFF)/255.0) alpha:1.0]

static inline UIColor *ZLColorFromStr(NSString *hexStr) {
    hexStr = [hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([hexStr hasPrefix:@"0x"])hexStr = [hexStr substringFromIndex:2];
    if([hexStr hasPrefix:@"#"])hexStr = [hexStr substringFromIndex:1];
    unsigned int hexInt = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    [scanner scanHexInt:&hexInt];
    return hexStr.length > 6 ? kZLRGBAHexColor(hexInt) : kZLRGBHexColor(hexInt);
}

static inline UIImage * _Nullable ZLImageFromObj(NSObject * _Nullable image) {
    UIImage *img = nil;
    if ([image isKindOfClass:UIImage.class]) {
        img = (UIImage *)image;
    } else if ([image isKindOfClass:NSString.class]) {
        img = [UIImage imageNamed:(NSString *)image];
    }
    return img;
}

static inline UIColor * _Nullable ZLColorFromObj(NSObject * _Nullable obj) {
    if ([obj isKindOfClass:UIColor.class]) return (UIColor *)obj;
    if ([obj isKindOfClass:NSString.class]) return ZLColorFromStr((NSString*)obj);
    return nil;
}

@interface ZLUI : NSObject

@property (nonatomic,weak)UIView *view;


@property (nonatomic,  readonly) ZLUI* (^centerX)(CGFloat x);

@property (nonatomic,  readonly) ZLUI* (^centerY)(CGFloat y);

@property (nonatomic,  readonly) ZLUI* (^center)(void);

@property (nonatomic,  readonly) ZLUI* (^centerOffset)(CGFloat x,CGFloat y);

@property (nonatomic,  readonly) ZLUI* (^top)(CGFloat top);

@property (nonatomic,  readonly) ZLUI* (^leading)(CGFloat leading);

@property (nonatomic,  readonly) ZLUI* (^bottom)(CGFloat bottom);

@property (nonatomic,  readonly) ZLUI* (^trailing)(CGFloat trailling);

///设置高度
@property (nonatomic, copy, readonly) ZLUI* (^height)(CGFloat height);
///设置宽度
@property (nonatomic, copy, readonly) ZLUI* (^width)(CGFloat width);
///同时设置宽高
@property (nonatomic, copy, readonly) ZLUI* (^size)(CGFloat width,CGFloat height);

///设置宽高相等
@property (nonatomic, copy, readonly) ZLUI* (^square)(CGFloat wh);

///贴紧父视图四边(参数布局)
@property (nonatomic, copy, readonly) ZLUI* (^edge)(CGFloat top,CGFloat leading, CGFloat bottom, CGFloat trailing);

///贴紧父视图四边(参数布局)，参数相同 inset(10) 等价于 edge(10,10,10,10)
@property (nonatomic, copy, readonly) ZLUI *(^inset)(CGFloat); // ⭐高频
///贴紧父视图四边布局
@property (nonatomic, copy, readonly) ZLUI* (^edgesZero)(void);

///添加点击事件
@property (nonatomic,readonly) ZLUI* (^tapAction)(void(^)(__kindof UIView *view));

///添加到父视图，参数是父视图
@property (nonatomic, copy, readonly) ZLUI *(^addTo)(UIView *superview);
///添加到父视图 并且贴紧父视图四边布局，参数是父视图
@property (nonatomic, copy, readonly) ZLUI *(^addToFull)(UIView *superview);

@property (nonatomic, copy, readonly) ZLUI *(^addSubview)(UIView *subview);

///返回包裹好的一个view返回
@property (nonatomic, copy, readonly) UIView *(^wrapEdges)(CGFloat top,CGFloat leading, CGFloat bottom, CGFloat trailing);

@end

@interface UIView (ZLUI)
@property (nonatomic,readonly)ZLUI *KFC;
@end

NS_ASSUME_NONNULL_END
