//
//  ZLLayoutGuide.m
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/5/4.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLLayoutGuide.h"

@implementation ZLLayoutGuide
- (void)setStackView:(UIView *)stackView{
    _stackView = stackView;
    if (stackView) {
        [stackView addLayoutGuide:self];
    }
}
@end
