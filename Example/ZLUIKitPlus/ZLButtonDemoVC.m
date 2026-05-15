#import "ZLButtonDemoVC.h"
#import <ZLUIKitPlus/ZLUIKitPlus.h>
#import <Masonry/Masonry.h>
@implementation ZLButtonDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZLButton Demo";
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];

    ZLStackView *root;
    VStackView
        .alignFill
        .justifyStart
        .space(16)
        .inset(16, 16, 16, 16)
        .assignToPtr(&root)
        .wrapScrollView
        .zl_layout
        .addToFull(self.view);
    
    

    // ─────────────────────────────────────
    // 1. 水平布局：图片在前（HButton）
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"1. 水平布局 HButton（图左文右）"]];

    [root addArrangedSubview:HButton
     .systemImage(@"star.fill")
     .imageSize(20, 20)
     .title(@"spacing=12")
     .systemFont(15)
     .titleColor(@"#333333")
     .bgColor(@"#E3F2FD")
     .insets(10, 16, 10, 16)
     .corner(8)
     .spacing(12)];
//    // ─────────────────────────────────────
//    // 2. 垂直布局：图片在上（VButton）
//    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"2. 垂直布局 VButton（图上文下）"]];
    [root addArrangedSubview:ZLStackView.horizontal.alignCenter.space(16)
        .justifyFillEqually
        .addView(VButton.systemImage(@"heart")
            .imageSize(28, 28)
            .title(@"图上文下")
            .systemFont(13)
            .titleColor(@"#E91E63")
            .spacing(6)
            .insets(12, 16, 12, 16))
        .addView(VButton.systemImage(@"star")
            .imageSize(28, 28)
            .title(@"spacing=10")
            .systemFont(13)
            .titleColor(@"#FF9800")
            .spacing(10)
            .insets(12, 16, 12, 16))];
    // ─────────────────────────────────────
    // 3. titleFirst（文字在前）
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"3. titleFirst（文字在前）"]];
    [root addArrangedSubview:HStackView.justifyFillEqually.alignCenter.space(12)
        .addView(HButton.titleFirst
            .title(@"文左图右")
            .systemImage(@"chevron.right")
            .imageSize(14, 14)
            .systemFont(15)
            .titleColor(@"#333333")
            .bgColor(@"#EEEEEE")
            .insets(10, 16, 10, 16)
            .corner(8)
            .spacing(6))
        .addView(VButton.titleFirst
            .title(@"文上图下")
            .systemImage(@"chevron.down")
            .imageSize(50, 50)
            .systemFont(13)
            .titleColor(@"#9C27B0")
            .insets(10, 16, 10, 16)
            .spacing(6))];
    
    // ─────────────────────────────────────
    // 4. flexibleSpacing（弹性间距）
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"4. flexSpacing 弹性间距（图文撑满）"]];
    ZLButton *flexBtn = HButton.flexSpacing
        .hAlignFill
        .title(@"弹性间距：图文撑满")
        .systemImage(@"arrow.left.and.right")
        .imageSize(18, 18)
        .spacing(10)
        .systemFont(14)
        .titleColor(@"#FFFFFF")
        .bgColor(@"#4CAF50")
        .insets(10, 16, 10, 16)
        .corner(8);
    
    flexBtn.zl_layout.height(64);
  
    [root addArrangedSubview:flexBtn];
    // ─────────────────────────────────────
    // 5. insets / hInset / vInset 内边距
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"5. insets / hInset / vInset 内边距"]];
    [root addArrangedSubview:ZLStackView.vertical.alignStart.space(8)
        .addView(HButton.title(@"insets(8,20,8,20)")
            .systemFont(14).titleColor(@"#333333")
            .bgColor(@"#E3F2FD").corner(6).insets(8, 20, 8, 20))
        .addView(HButton.title(@"hInset(24,24)")
            .systemFont(14).titleColor(@"#333333")
            .bgColor(@"#FFF9C4").corner(6).hInset(24, 24))
        .addView(HButton.title(@"vInset(14,14)")
            .systemFont(14).titleColor(@"#333333")
            .bgColor(@"#F3E5F5").corner(6).vInset(14, 14))];
    // ─────────────────────────────────────
    // 6. 字体：systemFont / mediumFont / semiboldFont / boldFont
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"6. 字体 systemFont / mediumFont / semiboldFont / boldFont"]];
    [root addArrangedSubview:ZLStackView.vertical.alignStart.space(8)
        .addView(HButton.title(@"systemFont(15)").systemFont(15).titleColor(@"#333333"))
        .addView(HButton.title(@"systemFontColor(15, '#2196F3')").systemFontColor(15, @"#2196F3"))
        .addView(HButton.title(@"systemTitleFontColor").systemTitleFontColor(@"快捷三合一", 15, @"#9C27B0"))
        .addView(HButton.title(@"mediumFont(16)").mediumFont(16).titleColor(@"#FF9800"))
        .addView(HButton.title(@"mediumFontColor(16,'#4CAF50')").mediumFontColor(16, @"#4CAF50"))
        .addView(HButton.title(@"semiboldFont(17)").semiboldFont(17).titleColor(@"#E91E63"))
        .addView(HButton.title(@"boldFont(18)").boldFont(18).titleColor(@"#F44336"))];

    // ─────────────────────────────────────
    // 7. selectTitle / selectImage / selectTitleColor
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"7. selectTitle / selectImage / selectTitleColor（点击切换）"]];
    UILabel *selResult = ZLLab.txt(@"点击按钮切换选中状态").systemFont(13).color(@"#999999");
    __weak UILabel *weakSelResult = selResult;
    ZLButton *selBtn = HButton
        .systemImage(@"heart")
        .selectImage(@"heart.fill")
        .title(@"收藏")
        .selectTitle(@"已收藏")
        .titleColor(@"#555555")
        .selectTitleColor(@"#F44336")
        .imageSize(18, 18)
        .systemFont(15)
        .bgColor(@"#F5F5F5")
        .insets(10, 16, 10, 16)
        .corner(20)
        .spacing(6)
        .tapAction(^(ZLButton *btn) {
            btn.selected = !btn.selected;
            weakSelResult.text = btn.selected ? @"当前状态：已收藏 ❤️" : @"当前状态：未收藏";
        });
    [root addArrangedSubview:ZLStackView.vertical.alignCenter.space(8)
        .addView(selBtn).addView(selResult)];

    // ─────────────────────────────────────
    // 8. select / activeStyle / inactiveStyle
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"8. select / userActive / activeStyle / inactiveStyle"]];
    [root addArrangedSubview:ZLStackView.horizontal.alignCenter.space(12)
        .addView(HButton.title(@"select=YES")
            .systemFont(14).titleColor(UIColor.whiteColor)
            .bgColor(@"#2196F3").insets(10, 16, 10, 16).corner(8)
            .select(YES))
        .addView(HButton.title(@"userActive=NO")
            .systemFont(14).titleColor(UIColor.whiteColor)
            .bgColor(@"#9E9E9E").insets(10, 16, 10, 16).corner(8)
            .userActive(NO)
            .inactiveStyle(^(ZLButton *b) { b.alpha = 0.5; }))
        .addView(HButton.title(@"activeStyle")
            .systemFont(14).titleColor(UIColor.whiteColor)
            .bgColor(@"#4CAF50").insets(10, 16, 10, 16).corner(8)
            .userActive(YES)
            .activeStyle(^(ZLButton *b) { b.backgroundColor = UIColor.systemGreenColor; }))];
    // ─────────────────────────────────────
    // 9. corner / cornerRadii / circle
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"9. corner / cornerRadii / circle 圆角"]];
    [root addArrangedSubview:ZLStackView.horizontal.alignCenter.space(10)
        .addView(HButton.title(@"corner(8)")
            .systemFont(13).titleColor(UIColor.whiteColor)
            .bgColor(@"#2196F3").insets(10, 14, 10, 14).corner(8))
        .addView(HButton.title(@"corner(20)")
            .systemFont(13).titleColor(UIColor.whiteColor)
            .bgColor(@"#4CAF50").insets(10, 14, 10, 14).corner(20))
        .addView(HButton.title(@"circle")
            .systemFont(13).titleColor(UIColor.whiteColor)
            .bgColor(@"#FF9800").square(56).circle(YES))
        .addView(HButton.title(@"TL=0\nBR=16")
            .systemFont(11).titleColor(UIColor.whiteColor)
            .bgColor(@"#9C27B0").insets(10, 14, 10, 14)
            .cornerRadii(0, 16, 16, 0))];
    // ─────────────────────────────────────
    // 10. border / shColor / shOpacity / shRadius / shOffset
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"10. border + shadow 边框和阴影"]];
    [root addArrangedSubview:ZLStackView.horizontal.alignCenter.space(16)
        .addView(HButton.title(@"border(2,'#2196F3')")
            .systemFont(12).titleColor(@"#2196F3")
            .insets(10, 14, 10, 14).corner(8)
            .border(2, @"#2196F3"))
        .addView(HButton.title(@"shadow")
            .systemFont(14).titleColor(@"#333333")
            .bgColor(UIColor.whiteColor).insets(12, 20, 12, 20).corner(10)
            .shColor(@"#000000").shOpacity(0.2).shRadius(8).shOffset(0, 4))];
    // ─────────────────────────────────────
    // 11. bgImage / selectBgImage / bgImageMode
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"11. bgImage / selectBgImage 背景图片"]];
    ZLButton *bgImgBtn = HButton
        .title(@"背景图片（点击切换）")
        .systemFont(14).titleColor(UIColor.whiteColor)
        .bgImage([UIImage systemImageNamed:@"star.fill"])
        .selectBgImage([UIImage systemImageNamed:@"photo.fill"])
        .bgImageMode(UIViewContentModeScaleAspectFill)
        .insets(14, 20, 14, 20).corner(10)
        .bgColor(@"#2196F3") // 图片加载失败时的兜底色
        .tapAction(^(ZLButton *b) { b.selected = !b.selected; });
    [root addArrangedSubview:bgImgBtn];
    // ─────────────────────────────────────
    // 12. imageSize / imageCorner / imageMode
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"12. imageSize / imageCorner / imageMode 图片控制"]];
    [root addArrangedSubview:ZLStackView.horizontal.alignCenter.space(12).justifyFillEqually
        .addView(HButton.systemImage(@"photo")
            .imageSize(32, 32)
            .title(@"imageSize(32,32)")
            .systemFont(13).titleColor(@"#333333")
            .bgColor(@"#E3F2FD").insets(10, 14, 10, 14).corner(8).spacing(6))
        .addView(HButton.systemImage(@"photo.fill")
            .imageSize(32, 32)
            .imageCorner(20)
            .title(@"imageCorner(8)")
            .systemFont(13).titleColor(@"#333333")
            .bgColor(@"#FFF9C4").insets(10, 14, 10, 14).corner(8).spacing(6))];
    // ─────────────────────────────────────
    // 13. imgInsets / titInsets 偏移
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"13. imgInsets / titInsets 图片和文字偏移"]];
    [root addArrangedSubview:ZLStackView.horizontal.alignCenter.space(12)
        .addView(HButton.systemImage(@"star")
            .imageSize(18, 18)
            .title(@"imgInsets(10,4)")
            .systemFont(13).titleColor(@"#333333")
            .bgColor(@"#EFEFEF").insets(10, 14, 10, 14).corner(8)
            .imgInsets(10, 4)
            .spacing(6))
        .addView(HButton.systemImage(@"star")
            .imageSize(18, 18)
            .title(@"titInsets(4,10)")
            .systemFont(13).titleColor(@"#333333")
            .bgColor(@"#EFEFEF").insets(10, 14, 10, 14).corner(8)
            .titInsets(4, 10)
            .spacing(6))];
    // ─────────────────────────────────────
    // 14. titleLines / titleMaxWidth 多行文字
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"14. titleLines / titleMaxWidth 多行文字"]];
    [root addArrangedSubview:ZLStackView.vertical.alignStart.space(8)
        .addView(HButton
            .title(@"这是一段较长的按钮标题，titleLines(0)+titleMaxWidth(200)，超出会自动换行显示")
            .systemFont(13).titleColor(@"#333333")
            .bgColor(@"#E8F5E9").insets(10, 14, 10, 14).corner(6)
            .titleLines(0).titleMaxWidth(200))
        .addView(HButton
            .title(@"titleLines(2)：超过两行截断，这是超出两行的文字内容部分")
            .systemFont(13).titleColor(@"#333333")
            .bgColor(@"#FFF3E0").insets(10, 14, 10, 14).corner(6)
            .titleLines(2).titleMaxWidth(200))];
    // ─────────────────────────────────────
    // 15. titSize 固定文字区域大小
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"15. titSize 固定文字区域"]];
    [root addArrangedSubview:HButton
        .systemImage(@"star").imageSize(20, 20)
        .title(@"titSize(120,30)")
        .systemFont(14).titleColor(@"#FFFFFF")
        .bgColor(@"#607D8B").insets(10, 14, 10, 14).corner(8).spacing(8)
        .titSize(120, 30)];

    // ─────────────────────────────────────
    // 16. tapAction / addTargetSel 点击事件
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"16. tapAction / addTargetSel 点击事件"]];
    UILabel *tapResult = ZLLab.txt(@"等待点击...").systemFont(13).color(@"#999999");
    __weak UILabel *weakTapResult = tapResult;

    ZLButton *tapBtn = HButton
        .title(@"tapAction 点我")
        .systemFont(15).titleColor(UIColor.whiteColor)
        .bgColor(@"#2196F3").insets(12, 20, 12, 20).corner(8)
        .tapAction(^(ZLButton *btn) {
            static int n = 0;
            weakTapResult.text = [NSString stringWithFormat:@"tapAction 点击了 %d 次 ✅", ++n];
        });
    
    ZLButton *selBtn2 = HButton
        .title(@"addTargetSel 点我")
        .systemFont(15).titleColor(UIColor.whiteColor)
        .bgColor(@"#4CAF50").insets(12, 20, 12, 20).corner(8)
        .addTargetSel(self, @selector(_onBtnTap:));

    [root addArrangedSubview:ZLStackView.vertical.alignFill.space(8)
        .addView(ZLStackView.horizontal.alignCenter.space(10).addView(tapBtn).addView(selBtn2))
        .addView(tapResult)];
    // ─────────────────────────────────────
    // 17. debounce 防抖
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"17. debounce 防抖（1s 内只响应一次）"]];
    UILabel *debounceResult = ZLLab.txt(@"等待点击...").systemFont(13).color(@"#999999");
    __weak UILabel *weakDebounce = debounceResult;
    [root addArrangedSubview:ZLStackView.vertical.alignFill.space(8)
        .addView(HButton.title(@"debounce(1.0) 快速点击只响应一次")
            .systemFont(14).titleColor(UIColor.whiteColor)
            .bgColor(@"#FF5722").insets(12, 16, 12, 16).corner(8)
            .debounce(1.0)
            .tapAction(^(ZLButton *b) {
                static int d = 0;
                weakDebounce.text = [NSString stringWithFormat:@"防抖触发 %d 次（快速点击无效）", ++d];
            }))
        .addView(debounceResult)];

    // ─────────────────────────────────────
    // 18. touchAreaEdge 扩大点击区域
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"18. touchAreaEdge 扩大点击区域"]];
    UILabel *touchResult = ZLLab.txt(@"点击小按钮周围也能响应 ↓").systemFont(13).color(@"#999999");
    __weak UILabel *weakTouch = touchResult;
    ZLButton *smallBtn = HButton
        .title(@"小按钮")
        .systemFont(12).titleColor(UIColor.whiteColor)
        .bgColor(@"#9C27B0").square(44).corner(22)
        .touchAreaEdge(20, 20, 20, 20)  // 四周各扩大 20pt
        .tapAction(^(ZLButton *b) {
            weakTouch.text = @"点击命中 ✅（扩大了 20pt 点击区域）";
        });
    [root addArrangedSubview:ZLStackView.vertical.alignCenter.space(12)
        .addView(smallBtn).addView(touchResult)];
    // ─────────────────────────────────────
    // 19. imageTouchOnly 仅图片响应点击
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"19. imageTouchOnly 仅图片区域响应点击"]];
    UILabel *imgTouchResult = ZLLab.txt(@"只有点击图片才响应").systemFont(13).color(@"#999999");
    __weak UILabel *weakImgTouch = imgTouchResult;
    [root addArrangedSubview:ZLStackView.vertical.alignStart.space(8)
        .addView(HButton
            .systemImage(@"star.fill").imageSize(28, 28)
            .title(@"文字区域点击无效，只有图片响应")
            .systemFont(14).titleColor(@"#333333")
            .bgColor(@"#E3F2FD").insets(10, 14, 10, 14).corner(8).spacing(8)
            .imageTouchOnly(YES)
            .tapAction(^(ZLButton *b) {
                weakImgTouch.text = @"图片点击命中 ⭐️";
            }))
        .addView(imgTouchResult)];
    // ─────────────────────────────────────
    // 20. gradColors / gradDirection 渐变
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"20. gradColors / gradDirection 渐变背景"]];
    [root addArrangedSubview:ZLStackView.horizontal.justifyFillEqually.alignCenter.space(12)
        .addView(HButton.title(@"水平渐变")
            .systemFont(14).titleColor(UIColor.whiteColor)
            .insets(12, 20, 12, 20).corner(10)
            .gradColors(@[[UIColor colorWithRed:0.13 green:0.59 blue:0.95 alpha:1],
                           [UIColor colorWithRed:0.30 green:0.69 blue:0.31 alpha:1]])
            .gradDirection(CGPointMake(0, 0.5), CGPointMake(1, 0.5)))
        .addView(HButton.title(@"垂直渐变")
            .systemFont(14).titleColor(UIColor.whiteColor)
            .insets(12, 20, 12, 20).corner(10)
            .gradColors(@[[UIColor colorWithRed:0.96 green:0.26 blue:0.21 alpha:1],
                           [UIColor colorWithRed:1.00 green:0.60 blue:0.00 alpha:1]])
            .gradDirection(CGPointMake(0.5, 0), CGPointMake(0.5, 1)))];
    // ─────────────────────────────────────
    // 21. visibility / alphaValue
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"21. visibility / alphaValue"]];
    [root addArrangedSubview:ZLStackView.horizontal.alignCenter.space(10)
        .addView(HButton.title(@"visibility=YES").systemFont(13).titleColor(UIColor.whiteColor)
            .bgColor(@"#4CAF50").insets(10, 14, 10, 14).corner(6).visibility(YES))
        .addView(HButton.title(@"visibility=NO").systemFont(13).titleColor(UIColor.whiteColor)
            .bgColor(@"#F44336").insets(10, 14, 10, 14).corner(6).visibility(NO))
        .addView(HButton.title(@"alpha=0.4").systemFont(13).titleColor(UIColor.whiteColor)
            .bgColor(@"#2196F3").insets(10, 14, 10, 14).corner(6).alphaValue(0.4))];
    // ─────────────────────────────────────
    // 22. assignToPtr / then
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"22. assignToPtr / then"]];
    ZLButton *refBtn;
    HButton.title(@"assignToPtr：通过指针引用按钮")
        .systemFont(14).titleColor(@"#333333")
        .bgColor(@"#E8F5E9").insets(12, 16, 12, 16).corner(8)
        .assignToPtr(&refBtn)
        .then(^(ZLButton *b) {
            b.layer.borderColor = [UIColor systemGreenColor].CGColor;
            b.layer.borderWidth = 1.5;
        });
    [root addArrangedSubview:refBtn];

    [root addArrangedSubview:HButton.title(@"then：链式中立即执行配置")
        .systemFont(14).titleColor(@"#555555")
        .bgColor(@"#FFF8E1").insets(12, 16, 12, 16).corner(8)
        .then(^(ZLButton *b) {
            b.layer.shadowColor = UIColor.blackColor.CGColor;
            b.layer.shadowOpacity = 0.15;
            b.layer.shadowOffset = CGSizeMake(0, 3);
            b.layer.shadowRadius = 6;
        })];
    // ─────────────────────────────────────
    // 23. hAlign / vAlign 内容对齐
    // ─────────────────────────────────────
    [root addArrangedSubview:[self sec:@"23. hAlignStart / hAlignEnd / vAlignStart / vAlignEnd 内容对齐"]];
    ZLStackView *alignRow = ZLStackView.horizontal.space(8).alignFill.justifyFillEqually;
    NSArray *alignCases = @[
        @[@"hStart", @"hAlignStart"],
        @[@"hEnd",   @"hAlignEnd"],
        @[@"vStart", @"vAlignStart"],
        @[@"vEnd",   @"vAlignEnd"],
    ];
    for (NSArray *c in alignCases) {
        ZLButton *ab = VButton
            .systemImage(@"star").imageSize(16, 16)
            .title(c[0])
            .systemFont(11).titleColor(@"#FFFFFF")
            .bgColor(@"#607D8B").corner(6).spacing(4);
        NSString *key = c[1];
        if ([key isEqualToString:@"hAlignStart"])       [ab hAlignStart];
        else if ([key isEqualToString:@"hAlignEnd"])    [ab hAlignEnd];
        else if ([key isEqualToString:@"vAlignStart"])  [ab vAlignStart];
        else if ([key isEqualToString:@"vAlignEnd"])    [ab vAlignEnd];
        ab.zl_layout.height(80);
        [alignRow addArrangedSubview:ab];
    }
    [root addArrangedSubview:alignRow];
}

#pragma mark - addTargetSel 回调
- (void)_onBtnTap:(ZLButton *)btn {
    static int n = 0;
    // 找到 tapResult label 并更新（此处直接用 tag 简化）
    UILabel *lab = (UILabel *)[self.view viewWithTag:9999];
    lab.text = [NSString stringWithFormat:@"addTargetSel 点击了 %d 次 ✅", ++n];
}

#pragma mark - 辅助
- (UILabel *)sec:(NSString *)title {
    return ZLLab.txt(title).boldFont(13).color(@"#555555")
        .bgColor(@"#E8E8E8").insets(6, 10, 6, 10).corner(4);
}

@end
