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
    ZLAlignStart,
    ZLAlignCenter,
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
@interface ZLStackView : UIView
@property (nonatomic,assign)BOOL horizontal;
@property (nonatomic,assign)ZLAlign alignment;
@property (nonatomic,assign)ZLJustify justify;
@property(nonatomic,readonly,copy) NSArray<__kindof UIView *> *arrangedSubviews;
@property(nonatomic,strong) NSMutableArray<__kindof UIView *> *views;

@property (nonatomic,assign)CGFloat spacing;
- (void)addArrangedSubview:(UIView *)view;
- (void)removeArrangedSubview:(UIView *)view;
- (void)setCustomSpacing:(CGFloat)spacing afterView:(UIView *)arrangedSubview;

@end

NS_ASSUME_NONNULL_END
