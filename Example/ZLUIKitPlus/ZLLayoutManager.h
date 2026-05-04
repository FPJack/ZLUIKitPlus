//
//  ZLLayoutManager.h
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/5/4.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLLayoutGuide.h"

NS_ASSUME_NONNULL_BEGIN
@class ZLStackView;
@interface ZLLayoutManager : NSObject
@property (nonatomic,weak)ZLStackView *stackView;
- (void)addHorizontalLayoutConstraints;
- (void)addVerticalLayoutConstraints;
///激活所有约束
- (void)activateConstraints;
- (void)deactivateConstraints;
@end

NS_ASSUME_NONNULL_END
