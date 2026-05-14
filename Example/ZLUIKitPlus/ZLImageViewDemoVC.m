#import "ZLImageViewDemoVC.h"
#import <ZLUIKitPlus/ZLUIKitPlus.h>

@implementation ZLImageViewDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZLImageView Demo";
    self.view.backgroundColor = UIColor.whiteColor;

    ZLStackView *root = ZLStackView.vertical.alignFill.space(20).inset(16, 16, 16, 16);
    [root wrapScrollView].zl_layout.addToFull(self.view);

    [root addArrangedSubview:[self demo01_img]];
    [root addArrangedSubview:[self demo02_hlImg_highlight]];
    [root addArrangedSubview:[self demo03_mode]];
    [root addArrangedSubview:[self demo04_corner]];
    [root addArrangedSubview:[self demo05_corners]];
    [root addArrangedSubview:[self demo06_circle]];
    [root addArrangedSubview:[self demo07_border]];
    [root addArrangedSubview:[self demo08_bgColor]];
    [root addArrangedSubview:[self demo09_visibility_alpha]];
    [root addArrangedSubview:[self demo10_url]];
    [root addArrangedSubview:[self demo11_tapAction]];
    [root addArrangedSubview:[self demo12_assignToPtr_then]];
    [root addArrangedSubview:[self demo13_layout]];
    [root addArrangedSubview:[self demo14_addTo_addToFull_addSubview]];
    [root addArrangedSubview:[self demo15_activeStyle]];
    [root addArrangedSubview:[self demo16_comprehensive]];
}

#pragma mark - Helper

- (ZLLabel *)sec:(NSString *)title {
    return ZLLab.txt(title).mediumFont(14).color(@"#333333");
}

- (UIImage *)imgWithColor:(UIColor *)color {
    CGSize size = CGSizeMake(80, 80);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)blueImg { return [self imgWithColor:[UIColor colorWithRed:0.26 green:0.56 blue:0.96 alpha:1]]; }
- (UIImage *)redImg { return [self imgWithColor:UIColor.redColor]; }
- (UIImage *)greenImg { return [self imgWithColor:[UIColor colorWithRed:0.30 green:0.78 blue:0.47 alpha:1]]; }
- (UIImage *)orangeImg { return [self imgWithColor:UIColor.orangeColor]; }
- (UIImage *)purpleImg { return [self imgWithColor:[UIColor colorWithRed:0.61 green:0.35 blue:0.85 alpha:1]]; }

- (UIImage *)wideImg {
    CGSize size = CGSizeMake(200, 80);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [[UIColor colorWithRed:0.26 green:0.56 blue:0.96 alpha:1] setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - Demo 01: img

- (UIView *)demo01_img {
    ZLStackView *sec = ZLStackView.vertical.alignStart.space(8);
    [sec addArrangedSubview:[self sec:@"1. img — 设置图片（UIImage / UIColor）"]];
    ZLStackView *row = ZLStackView.horizontal.alignCenter.space(12);
    [row addArrangedSubview:ZLImgView.img([self blueImg]).square(60)];
    [row addArrangedSubview:ZLImgView.img([self orangeImg]).square(60).corner(8)];
    [row addArrangedSubview:ZLImgView.img([self greenImg]).size(90, 60).corner(8)];
    [sec addArrangedSubview:row];
    return sec;
}

#pragma mark - Demo 02: hlImg + highlight

- (UIView *)demo02_hlImg_highlight {
    ZLStackView *sec = ZLStackView.vertical.alignStart.space(8);
    [sec addArrangedSubview:[self sec:@"2. hlImg + highlight — 高亮图片切换"]];
    ZLStackView *row = ZLStackView.horizontal.alignCenter.space(12);

    ZLImageView *iv1 = ZLImgView.img([self blueImg]).hlImg([self redImg]).square(60).corner(8);
    [row addArrangedSubview:iv1];

    [row addArrangedSubview:ZLImgView.img([self blueImg]).hlImg([self greenImg]).highlight(YES).square(60).corner(8)];

    __weak ZLImageView *w1 = iv1;
    [row addArrangedSubview:HButton.title(@"切换高亮").systemFont(13).titleColor(@"#FFF")
        .bgColor(@"#4A90D9").corner(14).insets(8, 16, 8, 16)
        .tapAction(^(ZLButton *b) { w1.highlighted = !w1.highlighted; })];
    [sec addArrangedSubview:row];
    return sec;
}

#pragma mark - Demo 03: mode / aspectFit / aspectFill

- (UIView *)demo03_mode {
    ZLStackView *sec = ZLStackView.vertical.alignStart.space(8);
    [sec addArrangedSubview:[self sec:@"3. mode / aspectFit / aspectFill"]];
    UIImage *wide = [self wideImg];
    ZLStackView *row = ZLStackView.horizontal.alignEnd.space(12);

    // ScaleToFill
    ZLStackView *c1 = ZLStackView.vertical.alignCenter.space(4);
    [c1 addArrangedSubview:ZLImgView.img(wide).mode(UIViewContentModeScaleToFill).size(60, 60).border(1, @"#DDD")];
    [c1 addArrangedSubview:ZLLab.txt(@"ScaleToFill").systemFont(10).color(@"#999")];
    [row addArrangedSubview:c1];

    // AspectFit
    ZLStackView *c2 = ZLStackView.vertical.alignCenter.space(4);
    [c2 addArrangedSubview:ZLImgView.img(wide).aspectFit.size(60, 60).border(1, @"#DDD")];
    [c2 addArrangedSubview:ZLLab.txt(@"AspectFit").systemFont(10).color(@"#999")];
    [row addArrangedSubview:c2];

    // AspectFill
    ZLStackView *c3 = ZLStackView.vertical.alignCenter.space(4);
    ZLImageView *fillIv = ZLImgView.img(wide).aspectFill.size(60, 60).border(1, @"#DDD");
    fillIv.clipsToBounds = YES;
    [c3 addArrangedSubview:fillIv];
    [c3 addArrangedSubview:ZLLab.txt(@"AspectFill").systemFont(10).color(@"#999")];
    [row addArrangedSubview:c3];

    // Center
    ZLStackView *c4 = ZLStackView.vertical.alignCenter.space(4);
    ZLImageView *centerIv = ZLImgView.img(wide).mode(UIViewContentModeCenter).size(60, 60).border(1, @"#DDD");
    centerIv.clipsToBounds = YES;
    [c4 addArrangedSubview:centerIv];
    [c4 addArrangedSubview:ZLLab.txt(@"Center").systemFont(10).color(@"#999")];
    [row addArrangedSubview:c4];

    [sec addArrangedSubview:row];
    return sec;
}

#pragma mark - Demo 04: corner

- (UIView *)demo04_corner {
    ZLStackView *sec = ZLStackView.vertical.alignStart.space(8);
    [sec addArrangedSubview:[self sec:@"4. corner — 统一圆角"]];
    ZLStackView *row = ZLStackView.horizontal.alignEnd.space(12);
    CGFloat radii[] = {0, 4, 8, 16, 30};
    for (int i = 0; i < 5; i++) {
        ZLStackView *col = ZLStackView.vertical.alignCenter.space(4);
        [col addArrangedSubview:ZLImgView.img([self blueImg]).corner(radii[i]).square(60)];
        [col addArrangedSubview:ZLLab.txt([NSString stringWithFormat:@"%.0f", radii[i]]).systemFont(10).color(@"#999")];
        [row addArrangedSubview:col];
    }
    [sec addArrangedSubview:row];
    return sec;
}

#pragma mark - Demo 05: corners

- (UIView *)demo05_corners {
    ZLStackView *sec = ZLStackView.vertical.alignStart.space(8);
    [sec addArrangedSubview:[self sec:@"5. corners(CACornerMask) — 指定角"]];
    ZLStackView *row = ZLStackView.horizontal.alignEnd.space(10);

    // 左上
    ZLStackView *col1 = ZLStackView.vertical.alignCenter.space(4);
    [col1 addArrangedSubview:ZLImgView.img([self blueImg]).corner(16).corners(kCALayerMinXMinYCorner).square(60)];
    [col1 addArrangedSubview:ZLLab.txt(@"左上").systemFont(10).color(@"#999")];
    [row addArrangedSubview:col1];

    // 右上
    ZLStackView *col2 = ZLStackView.vertical.alignCenter.space(4);
    [col2 addArrangedSubview:ZLImgView.img([self greenImg]).corner(16).corners(kCALayerMaxXMinYCorner).square(60)];
    [col2 addArrangedSubview:ZLLab.txt(@"右上").systemFont(10).color(@"#999")];
    [row addArrangedSubview:col2];

    // 下方两角
    ZLStackView *col3 = ZLStackView.vertical.alignCenter.space(4);
    [col3 addArrangedSubview:ZLImgView.img([self orangeImg]).corner(16).corners(kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner).square(60)];
    [col3 addArrangedSubview:ZLLab.txt(@"左下+右下").systemFont(10).color(@"#999")];
    [row addArrangedSubview:col3];

    // 上方两角
    ZLStackView *col4 = ZLStackView.vertical.alignCenter.space(4);
    [col4 addArrangedSubview:ZLImgView.img([self purpleImg]).corner(16).corners(kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner).square(60)];
    [col4 addArrangedSubview:ZLLab.txt(@"左上+右上").systemFont(10).color(@"#999")];
    [row addArrangedSubview:col4];

    [sec addArrangedSubview:row];
    return sec;
}

#pragma mark - Demo 06: circle

- (UIView *)demo06_circle {
    ZLStackView *sec = ZLStackView.vertical.alignStart.space(8);
    [sec addArrangedSubview:[self sec:@"6. circle — 圆形裁剪"]];
    ZLStackView *row = ZLStackView.horizontal.alignEnd.space(12);

    ZLStackView *c1 = ZLStackView.vertical.alignCenter.space(4);
    [c1 addArrangedSubview:ZLImgView.img([self blueImg]).circle(YES).square(60)];
    [c1 addArrangedSubview:ZLLab.txt(@"60×60").systemFont(10).color(@"#999")];
    [row addArrangedSubview:c1];

    ZLStackView *c2 = ZLStackView.vertical.alignCenter.space(4);
    [c2 addArrangedSubview:ZLImgView.img([self greenImg]).circle(YES).square(80)];
    [c2 addArrangedSubview:ZLLab.txt(@"80×80").systemFont(10).color(@"#999")];
    [row addArrangedSubview:c2];

    ZLStackView *c3 = ZLStackView.vertical.alignCenter.space(4);
    [c3 addArrangedSubview:ZLImgView.img([self orangeImg]).circle(YES).size(100, 50)];
    [c3 addArrangedSubview:ZLLab.txt(@"100×50 胶囊").systemFont(10).color(@"#999")];
    [row addArrangedSubview:c3];

    [sec addArrangedSubview:row];
    return sec;
}

#pragma mark - Demo 07: border

- (UIView *)demo07_border {
    ZLStackView *sec = ZLStackView.vertical.alignStart.space(8);
    [sec addArrangedSubview:[self sec:@"7. border — 边框"]];
    ZLStackView *row = ZLStackView.horizontal.alignEnd.space(12);

    ZLStackView *c1 = ZLStackView.vertical.alignCenter.space(4);
    [c1 addArrangedSubview:ZLImgView.img([self blueImg]).border(1, @"#4A90D9").square(60)];
    [c1 addArrangedSubview:ZLLab.txt(@"border(1)").systemFont(10).color(@"#999")];
    [row addArrangedSubview:c1];

    ZLStackView *c2 = ZLStackView.vertical.alignCenter.space(4);
    [c2 addArrangedSubview:ZLImgView.img([self greenImg]).border(3, UIColor.redColor).corner(12).square(60)];
    [c2 addArrangedSubview:ZLLab.txt(@"border(3)").systemFont(10).color(@"#999")];
    [row addArrangedSubview:c2];

    ZLStackView *c3 = ZLStackView.vertical.alignCenter.space(4);
    [c3 addArrangedSubview:ZLImgView.img([self purpleImg]).circle(YES).border(2, @"#FF6B6B").square(60)];
    [c3 addArrangedSubview:ZLLab.txt(@"circle+border").systemFont(10).color(@"#999")];
    [row addArrangedSubview:c3];

    [sec addArrangedSubview:row];
    return sec;
}

#pragma mark - Demo 08: bgColor

- (UIView *)demo08_bgColor {
    ZLStackView *sec = ZLStackView.vertical.alignStart.space(8);
    [sec addArrangedSubview:[self sec:@"8. bgColor — 背景色"]];
    ZLStackView *row = ZLStackView.horizontal.alignEnd.space(12);

    ZLStackView *c1 = ZLStackView.vertical.alignCenter.space(4);
    [c1 addArrangedSubview:ZLImgView.bgColor(UIColor.systemPinkColor).corner(8).square(60)];
    [c1 addArrangedSubview:ZLLab.txt(@"UIColor").systemFont(10).color(@"#999")];
    [row addArrangedSubview:c1];

    ZLStackView *c2 = ZLStackView.vertical.alignCenter.space(4);
    [c2 addArrangedSubview:ZLImgView.bgColor(@"#4A90D9").corner(8).square(60)];
    [c2 addArrangedSubview:ZLLab.txt(@"#hex").systemFont(10).color(@"#999")];
    [row addArrangedSubview:c2];

    ZLStackView *c3 = ZLStackView.vertical.alignCenter.space(4);
    [c3 addArrangedSubview:ZLImgView.bgColor(@"#E8F5E9").circle(YES).square(60)];
    [c3 addArrangedSubview:ZLLab.txt(@"占位头像").systemFont(10).color(@"#999")];
    [row addArrangedSubview:c3];

    [sec addArrangedSubview:row];
    return sec;
}

#pragma mark - Demo 09: visibility + alphaValue

- (UIView *)demo09_visibility_alpha {
    ZLStackView *sec = ZLStackView.vertical.alignStart.space(8);
    [sec addArrangedSubview:[self sec:@"9. visibility + alphaValue"]];
    ZLStackView *row = ZLStackView.horizontal.alignCenter.space(12);

    [row addArrangedSubview:ZLImgView.img([self blueImg]).square(50).corner(8)];

    ZLImageView *ivAlpha = ZLImgView.img([self blueImg]).alphaValue(0.3).square(50).corner(8);
    [row addArrangedSubview:ivAlpha];

    ZLImageView *ivHidden = ZLImgView.img([self redImg]).visibility(NO).square(50).corner(8);
    [row addArrangedSubview:ivHidden];

    __weak ZLImageView *wH = ivHidden;
    __weak ZLImageView *wA = ivAlpha;
    [row addArrangedSubview:HButton.title(@"显隐").systemFont(12).titleColor(@"#FFF")
        .bgColor(@"#4A90D9").corner(14).insets(8, 14, 8, 14)
        .tapAction(^(ZLButton *b) { wH.hidden = !wH.hidden; })];
    [row addArrangedSubview:HButton.title(@"透明度").systemFont(12).titleColor(@"#FFF")
        .bgColor(@"#52C41A").corner(14).insets(8, 14, 8, 14)
        .tapAction(^(ZLButton *b) { wA.alpha = wA.alpha < 0.5 ? 1.0 : 0.3; })];

    [sec addArrangedSubview:row];
    return sec;
}

#pragma mark - Demo 10: url

- (UIView *)demo10_url {
    ZLStackView *sec = ZLStackView.vertical.alignStart.space(8);
    [sec addArrangedSubview:[self sec:@"10. url — 网络图片（需 SDWebImage）"]];
    ZLStackView *row = ZLStackView.horizontal.alignCenter.space(12);
    [row addArrangedSubview:ZLImgView.url(@"https://gips3.baidu.com/it/u=3886271102,3123389489&fm=3028&app=3028&f=JPEG&fmt=auto?w=1280&h=960", [self blueImg]).size(90, 60).corner(8)];
    [row addArrangedSubview:ZLImgView.url(nil, [self greenImg]).size(90, 60).corner(8)];
    [sec addArrangedSubview:row];
    [sec addArrangedSubview:ZLLab.txt(@"⚠️ 内部调用 sd_setImageWithURL:，需集成 SDWebImage").systemFont(11).color(@"#FA8C16").lines(0)];
    return sec;
}

#pragma mark - Demo 11: tapAction

- (UIView *)demo11_tapAction {
    ZLStackView *sec = ZLStackView.vertical.alignStart.space(8);
    [sec addArrangedSubview:[self sec:@"11. tapAction — 点击事件"]];
    ZLStackView *row = ZLStackView.horizontal.alignCenter.space(12);

    __block NSInteger count = 0;
    ZLLabel *countLab = ZLLab.txt(@"点击: 0").systemFont(13).color(@"#333");
    [row addArrangedSubview:ZLImgView.img([self blueImg]).corner(12).square(70)
        .tapAction(^(ZLImageView *iv) {
            count++;
            countLab.text = [NSString stringWithFormat:@"点击: %ld", (long)count];
            iv.alpha = 0.5;
            [UIView animateWithDuration:0.2 animations:^{ iv.alpha = 1.0; }];
        })];
    [row addArrangedSubview:countLab];
    [row addArrangedSubview:ZLImgView.img([self greenImg]).corner(12).square(70)
        .tapAction(^(ZLImageView *iv) {
            static BOOL t = NO; t = !t;
            iv.image = t ? [self redImg] : [self greenImg];
        })];
    [sec addArrangedSubview:row];
    return sec;
}

#pragma mark - Demo 12: assignToPtr + then

- (UIView *)demo12_assignToPtr_then {
    ZLStackView *sec = ZLStackView.vertical.alignStart.space(8);
    [sec addArrangedSubview:[self sec:@"12. assignToPtr + then"]];

    ZLStackView *row = ZLStackView.horizontal.alignCenter.space(12);
    ZLImageView *ref = nil;
    ZLImgView.img([self purpleImg]).corner(12).square(60).assignToPtr(&ref);
    if (ref) {
        [row addArrangedSubview:ref];
        [row addArrangedSubview:ZLLab.txt(@"✅ assignToPtr OK").systemFont(12).color(@"#52C41A")];
    }
    [sec addArrangedSubview:row];

    ZLStackView *row2 = ZLStackView.horizontal.alignCenter.space(12);
    [row2 addArrangedSubview:ZLImgView.img([self blueImg]).square(60).then(^(ZLImageView *v) {
        v.layer.cornerRadius = 30;
        v.layer.masksToBounds = YES;
        v.layer.borderWidth = 3;
        v.layer.borderColor = [UIColor colorWithRed:0.26 green:0.56 blue:0.96 alpha:1].CGColor;
    })];
    [row2 addArrangedSubview:ZLLab.txt(@"then{} 配置 border").systemFont(12).color(@"#666")];
    [sec addArrangedSubview:row2];
    return sec;
}

#pragma mark - Demo 13: 布局属性

- (UIView *)demo13_layout {
    ZLStackView *sec = ZLStackView.vertical.alignStart.space(8);
    [sec addArrangedSubview:[self sec:@"13. 布局 — square/size/width/height"]];
    ZLStackView *row = ZLStackView.horizontal.alignEnd.space(10);

    ZLStackView *c1 = ZLStackView.vertical.alignCenter.space(4);
    [c1 addArrangedSubview:ZLImgView.bgColor(@"#4A90D9").corner(4).square(40)];
    [c1 addArrangedSubview:ZLLab.txt(@"square(40)").systemFont(10).color(@"#999")];
    [row addArrangedSubview:c1];

    ZLStackView *c2 = ZLStackView.vertical.alignCenter.space(4);
    [c2 addArrangedSubview:ZLImgView.bgColor(@"#52C41A").corner(4).size(80, 40)];
    [c2 addArrangedSubview:ZLLab.txt(@"size(80,40)").systemFont(10).color(@"#999")];
    [row addArrangedSubview:c2];

    ZLStackView *c3 = ZLStackView.vertical.alignCenter.space(4);
    [c3 addArrangedSubview:ZLImgView.bgColor(@"#FF6B6B").corner(4).width(60).height(30)];
    [c3 addArrangedSubview:ZLLab.txt(@"w(60)h(30)").systemFont(10).color(@"#999")];
    [row addArrangedSubview:c3];

    [sec addArrangedSubview:row];
    return sec;
}

#pragma mark - Demo 14: addTo / addToFull / addSubview

- (UIView *)demo14_addTo_addToFull_addSubview {
    ZLStackView *sec = ZLStackView.vertical.alignStart.space(8);
    [sec addArrangedSubview:[self sec:@"14. addTo / addToFull / addSubview"]];
    ZLStackView *row = ZLStackView.horizontal.alignEnd.space(10);

    UIView *p1 = UIView.new;
    p1.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    p1.zl_layout.size(80, 60);
    ZLImgView.bgColor(@"#4A90D9").corner(8).addTo(p1).square(40).centerOffset(0, 0);
    ZLStackView *c1 = ZLStackView.vertical.alignCenter.space(4);
    [c1 addArrangedSubview:p1];
    [c1 addArrangedSubview:ZLLab.txt(@"addTo").systemFont(10).color(@"#999")];
    [row addArrangedSubview:c1];

    UIView *p2 = UIView.new;
    p2.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    p2.zl_layout.size(80, 60);
    ZLImgView.bgColor(@"#52C41A").corner(8).addToFull(p2);
    ZLStackView *c2 = ZLStackView.vertical.alignCenter.space(4);
    [c2 addArrangedSubview:p2];
    [c2 addArrangedSubview:ZLLab.txt(@"addToFull").systemFont(10).color(@"#999")];
    [row addArrangedSubview:c2];

    [sec addArrangedSubview:row];
    return sec;
}

#pragma mark - Demo 15: activeStyle / inactiveStyle

- (UIView *)demo15_activeStyle {
    ZLStackView *sec = ZLStackView.vertical.alignStart.space(8);
    [sec addArrangedSubview:[self sec:@"15. activeStyle / inactiveStyle"]];
    ZLStackView *row = ZLStackView.horizontal.alignCenter.space(12);

    ZLImageView *iv = ZLImgView.img([self blueImg]).corner(12).square(70)
        .activeStyle(^(ZLImageView *v) {
            v.alpha = 1.0;
            v.layer.borderWidth = 2;
            v.layer.borderColor = [UIColor colorWithRed:0.26 green:0.56 blue:0.96 alpha:1].CGColor;
        })
        .inactiveStyle(^(ZLImageView *v) {
            v.alpha = 0.4;
            v.layer.borderWidth = 1;
            v.layer.borderColor = UIColor.lightGrayColor.CGColor;
        });
    [row addArrangedSubview:iv];

    __weak ZLImageView *wIv = iv;
    [row addArrangedSubview:HButton.title(@"切换Active").systemFont(12).titleColor(@"#FFF")
        .bgColor(@"#FA541C").corner(14).insets(8, 14, 8, 14)
        .tapAction(^(ZLButton *b) {
            wIv.userActive(!wIv.userInteractionEnabled);
        })];

    [sec addArrangedSubview:row];
    return sec;
}

#pragma mark - Demo 16: 综合实战

- (UIView *)demo16_comprehensive {
    ZLStackView *sec = ZLStackView.vertical.alignFill.space(8);
    [sec addArrangedSubview:[self sec:@"16. 综合 — 用户卡片 / 图片墙 / 头像组"]];

    // 用户卡片
    ZLStackView *card = ZLStackView.horizontal.alignCenter.space(12)
        .bgColor(@"#FFFFFF").corner(12).border(1, @"#E8E8E8").inset(16, 16, 16, 16);
    [card addArrangedSubview:ZLImgView.img([self purpleImg]).circle(YES).border(2, @"#4A90D9").square(56)];
    ZLStackView *info = ZLStackView.vertical.alignStart.space(4);
    [info addArrangedSubview:ZLLab.txt(@"张三").mediumFont(16).color(@"#333")];
    [info addArrangedSubview:ZLLab.txt(@"iOS 工程师 · 深圳").systemFont(13).color(@"#999")];
    [card addArrangedSubview:info];
    [sec addArrangedSubview:card];

    // 图片墙
    ZLStackView *wall = ZLStackView.horizontal.justifyFill.alignFill.space(6);
    for (NSString *hex in @[@"#4A90D9", @"#52C41A", @"#FA541C", @"#722ED1"]) {
        ZLImageView *iv = ZLImgView.bgColor(hex).corner(8);
        iv.zl_layout.height(80);
        [wall addArrangedSubview:iv];
    }
    [sec addArrangedSubview:wall];

    // 头像叠层组
    ZLStackView *avatarRow = ZLStackView.horizontal.alignCenter.space(-10);
    for (NSString *hex in @[@"#4A90D9", @"#52C41A", @"#FA541C", @"#722ED1", @"#EB2F96"]) {
        [avatarRow addArrangedSubview:ZLImgView.bgColor(hex).circle(YES).border(2, @"#FFFFFF").square(36)];
    }
    [sec addArrangedSubview:ZLStackView.horizontal.alignCenter.space(8)
        .addView(ZLLab.txt(@"参与者:").systemFont(13).color(@"#666"))
        .addView(avatarRow)];

    return sec;
}

@end
