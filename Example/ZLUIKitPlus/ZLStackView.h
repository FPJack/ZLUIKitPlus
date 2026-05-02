//
//  ZLStackView.h
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/4/25.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ZLAlign) {
    ZLAlignCenter,
    ZLAlignStart,
    ZLAlignEnd,
    ZLAlignFill,
};
typedef NS_ENUM(NSInteger, ZLJustify) {
   ZlJustifyFill,
   ZlJustifyFillEqually,
   ZLJustifyStart,
   ZLJustifyCenter,
   ZlJustifyEnd,
   ZlJustifySpaceBetween,//两边没有间距，中间相等
   ZlJustifySpaceAround,//两边是中间一半
   ZlJustifySpaceEvenly,//所有间距都相等
};
@class ZLViewLayoutCfg;
@interface UIView (ZLView)
@property (nonatomic,readonly)ZLViewLayoutCfg *zl_layoutCfg;
@end

@class ZLStackView;

@interface ZLLayoutGuide : UILayoutGuide
@property (nonatomic,weak)NSLayoutConstraint *widthCons;
@property (nonatomic,weak)NSLayoutConstraint *heightCons;
@property (nonatomic,weak)ZLStackView *stackView;
@property (nonatomic,assign)int direction;// 0 1 2 3
- (instancetype)initWithStackView:(ZLStackView *)stackView direction:(int)direction;
- (void)addGreadThanWidthCons;
- (void)addGreadThanHeightCons;
- (void)addZeroHeightCons;
- (void)addZeroWidthCons;
@end

@interface ZLLayoutGuideMerge : NSObject
@property (nonatomic,weak)ZLStackView *stackView;
@property (nonatomic,strong)ZLLayoutGuide *topGuide;
@property (nonatomic,strong)ZLLayoutGuide *leadingGuide;
@property (nonatomic,strong)ZLLayoutGuide *bottomGuide;
@property (nonatomic,strong)ZLLayoutGuide *trailingGuide;
@property (nonatomic,weak)NSLayoutConstraint *eqWidthCons;
@property (nonatomic,weak)NSLayoutConstraint *eqHeightCons;

@property (nonatomic,readonly)NSLayoutXAxisAnchor *leadingAnchor;
@property (nonatomic,readonly)NSLayoutXAxisAnchor *trailingAnchor;
@property (nonatomic,readonly)NSLayoutYAxisAnchor *topAnchor;
@property (nonatomic,readonly)NSLayoutYAxisAnchor *bottomAnchor;




@property (nonatomic,copy)NSArray<NSLayoutDimension *> *widthAnchors;
@property (nonatomic,copy)NSArray<NSLayoutDimension *> *heightAnchors;

- (void)addJustifyConstraints;
- (void)addAlignConstraints;
- (void)setEqWidthConstant:(CGFloat)constant;
- (void)setEqHeightConstant:(CGFloat)constant;
- (void)setEqConstraintsValue:(CGFloat)constant;

@end

@interface ZLStackView : UIView
@property (nonatomic, strong)ZLLayoutGuideMerge *layoutGuideMerge;
@property (nonatomic,strong)UILayoutGuide *topGuide;
@property (nonatomic,strong)UILayoutGuide *leadingGuide;
@property (nonatomic,strong)UILayoutGuide *bottomGuide;
@property (nonatomic,strong)UILayoutGuide *trailingGuide;

@property (nonatomic,assign)BOOL horizontal;

@property (nonatomic,assign)ZLAlign alignment;

@property (nonatomic,assign)ZLJustify justify;

@property (nonatomic,assign)BOOL markedDirty;

@property(nonatomic,assign)UIEdgeInsets insets;

@property(nonatomic,strong) NSMutableArray<__kindof UIView *> *arrangedViews;

@property(nonatomic,strong) NSMutableArray<__kindof UIView *> *allViews;

@property (nonatomic,assign)CGFloat spacing;

- (void)addArrangedSubview:(UIView *)view;

- (void)insertArrangedSubview:(UIView *)view atIndex:(NSUInteger)stackIndex;

- (void)removeArrangedSubview:(UIView *)view;

- (void)setCustomSpacing:(CGFloat)spacing afterView:(UIView *)arrangedSubview;

///在某个view后面设置是否弹性空间
- (void)setFlexibleSpacing:(BOOL)flexible afterView:(UIView *)arrangedSubview;

///设置view的alignment，优先级高于stackView的alignment
- (void)setAlignment:(ZLAlign)alignment forView:(UIView *)arrangedSubview;

///设置view的alignment方向start间距
- (void)setAlignmentStartSpacing:(CGFloat)spacing forView:(UIView *)arrangedSubview;

///设置view的alignment方向end间距
- (void)setAlignmentEndSpacing:(CGFloat)spacing forView:(UIView *)arrangedSubview;

@end
@interface ZLViewLayoutCfg: NSObject
@property (nonatomic,assign)CGFloat startSpacing;
@property (nonatomic,assign)CGFloat endSpacing;
@property (nonatomic,assign)CGFloat behindSpacing;
@property (nonatomic,assign)BOOL    isFlexSpace;
@property (nonatomic,assign)ZLAlign alignSelf;


@property (nonatomic,weak)NSLayoutConstraint *leadingCons;
@property (nonatomic,weak)NSLayoutConstraint *trailingCons;
@property (nonatomic,weak)NSLayoutConstraint *topCons;
@property (nonatomic,weak)NSLayoutConstraint *bottomCons;
@property (nonatomic,weak)NSLayoutConstraint *centerXCons;
@property (nonatomic,weak)NSLayoutConstraint *centerYCons;
@property (nonatomic,weak)NSLayoutConstraint *widthCons;
@property (nonatomic,weak)NSLayoutConstraint *heightCons;
///宽度或者高度加上后间距
@property (nonatomic,readonly)CGFloat widthOrHeightPlusBehindSpacing;

@property (nonatomic,readonly)CGFloat leadingOrTopContant;

///是否设置对齐方式
@property (nonatomic,assign)BOOL isSetAlign;
@property (nonatomic,weak)ZLStackView *stackView;


@property (nonatomic,weak)UIView *view;
@property(nonatomic,readonly)NSLayoutXAxisAnchor
    *leadingAnchor;
@property(nonatomic,readonly)NSLayoutXAxisAnchor *trailingAnchor;
@property(nonatomic,readonly)NSLayoutYAxisAnchor
    *topAnchor;
@property(nonatomic,readonly)NSLayoutYAxisAnchor
    *bottomAnchor;
@property(nonatomic,readonly)NSLayoutXAxisAnchor
    *centerXAnchor;
@property(nonatomic,readonly)NSLayoutYAxisAnchor
    *centerYAnchor;

@property(nonatomic,readonly)NSLayoutDimension
    *widthAnchor;
@property(nonatomic,readonly)NSLayoutDimension
    *heightAnchor;
@property (nonatomic,readonly)UIEdgeInsets insets;
@property(nonatomic,assign)BOOL isFirstView;
@property(nonatomic,assign)BOOL isLastView;
@property(nonatomic,readonly)ZLJustify justify;
@property(nonatomic,readonly)CGFloat spacing;

///记录已kvo
@property (nonatomic,assign)BOOL isKVOAdded;
@end

NS_ASSUME_NONNULL_END
