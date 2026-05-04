//
//  ZLStackEdgeInsets.m
//  ZLUIKitPlus_Example
//
//  Created by Qiuxia Cui on 2026/5/4.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLStackEdgeInsets.h"
#import "ZLStackView.h"
#import "ZLLayoutGuide.h"
@interface ZLTopGuide : ZLLayoutGuide
@end
@implementation ZLTopGuide
@end
@interface ZLLeadingGuide : ZLLayoutGuide
@end
@implementation ZLLeadingGuide
@end
@interface ZLBottomGuide : ZLLayoutGuide
@end
@implementation ZLBottomGuide
@end
@interface ZLTrailingGuide : ZLLayoutGuide
@end
@implementation ZLTrailingGuide
@end
@interface ZLStackEdgeInsets()
@property (nonatomic,strong)ZLLayoutGuide *topGuide;
@property (nonatomic,strong)ZLLayoutGuide *leadingGuide;
@property (nonatomic,strong)ZLLayoutGuide *bottomGuide;
@property (nonatomic,strong)ZLLayoutGuide *trailingGuide;
@end
@implementation ZLStackEdgeInsets
- (NSLayoutXAxisAnchor *)leadingAnchor {
    switch (self.stackView.justify) {
        case ZLJustifyCenter:
        case ZlJustifySpaceAround:
        case ZlJustifySpaceEvenly:
        {
            return self.leadingGuide.trailingAnchor;
        }
            break;
        default:
            break;
    }
    return self.stackView.leadingAnchor;
}

- (NSLayoutXAxisAnchor *)trailingAnchor {
    switch (self.stackView.justify) {
        case ZLJustifyCenter:
        case ZlJustifySpaceAround:
        case ZlJustifySpaceEvenly:
        {
            return self.trailingGuide.leadingAnchor;
        }
            break;
        default:
            break;
    }
    return self.stackView.trailingAnchor;
}

- (NSLayoutYAxisAnchor *)topAnchor {
    switch (self.stackView.justify) {
        case ZLJustifyCenter:
        case ZlJustifySpaceAround:
        case ZlJustifySpaceEvenly:
        {
            return self.topGuide.bottomAnchor;
        }
            break;
        default:
            break;
    }
    return self.stackView.topAnchor;
}
- (NSLayoutYAxisAnchor *)bottomAnchor {
    switch (self.stackView.justify) {
        case ZLJustifyCenter:
        case ZlJustifySpaceAround:
        case ZlJustifySpaceEvenly:
        {
            return self.bottomGuide.topAnchor;
        }
            break;
        default:
            break;
    }
    return self.stackView.bottomAnchor;
}

- (NSArray<NSLayoutDimension *> *)widthAnchors {
    return @[
        self.leadingGuide.widthAnchor,
        self.trailingGuide.widthAnchor
    ];
}
- (NSArray<NSLayoutDimension *> *)heightAnchors {
    return @[
        self.topGuide.heightAnchor,
        self.bottomGuide.heightAnchor
    ];
}
- (UILayoutGuide *)topGuide {
    if (!_topGuide) {
        _topGuide = [[ZLTopGuide alloc] init];
        [self.stackView addLayoutGuide:_topGuide];
        [_topGuide.topAnchor constraintEqualToAnchor:self.stackView.topAnchor].active = YES;
    }
    return _topGuide;
}
- (UILayoutGuide *)leadingGuide {
    if (!_leadingGuide) {
        _leadingGuide = [[ZLLeadingGuide alloc] init];
        [self.stackView addLayoutGuide:_leadingGuide];
        [_leadingGuide.leadingAnchor constraintEqualToAnchor:self.stackView.leadingAnchor].active = YES;
    }
    return _leadingGuide;
}
- (UILayoutGuide *)bottomGuide {
    if (!_bottomGuide) {
        _bottomGuide = [[ZLBottomGuide alloc] init];
        [self.stackView addLayoutGuide:_bottomGuide];
        [_bottomGuide.bottomAnchor constraintEqualToAnchor:self.stackView.bottomAnchor].active = YES;
    }
    return _bottomGuide;
}

- (UILayoutGuide *)trailingGuide {
    if (!_trailingGuide) {
        _trailingGuide = [[ZLTrailingGuide alloc] init];
        [self.stackView addLayoutGuide:_trailingGuide];
        [self.stackView.trailingAnchor constraintEqualToAnchor:_trailingGuide.trailingAnchor].active = YES;
        //[_trailingGuide.trailingAnchor constraintEqualToAnchor:self.stackView.trailingAnchor].active = YES;
    }
    return _trailingGuide;
}
@end
