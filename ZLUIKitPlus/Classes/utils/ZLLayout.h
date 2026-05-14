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


typedef NS_ENUM(NSInteger, ZLAttr) {
    ZLAttrNone = 0,
    
    // MARK: - Top
    
    ZLAttrTop,        /// view.topAnchor ==
    ZLAttrGTTop,      /// view.topAnchor >=
    ZLAttrLTTop,      /// view.topAnchor <=
    
    // MARK: - Leading
    
    ZLAttrLeading,    /// view.leadingAnchor ==
    ZLAttrGTLeading,  /// view.leadingAnchor >=
    ZLAttrLTLeading,  /// view.leadingAnchor <=
    
    // MARK: - Bottom
    
    ZLAttrBottom,     /// view.bottomAnchor ==
    ZLAttrGTBottom,   /// view.bottomAnchor >=
    ZLAttrLTBottom,   /// view.bottomAnchor <=
    
    // MARK: - Trailing
    
    ZLAttrTrailing,   /// view.trailingAnchor ==
    ZLAttrGTTrailing, /// view.trailingAnchor >=
    ZLAttrLTTrailing, /// view.trailingAnchor <=
    
    // MARK: - CenterX
    
    ZLAttrCenterX,    /// view.centerXAnchor ==
    ZLAttrGTCenterX,  /// view.centerXAnchor >=
    ZLAttrLTCenterX,  /// view.centerXAnchor <=
    
    // MARK: - CenterY
    
    ZLAttrCenterY,    /// view.centerYAnchor ==
    ZLAttrGTCenterY,  /// view.centerYAnchor >=
    ZLAttrLTCenterY,  /// view.centerYAnchor <=
    
    // MARK: - Width
    
    ZLAttrWidth,      /// view.widthAnchor ==
    ZLAttrGTWidth,    /// view.widthAnchor >=
    ZLAttrLTWidth,    /// view.widthAnchor <=
    
    // MARK: - Height
    
    ZLAttrHeight,     /// view.heightAnchor ==
    ZLAttrGTHeight,   /// view.heightAnchor >=
    ZLAttrLTHeight,   /// view.heightAnchor <=
};

@interface ZLLayout : NSObject

@property (nonatomic,weak)UIView *view;


@property (readonly)  ZLLayout* (^centerX)(CGFloat x);
@property (readonly)  ZLLayout* (^centerXTo)(NSLayoutXAxisAnchor *anchor, CGFloat offset);
@property (readonly)  ZLLayout* (^centerXGreaterThanOrTo)(NSLayoutXAxisAnchor *anchor, CGFloat offset);
@property (readonly)  ZLLayout* (^centerXLessThanOrTo)(NSLayoutXAxisAnchor *anchor, CGFloat offset);

@property (readonly)  ZLLayout* (^centerY)(CGFloat y);
@property (readonly)  ZLLayout* (^centerYTo)(NSLayoutYAxisAnchor *anchor, CGFloat offset);
@property (readonly)  ZLLayout* (^centerYGreaterThanOrTo)(NSLayoutYAxisAnchor *anchor, CGFloat offset);
@property (readonly)  ZLLayout* (^centerYLessThanOrTo)(NSLayoutYAxisAnchor *anchor, CGFloat offset);

@property (readonly) ZLLayout* (^center)(void);
@property (readonly) ZLLayout* (^centerOffset)(CGFloat x,CGFloat y);

@property (readonly) ZLLayout* (^top)(CGFloat top);
@property (readonly) ZLLayout* (^topTo)(NSLayoutYAxisAnchor *anchor, CGFloat offset);
@property (readonly) ZLLayout* (^topGreaterThanOrTo)(NSLayoutYAxisAnchor *anchor, CGFloat offset);
@property (readonly) ZLLayout* (^topLessThanOrTo)(NSLayoutYAxisAnchor *anchor, CGFloat offset);

@property (readonly) ZLLayout* (^leading)(CGFloat leading);
@property (readonly) ZLLayout* (^leadingTo)(NSLayoutXAxisAnchor *anchor, CGFloat offset);
@property (readonly) ZLLayout* (^leadingGreaterThanOrTo)(NSLayoutXAxisAnchor *anchor, CGFloat offset);
@property (readonly) ZLLayout* (^leadingLessThanOrTo)(NSLayoutXAxisAnchor *anchor, CGFloat offset);

@property (readonly) ZLLayout* (^bottom)(CGFloat bottom);
@property (readonly) ZLLayout* (^bottomTo)(NSLayoutYAxisAnchor *anchor, CGFloat offset);
@property (readonly) ZLLayout* (^bottomGreaterThanOrTo)(NSLayoutYAxisAnchor *anchor, CGFloat offset);
@property (readonly) ZLLayout* (^bottomLessThanOrTo)(NSLayoutYAxisAnchor *anchor, CGFloat offset);

@property (readonly) ZLLayout* (^trailing)(CGFloat trailling);
@property (readonly) ZLLayout* (^trailingTo)(NSLayoutXAxisAnchor *anchor, CGFloat offset);
@property (readonly) ZLLayout* (^trailingGreaterThanOrTo)(NSLayoutXAxisAnchor *anchor, CGFloat offset);
@property (readonly) ZLLayout* (^trailingLessThanOrTo)(NSLayoutXAxisAnchor *anchor, CGFloat offset);
///设置高度
@property (readonly) ZLLayout* (^height)(CGFloat height);
///设置高度相等
@property (readonly) ZLLayout* (^heightTo)(NSLayoutDimension * dimension);
@property (readonly) ZLLayout* (^minHeight)(CGFloat height);
@property (readonly) ZLLayout* (^maxHeight)(CGFloat height);

///设置宽度
@property (readonly) ZLLayout* (^width)(CGFloat width);
///设置宽度相等
@property (readonly) ZLLayout* (^widthTo)(NSLayoutDimension * dimension);
@property (readonly) ZLLayout* (^minWidth)(CGFloat width);
@property (readonly) ZLLayout* (^maxWidth)(CGFloat width);

///同时设置宽高
@property (readonly) ZLLayout* (^size)(CGFloat width,CGFloat height);

///设置宽高相等
@property (readonly) ZLLayout* (^square)(CGFloat wh);

///贴紧父视图四边(参数布局)
@property (readonly) ZLLayout* (^edges)(CGFloat top,CGFloat leading, CGFloat bottom, CGFloat trailing);

///贴紧父视图四边(参数布局)，参数相同 inset(10) 等价于 edge(10,10,10,10)
@property (readonly) ZLLayout *(^allEdges)(CGFloat); // ⭐高频
///贴紧父视图四边布局
@property (readonly) ZLLayout* (^edgesZero)(void);

///添加点击事件
@property (readonly) ZLLayout* (^tapAction)(void(^)(__kindof UIView *view));

///添加到父视图，参数是父视图
@property (readonly) ZLLayout *(^addTo)(UIView *superview);
///添加到父视图 并且贴紧父视图四边布局，参数是父视图
@property (readonly) ZLLayout *(^addToFull)(UIView *superview);

@property (readonly) ZLLayout *(^addSubview)(UIView *subview);

@property (readonly) ZLLayout *(^addSubviewLayout)(UIView *subview, void(^)(ZLLayout *layout));

@end

@interface UIView (ZLLayout)
@property (nonatomic,readonly)ZLLayout *zl_layout;
@end

NS_ASSUME_NONNULL_END
