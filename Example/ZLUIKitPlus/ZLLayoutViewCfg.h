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
@interface ZLLayoutViewCfg : NSObject
@property (nonatomic,assign)CGFloat startSpacing;
@property (nonatomic,assign)CGFloat endSpacing;
@property (nonatomic,assign)CGFloat behindSpacing;
@property (nonatomic,assign)BOOL    isFlexSpace;
@property (nonatomic,assign)ZLAlign alignSelf;

///是否设置对齐方式
@property (nonatomic,assign)BOOL isSetAlign;
@property (nonatomic,weak)ZLStackView *stackView;


@property (nonatomic,weak)UIView *view;

@property (nonatomic,readonly)UIEdgeInsets insets;
@property(nonatomic,assign)BOOL isFirstView;
@property(nonatomic,assign)BOOL isLastView;
@property(nonatomic,readonly)ZLJustify justify;
@property(nonatomic,readonly)CGFloat spacing;

///记录已kvo
@property (nonatomic,assign)BOOL isKVOAdded;
@end

NS_ASSUME_NONNULL_END
