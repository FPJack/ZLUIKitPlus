//
//  ZLConstraintItem.h
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
    ZLLayoutConTypeCenter,
    ZLLayoutConTypeTop,
    ZLLayoutConTypeBottom,
    ZLLayoutConTypeLeading,
    ZLLayoutConTypeTrailing,
    ZLLayoutConTypeSpacing,
    ZLLayoutConTypeMinSpacing,
    ZLLayoutConTypeMaxSpacing,
};

@interface ZLConstraintItem : NSObject
@property (nonatomic,assign)ZLLayoutConType type;
@property (nonatomic,weak)UIView *view;
@end

@interface NSLayoutConstraint (item)
@property (nonatomic,readonly)ZLConstraintItem *item;
@end


NS_ASSUME_NONNULL_END
