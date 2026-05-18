#import "ZLPairViewDemoVC.h"
#import <ZLUIKitPlus/ZLUIKitPlus.h>
#import "ZLStackView.h"
#import "ZLPairView.h"
#import "ZLButton.h"
#import "ZLLabel.h"
#import "ZLImageView.h"

@implementation ZLPairViewDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZLPairView Demo";
    self.view.backgroundColor = UIColor.whiteColor;

    ZLStackView *contentStack = ZLStackView.vertical.alignFill.space(16).inset(16, 16, 16, 16);
    [contentStack wrapScrollView].zl_layout
        .addToFull(self.view);

//    [contentStack addArrangedSubview:[self demo01_pairLabelViewHorizontal]];
//    [contentStack addArrangedSubview:[self demo02_pairLabelViewVertical]];
//    [contentStack addArrangedSubview:[self demo03_pairLabelSpacing]];
//    [contentStack addArrangedSubview:[self demo04_pairLabelFlex]];
//    [contentStack addArrangedSubview:[self demo05_pairLabelAlignSpacing]];
//    [contentStack addArrangedSubview:[self demo06_pairImageView]];
    [contentStack addArrangedSubview:[self demo07_pairButtonView]];
    return;
    [contentStack addArrangedSubview:[self demo08_imgLabelView]];
    [contentStack addArrangedSubview:[self demo09_imgButtonView]];
    [contentStack addArrangedSubview:[self demo10_buttonImgView]];
    [contentStack addArrangedSubview:[self demo11_buttonLabView]];
    [contentStack addArrangedSubview:[self demo12_labelImgView]];
    [contentStack addArrangedSubview:[self demo13_labButtonView]];
    [contentStack addArrangedSubview:[self demo14_buttonStackView]];
    [contentStack addArrangedSubview:[self demo15_stackViewButton]];
    [contentStack addArrangedSubview:[self demo16_pairStackView]];
    [contentStack addArrangedSubview:[self demo17_thenConfig]];
    [contentStack addArrangedSubview:[self demo18_flexSpaceAndMinMax]];
    [contentStack addArrangedSubview:[self demo19_cornerBorderShadow]];
    [contentStack addArrangedSubview:[self demo20_tapAction]];
}

#pragma mark - 工具

- (ZLLabel *)sectionTitle:(NSString *)title {
    return ZLLab.txt(title).mediumFont(13).color(@"#FFFFFF")
        .bgColor(@"#333333").insets(4, 8, 4, 8).corner(4).masksToBounds(YES);
}

- (ZLLabel *)tag:(NSString *)text color:(NSString *)hex {
    return ZLLab.txt(text).systemFont(12).color(@"#FFFFFF")
        .bgColor(hex).insets(3, 8, 3, 8).corner(10).masksToBounds(YES);
}

#pragma mark - Demo 01: ZLPairLabelView 水平排列（默认）

- (UIView *)demo01_pairLabelViewHorizontal {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 01 · ZLPairLabelView 水平排列（默认）"]];

    // 最基础用法：左 label + 右 label，水平排列
    ZLPairLabelView *pair = ZLPairLabelView.new;
    pair.first.txt(@"姓名：").systemFont(14).color(@"#333333");
    pair.second.txt(@"张三").systemFont(14).color(@"#666666");
    [sec addArrangedSubview:pair];

    // 水平+间距
    ZLPairLabelView *pair2 = ZLPairLabelView.new.space(12);
    pair2.first.txt(@"手机：").systemFont(14).color(@"#333333");
    pair2.second.txt(@"138****8888").systemFont(14).color(@"#666666");
    [sec addArrangedSubview:pair2];

    // 带背景色 + 圆角
    ZLPairLabelView *pair3 = ZLPairLabelView.new.space(8)
        .bgColor(@"#F5F5F5").corner(8).masksToBounds(YES).inset(10, 12, 10, 12);
    pair3.first.txt(@"状态：").mediumFont(14).color(@"#333333");
    pair3.second.txt(@"正常").systemFont(14).color(@"#52C41A");
    [sec addArrangedSubview:pair3];

    return sec;
}

#pragma mark - Demo 02: ZLPairLabelView 垂直排列

- (UIView *)demo02_pairLabelViewVertical {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 02 · ZLPairLabelView 垂直排列"]];

    // 垂直排列：上 label + 下 label
    ZLPairLabelView *pair = ZLPairLabelView.new.vertical.space(4)
        .bgColor(@"#F9F9F9").corner(8).masksToBounds(YES).inset(12, 12, 12, 12);
    pair.first.txt(@"收货地址").mediumFont(13).color(@"#999999");
    pair.second.txt(@"广东省深圳市南山区科技园北区某某大厦 1001 室").systemFont(15).color(@"#333333").lines(0);
    [sec addArrangedSubview:pair];

    // 垂直 + 居中对齐
    ZLPairLabelView *pair2 = ZLPairLabelView.new.vertical.alignCenter.space(6)
        .bgColor(@"#EEF6FF").corner(10).masksToBounds(YES).inset(16, 0, 16, 0);
    pair2.first.txt(@"88").boldFont(28).color(@"#1677FF");
    pair2.second.txt(@"累计订单").systemFont(12).color(@"#999999");
    [sec addArrangedSubview:pair2];

    return sec;
}

#pragma mark - Demo 03: ZLPairLabelView space / minSpace / maxSpace

- (UIView *)demo03_pairLabelSpacing {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 03 · space / minSpace / maxSpace / flexSpace"]];

    // space：固定间距
    ZLPairLabelView *p1 = ZLPairLabelView.new.space(4);
    p1.first.txt(@"space(4):").systemFont(13).color(@"#333333");
    p1.second.txt(@"固定4pt间距").systemFont(13).color(@"#666666");
    [sec addArrangedSubview:p1];

    // minSpace：最小间距（两端 view 内容超长时不会小于此值）
    ZLPairLabelView *p2 = ZLPairLabelView.new.minSpace(20);
    p2.first.txt(@"minSpace(20):").systemFont(13).color(@"#333333");
    p2.second.txt(@"最小间距20pt").systemFont(13).color(@"#666666");
    [sec addArrangedSubview:p2];

    // maxSpace：最大间距
    ZLPairLabelView *p3 = ZLPairLabelView.new.maxSpace(40);
    p3.first.txt(@"maxSpace(40):").systemFont(13).color(@"#333333");
    p3.second.txt(@"最大间距40pt").systemFont(13).color(@"#666666");
    [sec addArrangedSubview:p3];

    // flexSpace(YES)：弹性间距，把剩余空间全部撑开
    ZLPairLabelView *p4 = ZLPairLabelView.new.flexSpace(YES)
        .bgColor(@"#F5F5F5").corner(6).masksToBounds(YES).inset(8, 10, 8, 10);
    p4.first.txt(@"标题").systemFont(14).color(@"#333333");
    p4.second.txt(@"详情 >").systemFont(14).color(@"#999999");
    [sec addArrangedSubview:p4];

    return sec;
}

#pragma mark - Demo 04: firstFlex / secondFlex 按权重分配宽度

- (UIView *)demo04_pairLabelFlex {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 04 · firstFlex / secondFlex 权重分配"]];

    // firstFlex(1) secondFlex(2)：first 占 1/3，second 占 2/3
    ZLPairLabelView *p1 = ZLPairLabelView.new.firstFlex(1).secondFlex(2)
        .bgColor(@"#F0F7FF").corner(8).masksToBounds(YES).inset(10, 12, 10, 12);
    p1.first.txt(@"first(1)").systemFont(13).color(@"#1677FF").bgColor(@"#DDEEFF").insets(4, 4, 4, 4);
    p1.second.txt(@"second(2)").systemFont(13).color(@"#FF6B35").bgColor(@"#FFE8E0").insets(4, 4, 4, 4);
    [sec addArrangedSubview:p1];

    // 1:1 等分
    ZLPairLabelView *p2 = ZLPairLabelView.new.firstFlex(1).secondFlex(1).space(8)
        .bgColor(@"#F9F9F9").corner(8).masksToBounds(YES).inset(10, 12, 10, 12);
    p2.first.txt(@"first(1) 等分").systemFont(13).color(@"#333333").bgColor(@"#E8E8E8").insets(4, 4, 4, 4);
    p2.second.txt(@"second(1) 等分").systemFont(13).color(@"#333333").bgColor(@"#E8E8E8").insets(4, 4, 4, 4);
    [sec addArrangedSubview:p2];

    // 垂直方向 flex（高度按权重分配）
    ZLPairLabelView *p3 = ZLPairLabelView.new.vertical.firstFlex(1).secondFlex(2).space(6).height(90)
        .bgColor(@"#FFFBE6").corner(8).masksToBounds(YES).inset(8, 12, 8, 12);
    p3.first.txt(@"first 高度1份").systemFont(12).color(@"#FA8C16").bgColor(@"#FFE7BA").insets(2, 4, 2, 4);
    p3.second.txt(@"second 高度2份").systemFont(12).color(@"#FA8C16").bgColor(@"#FFE7BA").insets(2, 4, 2, 4);
    [sec addArrangedSubview:p3];

    return sec;
}

#pragma mark - Demo 05: firstStartSpace / firstEndSpace / secondStartSpace / secondEndSpace

- (UIView *)demo05_pairLabelAlignSpacing {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 05 · firstStartSpace / firstEndSpace / secondStartSpace / secondEndSpace"]];

    // firstStartSpace：first 在纵轴 start 方向留间距（水平轴时=上边距）
    ZLPairLabelView *p1 = ZLPairLabelView.new
        .space(8)
        .bgColor(@"#F5F5F5")
        .corner(8)
        .masksToBounds(YES)
        .inset(0, 12, 0, 12)
        .firstStartSpace(8)
        .firstEndSpace(8);
    p1.first
        .txt(@"firstStartSpace(8)\nfirstEndSpace(8)")
        .systemFont(12)
        .color(@"#1677FF")
        .lines(2)
        .bgColor(@"#DDEEFF")
        .insets(2, 4, 2, 4);
    p1.second
        .txt(@"second")
        .systemFont(13)
        .color(@"#666666");
    [sec addArrangedSubview:p1];
//    
    
    // secondStartSpace / secondEndSpace
    ZLPairLabelView *p2 = ZLPairLabelView.new
        .bgColor(@"#FFF7E6")
        .corner(8)
        .minSpace(20)
        //.flexSpace(YES)
        .masksToBounds(YES)
        .inset(0, 12, 0, 12)
        .secondStartSpace(18)
        .secondEndSpace(18);
   
    p2.second
        .txt(@"secondStartSpace(18)secondEndSpace(18)secondStartSpace")
        .systemFont(12)
        .color(@"#FA8C16")
        .lines(2)
        .bgColor(@"#FFE7BA");
    p2.first
        .txt(@"first")
        .systemFont(13)
        .color(@"#666666")
        .insets(2, 4, 2, 4);
    ;
    [sec addArrangedSubview:p2];

    return sec;
}

#pragma mark - Demo 06: ZLPairImageView

- (UIView *)demo06_pairImageView {
    ZLStackView *sec = ZLStackView.vertical.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 06 · ZLPairImageView 两个 ImageView"]];

    // 水平排列两个色块 ImageView
    ZLPairImageView *pair = ZLPairImageView.new.space(12).inset(8, 0, 8, 0)
        .bgColor(@"#F9F9F9").corner(8).masksToBounds(YES);
    pair.first.backgroundColor = [UIColor colorWithRed:0.36 green:0.61 blue:1.0 alpha:1];
    pair.first.corner(8).zl_layout.square(60);
    pair.second.backgroundColor = [UIColor colorWithRed:1.0 green:0.42 blue:0.21 alpha:1];
    pair.second.corner(8).zl_layout.square(60);
    [sec addArrangedSubview:pair];

    // 垂直排列
    ZLPairImageView *pair2 = ZLPairImageView.new.vertical.space(8).inset(8, 0, 8, 0).alignCenter
        .bgColor(@"#F9F9F9").corner(8).masksToBounds(YES);
    pair2.first.backgroundColor = [UIColor colorWithRed:0.32 green:0.80 blue:0.52 alpha:1];
    pair2.first.corner(6).zl_layout.size(80, 40);
    pair2.second.backgroundColor = [UIColor colorWithRed:1.0 green:0.76 blue:0 alpha:1];
    pair2.second.corner(6).zl_layout.size(80, 40);
    [sec addArrangedSubview:pair2];

    return sec;
}

#pragma mark - Demo 07: ZLPairButtonView

- (UIView *)demo07_pairButtonView {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 07 · ZLPairButtonView 两个 Button"]];

    // 取消 + 确认
    ZLPairButtonView *pair = ZLPairButtonView.new.space(12).firstFlex(1).secondFlex(1);
//    pair.first.title(@"取消").systemFont(15).titleColor(@"#666666")
//        .border(1, @"#DDDDDD").corner(20).masksToBounds(YES).height(40)
//        .tapAction(^(ZLButton *btn) { NSLog(@"点击取消"); });
//    pair.second.title(@"确认").systemFont(15).titleColor(@"#FFFFFF")
//        .bgColor(@"#1677FF").corner(20).masksToBounds(YES).height(40)
//        .tapAction(^(ZLButton *btn) { NSLog(@"点击确认"); });
//    [sec addArrangedSubview:pair];

    // 垂直排列两个按钮
    ZLPairButtonView *pair2 = ZLPairButtonView.new.vertical.space(8).alignFill;
    //pair2.first.title(@"主要操作").systemFont(15).titleColor(@"#FFFFFF")
       // .bgColor(@"#1677FF").corner(8).masksToBounds(YES).height(44);
    pair2.second.title(@"次要操作").systemFont(15).titleColor(@"#1677FF")
        .border(1, @"#1677FF").corner(8).height(44);
    [sec addArrangedSubview:pair2];

    return sec;
}

#pragma mark - Demo 08: ZLImgLabelView（ImageView + Label）

- (UIView *)demo08_imgLabelView {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 08 · ZLImgLabelView（ImageView + Label）"]];

    // 图标 + 文字，水平，常见于列表项
    ZLImgLabelView *item = ZLImgLabelView.new.alignCenter.space(8)
        .bgColor(@"#F5F5F5").corner(8).masksToBounds(YES).inset(12, 12, 12, 12);
    item.first.backgroundColor = [UIColor colorWithRed:0.36 green:0.61 blue:1.0 alpha:1];
    item.first.corner(18).zl_layout.square(36);
    item.second.txt(@"消息通知").systemFont(15).color(@"#333333");
    [sec addArrangedSubview:item];

    // 图标 + 多行文字
    ZLImgLabelView *item2 = ZLImgLabelView.new.alignStart.space(10)
        .bgColor(@"#FFFBE6").corner(8).masksToBounds(YES).inset(12, 12, 12, 12);
    item2.first.backgroundColor = [UIColor colorWithRed:1.0 green:0.76 blue:0 alpha:1];
    item2.first.corner(8).zl_layout.square(40);
    item2.second.txt(@"这是一段比较长的描述文字，用来展示图标与多行文字组合的效果，文字会自动换行。")
        .systemFont(13).color(@"#666666").lines(0);
    [sec addArrangedSubview:item2];

    // 垂直：图片在上，文字在下（底部导航栏风格）
    ZLStackView *row = ZLStackView.horizontal.alignFill.justifySpaceEvenly;
    for (NSString *title in @[@"首页", @"发现", @"消息", @"我的"]) {
        ZLImgLabelView *tab = ZLImgLabelView.new.vertical.alignCenter.space(4);
        tab.first.backgroundColor = [UIColor colorWithRed:0.36 green:0.61 blue:1.0 alpha:1];
        tab.first.corner(14).zl_layout.square(28);
        tab.second.txt(title).systemFont(11).color(@"#1677FF");
        [row addArrangedSubview:tab];
    }
    row.bgColor(@"#F0F7FF").corner(10).masksToBounds(YES).inset(10, 0, 10, 0);
    [sec addArrangedSubview:row];

    return sec;
}

#pragma mark - Demo 09: ZLImgButtonView（ImageView + Button）

- (UIView *)demo09_imgButtonView {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 09 · ZLImgButtonView（ImageView + Button）"]];

    ZLImgButtonView *item = ZLImgButtonView.new.alignCenter.space(12).flexSpace(YES)
        .bgColor(@"#F9F9F9").corner(10).masksToBounds(YES).inset(12, 12, 12, 12);
    item.first.backgroundColor = [UIColor colorWithRed:0.32 green:0.80 blue:0.52 alpha:1];
    item.first.corner(22).zl_layout.square(44);
    item.second.title(@"立即领取").systemFont(14).titleColor(@"#FFFFFF")
        .bgColor(@"#52C41A").corner(16).masksToBounds(YES).height(32).width(80)
        .tapAction(^(ZLButton *btn) { NSLog(@"领取"); });
    [sec addArrangedSubview:item];

    return sec;
}

#pragma mark - Demo 10: ZLButtonImgView（Button + ImageView）

- (UIView *)demo10_buttonImgView {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 10 · ZLButtonImgView（Button + ImageView）"]];

    ZLButtonImgView *item = ZLButtonImgView.new.alignCenter.flexSpace(YES)
        .bgColor(@"#FFF0F6").corner(10).masksToBounds(YES).inset(12, 12, 12, 12);
    item.first.title(@"喜欢").systemFont(14).titleColor(@"#EB2F96")
        .border(1, @"#EB2F96").corner(14).masksToBounds(YES).height(28).width(60)
        .tapAction(^(ZLButton *btn) { NSLog(@"喜欢"); });
    item.second.backgroundColor = [UIColor colorWithRed:0.92 green:0.18 blue:0.59 alpha:1];
    item.second.corner(18).zl_layout.square(36);
    [sec addArrangedSubview:item];

    return sec;
}

#pragma mark - Demo 11: ZLButtonLabView（Button + Label）

- (UIView *)demo11_buttonLabView {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 11 · ZLButtonLabView（Button + Label）"]];

    // 勾选框 + 文字（协议条款场景）
    __block BOOL checked = NO;
    ZLButtonLabView *item = ZLButtonLabView.new.alignCenter.space(6);
    item.first.title(@"☐").systemFont(18).titleColor(@"#CCCCCC")
        .tapAction(^(ZLButton *btn) {
            checked = !checked;
            btn.title(checked ? @"☑" : @"☐").titleColor(checked ? @"#1677FF" : @"#CCCCCC");
        });
    item.second.txt(@"我已阅读并同意《用户协议》和《隐私政策》").systemFont(13).color(@"#666666").lines(0);
    [sec addArrangedSubview:item];

    return sec;
}

#pragma mark - Demo 12: ZLLabelImgView（Label + ImageView）

- (UIView *)demo12_labelImgView {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 12 · ZLLabelImgView（Label + ImageView）"]];

    ZLLabelImgView *item = ZLLabelImgView.new.alignCenter.flexSpace(YES)
        .bgColor(@"#F5F5F5").corner(8).masksToBounds(YES).inset(14, 16, 14, 16);
    item.first.txt(@"个人信息").systemFont(15).color(@"#333333");
    item.second.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    item.second.corner(2).zl_layout.size(50, 50);
    [sec addArrangedSubview:item];

    return sec;
}

#pragma mark - Demo 13: ZLLabButtonView（Label + Button）

- (UIView *)demo13_labButtonView {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 13 · ZLLabButtonView（Label + Button）"]];

    // 标题 + 右侧按钮（查看更多）
    ZLLabButtonView *item = ZLLabButtonView.new.alignCenter.flexSpace(YES)
        .bgColor(@"#FFFFFF").border(1, @"#EEEEEE").corner(8).masksToBounds(YES).inset(12, 16, 12, 16);
    item.first.txt(@"热门推荐").mediumFont(16).color(@"#333333");
    item.second.title(@"查看全部 >").systemFont(13).titleColor(@"#1677FF")
        .tapAction(^(ZLButton *btn) { NSLog(@"查看全部"); });
    [sec addArrangedSubview:item];

    // 红点通知场景：用户名 + 未读数 badge
    ZLLabButtonView *badge = ZLLabButtonView.new.alignCenter.space(8);
    badge.first.txt(@"消息中心").systemFont(15).color(@"#333333");
    badge.second.title(@"99+").systemFont(11).titleColor(@"#FFFFFF")
        .bgColor(@"#FF4D4F").corner(10).masksToBounds(YES).insets(1, 5, 1, 5);
    [sec addArrangedSubview:badge];

    return sec;
}

#pragma mark - Demo 14: ZLButtonStackView（Button + StackView）

- (UIView *)demo14_buttonStackView {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 14 · ZLButtonStackView（Button + StackView）"]];

    ZLButtonStackView *item = ZLButtonStackView.new.alignCenter.space(12)
        .bgColor(@"#F9F9F9").corner(10).masksToBounds(YES).inset(12, 12, 12, 12).secondFlex(1);
    item.first.bgColor(@"#1677FF").corner(22).masksToBounds(YES).square(44)
        .tapAction(^(ZLButton *btn) { NSLog(@"头像点击"); });

    ZLStackView *info = item.second.vertical.alignStart.space(4);
    [info addArrangedSubview:ZLLab.txt(@"李四").mediumFont(15).color(@"#333333")];
    [info addArrangedSubview:ZLLab.txt(@"深圳市 · 产品经理").systemFont(12).color(@"#999999")];
    [sec addArrangedSubview:item];

    return sec;
}

#pragma mark - Demo 15: ZLStackViewButton（StackView + Button）

- (UIView *)demo15_stackViewButton {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 15 · ZLStackViewButton（StackView + Button）"]];

    ZLStackViewButton *item = ZLStackViewButton.new.alignCenter.flexSpace(YES)
        .bgColor(@"#FFF7E6").corner(10).masksToBounds(YES).inset(12, 16, 12, 16);
    ZLStackView *info = item.first.vertical.alignStart.space(4);
    [info addArrangedSubview:ZLLab.txt(@"限时优惠券").mediumFont(15).color(@"#FA8C16")];
    [info addArrangedSubview:ZLLab.txt(@"满100减20，今日到期").systemFont(12).color(@"#999999")];

    item.second.title(@"立即使用").systemFont(13).titleColor(@"#FFFFFF")
        .bgColor(@"#FA8C16").corner(14).masksToBounds(YES).height(28).width(72)
        .tapAction(^(ZLButton *btn) { NSLog(@"使用优惠券"); });
    [sec addArrangedSubview:item];

    return sec;
}

#pragma mark - Demo 16: ZLPairStackView（StackView + StackView）

- (UIView *)demo16_pairStackView {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 16 · ZLPairStackView（StackView + StackView）"]];

    // 左右各一个 StackView，各占一半（flex 1:1）
    ZLPairStackView *item = ZLPairStackView.new.alignFill.space(12).firstFlex(1).secondFlex(1)
        .bgColor(@"#F0F7FF").corner(10).masksToBounds(YES).inset(12, 12, 12, 12);

    ZLStackView *left = item.first.vertical.alignCenter.space(6)
        .bgColor(@"#DDEEFF").corner(8).masksToBounds(YES).inset(10, 0, 10, 0);
    [left addArrangedSubview:ZLLab.txt(@"￥388").boldFont(20).color(@"#1677FF")];
    [left addArrangedSubview:ZLLab.txt(@"本月消费").systemFont(12).color(@"#999999")];

    ZLStackView *right = item.second.vertical.alignCenter.space(6)
        .bgColor(@"#DDEEFF").corner(8).masksToBounds(YES).inset(10, 0, 10, 0);
    [right addArrangedSubview:ZLLab.txt(@"12").boldFont(20).color(@"#52C41A")];
    [right addArrangedSubview:ZLLab.txt(@"本月订单").systemFont(12).color(@"#999999")];

    [sec addArrangedSubview:item];
    return sec;
}

#pragma mark - Demo 17: then / thenFirst / thenSecond 链式配置回调

- (UIView *)demo17_thenConfig {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 17 · then / thenFirst / thenSecond 链式配置回调"]];

    ZLPairLabelView *p1 = ZLPairLabelView.new
        .then(^(ZLPairLabelView *pv) {
            pv.space(8);
            pv.bgColor(@"#F6FFED").corner(8).masksToBounds(YES).inset(10, 12, 10, 12);
        })
        .thenFirst(^(ZLLabel *first) {
            first.txt(@"thenFirst 配置 →").mediumFont(14).color(@"#52C41A");
        })
        .thenSecond(^(ZLLabel *second) {
            second.txt(@"thenSecond 配置 ✓").systemFont(14).color(@"#389E0D");
        });
    [sec addArrangedSubview:p1];

    ZLImgLabelView *p2 = ZLImgLabelView.new.alignCenter.space(10)
        .bgColor(@"#FFF0F6").corner(8).masksToBounds(YES).inset(12, 12, 12, 12)
        .thenFirst(^(ZLImageView *img) {
            img.backgroundColor = [UIColor colorWithRed:0.92 green:0.18 blue:0.59 alpha:1];
            img.corner(20).zl_layout.square(40);
        })
        .thenSecond(^(ZLLabel *lab) {
            lab.txt(@"thenFirst 配置图片\nthenSecond 配置文字").systemFont(13).color(@"#EB2F96").lines(2);
        });
    [sec addArrangedSubview:p2];

    return sec;
}

#pragma mark - Demo 18: flexSpace + minSpace + maxSpace 综合

- (UIView *)demo18_flexSpaceAndMinMax {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 18 · flexSpace + minSpace + maxSpace 综合"]];

    // 键值对列表：key 固定，value 弹性对齐右侧
    NSArray *items = @[@[@"商品名称", @"高端蓝牙耳机 Pro Max"],
                       @[@"单价", @"￥299.00"],
                       @[@"数量", @"2"],
                       @[@"优惠", @"-￥50.00"],
                       @[@"实付", @"￥548.00"]];
    for (NSArray *kv in items) {
        BOOL isTotal = [kv[0] isEqualToString:@"实付"];
        ZLPairLabelView *row = ZLPairLabelView.new.flexSpace(YES)
            .bgColor(isTotal ? @"#FFF7E6" : @"#FAFAFA")
            .corner(6).masksToBounds(YES).inset(10, 12, 10, 12).minSpace(20);
        row.first.txt(kv[0]).systemFont(isTotal ? 15 : 13)
            .color(isTotal ? @"#FA8C16" : @"#999999");
        row.second.txt(kv[1]).systemFont(isTotal ? 15 : 13)
            .color(isTotal ? @"#FA8C16" : @"#333333");
        if (isTotal) row.first.mediumFont(15), row.second.mediumFont(15);
        [sec addArrangedSubview:row];
    }

    return sec;
}

#pragma mark - Demo 19: 圆角 / 边框 / 阴影

- (UIView *)demo19_cornerBorderShadow {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(12);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 19 · corner / border / shadow"]];

    // 圆角
    ZLPairLabelView *p1 = ZLPairLabelView.new.space(8).corner(20).masksToBounds(YES)
        .bgColor(@"#1677FF").inset(10, 16, 10, 16);
    p1.first.txt(@"大圆角").systemFont(14).color(@"#FFFFFF");
    p1.second.txt(@"corner(20)").systemFont(12).color(@"#DDEEFF");
    [sec addArrangedSubview:p1];

    // 边框
    ZLPairLabelView *p2 = ZLPairLabelView.new.space(8).corner(8).masksToBounds(YES)
        .border(2, @"#1677FF").inset(10, 16, 10, 16);
    p2.first.txt(@"边框样式").systemFont(14).color(@"#1677FF");
    p2.second.txt(@"border(2, #1677FF)").systemFont(12).color(@"#999999");
    [sec addArrangedSubview:p2];

    // 阴影（阴影和 masksToBounds 互斥，不能同时设置）
    ZLPairLabelView *p3 = ZLPairLabelView.new.space(8).corner(10)
        .bgColor(@"#FFFFFF").inset(14, 16, 14, 16)
        .shColor(@"#000000").shOpacity(0.12).shRadius(8).shOffset(0, 4);
    p3.first.txt(@"阴影效果").mediumFont(15).color(@"#333333");
    p3.second.txt(@"shColor+shOpacity+shRadius+shOffset").systemFont(11).color(@"#999999");
    [sec addArrangedSubview:p3];

    return sec;
}

#pragma mark - Demo 20: tapAction 点击事件

- (UIView *)demo20_tapAction {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sectionTitle:@"Demo 20 · tapAction 点击整体 PairView"]];

    ZLPairLabelView *p1 = ZLPairLabelView.new.flexSpace(YES)
        .bgColor(@"#F5F5F5").corner(10).masksToBounds(YES).inset(14, 16, 14, 16)
        .tapAction(^(ZLBaseStackView *view) {
            NSLog(@"点击了整个 PairLabelView");
            view.bgColor(@"#E6F4FF");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                view.bgColor(@"#F5F5F5");
            });
        });
    p1.first.txt(@"点我试试").systemFont(15).color(@"#333333");
    p1.second.txt(@"👉 整体可点击").systemFont(13).color(@"#999999");
    [sec addArrangedSubview:p1];

    // userActive：禁用后不响应点击
    __block BOOL enabled = YES;
    ZLPairButtonView *p2 = ZLPairButtonView.new.space(12).firstFlex(1).secondFlex(1);
    p2.first.title(@"禁用下方行").systemFont(14).titleColor(@"#FFFFFF")
        .bgColor(@"#FF4D4F").corner(8).masksToBounds(YES).height(36)
        .tapAction(^(ZLButton *btn) {
            enabled = !enabled;
            p1.userActive(enabled).bgColor(enabled ? @"#F5F5F5" : @"#EEEEEE");
            p1.second.txt(enabled ? @"👉 整体可点击" : @"🚫 已禁用");
        });
    p2.second.title(@"visibility 切换").systemFont(14).titleColor(@"#FFFFFF")
        .bgColor(@"#722ED1").corner(8).masksToBounds(YES).height(36)
        .tapAction(^(ZLButton *btn) {
            p1.visibility(!p1.isHidden ? NO : YES);
        });
    [sec addArrangedSubview:p2];

    return sec;
}

@end
