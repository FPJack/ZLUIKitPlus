//
//  ZLFlexItem.h
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/5/4.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLLayoutGuide.h"
NS_ASSUME_NONNULL_BEGIN
@class ZLStackView;
@class ZLFlexItem;
@interface UIView (Flex)
@property (nonatomic,readonly)ZLFlexItem *zl_flex;
@end


@interface ZLFlexItem : NSObject

@property (nonatomic,assign)CGFloat startSpacing;

@property (nonatomic,assign)CGFloat endSpacing;

@property (nonatomic,assign)CGFloat spacing;

@property (nonatomic,assign)CGFloat minSpacing;

@property (nonatomic,assign)CGFloat maxSpacing;

@property (nonatomic,assign)BOOL    isFlexSpace; ///ZLJustifyFill 才会有效

///弹性权重（横向=宽度比例，纵向=高度比例）
@property (nonatomic,assign)NSInteger flexValue;

//弹性权重（横向=宽度比例，纵向=高度比例）
@property (nonatomic,assign)ZLAlign alignSelf;


///链式配置
@property(readonly)ZLFlexItem *(^start)(CGFloat spacing);
@property(readonly)ZLFlexItem *(^end)(CGFloat spacing);
@property(readonly)ZLFlexItem *(^space)(CGFloat spacing);
@property(readonly)ZLFlexItem *(^minSpace)(CGFloat spacing);
@property(readonly)ZLFlexItem *(^maxSpace)(CGFloat spacing);
@property(readonly)ZLFlexItem *(^flexSpace)(BOOL isFlex);
@property(readonly)ZLFlexItem *(^align)(ZLAlign align);
@property(readonly)ZLFlexItem *(^flex)(NSInteger flex);
@end

NS_ASSUME_NONNULL_END
