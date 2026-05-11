//
//  ZLLayoutViewFlex.h
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/5/4.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLLayoutGuide.h"
NS_ASSUME_NONNULL_BEGIN
@class ZLStackView;
@class ZLLayoutViewFlex;
@interface UIView (Flex)
@property (nonatomic,readonly)ZLLayoutViewFlex *zl_flex;
@end


@interface ZLLayoutViewFlex : NSObject

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
@property(readonly)ZLLayoutViewFlex *(^start)(CGFloat spacing);
@property(readonly)ZLLayoutViewFlex *(^end)(CGFloat spacing);
@property(readonly)ZLLayoutViewFlex *(^space)(CGFloat spacing);
@property(readonly)ZLLayoutViewFlex *(^minSpace)(CGFloat spacing);
@property(readonly)ZLLayoutViewFlex *(^maxSpace)(CGFloat spacing);
@property(readonly)ZLLayoutViewFlex *(^flexSpace)(BOOL isFlex);
@property(readonly)ZLLayoutViewFlex *(^align)(ZLAlign align);
@property(readonly)ZLLayoutViewFlex *(^flex)(NSInteger flex);
@end

NS_ASSUME_NONNULL_END
