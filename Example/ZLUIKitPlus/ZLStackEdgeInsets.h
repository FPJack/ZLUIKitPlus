//
//  ZLStackEdgeInsets.h
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/5/4.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZLStackView,ZLLayoutGuide;
NS_ASSUME_NONNULL_BEGIN
@interface ZLStackEdgeInsets : NSObject
@property (nonatomic,weak)ZLStackView *stackView;
@property (nonatomic,readonly)NSLayoutXAxisAnchor *leadingAnchor;
@property (nonatomic,readonly)NSLayoutXAxisAnchor *trailingAnchor;
@property (nonatomic,readonly)NSLayoutYAxisAnchor *topAnchor;
@property (nonatomic,readonly)NSLayoutYAxisAnchor *bottomAnchor;
@property (nonatomic,copy)NSArray<NSLayoutDimension *> *widthAnchors;
@property (nonatomic,copy)NSArray<NSLayoutDimension *> *heightAnchors;
@end

NS_ASSUME_NONNULL_END
