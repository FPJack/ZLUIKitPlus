//
//  ZLLayoutViewCfg.h
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/5/4.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLLayoutGuide.h"

NS_ASSUME_NONNULL_BEGIN
@class ZLStackView;
@class ZLLayoutViewCfg;
@interface UIView (ZLView)
@property (nonatomic,readonly)ZLLayoutViewCfg *zl_layoutCfg;
@end
@interface ZLLayoutViewCfg : NSObject
@property (nonatomic,assign)CGFloat startSpacing;
@property (nonatomic,assign)CGFloat endSpacing;
@property (nonatomic,assign)CGFloat spacing;
@property (nonatomic,assign)CGFloat minSpacing;
@property (nonatomic,assign)CGFloat maxSpacing;
@property (nonatomic,assign)BOOL    isFlexSpace; ///ZlJustifyFill 才会有效
@property (nonatomic,assign)NSInteger flex;  //弹性权重（横向=宽度比例，纵向=高度比例）
@property (nonatomic,assign)ZLAlign alignSelf;
@end

NS_ASSUME_NONNULL_END
