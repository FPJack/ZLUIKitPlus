//
//  ZLConstraintsCfg.h
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/5/4.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ZLLayoutConType) {
    ZLLayoutConTypeStart,
    ZLLayoutConTypeEnd,
    ZLLayoutConTypeTop,
    ZLLayoutConTypeBottom,
    ZLLayoutConTypeLeading,
    ZLLayoutConTypeTrailing,
    ZLLayoutConTypeSpacing,
};

@interface ZLConstraintsCfg : NSObject
@property (nonatomic,assign)ZLLayoutConType type;
@property (nonatomic,weak)UIView *view;
@end

@interface NSLayoutConstraint (Cfg)
@property (nonatomic,readonly)ZLConstraintsCfg *cfg;
@end


NS_ASSUME_NONNULL_END
