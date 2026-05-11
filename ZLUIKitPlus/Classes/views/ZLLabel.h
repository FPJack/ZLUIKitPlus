#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define ZLLab [ZLLabel new]

@interface ZLLabel : UILabel
@property (nonatomic, assign)  CGFloat insetTop;
@property (nonatomic, assign)  CGFloat insetBottom;
@property (nonatomic, assign)  CGFloat insetLeading;
@property (nonatomic, assign)  CGFloat insetTrailing;
@property (nonatomic, assign)  UIEdgeInsets edgeInsets;
@property(nonatomic,assign) BOOL selected;  


@property (readonly)ZLLabel *(^insets)(CGFloat top, CGFloat leading, CGFloat bottom, CGFloat trailing); // edgeInsets 设置

@property (readonly)ZLLabel *(^hInset)(CGFloat leading, CGFloat trailing); // edgeInsets 设置

@property (readonly)ZLLabel *(^vInset)(CGFloat top, CGFloat bottom); // edgeInsets 设置

@property (readonly) ZLLabel*  (^txt)(NSString *text);

@property (readonly) ZLLabel*  (^color)(id color);


@property (readonly) ZLLabel*  (^textAlign)(NSTextAlignment align);

- (instancetype)textAlignLeft;
- (instancetype)textAlignCenter;
- (instancetype)textAlignRight;

@property (readonly) ZLLabel* (^systemFont)(CGFloat fontSize);
@property (readonly) ZLLabel* (^systemFontColor)(CGFloat fontSize,id color);
@property (readonly) ZLLabel* (^systemTextFontColor)(NSString *text,CGFloat fontSize,id color);

@property (readonly) ZLLabel* (^mediumFont)(CGFloat fontSize);
@property (readonly) ZLLabel* (^mediumFontColor)(CGFloat fontSize,id color);
@property (readonly) ZLLabel* (^mediumTextFontColor)(NSString *text,CGFloat fontSize,id color);

@property (readonly) ZLLabel* (^semiboldFont)(CGFloat fontSize);
@property (readonly) ZLLabel* (^boldFont)(CGFloat fontSize);
///设置选中文字颜色
///设置文字换行最大宽度
@property ( readonly) ZLLabel* (^txtMaxWidth)(CGFloat preferredMaxLayoutWidth);
///设置几行 文字，超过则换行，配合 titleMaxWidth 使用
@property ( readonly) ZLLabel* (^lines)(NSInteger lines);
///设置背景色
@property (readonly) ZLLabel*  (^bgColor)(id color);// 便捷设置背景色，支持 UIColor 或 UIColorHex
///设置是否可见
@property ( readonly) ZLLabel* (^visibility)(BOOL visible);
///设置透明度
@property ( readonly) ZLLabel* (^alphaValue)(CGFloat alpha);
///设置userinteractionEnabled
@property (nonatomic, copy, readonly) ZLLabel* (^userActive)(BOOL userInteractionEnabled);
///可点击情况下进行相应配置 userActive(YES) 触发回调
@property (readonly) ZLLabel* (^activeStyle)(void (^)(ZLLabel * label));

///不可点击情况下配置userActive(NO) 触发回调
@property (readonly) ZLLabel* (^inactiveStyle)(void (^)(ZLLabel * label));
///设置选中状态
@property (readonly) ZLLabel* (^select)(BOOL select);
///选中样式
@property (readonly) ZLLabel* (^selectStyle)(void (^)(ZLLabel * label));

///设置圆角
@property ( readonly) ZLLabel* (^corner)(CGFloat radius);

@property (readonly) ZLLabel* (^circle)(BOOL circle);


///设置4个方向的圆角，传入不同的值
@property ( readonly) ZLLabel* (^cornerRadii)(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight);
///设置属性文本
@property ( readonly) ZLLabel* (^attributeTxt)(NSAttributedString *attributeStr);
///通过block设置属性文本，支持链式调用
@property ( readonly) ZLLabel* (^attributeTxtBK)(NSAttributedString* (^attributeStrBlock)(ZLLabel *label));

///UIColor or #333333
@property (readonly) ZLLabel* (^borderColor)(id);
@property (readonly) ZLLabel* (^borderWidth)(CGFloat);
@property (readonly) ZLLabel* (^border)(CGFloat width,id color);

@property (readonly) ZLLabel* (^masksToBounds)(BOOL masksToBounds);

@property (readonly) ZLLabel* (^tapAction)(void(^)(ZLLabel *label));

@property ( copy, readonly) ZLLabel* (^assignToPtr)(ZLLabel *_Nullable* _Nullable ptr);
///立即触发block回调，适用于需要在初始化时立即配置样式的场景
@property (readonly) ZLLabel* (^then)(void (^)(ZLLabel * label));

///设置高度
@property ( copy, readonly) ZLLabel* (^height)(CGFloat height);
///设置宽度
@property ( copy, readonly) ZLLabel* (^width)(CGFloat width);
///同时设置宽高
@property ( copy, readonly) ZLLabel* (^size)(CGFloat width,CGFloat height);
///设置宽高相等
@property ( copy, readonly) ZLLabel* (^square)(CGFloat wh);
///贴紧父视图四边(参数布局)
@property ( copy, readonly) ZLLabel* (^edge)(CGFloat top,CGFloat leading, CGFloat bottom, CGFloat trailing);
 // ⭐高频
///贴紧父视图四边布局
@property ( copy, readonly) ZLLabel* (^edgesZero)(void);
///添加到父视图，参数是父视图
@property (nonatomic, copy, readonly) ZLLabel* (^addTo)(UIView *superview);
///添加到父视图 并且贴紧父视图四边布局，参数是父视图
@property (nonatomic, copy, readonly) ZLLabel* (^addToFull)(UIView *superview);
@end



NS_ASSUME_NONNULL_END
