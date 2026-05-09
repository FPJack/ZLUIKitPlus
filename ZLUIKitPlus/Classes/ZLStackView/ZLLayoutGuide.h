//
//  ZLLayoutGuide.h
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/5/4.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZLStackViewAxis) {
    ZLStackViewAxisHorizontal = 0,  // 水平排列
    ZLStackViewAxisVertical,        // 垂直排列
};


typedef NS_ENUM(NSInteger, ZLAlign) {
    ZLAlignCenter,
    ZLAlignStart,
    ZLAlignEnd,
    ZLAlignFill,
};
typedef NS_ENUM(NSInteger, ZLJustify) {
   ZLJustifyFill,
   ZLJustifyFillEqually,
   ZLJustifyStart,
   ZLJustifyCenter,
   ZLJustifyEnd,
   ZLJustifySpaceBetween,//两边没有间距，中间相等
   ZLJustifySpaceAround,//两边是中间一半
   ZLJustifySpaceEvenly,//所有间距都相等
};

@interface ZLLayoutGuide : UILayoutGuide
@property (nonatomic,weak)UIView *stackView;
- (void)removeFromOwningView;
@end

NS_ASSUME_NONNULL_END
