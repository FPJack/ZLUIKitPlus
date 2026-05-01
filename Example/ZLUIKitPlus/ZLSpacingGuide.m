//
//  ZLSpacingGuide.m
//  ZLUIKitPlus_Example
//
//  Created by admin on 2026/5/1.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLSpacingGuide.h"

@implementation ZLSpacingGuide
- (NSLayoutConstraint *)addGreadThanWidthCons {
   [self.stackView addLayoutGuide:self];
    self.widthCons = [self.widthAnchor constraintGreaterThanOrEqualToConstant:0];
    return self.widthCons;
}
- (NSLayoutConstraint *)addGreadThanHeightCons {
    [self.stackView addLayoutGuide:self];
    self.heightCons =  [self.heightAnchor constraintGreaterThanOrEqualToConstant:0];
    return self.heightCons;
}
- (void)addZeroHeightCons {
    if (_heightCons) {
        _heightCons.active = NO;
    }
    [self.stackView addLayoutGuide:self];
    self.heightCons = [self.heightAnchor constraintEqualToConstant:0];
    self.heightCons.active = YES;

}
- (void)addZeroWidthCons {
    if (_widthCons) {
        _widthCons.active = NO;
    }
   [self.stackView addLayoutGuide:self];
   self.widthCons = [self.widthAnchor constraintEqualToConstant:0];
    self.widthCons.active = YES;
}
@end
