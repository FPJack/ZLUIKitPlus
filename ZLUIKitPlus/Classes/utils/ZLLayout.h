//
//  ZLLayout.h
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

@interface ZLLayout : NSObject

@property (nonatomic,weak)UIView *view;


@property (nonatomic,  readonly) ZLLayout* (^centerX)(CGFloat x);

@property (nonatomic,  readonly) ZLLayout* (^centerY)(CGFloat y);

@property (nonatomic,  readonly) ZLLayout* (^center)(void);

@property (nonatomic,  readonly) ZLLayout* (^centerOffset)(CGFloat x,CGFloat y);

@property (nonatomic,  readonly) ZLLayout* (^top)(CGFloat top);

@property (nonatomic,  readonly) ZLLayout* (^leading)(CGFloat leading);

@property (nonatomic,  readonly) ZLLayout* (^bottom)(CGFloat bottom);

@property (nonatomic,  readonly) ZLLayout* (^trailing)(CGFloat trailling);

///设置高度
@property (nonatomic, copy, readonly) ZLLayout* (^height)(CGFloat height);

@property (nonatomic, copy, readonly) ZLLayout* (^minHeight)(CGFloat height);

@property (nonatomic, copy, readonly) ZLLayout* (^maxHeight)(CGFloat height);

///设置宽度
@property (nonatomic, copy, readonly) ZLLayout* (^width)(CGFloat width);

@property (nonatomic, copy, readonly) ZLLayout* (^minWidth)(CGFloat width);

@property (nonatomic, copy, readonly) ZLLayout* (^maxWidth)(CGFloat width);

///同时设置宽高
@property (nonatomic, copy, readonly) ZLLayout* (^size)(CGFloat width,CGFloat height);

///设置宽高相等
@property (nonatomic, copy, readonly) ZLLayout* (^square)(CGFloat wh);

///贴紧父视图四边(参数布局)
@property (nonatomic, copy, readonly) ZLLayout* (^edge)(CGFloat top,CGFloat leading, CGFloat bottom, CGFloat trailing);

///贴紧父视图四边(参数布局)，参数相同 inset(10) 等价于 edge(10,10,10,10)
@property (nonatomic, copy, readonly) ZLLayout *(^inset)(CGFloat); // ⭐高频
///贴紧父视图四边布局
@property (nonatomic, copy, readonly) ZLLayout* (^edgesZero)(void);

///添加点击事件
@property (nonatomic,readonly) ZLLayout* (^tapAction)(void(^)(__kindof UIView *view));

///添加到父视图，参数是父视图
@property (nonatomic, copy, readonly) ZLLayout *(^addTo)(UIView *superview);
///添加到父视图 并且贴紧父视图四边布局，参数是父视图
@property (nonatomic, copy, readonly) ZLLayout *(^addToFull)(UIView *superview);

@property (nonatomic, copy, readonly) ZLLayout *(^addSubview)(UIView *subview);

@property (nonatomic, copy, readonly) ZLLayout *(^addSubviewLayout)(UIView *subview, void(^)(ZLLayout *layout));

@end

@interface UIView (ZLLayout)
//@property (nonatomic,readonly)ZLLayout *KFC;
@property (nonatomic,readonly)ZLLayout *zl_layout;
@end

NS_ASSUME_NONNULL_END
