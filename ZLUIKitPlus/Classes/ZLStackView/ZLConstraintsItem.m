//
//  ZLConstraintsItem.m
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/5/4.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLConstraintsItem.h"
#import <objc/runtime.h>
@implementation ZLConstraintsItem
@end
@implementation NSLayoutConstraint (item)
- (ZLConstraintsItem *)item {
    ZLConstraintsItem *item = objc_getAssociatedObject(self, _cmd);
    if (!item) {
        item = ZLConstraintsItem.new;
        objc_setAssociatedObject(self, _cmd, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return item;
}
@end
