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
    ZLAlignEnd
};
typedef NS_ENUM(NSInteger, ZLJustify) {
   ZlJustifyFill,
   ZlJustifyFillEqually,
   ZLJustifyStart,
   ZLJustifyCenter,
   ZlJustifyEnd,
};
@interface ZLStackView : UIView
@property (nonatomic,assign)BOOL horizontal;
@property (nonatomic,assign)ZLAlign alignment;
@property (nonatomic,assign)CGFloat spacing;
- (void)addArrandgeView:(UIView *)view;
- (void)updateViewsConstraints;
@end

NS_ASSUME_NONNULL_END
