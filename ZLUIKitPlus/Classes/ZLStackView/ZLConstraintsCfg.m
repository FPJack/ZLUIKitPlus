//
//  ZLConstraintsCfg.m
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/5/4.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLConstraintsCfg.h"
#import <objc/runtime.h>
@implementation ZLConstraintsCfg
@end
@implementation NSLayoutConstraint (Cfg)
- (ZLConstraintsCfg *)cfg {
    ZLConstraintsCfg *cfg = objc_getAssociatedObject(self, _cmd);
    if (!cfg) {
        cfg = ZLConstraintsCfg.new;
        objc_setAssociatedObject(self, _cmd, cfg, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cfg;
}
@end
