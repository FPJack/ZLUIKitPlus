//
//  ZLDoubleView.m
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/4/25.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLDoubleView.h"
#define kFT @"BL"
#define kFL @"BR"
#define kFB @"BT"
#define kFR @"BB"
#define kST @"BL"
#define kSL @"BR"
#define kSB @"BT"
#define kSR @"BB"
@interface ZLDoubleView()
@property (nonatomic,strong)NSMutableDictionary *constraintsDic;
@property (nonatomic, strong,readwrite) UIView*  first;
@property (nonatomic, strong,readwrite) UIView* second;
@end

@implementation ZLDoubleView
- (NSMutableDictionary *)constraintsDic{
    if (!_constraintsDic) {
        _constraintsDic = NSMutableDictionary.dictionary;
    }
    return _constraintsDic;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (NSLayoutConstraint *)firstViewTopSpacing:(CGFloat)spacing :(BOOL)isFlexible {
    if (!_first) return nil;
    NSLayoutConstraint *cons;
    if (isFlexible) {
        cons  =  [self.first.topAnchor constraintGreaterThanOrEqualToAnchor:self.layoutMarginsGuide.topAnchor constant:spacing];
    }else {
        cons =  [self.first.topAnchor constraintEqualToAnchor:self.layoutMarginsGuide.topAnchor constant:spacing];
    }
    cons.active = YES;
    cons.identifier = kFT;
    self.constraintsDic[kFT] = cons;
    return cons;
}
- (NSLayoutConstraint *)firstViewLeadSpacing:(CGFloat)spacing :(BOOL)isFlexible {
    if (!_first) return nil;
    NSLayoutConstraint *cons;
    if (isFlexible) {
        cons  =  [self.first.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.layoutMarginsGuide.leadingAnchor constant:spacing];
    }else {
        cons =  [self.first.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor constant:spacing];
    }
    cons.active = YES;
    self.constraintsDic[kFL] = cons;
    return cons;
}

- (NSLayoutConstraint *)firstViewBottomSpacing:(CGFloat)spacing :(BOOL)isFlexible {
    if (!_first) return nil;
    NSLayoutConstraint *cons;
    if (isFlexible) {
        cons  =  [self.first.bottomAnchor constraintLessThanOrEqualToAnchor:self.layoutMarginsGuide.bottomAnchor constant:spacing];
    }else {
        cons =  [self.first.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor constant:spacing];
    }
    cons.active = YES;
    self.constraintsDic[kFL] = cons;
    return cons;
}


@end
