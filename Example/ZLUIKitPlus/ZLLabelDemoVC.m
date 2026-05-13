#import "ZLLabelDemoVC.h"
#import <ZLUIKitPlus/ZLUIKitPlus.h>

@implementation ZLLabelDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZLLabel Demo";
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];

    // 根滚动容器
    ZLStackView *root;
    ZLStackView.vertical.alignFill.space(16).inset(16, 16, 16, 16)
        .assignToPtr(&root)
        .wrapScrollView
        .zl_layout
        .addToFull(self.view);

    // ─────────────────────────────────────────
    // 1. txt / systemFont / color
    // ─────────────────────────────────────────
    [root addArrangedSubview:[self sectionTitle:@"1. txt / systemFont / color"]];
    ZLStackView *s1 = ZLStackView.vertical.alignStart.space(8);
    [s1 addArrangedSubview:ZLLab.txt(@"systemFont(13)").systemFont(13).color(@"#333333")];
    [s1 addArrangedSubview:ZLLab.txt(@"systemFont(16) 红色").systemFont(16).color(@"#F44336")];
    [s1 addArrangedSubview:ZLLab.txt(@"systemFontColor(18, '#4A90D9')").systemFontColor(18, @"#4A90D9")];
    [s1 addArrangedSubview:ZLLab.txt(@"systemTextFontColor('快捷三合一', 15, '#9C27B0')").systemTextFontColor(@"快捷三合一", 15, @"#9C27B0")];
    [root addArrangedSubview:s1];

    // ─────────────────────────────────────────
    // 2. mediumFont / semiboldFont / boldFont
    // ─────────────────────────────────────────
    [root addArrangedSubview:[self sectionTitle:@"2. mediumFont / semiboldFont / boldFont"]];
    ZLStackView *s2 = ZLStackView.vertical.alignStart.space(8);
    [s2 addArrangedSubview:ZLLab.txt(@"mediumFont(15)").mediumFont(15).color(@"#333333")];
    [s2 addArrangedSubview:ZLLab.txt(@"mediumFontColor(16, '#2196F3')").mediumFontColor(16, @"#2196F3")];
    [s2 addArrangedSubview:ZLLab.txt(@"mediumTextFontColor('快捷', 15, '#4CAF50')").mediumTextFontColor(@"快捷", 15, @"#4CAF50")];
    [s2 addArrangedSubview:ZLLab.txt(@"semiboldFont(17)").semiboldFont(17).color(@"#FF9800")];
    [s2 addArrangedSubview:ZLLab.txt(@"boldFont(18)").boldFont(18).color(@"#E91E63")];
    [root addArrangedSubview:s2];

    // ─────────────────────────────────────────
    // 3. bgColor / corner / masksToBounds
    // ─────────────────────────────────────────
    [root addArrangedSubview:[self sectionTitle:@"3. bgColor / corner / masksToBounds"]];
    ZLStackView *s3 = ZLStackView.horizontal.alignCenter.space(10);
    [s3 addArrangedSubview:ZLLab.txt(@"corner(8)").systemFont(13).color(UIColor.whiteColor)
        .bgColor(@"#2196F3").insets(8, 14, 8, 14).corner(8)];
    [s3 addArrangedSubview:ZLLab.txt(@"corner(20)").systemFont(13).color(UIColor.whiteColor)
        .bgColor(@"#4CAF50").insets(8, 14, 8, 14).corner(20)];
    [s3 addArrangedSubview:ZLLab.txt(@"UIColor").systemFont(13).color(UIColor.whiteColor)
        .bgColor(UIColor.systemPurpleColor).insets(8, 14, 8, 14).corner(10)];
    [root addArrangedSubview:s3];

    // ─────────────────────────────────────────
    // 4. insets / hInset / vInset
    // ─────────────────────────────────────────
    [root addArrangedSubview:[self sectionTitle:@"4. insets / hInset / vInset"]];
    ZLStackView *s4 = ZLStackView.vertical.alignStart.space(8);
    [s4 addArrangedSubview:ZLLab.txt(@"insets(8, 20, 8, 20)").systemFont(14).color(@"#333333")
        .bgColor(@"#E3F2FD").corner(6).insets(8, 20, 8, 20)];
    [s4 addArrangedSubview:ZLLab.txt(@"hInset(24, 24) 水平内边距").systemFont(14).color(@"#333333")
        .bgColor(@"#FFF9C4").corner(6).hInset(24, 24)];
    [s4 addArrangedSubview:ZLLab.txt(@"vInset(14, 14) 垂直内边距").systemFont(14).color(@"#333333")
        .bgColor(@"#F3E5F5").corner(6).vInset(14, 14)];
    [root addArrangedSubview:s4];

    // ─────────────────────────────────────────
    // 5. lines / txtMaxWidth 多行文字
    // ─────────────────────────────────────────
    [root addArrangedSubview:[self sectionTitle:@"5. lines / txtMaxWidth 多行文字"]];
    ZLStackView *s5 = ZLStackView.vertical.alignFill.space(8);
    CGFloat maxW = UIScreen.mainScreen.bounds.size.width - 64;
    [s5 addArrangedSubview:ZLLab
        .txt(@"lines(0) + txtMaxWidth：这是一段很长的文本，设置 lines(0) 后会自动换行显示所有内容，txtMaxWidth 限制最大宽度。")
        .systemFont(14).color(@"#555555").lines(0).txtMaxWidth(maxW)];
    [s5 addArrangedSubview:ZLLab
        .txt(@"lines(2) 最多两行：这是一段很长的文本，超过两行后会被截断，展示省略号效果。这是超出的部分内容。")
        .systemFont(14).color(@"#555555").lines(2).txtMaxWidth(maxW)];
    [root addArrangedSubview:s5];

    // ─────────────────────────────────────────
    // 6. textAlign（左/中/右）
    // ─────────────────────────────────────────
    [root addArrangedSubview:[self sectionTitle:@"6. textAlign 文字对齐"]];
    ZLStackView *s6 = ZLStackView.vertical.alignFill.space(6);
    [s6 addArrangedSubview:ZLLab.txt(@"textAlignLeft  ←").systemFont(14).color(@"#333333")
        .bgColor(@"#EFEFEF").insets(8, 12, 8, 12).textAlignLeft];
    [s6 addArrangedSubview:ZLLab.txt(@"textAlignCenter  →|←").systemFont(14).color(@"#333333")
        .bgColor(@"#E0E0E0").insets(8, 12, 8, 12).textAlignCenter];
    [s6 addArrangedSubview:ZLLab.txt(@"textAlignRight  →").systemFont(14).color(@"#333333")
        .bgColor(@"#EFEFEF").insets(8, 12, 8, 12).textAlignRight];
    [root addArrangedSubview:s6];

    // ─────────────────────────────────────────
    // 7. border
    // ─────────────────────────────────────────
    [root addArrangedSubview:[self sectionTitle:@"7. border / borderColor / borderWidth"]];
    ZLStackView *s7 = ZLStackView.horizontal.alignCenter.space(10);
    [s7 addArrangedSubview:ZLLab.txt(@"border(1,'#2196F3')").systemFont(12).color(@"#2196F3")
        .insets(8, 12, 8, 12).corner(6).border(1, @"#2196F3")];
    [s7 addArrangedSubview:ZLLab.txt(@"border(2,'#F44336')").systemFont(12).color(@"#F44336")
        .insets(8, 12, 8, 12).corner(8).border(2, @"#F44336")];
    [s7 addArrangedSubview:ZLLab.txt(@"宽度+颜色分开设置").systemFont(12).color(@"#4CAF50")
        .insets(8, 12, 8, 12).corner(6).borderWidth(1.5).borderColor(@"#4CAF50")];
    [root addArrangedSubview:s7];

    // ─────────────────────────────────────────
    // 8. visibility / alphaValue
    // ─────────────────────────────────────────
    [root addArrangedSubview:[self sectionTitle:@"8. visibility / alphaValue"]];
    ZLStackView *s8 = ZLStackView.horizontal.alignCenter.space(10);
    [s8 addArrangedSubview:ZLLab.txt(@"visibility=YES").systemFont(13).color(UIColor.whiteColor)
        .bgColor(@"#4CAF50").insets(8, 12, 8, 12).corner(6).visibility(YES)];
    [s8 addArrangedSubview:ZLLab.txt(@"visibility=NO(隐藏)").systemFont(13).color(UIColor.whiteColor)
        .bgColor(@"#F44336").insets(8, 12, 8, 12).corner(6).visibility(NO)];
    [s8 addArrangedSubview:ZLLab.txt(@"alpha=0.4").systemFont(13).color(UIColor.whiteColor)
        .bgColor(@"#2196F3").insets(8, 12, 8, 12).corner(6).alphaValue(0.4)];
    [root addArrangedSubview:s8];

    // ─────────────────────────────────────────
    // 9. tapAction 点击回调
    // ─────────────────────────────────────────
    [root addArrangedSubview:[self sectionTitle:@"9. tapAction 点击回调"]];
    ZLStackView *s9 = ZLStackView.vertical.alignFill.space(8);
    ZLLabel *tapResult = ZLLab.txt(@"点击下方标签").systemFont(13).color(@"#999999").textAlignCenter;
    __weak typeof(tapResult) weakResult = tapResult;
    ZLLabel *tapLab = ZLLab.txt(@"点击我！tapAction").systemFont(15).color(UIColor.whiteColor)
        .bgColor(@"#2196F3").insets(12, 20, 12, 20).corner(8)
        .tapAction(^(ZLLabel *l) {
            static int cnt = 0;
            weakResult.text = [NSString stringWithFormat:@"点击了 %d 次 ✅", ++cnt];
        });
    [s9 addArrangedSubview:tapLab];
    [s9 addArrangedSubview:tapResult];
    [root addArrangedSubview:s9];

    // ─────────────────────────────────────────
    // 10. userActive / activeStyle / inactiveStyle
    // ─────────────────────────────────────────
    [root addArrangedSubview:[self sectionTitle:@"10. userActive / activeStyle / inactiveStyle"]];
    ZLStackView *s10 = ZLStackView.horizontal.alignCenter.space(10);
    [s10 addArrangedSubview:ZLLab.txt(@"userActive=YES").systemFont(13).color(UIColor.whiteColor)
        .bgColor(@"#4CAF50").insets(10, 14, 10, 14).corner(6)
        .userActive(YES)
        .activeStyle(^(ZLLabel *l) { l.backgroundColor = UIColor.systemGreenColor; })
        .inactiveStyle(^(ZLLabel *l) { l.backgroundColor = UIColor.lightGrayColor; })];
    [s10 addArrangedSubview:ZLLab.txt(@"userActive=NO").systemFont(13).color(UIColor.whiteColor)
        .bgColor(@"#9E9E9E").insets(10, 14, 10, 14).corner(6)
        .userActive(NO)
        .inactiveStyle(^(ZLLabel *l) { l.backgroundColor = UIColor.lightGrayColor; })];
    [root addArrangedSubview:s10];

   

    // ─────────────────────────────────────────
    // 12. attributeTxt / attributeTxtBK
    // ─────────────────────────────────────────
    [root addArrangedSubview:[self sectionTitle:@"12. attributeTxt / attributeTxtBK 属性文本"]];
    ZLStackView *s12 = ZLStackView.vertical.alignStart.space(8);

    // 直接传 NSAttributedString
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"attributeTxt: "
        attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor colorWithWhite:0.4 alpha:1]}]];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"红色加粗 "
        attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName: UIColor.redColor}]];
    [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"蓝色斜体"
        attributes:@{NSFontAttributeName: [UIFont italicSystemFontOfSize:15], NSForegroundColorAttributeName: UIColor.blueColor}]];
    [s12 addArrangedSubview:ZLLab.attributeTxt(attr)];

    // block 方式（可拿到 label 自身做动态处理）
    [s12 addArrangedSubview:ZLLab.attributeTxtBK(^NSAttributedString *(ZLLabel *l) {
        NSMutableAttributedString *a = NSMutableAttributedString.new;
        [a appendAttributedString:[[NSAttributedString alloc] initWithString:@"attributeTxtBK: "
            attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}]];
        [a appendAttributedString:[[NSAttributedString alloc] initWithString:@"🎉 动态构建"
            attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName: [UIColor systemOrangeColor]}]];
        return a;
    })];
    [root addArrangedSubview:s12];

    // ─────────────────────────────────────────
    // 13. then / assignToPtr
    // ─────────────────────────────────────────
    [root addArrangedSubview:[self sectionTitle:@"13. then 立即回调 / assignToPtr 赋值指针"]];
    ZLStackView *s13 = ZLStackView.vertical.alignStart.space(8);

    ZLLabel *refLabel;
    ZLLab.txt(@"assignToPtr：通过指针引用此 label")
        .systemFont(14).color(@"#333333")
        .bgColor(@"#E8F5E9").insets(8, 12, 8, 12).corner(6)
        .assignToPtr(&refLabel)
        .then(^(ZLLabel *l) {
            // then：label 初始化时立即执行，可做额外配置
            l.layer.borderColor = [UIColor systemGreenColor].CGColor;
            l.layer.borderWidth = 1;
        });
    [s13 addArrangedSubview:refLabel];

    [s13 addArrangedSubview:ZLLab.txt(@"then：可在链式调用中立即执行任意配置")
        .systemFont(14).color(@"#555555")
        .bgColor(@"#FFF8E1").insets(8, 12, 8, 12).corner(6)
        .then(^(ZLLabel *l) {
            l.layer.shadowColor = UIColor.blackColor.CGColor;
            l.layer.shadowOpacity = 0.15;
            l.layer.shadowOffset = CGSizeMake(0, 2);
            l.layer.shadowRadius = 4;
        })];
    [root addArrangedSubview:s13];

    // ─────────────────────────────────────────
    // 14. KFC 布局 API（width / height / square / size / edge）
    // ─────────────────────────────────────────
    [root addArrangedSubview:[self sectionTitle:@"14. ZLLabel 内置布局 API（width/height/square/size）"]];
    ZLStackView *s14 = ZLStackView.horizontal.alignCenter.space(8);

    ZLLabel *l14a = ZLLab.txt(@"width(80)").systemFont(11).color(UIColor.whiteColor)
        .bgColor(@"#9C27B0").textAlignCenter.corner(4);
    l14a.width(80);

    ZLLabel *l14b = ZLLab.txt(@"height(50)").systemFont(11).color(UIColor.whiteColor)
        .bgColor(@"#FF5722").textAlignCenter.corner(4);
    l14b.height(50);

    ZLLabel *l14c = ZLLab.txt(@"sq\n40").systemFont(11).color(UIColor.whiteColor)
        .bgColor(@"#009688").textAlignCenter.corner(20).lines(0);
    l14c.square(40);

    ZLLabel *l14d = ZLLab.txt(@"size\n70×40").systemFont(10).color(UIColor.whiteColor)
        .bgColor(@"#607D8B").textAlignCenter.corner(4).lines(0);
    l14d.size(70, 40);

    [s14 addArrangedSubview:l14a];
    [s14 addArrangedSubview:l14b];
    [s14 addArrangedSubview:l14c];
    [s14 addArrangedSubview:l14d];
    [root addArrangedSubview:s14];

    // ─────────────────────────────────────────
    // 15. corners CACornerMask 单角圆角
    // ─────────────────────────────────────────
    [root addArrangedSubview:[self sectionTitle:@"15. corners CACornerMask 单独设置各角圆角"]];
    ZLStackView *s15 = ZLStackView.horizontal.alignCenter.space(8);
    if (@available(iOS 11.0, *)) {
        struct { CACornerMask mask; NSString *name; NSString *color; } cornerCases[] = {
            { kCALayerMinXMinYCorner,                                                                                                           @"左上",   @"#F44336" },
            { kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner,                                                                                  @"上两角", @"#2196F3" },
            { kCALayerMinXMinYCorner | kCALayerMaxXMaxYCorner,                                                                                  @"对角线", @"#4CAF50" },
            { kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner | kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner,                                @"全圆角",  @"#FF9800" },
        };
        for (int i = 0; i < 4; i++) {
            ZLLabel *cl = ZLLab.txt(cornerCases[i].name).systemFont(11).color(UIColor.whiteColor)
                .bgColor(cornerCases[i].color).insets(8, 10, 8, 10).corner(14)
                .corners(cornerCases[i].mask)
                .masksToBounds(YES);
            [s15 addArrangedSubview:cl];
        }
    } else {
        [s15 addArrangedSubview:ZLLab.txt(@"CACornerMask 需要 iOS 11+").systemFont(13).color(@"#999999")];
    }
    [root addArrangedSubview:s15];
}

// 辅助：分区标题
- (UILabel *)sectionTitle:(NSString *)title {
    return ZLLab.txt(title)
        .boldFont(13)
        .color(@"#555555")
        .bgColor(@"#E8E8E8")
        .insets(6, 10, 6, 10)
        .corner(4);
}

@end
