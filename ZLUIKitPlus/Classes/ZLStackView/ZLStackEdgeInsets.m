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


@implementation ZLMargeGuide
- (instancetype)initView:(UIView *)view insets:(UIEdgeInsets)insets {
    self = [super init];
    [view addLayoutGuide:self];
    NSArray *arr = @[
        [self.topAnchor constraintEqualToAnchor:view.topAnchor constant:insets.top],
        [self.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:insets.left],
        [self.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:-insets.bottom],
        [self.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-insets.right]
    ];
    self.top = arr[0];
    self.leading = arr[1];
    self.bottom = arr[2];
    self.trailing = arr[3];
    [NSLayoutConstraint activateConstraints:arr];
    return self;
}
@end
@interface ZLStackEdgeInsets()
@property (nonatomic,strong)ZLLayoutGuide *topGuide;
@property (nonatomic,strong)ZLLayoutGuide *leadingGuide;
@property (nonatomic,strong)ZLLayoutGuide *bottomGuide;
@property (nonatomic,strong)ZLLayoutGuide *trailingGuide;
@property (nonatomic,strong)ZLMargeGuide *margeGuide;
@end
@implementation ZLStackEdgeInsets
- (void)setInsets:(UIEdgeInsets)insets {
    if (!_margeGuide) return;
    if (UIEdgeInsetsEqualToEdgeInsets(_insets, insets)) return;
    self.margeGuide.top.constant = insets.top;
    self.margeGuide.leading.constant = insets.left;
    self.margeGuide.bottom.constant = -insets.bottom;
    self.margeGuide.trailing.constant = -insets.right;
    _insets = insets;
}
- (NSLayoutXAxisAnchor *)jLeadingAnchor {
    switch (self.stackView.justifyContent) {
        case ZLJustifyCenter:
        case ZLJustifySpaceAround:
        case ZLJustifySpaceEvenly:
        {
            return self.leadingGuide.trailingAnchor;
        }
            break;
        default:
            break;
    }
    return self.margeGuide.leadingAnchor;
//    return self.stackView.leadingAnchor;
}

- (NSLayoutXAxisAnchor *)jTrailingAnchor {
    switch (self.stackView.justifyContent) {
        case ZLJustifyCenter:
        case ZLJustifySpaceAround:
        case ZLJustifySpaceEvenly:
        {
            return self.trailingGuide.leadingAnchor;
        }
            break;
        default:
            break;
    }
    return self.margeGuide.trailingAnchor;

//    return self.stackView.trailingAnchor;
}

- (NSLayoutYAxisAnchor *)jTopAnchor {
    switch (self.stackView.justifyContent) {
        case ZLJustifyCenter:
        case ZLJustifySpaceAround:
        case ZLJustifySpaceEvenly:
        {
            return self.topGuide.bottomAnchor;
        }
            break;
        default:
            break;
    }
    return self.margeGuide.topAnchor;

//    return self.stackView.topAnchor;
}
- (NSLayoutYAxisAnchor *)jBottomAnchor {
    switch (self.stackView.justifyContent) {
        case ZLJustifyCenter:
        case ZLJustifySpaceAround:
        case ZLJustifySpaceEvenly:
        {
            return self.bottomGuide.topAnchor;
        }
            break;
        default:
            break;
    }
    return self.margeGuide.bottomAnchor;

//    return self.stackView.bottomAnchor;
}
- (NSLayoutXAxisAnchor *)leadingAnchor {
    return self.margeGuide.leadingAnchor;
}
- (NSLayoutXAxisAnchor *)trailingAnchor {
    return self.margeGuide.trailingAnchor;
}
- (NSLayoutYAxisAnchor *)topAnchor {
    return self.margeGuide.topAnchor;
}
- (NSLayoutYAxisAnchor *)bottomAnchor {
    return self.margeGuide.bottomAnchor;
}
- (NSLayoutYAxisAnchor *)centerYAnchor {
    return self.margeGuide.centerYAnchor;
}
- (NSLayoutXAxisAnchor *)centerXAnchor {
    return self.margeGuide.centerXAnchor;
}
- (void)removeEdgeInsets {
    [_leadingGuide removeFromOwningView];
    _leadingGuide = nil;
    
    [_trailingGuide removeFromOwningView];
    _trailingGuide = nil;
    
    [_topGuide removeFromOwningView];
    _topGuide = nil;
    
    [_bottomGuide removeFromOwningView];
    _bottomGuide = nil;
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
//        [_topGuide.topAnchor constraintEqualToAnchor:self.stackView.topAnchor].active = YES;
        [_topGuide.topAnchor constraintEqualToAnchor:self.margeGuide.topAnchor].active = YES;
    }
    return _topGuide;
}
- (UILayoutGuide *)leadingGuide {
    if (!_leadingGuide) {
        _leadingGuide = [[ZLLeadingGuide alloc] init];
        [self.stackView addLayoutGuide:_leadingGuide];
//        [_leadingGuide.leadingAnchor constraintEqualToAnchor:self.stackView.leadingAnchor].active = YES;
        [_leadingGuide.leadingAnchor constraintEqualToAnchor:self.margeGuide.leadingAnchor].active = YES;
    }
    return _leadingGuide;
}
- (UILayoutGuide *)bottomGuide {
    if (!_bottomGuide) {
        _bottomGuide = [[ZLBottomGuide alloc] init];
        [self.stackView addLayoutGuide:_bottomGuide];
//        [_bottomGuide.bottomAnchor constraintEqualToAnchor:self.stackView.bottomAnchor].active = YES;
        [_bottomGuide.bottomAnchor constraintEqualToAnchor:self.margeGuide.bottomAnchor].active = YES;
    }
    return _bottomGuide;
}

- (UILayoutGuide *)trailingGuide {
    if (!_trailingGuide) {
        _trailingGuide = [[ZLTrailingGuide alloc] init];
        [self.stackView addLayoutGuide:_trailingGuide];
//        [self.stackView.trailingAnchor constraintEqualToAnchor:_trailingGuide.trailingAnchor].active = YES;
        [self.margeGuide.trailingAnchor constraintEqualToAnchor:_trailingGuide.trailingAnchor].active = YES;
        //[_trailingGuide.trailingAnchor constraintEqualToAnchor:self.stackView.trailingAnchor].active = YES;
    }
    return _trailingGuide;
}
- (ZLMargeGuide *)margeGuide {
    if (!_margeGuide) {
        _margeGuide = [[ZLMargeGuide alloc] initView:self.stackView insets:self.stackView.insets];
    }
    return _margeGuide;
}
@end
