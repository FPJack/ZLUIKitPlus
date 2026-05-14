//
//  ZLStackEdgeInsets.h
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/5/4.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZLBaseStackView,ZLLayoutGuide;
@interface ZLMargeGuide : UILayoutGuide
@property (nonatomic,weak)NSLayoutConstraint *top;
@property (nonatomic,weak)NSLayoutConstraint *leading;
@property (nonatomic,weak)NSLayoutConstraint *bottom;
@property (nonatomic,weak)NSLayoutConstraint *trailing;
@end
NS_ASSUME_NONNULL_BEGIN
@interface ZLStackEdgeInsets : NSObject
@property (nonatomic,weak)ZLBaseStackView *stackView;
@property (nonatomic,readonly)NSLayoutXAxisAnchor *jLeadingAnchor;
@property (nonatomic,readonly)NSLayoutXAxisAnchor *jTrailingAnchor;
@property (nonatomic,readonly)NSLayoutYAxisAnchor *jTopAnchor;
@property (nonatomic,readonly)NSLayoutYAxisAnchor *jBottomAnchor;


@property (nonatomic,readonly)NSLayoutXAxisAnchor *leadingAnchor;
@property (nonatomic,readonly)NSLayoutXAxisAnchor *trailingAnchor;
@property (nonatomic,readonly)NSLayoutYAxisAnchor *topAnchor;
@property (nonatomic,readonly)NSLayoutYAxisAnchor *bottomAnchor;
@property (nonatomic,readonly)NSLayoutYAxisAnchor *centerYAnchor;
@property (nonatomic,readonly)NSLayoutXAxisAnchor *centerXAnchor;


@property (nonatomic,copy)NSArray<NSLayoutDimension *> *widthAnchors;
@property (nonatomic,copy)NSArray<NSLayoutDimension *> *heightAnchors;

@property (nonatomic,assign)UIEdgeInsets insets;

- (void)removeEdgeInsets;
@end

NS_ASSUME_NONNULL_END
