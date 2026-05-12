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
#import <Masonry/Masonry.h>

// ─────────────────────────────────────────
#pragma mark - 辅助宏
// ─────────────────────────────────────────

/// 快速创建带文字的色块 label
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

// 带标题的 section 容器
static ZLStackView *sectionView(NSString *title) {
    ZLStackView *s = ZLStackView.vertical;
    s.insets = UIEdgeInsetsMake(12, 12, 12, 12);
    s.spacing = 10;
    s.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
    s.layer.borderWidth = 1;
    s.layer.cornerRadius = 8;
    s.layer.masksToBounds = YES;

    UILabel *titleLab = UILabel.new;
    titleLab.text = title;
    titleLab.font = [UIFont boldSystemFontOfSize:13];
    titleLab.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    [s addArrangedSubview:titleLab];
    return s;
}


@interface ZLStackViewDemoVC ()
@property (nonatomic, strong) ZLStackView  *contentStack;
@end

@implementation ZLStackViewDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZLStackView Demo";
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    
    ZLStackView *view;
    ZLStackView
    .vertical
    .assignToPtr(&view)
    .space(16)
    .vInset(16, 16)
    .hInset(16, 16)
    .wrapScrollView
    .KFC
    .addToFull(self.view);
    
    self.contentStack = view;
    
    [self buildDemos];
}

- (void)buildDemos {
//    [self demo01_axisAndSpacing];
//    [self demo02_justifyContent];
//    [self demo03_alignment];
//    [self demo04_insets];
//    [self demo05_customSpacing];
//    [self demo06_flexibleSpacing];
    
//    [self demo07_flex];
//    [self demo08_alignSelf];
//    [self demo09_alignStartEndSpacing];
//    [self demo10_hiddenAutoLayout];
//    [self demo11_addLayout];
    
//    [self demo12_removeView];
//    [self demo13_insertAtIndex];
//    [self demo14_tapAction];
//    [self demo15_chainAPI];
    [self demo16_scrollStackView];
    [self demo17_wrapScrollView];
    [self demo18_nestedStack];
}

// ─────────────────────────────────────────
#pragma mark - Demo 01: axis + spacing
// ─────────────────────────────────────────
- (void)demo01_axisAndSpacing {
    ZLStackView *sec = sectionView(@"01. axis 轴向 + spacing 间距");
    [_contentStack addArrangedSubview:sec];

    // 水平
    ZLStackView *h = ZLStackView.horizontal;
    h.spacing = 8;
    for (int i = 1; i <= 3; i++) {
        [h addArrangedSubview:colorBlock([NSString stringWithFormat:@"H%d", i], randColor())];
    }
    [sec addArrangedSubview:h];

    // 垂直
    ZLStackView *v = ZLStackView.vertical;
    v.spacing = 6;
    for (int i = 1; i <= 3; i++) {
        UILabel *l = colorBlock([NSString stringWithFormat:@"V%d", i], randColor());
        [v addArrangedSubview:l];
    }
    [sec addArrangedSubview:v];
}

// ─────────────────────────────────────────
#pragma mark - Demo 02: justifyContent 主轴对齐
// ─────────────────────────────────────────
- (void)demo02_justifyContent {
    ZLStackView *sec = sectionView(@"02. justifyContent 主轴对齐");
    sec.alignment = ZLAlignFill; // 纵轴居中
    [_contentStack addArrangedSubview:sec];
    sec.KFC.width(200);
    NSArray *modes = @[
        @[@"justifyStart",       @(ZLJustifyStart)],
        @[@"justifyCenter",      @(ZLJustifyCenter)],
        @[@"justifyEnd",         @(ZLJustifyEnd)],
        @[@"justifyFill",        @(ZLJustifyFill)],
        @[@"justifyFillEqually", @(ZLJustifyFillEqually)],
        @[@"justifySpaceBetween",@(ZLJustifySpaceBetween)],
        @[@"justifySpaceAround", @(ZLJustifySpaceAround)],
        @[@"justifySpaceEvenly", @(ZLJustifySpaceEvenly)],
    ];

    for (NSArray *item in modes) {
        UILabel *nameLabel = UILabel.new;
        nameLabel.text = item[0];
        nameLabel.font = [UIFont systemFontOfSize:11];
        nameLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [sec addArrangedSubview:nameLabel];

        ZLStackView *row = ZLStackView.horizontal;
        row.justifyContent = [item[1] integerValue];
        row.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
        [row mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(36);
        }];
        for (int i = 0; i < 3; i++) {
            UILabel *b = colorBlock(@"●●●●", randColor());
//            [b mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.mas_equalTo(36);
//            }];
            [row addArrangedSubview:b];
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

        ZLStackView *row = ZLStackView.horizontal;
        row.alignment = [item[1] integerValue];
        row.spacing = 8;
        row.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
        [row mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(80);
        }];

        NSArray *heights = @[@20, @36, @50];
        for (NSNumber *h in heights) {
            UILabel *b = colorBlock(@"", randColor());
            [b mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(40);
                if ([item[1] integerValue] != ZLAlignFill) {
                    make.height.mas_equalTo(h);
                }
            }];
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

    ZLStackView *row = ZLStackView.horizontal;
    row.spacing = 8;
    // 用链式 API 设置内边距
    row.inset(16, 20, 16, 20);
    row.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
    for (int i = 0; i < 3; i++) {
        [row addArrangedSubview:colorBlock([NSString stringWithFormat:@"item%d", i+1], randColor())];
    }
    [sec addArrangedSubview:row];

    // vInset hInset
    ZLStackView *row2 = ZLStackView.horizontal;
    row2.spacing = 8;
    row2.vInset(8, 8);
    row2.hInset(12, 12);
    row2.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1];
    for (int i = 0; i < 3; i++) {
        [row2 addArrangedSubview:colorBlock([NSString stringWithFormat:@"v%d", i+1], randColor())];
    }
    [sec addArrangedSubview:row2];
}

// ─────────────────────────────────────────
#pragma mark - Demo 05: customSpacing 自定义间距
// ─────────────────────────────────────────
- (void)demo05_customSpacing {
    ZLStackView *sec = sectionView(@"05. customSpacing / minSpacing / maxSpacing");
    [_contentStack addArrangedSubview:sec];

    ZLStackView *row = ZLStackView.horizontal;
    row.spacing = 4;

    UILabel *a = colorBlock(@"A", randColor());
    UILabel *b = colorBlock(@"B", randColor());
    UILabel *c = colorBlock(@"C", randColor());
    for (UILabel *l in @[a, b, c]) {
        [l mas_makeConstraints:^(MASConstraintMaker *make) { make.width.mas_equalTo(40); }];
        [row addArrangedSubview:l];
    }
    // A 后面固定 20pt
    [row setCustomSpacing:20 afterView:a];
    // B 后面最小 10pt 最大 30pt（justifyFill 时生效）
    [row setCustomMinSpacing:10 afterView:b];
    [row setCustomMaxSpacing:30 afterView:b];

    [sec addArrangedSubview:row];

    // 链式写法
    ZLStackView *row2 = ZLStackView.horizontal;
    row2.spacing = 4;
    UILabel *x = colorBlock(@"X", randColor());
    UILabel *y = colorBlock(@"Y", randColor());
    UILabel *z = colorBlock(@"Z", randColor());
    for (UILabel *l in @[x, y, z]) {
        [l mas_makeConstraints:^(MASConstraintMaker *make) { make.width.mas_equalTo(40); }];
    }
    row2
        .add(x)
        .spacingAfter(x, 24)   // X 后 24pt
        .add(y)
        .minSpacingAfter(y, 8) // Y 后最小 8pt
        .maxSpacingAfter(y, 40)
        .add(z);
    [sec addArrangedSubview:row2];
}

// ─────────────────────────────────────────
#pragma mark - Demo 06: flexibleSpacing 弹性间距
// ─────────────────────────────────────────
- (void)demo06_flexibleSpacing {
    ZLStackView *sec = sectionView(@"06. flexibleSpacing 弹性间距（justifyFill 下）");
    sec.alignment = ZLAlignFill; // 纵轴拉伸填满
    [_contentStack addArrangedSubview:sec];

    ZLStackView *row = ZLStackView.horizontal;
    row.justifyContent = ZLJustifyFill;
    row.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];

    UILabel *left  = colorBlock(@"Left",  randColor());
    UILabel *mid   = colorBlock(@"Mid",   randColor());
    UILabel *right = colorBlock(@"Right", randColor());

    [row addArrangedSubview:left];
    // left 后面设置弹性间距，mid 和 right 会被推到末尾
    [row setFlexibleSpacing:YES afterView:left];
    [row addArrangedSubview:mid];
    [row addArrangedSubview:right];
    [sec addArrangedSubview:row];

    // 链式写法
    ZLStackView *row2 = ZLStackView.horizontal;
    row2.justifyContent = ZLJustifyFill;
    row2.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1];
    UILabel *l1 = colorBlock(@"◀", randColor());
    UILabel *l2 = colorBlock(@"●", randColor());
    UILabel *l3 = colorBlock(@"▶", randColor());
    row2
        .add(l1)
        .flexSpacingAfter(l1, YES) // l1 后弹性
        .add(l2)
        .flexSpacingAfter(l2, YES) // l2 后也弹性（两段等分）
        .add(l3);
    [sec addArrangedSubview:row2];
}

// ─────────────────────────────────────────
#pragma mark - Demo 07: flex 权重
// ─────────────────────────────────────────
- (void)demo07_flex {
    ZLStackView *sec = sectionView(@"07. flex 权重（类似 flexbox flex:N）");
    [_contentStack addArrangedSubview:sec];

    ZLStackView *row = ZLStackView.horizontal;
    row.justifyContent = ZLJustifyFill;
    row.spacing = 4;

    UILabel *a = colorBlock(@"flex:1", randColor());
    UILabel *b = colorBlock(@"flex:2", randColor());
    UILabel *c = colorBlock(@"flex:1", randColor());
    [row addArrangedSubview:a];
    [row addArrangedSubview:b];
    [row addArrangedSubview:c];
    [row setFlex:1 forView:a];
    [row setFlex:2 forView:b]; // b 是 a/c 的两倍宽
    [row setFlex:1 forView:c];
    [sec addArrangedSubview:row];

    // 链式
    ZLStackView *row2 = ZLStackView.horizontal;
    row2.justifyContent = ZLJustifyFill;
    row2.spacing = 4;
    UILabel *x = colorBlock(@"1", randColor());
    UILabel *y = colorBlock(@"3", randColor());
    UILabel *z = colorBlock(@"1", randColor());
    row2
        .add(x).flexFor(x, 1)
        .add(y).flexFor(y, 3)
        .add(z).flexFor(z, 1);
    [sec addArrangedSubview:row2];
}

// ─────────────────────────────────────────
#pragma mark - Demo 08: alignSelf 单个 view 对齐
// ─────────────────────────────────────────
- (void)demo08_alignSelf {
    ZLStackView *sec = sectionView(@"08. alignSelf 单个 view 覆盖纵轴对齐");
    [_contentStack addArrangedSubview:sec];

    ZLStackView *row = ZLStackView.horizontal;
    row.alignment = ZLAlignCenter; // 整体居中
    row.spacing = 8;
    row.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
    [row mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(70);
    }];

    UILabel *a = colorBlock(@"Start",  randColor());
    UILabel *b = colorBlock(@"Center", randColor());
    UILabel *c = colorBlock(@"End",    randColor());
    UILabel *d = colorBlock(@"Fill",   randColor());
    for (UILabel *l in @[a, b, c, d]) {
        [l mas_makeConstraints:^(MASConstraintMaker *make) { make.width.mas_equalTo(50); }];
        [row addArrangedSubview:l];
    }
    // 各自覆盖对齐方式
    [row setAlignment:ZLAlignStart  forView:a];
    [row setAlignment:ZLAlignCenter forView:b];
    [row setAlignment:ZLAlignEnd    forView:c];
    [row setAlignment:ZLAlignFill   forView:d];
    [sec addArrangedSubview:row];
}

// ─────────────────────────────────────────
#pragma mark - Demo 09: alignStartSpacing / alignEndSpacing
// ─────────────────────────────────────────
- (void)demo09_alignStartEndSpacing {
    ZLStackView *sec = sectionView(@"09. alignmentStart/EndSpacing 纵轴方向偏移");
    [_contentStack addArrangedSubview:sec];

    ZLStackView *row = ZLStackView.horizontal;
    row.alignment = ZLAlignStart;
    row.spacing = 8;
    row.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
   
    UILabel *a = colorBlock(@"A\nstartSpacing=10", randColor());
    a.numberOfLines = 0;
    UILabel *b = colorBlock(@"B\nendSpacing=50", randColor());
    b.numberOfLines = 0;
    UILabel *c = colorBlock(@"C\nnormal", randColor());
    c.numberOfLines = 0;

    for (UILabel *l in @[a, b, c]) {
        [l mas_makeConstraints:^(MASConstraintMaker *make) { make.width.mas_equalTo(80); }];
        [row addArrangedSubview:l];
    }
    [row setAlignmentStartSpacing:10 forView:a]; // a 距顶部 10pt
    [row setAlignmentEndSpacing:50   forView:b]; // b 距底部 10pt
    [sec addArrangedSubview:row];
}

// ─────────────────────────────────────────
#pragma mark - Demo 10: hidden 自动重排
// ─────────────────────────────────────────
- (void)demo10_hiddenAutoLayout {
    ZLStackView *sec = sectionView(@"10. hidden 自动重排（点击 B 切换显示）");
    [_contentStack addArrangedSubview:sec];
    ZLStackView *row = ZLStackView.horizontal;
    row.spacing = 8;

    UILabel *a = colorBlock(@"A", randColor());
    UILabel *b = colorBlock(@"B(tap)", randColor());
    UILabel *c = colorBlock(@"C", randColor());
    for (UILabel *l in @[a,b,c]) {
        l.KFC.square(50);
        [row addArrangedSubview:l];
    }

    UILabel *tip = UILabel.new;
    tip.text = @"B 已隐藏，A C 自动补位";
    tip.font = [UIFont systemFontOfSize:11];
    tip.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    tip.hidden = YES;

    b.userInteractionEnabled = YES;
    __weak typeof(b) weakB = b;
    __weak typeof(tip) weakTip = tip;

    // 用 ZLStackView 的 tapAction 监听整行（演示 tapAction 用法）
    // 此处直接对 b 用 UITapGestureRecognizer
    UITapGestureRecognizer *tapGR = [UITapGestureRecognizer new];
    __block void(^tapHandler)(void) = ^{
        weakB.hidden = !weakB.hidden;
        weakTip.hidden = !weakB.hidden;
    };
    objc_setAssociatedObject(tapGR, "handler", tapHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [tapGR addTarget:self action:@selector(_onTapB:)];
    [b addGestureRecognizer:tapGR];

    [sec addArrangedSubview:row];
    [sec addArrangedSubview:tip];
}
- (void)_doNothing {}
- (void)_onTapB:(UITapGestureRecognizer *)gr {
    void(^handler)(void) = objc_getAssociatedObject(gr, "handler");
    if (handler) handler();
}

// ─────────────────────────────────────────
#pragma mark - Demo 11: addLayout block
// ─────────────────────────────────────────
- (void)demo11_addLayout {
    ZLStackView *sec = sectionView(@"11. addArrangedSubview:layout: 添加时配置");
    [_contentStack addArrangedSubview:sec];

    ZLStackView *row = ZLStackView.horizontal;
    row.justifyContent = ZLJustifyFill;
    row.spacing = 8;

    NSArray *titles = @[@"配置flex:1", @"配置flex:2", @"配置flex:1"];
    NSArray *flexes  = @[@1, @2, @1];
    for (int i = 0; i < 3; i++) {
        UILabel *l = colorBlock(titles[i], randColor());
        NSInteger flex = [flexes[i] integerValue];
        [row addArrangedSubview:l layout:^(__kindof UIView *view, ZLFlexItem *flexItem) {
            flexItem.flexValue = flex;
        }];
    }
    [sec addArrangedSubview:row];
}

// ─────────────────────────────────────────
#pragma mark - Demo 12: removeArrangedSubview
// ─────────────────────────────────────────
- (void)demo12_removeView {
    ZLStackView *sec = sectionView(@"12. removeArrangedSubview 移除 view");
    [_contentStack addArrangedSubview:sec];

    ZLStackView *row = ZLStackView.horizontal;
    row.spacing = 8;
    UILabel *a = colorBlock(@"A", randColor());
    UILabel *b = colorBlock(@"B(将被移除)", randColor());
    UILabel *c = colorBlock(@"C", randColor());
    for (UILabel *l in @[a, b, c]) {
        [l mas_makeConstraints:^(MASConstraintMaker *make) { make.width.mas_equalTo(60); make.height.mas_equalTo(36); }];
        [row addArrangedSubview:l];
    }
    // 0.8s 后移除 B
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [row removeArrangedSubview:b];
    });
    [sec addArrangedSubview:row];
}

// ─────────────────────────────────────────
#pragma mark - Demo 13: insertArrangedSubview:atIndex:
// ─────────────────────────────────────────
- (void)demo13_insertAtIndex {
    ZLStackView *sec = sectionView(@"13. insertArrangedSubview:atIndex: 插入");
    [_contentStack addArrangedSubview:sec];

    ZLStackView *row = ZLStackView.horizontal;
    row.spacing = 8;
    UILabel *a = colorBlock(@"A", randColor());
    UILabel *c = colorBlock(@"C", randColor());
    for (UILabel *l in @[a, c]) {
        [l mas_makeConstraints:^(MASConstraintMaker *make) { make.width.mas_equalTo(40); make.height.mas_equalTo(36); }];
        [row addArrangedSubview:l];
    }
    // 0.8s 后在 index=1 插入 B
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UILabel *b = colorBlock(@"B(插入)", randColor());
        [b mas_makeConstraints:^(MASConstraintMaker *make) { make.width.mas_equalTo(60); make.height.mas_equalTo(36); }];
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

    ZLStackView *row = ZLStackView.horizontal;
    row.spacing = 8;
    row.insets = UIEdgeInsetsMake(12, 12, 12, 12);
    row.backgroundColor = [UIColor colorWithRed:0.13 green:0.59 blue:0.95 alpha:1];
    row.layer.cornerRadius = 8;
    row.layer.masksToBounds = YES;
    [row addArrangedSubview:colorBlock(@"点我", UIColor.whiteColor)];

    __weak typeof(result) weakResult = result;
    row.tapAction(^(ZLBaseStackView *view) {
        static int cnt = 0;
        weakResult.text = [NSString stringWithFormat:@"点击了 %d 次", ++cnt];
    });
    [sec addArrangedSubview:row];
}

// ─────────────────────────────────────────
#pragma mark - Demo 15: 链式 API 综合
// ─────────────────────────────────────────
- (void)demo15_chainAPI {
    ZLStackView *sec = sectionView(@"15. 链式 API 综合：bgColor / corner / border / shadow / visibility / alphaValue");
    [_contentStack addArrangedSubview:sec];

    ZLStackView *row = [ZLStackView horizontal];
    [row alignCenter];
    [row justifyCenter];
    row.space(10);
    row.inset(12, 16, 12, 16);
    row.bgColor(@"#4A90D9");
    row.corner(12);
    row.border(1, @"#FFFFFF");
    row.shColor(@"#000000");
    row.shOpacity(0.25);
    row.shRadius(8);
    row.shOffset(0, 4);

    for (int i = 0; i < 3; i++) {
        [row addArrangedSubview:colorBlock([NSString stringWithFormat:@"item%d", i+1], UIColor.whiteColor)];
    }
    [sec addArrangedSubview:row];

    // visibility / alphaValue
    ZLStackView *row2 = ZLStackView.horizontal;
    row2.spacing = 8;
    UILabel *vis = colorBlock(@"visibility=YES", randColor());
    UILabel *alp = colorBlock(@"alpha=0.4", randColor());
    row2.add(vis).visibility(YES)
        .add(alp).alphaValue(0.4);
    [sec addArrangedSubview:row2];
}

// ─────────────────────────────────────────
#pragma mark - Demo 16: wrapScrollView 水平滚动
// ─────────────────────────────────────────
- (void)demo16_scrollStackView {
    ZLStackView *sec = sectionView(@"16. wrapScrollView 水平滚动");
    [_contentStack addArrangedSubview:sec];

    // 水平 StackView 内容超出，用 wrapScrollView 包裹实现横向滚动
    ZLStackView *hStack = ZLStackView.horizontal;
    hStack.spacing = 8;
    hStack.insets = UIEdgeInsetsMake(8, 8, 8, 8);
    hStack.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];

    for (int i = 1; i <= 12; i++) {
        UILabel *l = colorBlock([NSString stringWithFormat:@"item%d", i], randColor());
        [l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(40);
        }];
        [hStack addArrangedSubview:l];
    }

    UIScrollView *hSv = [hStack wrapScrollView];
    [hSv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(56);
    }];
    [sec addArrangedSubview:hSv];
}

// ─────────────────────────────────────────
#pragma mark - Demo 17: wrapScrollView 垂直滚动
// ─────────────────────────────────────────
- (void)demo17_wrapScrollView {
    ZLStackView *sec = sectionView(@"17. wrapScrollView 垂直滚动");
    [_contentStack addArrangedSubview:sec];

    ZLStackView *vStack = ZLStackView.vertical;
    vStack.spacing = 6;
    vStack.insets = UIEdgeInsetsMake(8, 8, 8, 8);

    for (int i = 1; i <= 8; i++) {
        UILabel *l = colorBlock([NSString stringWithFormat:@"row%d（内容超出容器可滚动）", i], randColor());
        [l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(36);
        }];
        [vStack addArrangedSubview:l];
    }

    UIScrollView *sv = [vStack wrapScrollView];
    [sv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(120); // 容器高度小于内容，产生滚动
    }];
    [sec addArrangedSubview:sv];
}

// ─────────────────────────────────────────
#pragma mark - Demo 18: 嵌套 StackView
// ─────────────────────────────────────────
- (void)demo18_nestedStack {
    ZLStackView *sec = sectionView(@"18. 嵌套 StackView（水平嵌垂直）");
    [_contentStack addArrangedSubview:sec];

    ZLStackView *hRow = ZLStackView.horizontal;
    hRow.spacing = 8;
    hRow.alignment = ZLAlignFill;

    // 左侧垂直 stack
    ZLStackView *left = ZLStackView.vertical;
    left.spacing = 6;
    left.insets = UIEdgeInsetsMake(8, 8, 8, 8);
    left.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
    left.layer.cornerRadius = 6;
    left.layer.masksToBounds = YES;
    for (int i = 0; i < 3; i++) {
        [left addArrangedSubview:colorBlock([NSString stringWithFormat:@"L%d", i+1], randColor())];
    }

    // 右侧垂直 stack（flex:2 占更多空间）
    ZLStackView *right = ZLStackView.vertical;
    right.spacing = 6;
    right.insets = UIEdgeInsetsMake(8, 8, 8, 8);
    right.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1];
    right.layer.cornerRadius = 6;
    right.layer.masksToBounds = YES;
    for (int i = 0; i < 2; i++) {
        [right addArrangedSubview:colorBlock([NSString stringWithFormat:@"R%d", i+1], randColor())];
    }

    [hRow addArrangedSubview:left];
    [hRow addArrangedSubview:right];
    hRow.justifyContent = ZLJustifyFill;
    [hRow setFlex:1 forView:left];
    [hRow setFlex:2 forView:right]; // 右侧是左侧宽度的 2 倍

    [sec addArrangedSubview:hRow];
}

@end
