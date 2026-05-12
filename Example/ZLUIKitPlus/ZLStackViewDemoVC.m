//
//  ZLStackViewDemoVC.m
//  ZLUIKitPlus_Example
//
//  Created by admin on 2026/5/11.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "ZLStackViewDemoVC.h"
#import "ZLStackView.h"
#import "ZLUI.h"
#import <objc/runtime.h>

// ─────────────────────────────────────────
#pragma mark - 辅助函数
// ─────────────────────────────────────────

static UILabel *colorBlock(NSString *text, UIColor *color) {
    UILabel *l = UILabel.new;
    l.text = text;
    l.textAlignment = NSTextAlignmentCenter;
    l.font = [UIFont systemFontOfSize:13];
    l.textColor = UIColor.whiteColor;
    l.backgroundColor = color;
    l.layer.cornerRadius = 4;
    l.layer.masksToBounds = YES;
    return l;
}

static UIColor *randColor(void) {
    static NSArray *colors;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        colors = @[
            [UIColor colorWithRed:0.96 green:0.26 blue:0.21 alpha:1],
            [UIColor colorWithRed:0.13 green:0.59 blue:0.95 alpha:1],
            [UIColor colorWithRed:0.30 green:0.69 blue:0.31 alpha:1],
            [UIColor colorWithRed:1.00 green:0.60 blue:0.00 alpha:1],
            [UIColor colorWithRed:0.61 green:0.15 blue:0.69 alpha:1],
            [UIColor colorWithRed:0.00 green:0.74 blue:0.83 alpha:1],
        ];
    });
    static NSUInteger idx = 0;
    return colors[(idx++) % colors.count];
}

static ZLStackView *sectionView(NSString *title) {
    ZLStackView *s = VStackView
        .space(10)
        .alignFill
        .inset(12, 12, 12, 12)
        .border(1, @"#DDDDDD")
        .corner(8)
        .masksToBounds(YES);
    UILabel *titleLab = UILabel.new;
    titleLab.text = title;
    titleLab.font = [UIFont boldSystemFontOfSize:13];
    titleLab.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    [s addArrangedSubview:titleLab];
    return s;
}

@interface ZLStackViewDemoVC ()
@property (nonatomic, strong) ZLStackView *contentStack;
@end

@implementation ZLStackViewDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZLStackView Demo";
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];

    ZLStackView *stack;
    ZLStackView.vertical.space(16).inset(16, 16, 16, 16)
        .assignToPtr(&stack)
        .wrapScrollView
        .KFC
        .addToFull(self.view);
    self.contentStack = stack;

    [self buildDemos];
}

- (void)buildDemos {
    [self demo01_axisAndSpacing];
    [self demo02_justifyContent];
    [self demo03_alignment];
    [self demo04_insets];
    [self demo05_customSpacing];
    [self demo06_flexibleSpacing];
    [self demo07_flex];
    [self demo08_alignSelf];
    [self demo09_alignStartEndSpacing];
    [self demo10_hiddenAutoLayout];
    [self demo11_addLayout];
    [self demo12_removeView];
    [self demo13_insertAtIndex];
    [self demo14_tapAction];
    [self demo15_chainAPI];
    [self demo16_wrapScrollViewHorizontal];
    [self demo17_wrapScrollViewVertical];
    [self demo18_nestedStack];
}

// ─────────────────────────────────────────
#pragma mark - Demo 01: axis + spacing
// ─────────────────────────────────────────
- (void)demo01_axisAndSpacing {
    ZLStackView *sec = sectionView(@"01. axis 轴向 + spacing 间距");
    [_contentStack addArrangedSubview:sec];

    ZLStackView *h = ZLStackView.horizontal.alignCenter.space(8);
    for (int i = 1; i <= 4; i++) {
        UILabel *l = colorBlock([NSString stringWithFormat:@"H%d", i], randColor());
//        l.KFC.square(36);
        [h addArrangedSubview:l];
    }
    [sec addArrangedSubview:h];

    ZLStackView *v = ZLStackView.vertical.alignStart.space(6);
    for (int i = 1; i <= 3; i++) {
        UILabel *l = colorBlock([NSString stringWithFormat:@"V%d", i], randColor());
//        l.KFC.height(28);
        [v addArrangedSubview:l];
    }
    [sec addArrangedSubview:v];
}

// ─────────────────────────────────────────
#pragma mark - Demo 02: justifyContent 主轴对齐
// ─────────────────────────────────────────
- (void)demo02_justifyContent {
    ZLStackView *sec = sectionView(@"02. justifyContent 主轴对齐");
    [_contentStack addArrangedSubview:sec];

    NSArray *modes = @[
        @[@"justifyStart",        @(ZLJustifyStart)],
        @[@"justifyCenter",       @(ZLJustifyCenter)],
        @[@"justifyEnd",          @(ZLJustifyEnd)],
        @[@"justifyFill",         @(ZLJustifyFill)],
        @[@"justifyFillEqually",  @(ZLJustifyFillEqually)],
        @[@"justifySpaceBetween", @(ZLJustifySpaceBetween)],
        @[@"justifySpaceAround",  @(ZLJustifySpaceAround)],
        @[@"justifySpaceEvenly",  @(ZLJustifySpaceEvenly)],
    ];

    for (NSArray *item in modes) {
        UILabel *name = UILabel.new;
        name.text = item[0];
        name.font = [UIFont systemFontOfSize:11];
        name.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [sec addArrangedSubview:name];

        ZLStackView *row = ZLStackView.horizontal.alignFill.bgColor(@"#EFEFEF");
        row.justifyContent = [item[1] integerValue];
        row.KFC.height(36);
        for (int i = 0; i < 3; i++) {
            [row addArrangedSubview:colorBlock(@"●●", randColor())];
        }
        [sec addArrangedSubview:row];
    }
}

// ─────────────────────────────────────────
#pragma mark - Demo 03: alignment 纵轴对齐
// ─────────────────────────────────────────
- (void)demo03_alignment {
    ZLStackView *sec = sectionView(@"03. alignment 纵轴对齐");
    [_contentStack addArrangedSubview:sec];

    NSArray *aligns = @[
        @[@"alignStart",  @(ZLAlignStart)],
        @[@"alignCenter", @(ZLAlignCenter)],
        @[@"alignEnd",    @(ZLAlignEnd)],
        @[@"alignFill",   @(ZLAlignFill)],
    ];
    for (NSArray *item in aligns) {
        UILabel *name = UILabel.new;
        name.text = item[0];
        name.font = [UIFont systemFontOfSize:11];
        name.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [sec addArrangedSubview:name];

        ZLStackView *row = ZLStackView.horizontal.space(8).bgColor(@"#EFEFEF").justifyCenter;
        row.alignment = [item[1] integerValue];
        row.KFC.height(70);
        NSArray *sizes = @[@20, @40, @60];
        for (NSNumber *h in sizes) {
            UILabel *b = colorBlock(@"", randColor());
            b.KFC.width(36);
            if ([item[1] integerValue] != ZLAlignFill) b.KFC.height(h.floatValue);
            [row addArrangedSubview:b];
        }
        [sec addArrangedSubview:row];
    }
}

// ─────────────────────────────────────────
#pragma mark - Demo 04: insets 内边距
// ─────────────────────────────────────────
- (void)demo04_insets {
    ZLStackView *sec = sectionView(@"04. insets 内边距");
    [_contentStack addArrangedSubview:sec];

    ZLStackView *row = ZLStackView.horizontal.space(8).inset(16, 20, 16, 20).bgColor(@"#EFEFEF");
    for (int i = 0; i < 3; i++) {
        [row addArrangedSubview:colorBlock([NSString stringWithFormat:@"item%d", i+1], randColor())];
    }
    [sec addArrangedSubview:row];

    ZLStackView *row2 = ZLStackView.horizontal.space(8).vInset(8, 8).hInset(20, 20).bgColor(@"#E0E0E0");
    for (int i = 0; i < 3; i++) {
        [row2 addArrangedSubview:colorBlock([NSString stringWithFormat:@"v%d", i+1], randColor())];
    }
    [sec addArrangedSubview:row2];
}

// ─────────────────────────────────────────
#pragma mark - Demo 05: customSpacing
// ─────────────────────────────────────────
- (void)demo05_customSpacing {
    ZLStackView *sec = sectionView(@"05. customSpacing / minSpacing / maxSpacing");
    sec.alignment = ZLAlignCenter;
    [_contentStack addArrangedSubview:sec];

    UILabel *a = colorBlock(@"A", randColor()); a.KFC.size(40, 32);
    UILabel *b = colorBlock(@"B", randColor()); b.KFC.size(40, 32);
    UILabel *c = colorBlock(@"C", randColor()); c.KFC.size(40, 32);
    ZLStackView *row = ZLStackView.horizontal.space(4).alignCenter;
    [row addArrangedSubview:a];
    [row setCustomSpacing:20 afterView:a];
    [row addArrangedSubview:b];
    [row setCustomMinSpacing:4 afterView:b];
    [row setCustomMaxSpacing:30 afterView:b];
    [row addArrangedSubview:c];
    [sec addArrangedSubview:row];

    UILabel *x = colorBlock(@"X", randColor()); x.KFC.size(40, 32);
    UILabel *y = colorBlock(@"Y", randColor()); y.KFC.size(40, 32);
    UILabel *z = colorBlock(@"Z", randColor()); z.KFC.size(40, 32);
    ZLStackView *row2 = ZLStackView.horizontal.space(4).alignCenter
        .addView(x).spacingAfter(24,x)
        .addView(y).minSpacingAfter(4,y).maxSpacingAfter( 40,y)
        .addView(z);
    [sec addArrangedSubview:row2];
}

// ─────────────────────────────────────────
#pragma mark - Demo 06: flexibleSpacing 弹性间距
// ─────────────────────────────────────────
- (void)demo06_flexibleSpacing {
    ZLStackView *sec = sectionView(@"06. flexibleSpacing 弹性间距（justifyFill 下）");
    [_contentStack addArrangedSubview:sec];

    UILabel *left  = colorBlock(@"Left",  randColor());
    UILabel *mid   = colorBlock(@"Mid",   randColor());
    UILabel *right = colorBlock(@"Right", randColor());
    ZLStackView *row = ZLStackView.horizontal.justifyFill.bgColor(@"#EFEFEF");
    [row addArrangedSubview:left];
    [row setFlexibleSpacing:YES afterView:left];
    [row addArrangedSubview:mid];
    [row addArrangedSubview:right];
    [sec addArrangedSubview:row];

    UILabel *l1 = colorBlock(@"◀", randColor());
    UILabel *l2 = colorBlock(@"●", randColor());
    UILabel *l3 = colorBlock(@"▶", randColor());
    ZLStackView *row2 = ZLStackView.horizontal.justifyFill.bgColor(@"#E0E0E0")
        .addView(l1).flexSpacingAfter(YES,l1)
        .addView(l2).flexSpacingAfter(YES,l2)
        .addView(l3);
    [sec addArrangedSubview:row2];
}

// ─────────────────────────────────────────
#pragma mark - Demo 07: flex 权重
// ─────────────────────────────────────────
- (void)demo07_flex {
    ZLStackView *sec = sectionView(@"07. flex 权重（类似 flexbox flex:N）");
    [_contentStack addArrangedSubview:sec];

    UILabel *a = colorBlock(@"flex:1", randColor()); a.KFC.height(36);
    UILabel *b = colorBlock(@"flex:2", randColor()); b.KFC.height(36);
    UILabel *c = colorBlock(@"flex:1", randColor()); c.KFC.height(36);
    ZLStackView *row = ZLStackView.horizontal.justifyFill.space(4);
    [row addArrangedSubview:a]; [row setFlex:1 forView:a];
    [row addArrangedSubview:b]; [row setFlex:2 forView:b];
    [row addArrangedSubview:c]; [row setFlex:1 forView:c];
    [sec addArrangedSubview:row];

    UILabel *x = colorBlock(@"1", randColor()); x.KFC.height(36);
    UILabel *y = colorBlock(@"3", randColor()); y.KFC.height(36);
    UILabel *z = colorBlock(@"1", randColor()); z.KFC.height(36);
    ZLStackView *row2 = ZLStackView.horizontal.justifyFill.space(4)
        .addView(x).flexFor(1,x)
        .addView(y).flexFor(3,y)
        .addView(z).flexFor(1,z);
    [sec addArrangedSubview:row2];
}

// ─────────────────────────────────────────
#pragma mark - Demo 08: alignSelf
// ─────────────────────────────────────────
- (void)demo08_alignSelf {
    ZLStackView *sec = sectionView(@"08. alignSelf 单个 view 覆盖纵轴对齐");
    [_contentStack addArrangedSubview:sec];

    ZLStackView *row = ZLStackView.horizontal.alignCenter.space(8).bgColor(@"#EFEFEF");
    row.KFC.height(70);
    UILabel *a = colorBlock(@"Start",  randColor()); a.KFC.width(52);
    UILabel *b = colorBlock(@"Center", randColor()); b.KFC.width(52);
    UILabel *c = colorBlock(@"End",    randColor()); c.KFC.width(52);
    UILabel *d = colorBlock(@"Fill",   randColor()); d.KFC.width(52);
    [row addArrangedSubview:a]; [row setAlignment:ZLAlignStart  forView:a];
    [row addArrangedSubview:b]; [row setAlignment:ZLAlignCenter forView:b];
    [row addArrangedSubview:c]; [row setAlignment:ZLAlignEnd    forView:c];
    [row addArrangedSubview:d]; [row setAlignment:ZLAlignFill   forView:d];
    [sec addArrangedSubview:row];
}

// ─────────────────────────────────────────
#pragma mark - Demo 09: alignStartSpacing / alignEndSpacing
// ─────────────────────────────────────────
- (void)demo09_alignStartEndSpacing {
    ZLStackView *sec = sectionView(@"09. alignmentStart/EndSpacing 纵轴方向偏移");
    [_contentStack addArrangedSubview:sec];

    ZLStackView *row = ZLStackView.horizontal.alignStart.space(8).bgColor(@"#EFEFEF");
    UILabel *a = colorBlock(@"A\nstart+10", randColor()); a.numberOfLines = 0; a.KFC.width(80);
    UILabel *b = colorBlock(@"B\nend+30",   randColor()); b.numberOfLines = 0; b.KFC.width(80);
    UILabel *c = colorBlock(@"C\nnormal",   randColor()); c.numberOfLines = 0; c.KFC.width(80);
    [row addArrangedSubview:a]; [row setAlignmentStartSpacing:10 forView:a];
    [row addArrangedSubview:b]; [row setAlignmentEndSpacing:30   forView:b];
    [row addArrangedSubview:c];
    [sec addArrangedSubview:row];
}

// ─────────────────────────────────────────
#pragma mark - Demo 10: hidden 自动重排
// ─────────────────────────────────────────
- (void)demo10_hiddenAutoLayout {
    ZLStackView *sec = sectionView(@"10. hidden 自动重排（点击 B 切换）");
    [_contentStack addArrangedSubview:sec];

    ZLStackView *row = ZLStackView.horizontal.space(8);
    UILabel *a = colorBlock(@"A", randColor()); a.KFC.square(50);
    UILabel *b = colorBlock(@"B(tap)", randColor()); b.KFC.square(50);
    UILabel *c = colorBlock(@"C", randColor()); c.KFC.square(50);
    row.addView(a).addView(b).addView(c);

    UILabel *tip = UILabel.new;
    tip.text = @"B 已隐藏，A C 自动补位";
    tip.font = [UIFont systemFontOfSize:11];
    tip.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    tip.hidden = YES;

    b.userInteractionEnabled = YES;
    __weak typeof(b) weakB = b;
    __weak typeof(tip) weakTip = tip;
    UITapGestureRecognizer *gr = UITapGestureRecognizer.new;
    void(^handler)(void) = ^{ weakB.hidden = !weakB.hidden; weakTip.hidden = !weakB.hidden; };
    objc_setAssociatedObject(gr, "h", handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [gr addTarget:self action:@selector(_onTapB:)];
    [b addGestureRecognizer:gr];

    [sec addArrangedSubview:row];
    [sec addArrangedSubview:tip];
}
- (void)_onTapB:(UITapGestureRecognizer *)gr {
    void(^h)(void) = objc_getAssociatedObject(gr, "h");
    if (h) h();
}

// ─────────────────────────────────────────
#pragma mark - Demo 11: addLayout block
// ─────────────────────────────────────────
- (void)demo11_addLayout {
    ZLStackView *sec = sectionView(@"11. addArrangedSubview:layout: 添加时配置 flexItem");
    [_contentStack addArrangedSubview:sec];

    ZLStackView *row = ZLStackView.horizontal.justifyFill.space(8);
    NSArray *titles = @[@"flex:1", @"flex:2", @"flex:1"];
    NSArray *flexes  = @[@1, @2, @1];
    for (int i = 0; i < 3; i++) {
        UILabel *l = colorBlock(titles[i], randColor());
        l.KFC.height(36);
        NSInteger flex = [flexes[i] integerValue];
        [row addArrangedSubview:l layout:^(__kindof UIView *view, ZLFlexItem *item) {
            item.flexValue = flex;
        }];
    }
    [sec addArrangedSubview:row];
}

// ─────────────────────────────────────────
#pragma mark - Demo 12: removeArrangedSubview
// ─────────────────────────────────────────
- (void)demo12_removeView {
    ZLStackView *sec = sectionView(@"12. removeArrangedSubview（0.8s 后移除 B）");
    [_contentStack addArrangedSubview:sec];

    UILabel *a = colorBlock(@"A", randColor()); a.KFC.size(60, 36);
    UILabel *b = colorBlock(@"B(移除)", randColor()); b.KFC.size(80, 36);
    UILabel *c = colorBlock(@"C", randColor()); c.KFC.size(60, 36);
    ZLStackView *row = ZLStackView.horizontal.space(8).addView(a).addView(b).addView(c);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [row removeArrangedSubview:b];
    });
    [sec addArrangedSubview:row];
}

// ─────────────────────────────────────────
#pragma mark - Demo 13: insertArrangedSubview:atIndex:
// ─────────────────────────────────────────
- (void)demo13_insertAtIndex {
    ZLStackView *sec = sectionView(@"13. insertArrangedSubview:atIndex:（2s 后插入 B）");
    [_contentStack addArrangedSubview:sec];

    UILabel *a = colorBlock(@"A", randColor()); a.KFC.size(40, 36);
    UILabel *c = colorBlock(@"C", randColor()); c.KFC.size(40, 36);
    ZLStackView *row = ZLStackView.horizontal.space(8).addView(a).addView(c);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UILabel *b = colorBlock(@"B(插入)", randColor());
        b.KFC.size(70, 36);
        [row insertArrangedSubview:b atIndex:1];
    });
    [sec addArrangedSubview:row];
}

// ─────────────────────────────────────────
#pragma mark - Demo 14: tapAction
// ─────────────────────────────────────────
- (void)demo14_tapAction {
    ZLStackView *sec = sectionView(@"14. tapAction 点击事件");
    [_contentStack addArrangedSubview:sec];

    UILabel *result = UILabel.new;
    result.text = @"点击下面的 StackView";
    result.font = [UIFont systemFontOfSize:13];
    result.textAlignment = NSTextAlignmentCenter;
    [sec addArrangedSubview:result];

    __weak typeof(result) weakResult = result;
    ZLStackView *row = ZLStackView.horizontal.justifyCenter.alignCenter
        .inset(12, 12, 12, 12)
        .bgColor(@"#2196F3")
        .corner(8)
        .masksToBounds(YES)
        .tapAction(^(ZLBaseStackView *v) {
            static int cnt = 0;
            weakResult.text = [NSString stringWithFormat:@"点击了 %d 次", ++cnt];
        });
    [row addArrangedSubview:colorBlock(@"点击我", UIColor.whiteColor)];
    [sec addArrangedSubview:row];
}

// ─────────────────────────────────────────
#pragma mark - Demo 15: 链式 API 综合
// ─────────────────────────────────────────
- (void)demo15_chainAPI {
    ZLStackView *sec = sectionView(@"15. 链式 API 综合");
    [_contentStack addArrangedSubview:sec];

    // 圆角 + 边框 + 阴影
    ZLStackView *row = ZLStackView.horizontal.justifyCenter.alignCenter
        .space(10).inset(12, 16, 12, 16)
        .bgColor(@"#4A90D9")
        .corner(12)
        .border(1, @"#FFFFFF")
        .shColor(@"#000000").shOpacity(0.25).shRadius(8).shOffset(0, 4);
    for (int i = 1; i <= 3; i++) {
        UILabel *l = colorBlock([NSString stringWithFormat:@"item%d", i], UIColor.whiteColor);
        l.KFC.height(30);
        [row addArrangedSubview:l];
    }
    [sec addArrangedSubview:row];

    // visibility + alphaValue
    UILabel *vis = colorBlock(@"visibility=YES", randColor()); vis.KFC.height(32);
    UILabel *alp = colorBlock(@"alpha=0.3", randColor());      alp.KFC.height(32);
    ZLStackView *row2 = ZLStackView.horizontal.space(8)
        .addView(vis).visibility(YES)
        .addView(alp).alphaValue(0.3);
    [sec addArrangedSubview:row2];

    // userActive=NO
    ZLStackView *row3 = ZLStackView.horizontal.justifyCenter.alignCenter
        .inset(8, 12, 8, 12).bgColor(@"#9E9E9E").corner(8).masksToBounds(YES)
        .userActive(NO);
    [row3 addArrangedSubview:colorBlock(@"userActive=NO（禁用交互）", UIColor.whiteColor)];
    [sec addArrangedSubview:row3];
}

// ─────────────────────────────────────────
#pragma mark - Demo 16: wrapScrollView 水平滚动
// ─────────────────────────────────────────
- (void)demo16_wrapScrollViewHorizontal {
    ZLStackView *sec = sectionView(@"16. wrapScrollView 水平滚动");
    [_contentStack addArrangedSubview:sec];

    ZLStackView *hStack = ZLStackView.horizontal.space(8).inset(8, 8, 8, 8).bgColor(@"#EFEFEF");
    for (int i = 1; i <= 12; i++) {
        UILabel *l = colorBlock([NSString stringWithFormat:@"item%d", i], randColor());
        l.KFC.size(64, 40);
        [hStack addArrangedSubview:l];
    }
    UIScrollView *sv = [hStack wrapScrollView];
    sv.KFC.height(56);
    [sec addArrangedSubview:sv];
}

// ─────────────────────────────────────────
#pragma mark - Demo 17: wrapScrollView 垂直滚动
// ─────────────────────────────────────────
- (void)demo17_wrapScrollViewVertical {
    ZLStackView *sec = sectionView(@"17. wrapScrollView 垂直滚动");
    [_contentStack addArrangedSubview:sec];

    ZLStackView *vStack = ZLStackView.vertical.space(6).inset(8, 8, 8, 8);
    for (int i = 1; i <= 8; i++) {
        UILabel *l = colorBlock([NSString stringWithFormat:@"row%d（内容超出可滚动）", i], randColor());
        l.KFC.height(36);
        [vStack addArrangedSubview:l];
    }
    UIScrollView *sv = [vStack wrapScrollView];
    sv.KFC.height(120);
    [sec addArrangedSubview:sv];
}

// ─────────────────────────────────────────
#pragma mark - Demo 18: 嵌套 StackView
// ─────────────────────────────────────────
- (void)demo18_nestedStack {
    ZLStackView *sec = sectionView(@"18. 嵌套 StackView（水平嵌垂直，flex 分配宽度）");
    
    [_contentStack addArrangedSubview:sec];

    ZLStackView *left = VStackView
        .space(6)
        .inset(8, 8, 8, 8)
        .bgColor(@"#EFEFEF")
        .corner(6)
        .masksToBounds(YES);
    for (int i = 0; i < 3; i++) {
        UILabel *l = colorBlock([NSString stringWithFormat:@"L%d", i+1], randColor());
        l.KFC.height(28);
        [left addArrangedSubview:l];
    }

    ZLStackView *right = VStackView
        .space(6)
        .inset(8, 8, 8, 8)
        .bgColor(@"#E8E8E8")
        .corner(6)
        .masksToBounds(YES);
    for (int i = 0; i < 3; i++) {
        UILabel *l = colorBlock([NSString stringWithFormat:@"R%d", i+1], randColor());
        l.KFC.height(28);
        [right addArrangedSubview:l];
    }

    ZLStackView *hRow = ZLStackView.horizontal.justifyFill.alignCenter.space(8)
        .addView(left).flexFor(1,left)
        .addView(right).flexFor(2,right);
    [sec addArrangedSubview:hRow];
}

@end
