// ZLViewExtDemoVC.m
// 演示 UIView+ZLView 扩展的所有属性用法

#import "ZLViewExtDemoVC.h"
#import <ZLUIKitPlus/ZLUIKitPlus.h>
#import "UIView+ZLView.h"
#import "ZLView.h"
#import "ZLStackView.h"
#import "ZLButton.h"
#import "ZLLabel.h"
#import "ZLImageView.h"
#import "ZLPairView.h"

@implementation ZLViewExtDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UIView+ZLView Demo";
    self.view.backgroundColor = UIColor.whiteColor;

    ZLStackView *contentStack = ZLStackView.vertical.alignFill.space(16).inset(16, 16, 16, 16);
    [contentStack wrapScrollView].KFC.addToFull(self.view);

    [contentStack addArrangedSubview:[self demo01_zl_lab]];
    [contentStack addArrangedSubview:[self demo02_zl_btn]];
    [contentStack addArrangedSubview:[self demo03_zl_imgView]];
    [contentStack addArrangedSubview:[self demo04_zl_stackView]];
    [contentStack addArrangedSubview:[self demo05_altGroup]];
    [contentStack addArrangedSubview:[self demo06_extraGroup]];
    [contentStack addArrangedSubview:[self demo07_pairLab]];
    [contentStack addArrangedSubview:[self demo08_pairImg]];
    [contentStack addArrangedSubview:[self demo09_pairBtn]];
    [contentStack addArrangedSubview:[self demo10_pairStackView]];
    [contentStack addArrangedSubview:[self demo11_imgViewLab]];
    [contentStack addArrangedSubview:[self demo12_imgViewBtn]];
    [contentStack addArrangedSubview:[self demo13_btnImgView]];
    [contentStack addArrangedSubview:[self demo14_btnLabel]];
    [contentStack addArrangedSubview:[self demo15_labelBtn]];
    [contentStack addArrangedSubview:[self demo16_labImgView]];
    [contentStack addArrangedSubview:[self demo17_wrapView_cornerBorderShadow]];
    [contentStack addArrangedSubview:[self demo18_wrapView_gradientAndInsets]];
    [contentStack addArrangedSubview:[self demo19_wrapView_reuseOnSameView]];
    [contentStack addArrangedSubview:[self demo20_multiPropertyOnOneView]];
}

#pragma mark - 工具方法

- (ZLLabel *)sectionTitle:(NSString *)title {
    return ZLLab.txt(title).mediumFont(13).color(@"#FFFFFF")
        .bgColor(@"#333333").insets(4, 8, 4, 8).corner(4).masksToBounds(YES);
}

- (UIView *)cardContainer {
    UIView *v = UIView.new;
    v.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    v.layer.cornerRadius = 8;
    return v;
}

#pragma mark - Demo 01: zl_lab（懒加载 ZLLabel，自动 addSubview）

- (UIView *)demo01_zl_lab {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 01 · zl_lab — 懒加载 ZLLabel，首次访问自动 addSubview"]];

    // 场景：自定义 UIView 内部不需要声明属性，直接用 zl_lab 配置标题
    UIView *card = [self cardContainer];
    card.zl_lab
        .txt(@"我是 zl_lab，首次访问自动被添加到父视图")
        .systemFont(14)
        .color(@"#333333")
        .lines(0)
        .KFC.edge(12, 12, 12, 12);
    card.KFC.height(56);
    [sec addArrangedSubview:card];

    // 多次访问同一个 zl_lab 返回同一个实例（懒加载单例）
    UIView *card2 = [self cardContainer];
    card2.zl_lab.txt(@"第一次设置文字").systemFont(13).color(@"#1677FF");
    card2.zl_lab.txt(@"第二次修改：同一个实例").color(@"#FF4D4F"); // 同一个 lab
    card2.zl_lab.KFC.edge(12, 12, 12, 12);
    card2.KFC.height(44);
    [sec addArrangedSubview:card2];

    return sec;
}

#pragma mark - Demo 02: zl_btn（懒加载 ZLButton）

- (UIView *)demo02_zl_btn {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 02 · zl_btn — 懒加载 ZLButton"]];

    // 场景：给任意 UIView 快速附加一个按钮
    UIView *card = [self cardContainer];
    card.zl_btn
        .title(@"zl_btn 快速按钮")
        .systemFont(15)
        .titleColor(@"#FFFFFF")
        .bgColor(@"#1677FF")
        .corner(8).masksToBounds(YES)
        .tapAction(^(ZLButton *btn) {
            NSLog(@"zl_btn 点击");
            btn.bgColor(btn.isUserInteractionEnabled ? @"#52C41A" : @"#1677FF");
        })
        .KFC.edge(12, 12, 12, 12).height(44);
    card.KFC.height(68);
    [sec addArrangedSubview:card];

    // zl_btn + zl_lab 同时挂载在同一个父视图上
    UIView *card2 = [self cardContainer];
    card2.zl_lab
        .txt(@"标题")
        .mediumFont(15)
        .color(@"#333333")
        .KFC.leading(12).centerY(0);
    card2.zl_btn
        .title(@"操作")
        .systemFont(13)
        .titleColor(@"#1677FF")
        .border(1, @"#1677FF")
        .corner(14).masksToBounds(YES)
        .tapAction(^(ZLButton *btn) { NSLog(@"操作按钮点击"); })
        .KFC.trailing(-12).centerY(0).size(60, 28);
    card2.KFC.height(52);
    [sec addArrangedSubview:card2];

    return sec;
}

#pragma mark - Demo 03: zl_imgView（懒加载 ZLImageView）

- (UIView *)demo03_zl_imgView {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 03 · zl_imgView — 懒加载 ZLImageView"]];

    UIView *card = [self cardContainer];
    card.zl_imgView.backgroundColor = [UIColor colorWithRed:0.36 green:0.61 blue:1.0 alpha:1];
    card.zl_imgView.corner(30).KFC.square(60).leading(12).centerY(0);

    card.zl_lab
        .txt(@"zl_imgView + zl_lab 组合")
        .systemFont(14)
        .color(@"#333333")
        .KFC.leading(84).trailing(-12).centerY(0);
    card.KFC.height(84);
    [sec addArrangedSubview:card];

    return sec;
}

#pragma mark - Demo 04: zl_stackView（懒加载 ZLStackView）

- (UIView *)demo04_zl_stackView {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 04 · zl_stackView — 懒加载 ZLStackView"]];

    // 在任意 UIView 上快速挂载一个 StackView 管理子视图布局
    UIView *card = [self cardContainer];
    ZLStackView *stack = card.zl_stackView.horizontal.alignCenter.space(8).inset(12, 12, 12, 12);
    for (NSString *color in @[@"#1677FF", @"#52C41A", @"#FA8C16", @"#FF4D4F"]) {
        ZLLabel *dot = ZLLab.txt(@"●").systemFont(20).color(color);
        [stack addArrangedSubview:dot];
    }
    stack.KFC.edgesZero();
    card.KFC.height(52);
    [sec addArrangedSubview:card];

    return sec;
}

#pragma mark - Demo 05: zl_altBtn / zl_altLab / zl_altImgView / zl_altStackView（第二组）

- (UIView *)demo05_altGroup {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 05 · zl_alt* — 第二组，同一父视图可挂载多个不同实例"]];

    // 场景：同一个 cell/card 上需要两个 label（主标题 + 副标题）
    UIView *card = [self cardContainer];

    // 主标题（zl_lab）
    card.zl_lab
        .txt(@"主标题 zl_lab")
        .mediumFont(16)
        .color(@"#333333")
        .KFC.leading(12).top(12);

    // 副标题（zl_altLab）—— 同一父视图上的第二个 label
    card.zl_altLab
        .txt(@"副标题 zl_altLab（独立实例）")
        .systemFont(13)
        .color(@"#999999")
        .KFC.leading(12).top(36);

    // 主按钮（zl_btn）
    card.zl_btn
        .title(@"主按钮")
        .systemFont(13).titleColor(@"#FFFFFF")
        .bgColor(@"#1677FF").corner(14).masksToBounds(YES)
        .tapAction(^(ZLButton *b) { NSLog(@"主按钮"); })
        .KFC.trailing(-12).top(12).size(64, 28);

    // 第二个按钮（zl_altBtn）
    card.zl_altBtn
        .title(@"次按钮")
        .systemFont(13).titleColor(@"#1677FF")
        .border(1, @"#1677FF").corner(14).masksToBounds(YES)
        .tapAction(^(ZLButton *b) { NSLog(@"次按钮"); })
        .KFC.trailing(-12).top(48).size(64, 28);

    // 图片（zl_altImgView）
    card.zl_altImgView.backgroundColor = [UIColor colorWithRed:0.32 green:0.80 blue:0.52 alpha:1];
    card.zl_altImgView.corner(4).KFC.leading(12).bottom(-12).size(32, 32);

    card.KFC.height(96);
    [sec addArrangedSubview:card];

    return sec;
}

#pragma mark - Demo 06: zl_extra* — 第三组

- (UIView *)demo06_extraGroup {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 06 · zl_extra* — 第三组，三组共9个槽位可独立使用"]];

    UIView *card = [self cardContainer];

    // 三个颜色标签：zl_lab / zl_altLab / zl_extraLab
    card.zl_lab.txt(@"Tag1").systemFont(12).color(@"#FFFFFF")
        .bgColor(@"#1677FF").insets(2, 6, 2, 6).corner(10).masksToBounds(YES)
        .KFC.leading(12).centerY(0);

    card.zl_altLab.txt(@"Tag2").systemFont(12).color(@"#FFFFFF")
        .bgColor(@"#52C41A").insets(2, 6, 2, 6).corner(10).masksToBounds(YES)
        .KFC.leading(68).centerY(0);

    card.zl_extraLab.txt(@"Tag3").systemFont(12).color(@"#FFFFFF")
        .bgColor(@"#FA8C16").insets(2, 6, 2, 6).corner(10).masksToBounds(YES)
        .KFC.leading(124).centerY(0);

    // 三个按钮：zl_btn / zl_altBtn / zl_extraBtn
    card.zl_extraBtn
        .title(@"第三按钮 zl_extraBtn")
        .systemFont(12).titleColor(@"#722ED1")
        .border(1, @"#722ED1").corner(14).masksToBounds(YES)
        .tapAction(^(ZLButton *b) { NSLog(@"extra btn"); })
        .KFC.trailing(-12).centerY(0).height(28).width(140);

    card.KFC.height(52);
    [sec addArrangedSubview:card];

    return sec;
}

#pragma mark - Demo 07: zl_pairLab（ZLPairLabelView）

- (UIView *)demo07_pairLab {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 07 · zl_pairLab — 懒加载 ZLPairLabelView"]];

    // 场景：任意 UIView 快速变成一个「键值对」行
    UIView *card = [self cardContainer];
    card.zl_pairLab
        .flexSpace(YES)
        .inset(12, 12, 12, 12);
    card.zl_pairLab.first.txt(@"收货地址").systemFont(14).color(@"#999999");
    card.zl_pairLab.second.txt(@"广东省深圳市南山区").systemFont(14).color(@"#333333");
    card.zl_pairLab.KFC.edgesZero();
    card.KFC.height(48);
    [sec addArrangedSubview:card];

    // 切换为垂直排列（同一个 zl_pairLab 实例，直接调用 .vertical）
    UIView *card2 = [self cardContainer];
    card2.zl_pairLab.vertical.space(4).inset(12, 12, 12, 12);
    card2.zl_pairLab.first.txt(@"订单金额").systemFont(12).color(@"#999999");
    card2.zl_pairLab.second.txt(@"¥ 299.00").boldFont(20).color(@"#FF4D4F");
    card2.zl_pairLab.KFC.edgesZero();
    card2.KFC.height(72);
    [sec addArrangedSubview:card2];

    return sec;
}

#pragma mark - Demo 08: zl_pairImg（ZLPairImageView）

- (UIView *)demo08_pairImg {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 08 · zl_pairImg — 懒加载 ZLPairImageView"]];

    UIView *card = [self cardContainer];
    card.zl_pairImg.alignCenter.space(12).inset(12, 12, 12, 12);
    card.zl_pairImg.first.backgroundColor = [UIColor colorWithRed:0.36 green:0.61 blue:1.0 alpha:1];
    card.zl_pairImg.first.corner(20).KFC.square(40);
    card.zl_pairImg.second.backgroundColor = [UIColor colorWithRed:0.32 green:0.80 blue:0.52 alpha:1];
    card.zl_pairImg.second.corner(20).KFC.square(40);
    card.zl_pairImg.KFC.edgesZero();
    card.KFC.height(64);
    [sec addArrangedSubview:card];

    return sec;
}

#pragma mark - Demo 09: zl_pairBtn（ZLPairButtonView）

- (UIView *)demo09_pairBtn {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 09 · zl_pairBtn — 懒加载 ZLPairButtonView"]];

    UIView *card = [self cardContainer];
    card.zl_pairBtn.space(12).firstFlex(1).secondFlex(1).inset(12, 12, 12, 12);
    card.zl_pairBtn.first
        .title(@"取消").systemFont(14).titleColor(@"#666666")
        .border(1, @"#DDDDDD").corner(20).masksToBounds(YES).height(40)
        .tapAction(^(ZLButton *b) { NSLog(@"取消"); });
    card.zl_pairBtn.second
        .title(@"确认").systemFont(14).titleColor(@"#FFFFFF")
        .bgColor(@"#1677FF").corner(20).masksToBounds(YES).height(40)
        .tapAction(^(ZLButton *b) { NSLog(@"确认"); });
    card.zl_pairBtn.KFC.edgesZero();
    card.KFC.height(64);
    [sec addArrangedSubview:card];

    return sec;
}

#pragma mark - Demo 10: zl_pairStackView（ZLPairStackView）

- (UIView *)demo10_pairStackView {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 10 · zl_pairStackView — 懒加载 ZLPairStackView"]];

    // 两个 StackView 各占一半，用于数据统计卡片
    UIView *card = [self cardContainer];
    card.zl_pairStackView.alignFill.space(1).firstFlex(1).secondFlex(1).inset(0, 0, 0, 0);

    ZLStackView *left = card.zl_pairStackView.first.vertical.alignCenter.space(4).inset(12, 0, 12, 0);
    [left addArrangedSubview:ZLLab.txt(@"128").boldFont(22).color(@"#1677FF")];
    [left addArrangedSubview:ZLLab.txt(@"关注").systemFont(12).color(@"#999999")];

    ZLStackView *right = card.zl_pairStackView.second.vertical.alignCenter.space(4).inset(12, 0, 12, 0);
    [right addArrangedSubview:ZLLab.txt(@"3.6k").boldFont(22).color(@"#52C41A")];
    [right addArrangedSubview:ZLLab.txt(@"粉丝").systemFont(12).color(@"#999999")];

    card.zl_pairStackView.KFC.edgesZero();
    card.KFC.height(80);
    [sec addArrangedSubview:card];

    return sec;
}

#pragma mark - Demo 11: zl_imgViewLab（ZLImgLabelView）

- (UIView *)demo11_imgViewLab {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 11 · zl_imgViewLab — ZLImgLabelView（图左文右）"]];

    UIView *card = [self cardContainer];
    card.zl_imgViewLab.alignCenter.space(10).inset(12, 12, 12, 12);
    card.zl_imgViewLab.first.backgroundColor = [UIColor colorWithRed:1.0 green:0.42 blue:0.21 alpha:1];
    card.zl_imgViewLab.first.corner(18).KFC.square(36);
    card.zl_imgViewLab.second.txt(@"zl_imgViewLab：图片在左，文字在右").systemFont(14).color(@"#333333");
    card.zl_imgViewLab.KFC.edgesZero();
    card.KFC.height(60);
    [sec addArrangedSubview:card];

    // 切换为垂直（图上文下）：同一个 zl_imgViewLab 实例
    UIView *card2 = [self cardContainer];
    card2.zl_imgViewLab.vertical.alignCenter.space(6).inset(10, 0, 10, 0);
    card2.zl_imgViewLab.first.backgroundColor = [UIColor colorWithRed:0.36 green:0.61 blue:1.0 alpha:1];
    card2.zl_imgViewLab.first.corner(18).KFC.square(36);
    card2.zl_imgViewLab.second.txt(@"图上文下").systemFont(12).color(@"#1677FF");
    card2.zl_imgViewLab.KFC.edgesZero();
    card2.KFC.height(90);
    [sec addArrangedSubview:card2];

    return sec;
}

#pragma mark - Demo 12: zl_imgViewBtn（ZLImgButtonView）

- (UIView *)demo12_imgViewBtn {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 12 · zl_imgViewBtn — ZLImgButtonView（图左按钮右）"]];

    UIView *card = [self cardContainer];
    card.zl_imgViewBtn.alignCenter.flexSpace(YES).inset(12, 12, 12, 12);
    card.zl_imgViewBtn.first.backgroundColor = [UIColor colorWithRed:0.32 green:0.80 blue:0.52 alpha:1];
    card.zl_imgViewBtn.first.corner(22).KFC.square(44);
    card.zl_imgViewBtn.second
        .title(@"立即领取")
        .systemFont(14).titleColor(@"#FFFFFF")
        .bgColor(@"#52C41A").corner(16).masksToBounds(YES).height(32).width(80)
        .tapAction(^(ZLButton *b) { NSLog(@"领取"); });
    card.zl_imgViewBtn.KFC.edgesZero();
    card.KFC.height(68);
    [sec addArrangedSubview:card];

    return sec;
}

#pragma mark - Demo 13: zl_btnImgView（ZLButtonImgView）

- (UIView *)demo13_btnImgView {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 13 · zl_btnImgView — ZLButtonImgView（按钮左图右）"]];

    UIView *card = [self cardContainer];
    card.zl_btnImgView.alignCenter.flexSpace(YES).inset(12, 12, 12, 12);
    card.zl_btnImgView.first
        .title(@"喜欢").systemFont(14).titleColor(@"#EB2F96")
        .border(1, @"#EB2F96").corner(14).masksToBounds(YES).height(28).width(60)
        .tapAction(^(ZLButton *b) { NSLog(@"喜欢"); });
    card.zl_btnImgView.second.backgroundColor = [UIColor colorWithRed:0.92 green:0.18 blue:0.59 alpha:1];
    card.zl_btnImgView.second.corner(18).KFC.square(36);
    card.zl_btnImgView.KFC.edgesZero();
    card.KFC.height(60);
    [sec addArrangedSubview:card];

    return sec;
}

#pragma mark - Demo 14: zl_btnLabel（ZLButtonLabView）

- (UIView *)demo14_btnLabel {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 14 · zl_btnLabel — ZLButtonLabView（按钮左文字右）"]];

    // 勾选框 + 协议文字
    UIView *card = [self cardContainer];
    __block BOOL checked = NO;
    card.zl_btnLabel.alignCenter.space(6).inset(12, 12, 12, 12);
    card.zl_btnLabel.first
        .title(@"☐").systemFont(18).titleColor(@"#CCCCCC")
        .tapAction(^(ZLButton *btn) {
            checked = !checked;
            btn.title(checked ? @"☑" : @"☐").titleColor(checked ? @"#1677FF" : @"#CCCCCC");
        });
    card.zl_btnLabel.second
        .txt(@"我已阅读并同意《用户协议》和《隐私政策》")
        .systemFont(13).color(@"#666666").lines(0);
    card.zl_btnLabel.KFC.edgesZero();
    card.KFC.height(48);
    [sec addArrangedSubview:card];

    return sec;
}

#pragma mark - Demo 15: zl_labelBtn（ZLLabButtonView）

- (UIView *)demo15_labelBtn {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 15 · zl_labelBtn — ZLLabButtonView（文字左按钮右）"]];

    // 标题 + 查看更多
    UIView *card = [self cardContainer];
    card.zl_labelBtn.alignCenter.flexSpace(YES).inset(12, 16, 12, 16);
    card.zl_labelBtn.first.txt(@"热门推荐").mediumFont(16).color(@"#333333");
    card.zl_labelBtn.second
        .title(@"查看全部 >").systemFont(13).titleColor(@"#1677FF")
        .tapAction(^(ZLButton *b) { NSLog(@"查看全部"); });
    card.zl_labelBtn.KFC.edgesZero();
    card.KFC.height(48);
    [sec addArrangedSubview:card];

    return sec;
}

#pragma mark - Demo 16: zl_labImgView（ZLLabelImgView）

- (UIView *)demo16_labImgView {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 16 · zl_labImgView — ZLLabelImgView（文字左图右）"]];

    // 设置项：文字 + 右侧箭头
    UIView *card = [self cardContainer];
    card.zl_labImgView.alignCenter.flexSpace(YES).inset(14, 16, 14, 16);
    card.zl_labImgView.first.txt(@"隐私设置").systemFont(15).color(@"#333333");
    card.zl_labImgView.second.backgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1];
    card.zl_labImgView.second.corner(2).KFC.size(7, 12);
    card.zl_labImgView.KFC.edgesZero();
    card.KFC.height(48);
    [sec addArrangedSubview:card];

    return sec;
}

#pragma mark - Demo 17: zl_wrapView — 圆角 / 边框 / 阴影

- (UIView *)demo17_wrapView_cornerBorderShadow {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(12);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 17 · zl_wrapView — 圆角 / 边框 / 阴影（包裹原始 UIView）"]];

    // ── 圆角 ──
    // 原始 UILabel，通过 zl_wrapView 包裹后加圆角
    ZLLabel *lab1 = ZLLab.txt(@"原始 UILabel，通过 zl_wrapView 加圆角 + 背景色")
        .systemFont(13).color(@"#FFFFFF").insets(10, 12, 10, 12);
    ZLWrapperView *wrap1 = lab1.zl_wrapView;
    
    lab1.zl_wrapView
        .insetsZero          // contentView 填满 wrapView
        .corner(12)
        .bgColor(@"#1677FF")
        .KFC.edgesZero();
    [sec addArrangedSubview:lab1.zl_wrapView];

    // ── 边框 ──
    ZLLabel *lab2 = ZLLab.txt(@"zl_wrapView 边框效果 border(2, #1677FF)")
        .systemFont(13).color(@"#1677FF").insets(10, 12, 10, 12);
    lab2.zl_wrapView
        .insetsZero
        .corner(8).masksToBounds(YES)
        .border(2, @"#1677FF")
        .KFC.edgesZero();
    [sec addArrangedSubview:lab2.zl_wrapView];

    // ── 阴影（不能与 masksToBounds 同时使用）──
    ZLLabel *lab3 = ZLLab.txt(@"zl_wrapView 阴影效果（shColor + shOpacity + shRadius + shOffset）")
        .systemFont(13).color(@"#333333").insets(10, 12, 10, 12).lines(0);
    lab3.zl_wrapView
        .insetsZero
        .bgColor(@"#FFFFFF")
        .corner(10)
        .shColor(@"#000000").shOpacity(0.12).shRadius(8).shOffset(0, 4)
        .KFC.edgesZero();
    [sec addArrangedSubview:lab3.zl_wrapView];

    return sec;
}

#pragma mark - Demo 18: zl_wrapView — 渐变 + insets

- (UIView *)demo18_wrapView_gradientAndInsets {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(12);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 18 · zl_wrapView — 渐变 gradColors + insets 内边距"]];

    // 渐变 + 圆角
    ZLLabel *lab1 = ZLLab.txt(@"渐变背景：左蓝右紫").mediumFont(15).color(@"#FFFFFF")
        .insets(14, 20, 14, 20);
    lab1.zl_wrapView
        .insetsZero
        .corner(12)
        .gradColors(@[[UIColor colorWithRed:0.22 green:0.47 blue:1.0 alpha:1],
                      [UIColor colorWithRed:0.56 green:0.18 blue:0.82 alpha:1]])
        .gradDirection(CGPointMake(0, 0.5), CGPointMake(1, 0.5))
        .KFC.edgesZero();
    [sec addArrangedSubview:lab1.zl_wrapView];

    // 渐变 + insets（contentView 不填满，有内边距）
    ZLLabel *lab2 = ZLLab.txt(@"insets(8,16,8,16)：contentView 与 wrapView 之间有内边距")
        .systemFont(13).color(@"#FA8C16").lines(0)
        .bgColor(@"#FFFFFF");
    lab2.zl_wrapView
        .insets(8, 16, 8, 16)  // ← contentView 与 wrap 的间距
        .bgColor(@"#FFF7E6")
        .corner(10).masksToBounds(YES)
        .border(1, @"#FFD591")
        .KFC.edgesZero();
    [sec addArrangedSubview:lab2.zl_wrapView];

    // 垂直渐变
    ZLLabel *lab3 = ZLLab.txt(@"渐变方向：上到下").mediumFont(14).color(@"#FFFFFF")
        .insets(14, 0, 14, 0).textAlignCenter;
    lab3.zl_wrapView
        .insetsZero
        .corner(8)
        .gradColors(@[[UIColor colorWithRed:0.32 green:0.80 blue:0.52 alpha:1],
                      [UIColor colorWithRed:0.0  green:0.50 blue:0.30 alpha:1]])
        .gradDirection(CGPointMake(0.5, 0), CGPointMake(0.5, 1))
        .KFC.edgesZero();
    [sec addArrangedSubview:lab3.zl_wrapView];

    return sec;
}

#pragma mark - Demo 19: zl_wrapView — 同一视图多次访问返回同一实例 + 动态修改样式

- (UIView *)demo19_wrapView_reuseOnSameView {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 19 · zl_wrapView — 同实例复用，点击动态切换样式"]];

    ZLLabel *lab = ZLLab.txt(@"点击切换：圆角 ↔ 椭圆 / 边框颜色切换")
        .systemFont(14).color(@"#333333").insets(12, 16, 12, 16).textAlignCenter;

    __block BOOL toggled = NO;
    lab.zl_wrapView
        .insetsZero
        .bgColor(@"#F0F7FF")
        .corner(8)
        .border(2, @"#1677FF")
        .tapAction(^(ZLBaseView *v) {
            toggled = !toggled;
            v.corner(toggled ? 24 : 8);
            v.border(2, toggled ? @"#FF4D4F" : @"#1677FF");
            v.bgColor(toggled ? @"#FFF0F0" : @"#F0F7FF");
        })
        .KFC.edgesZero();

    [sec addArrangedSubview:lab.zl_wrapView];

    return sec;
}

#pragma mark - Demo 20: 综合 — 多属性组合在同一个 UIView 上

- (UIView *)demo20_multiPropertyOnOneView {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 20 · 综合 — 多属性同时挂载在同一 UIView 上"]];

    // 模拟一个订单卡片：头像 + 姓名/职位 + 操作按钮 + 状态标签 + 分隔线
    UIView *card = [self cardContainer];

    // 头像：zl_imgView
    card.zl_imgView.backgroundColor = [UIColor colorWithRed:0.36 green:0.61 blue:1.0 alpha:1];
    card.zl_imgView.corner(24).KFC.square(48).leading(16).top(16);

    // 姓名：zl_lab
    card.zl_lab.txt(@"张三丰").mediumFont(16).color(@"#333333")
        .KFC.leading(80).top(18);

    // 职位：zl_altLab
    card.zl_altLab.txt(@"高级产品经理 · 深圳").systemFont(12).color(@"#999999")
        .KFC.leading(80).top(42);

    // 状态 badge：zl_extraLab
    card.zl_extraLab.txt(@"在线").systemFont(11).color(@"#FFFFFF")
        .bgColor(@"#52C41A").insets(2, 6, 2, 6).corner(8).masksToBounds(YES)
        .KFC.trailing(-16).top(18);

    // 操作按钮：zl_btn
    card.zl_btn
        .title(@"发消息").systemFont(13).titleColor(@"#1677FF")
        .border(1, @"#1677FF").corner(14).masksToBounds(YES)
        .tapAction(^(ZLButton *b) { NSLog(@"发消息"); })
        .KFC.trailing(-16).top(42).size(68, 26);

    // 分隔线：zl_altImgView（作为分隔线）
    card.zl_altImgView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    card.zl_altImgView.KFC.leading(16).trailing(-16).bottom(-1).height(1);

    card.KFC.height(88);

    // 用 zl_wrapView 给整个 card 加阴影
    card.zl_wrapView
        .insetsZero
        .bgColor(@"#FFFFFF")
        .corner(12)
        .shColor(@"#000000").shOpacity(0.08).shRadius(10).shOffset(0, 3)
        .KFC.edgesZero();

    [sec addArrangedSubview:card.zl_wrapView];

    return sec;
}

@end
