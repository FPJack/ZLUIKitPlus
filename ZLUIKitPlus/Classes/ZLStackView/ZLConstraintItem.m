//
//  ZLConstraintItem.m
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/5/4.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLConstraintItem.h"
#import <objc/runtime.h>
@implementation ZLConstraintItem
@end
@implementation NSLayoutConstraint (item)
- (ZLConstraintItem *)item {
    ZLConstraintItem *item = objc_getAssociatedObject(self, _cmd);
    if (!item) {
        item = ZLConstraintItem.new;
        objc_setAssociatedObject(self, _cmd, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return item;
}
@end
