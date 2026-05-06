#import "ZLButtonDemoVC.h"
#import <ZLUIKitPlus/ZLUIKitPlus.h>
#import <Masonry/Masonry.h>
@implementation ZLButtonDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZLButton Demo";
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    [self.view addSubview:scroll];
    scroll.KFC.edge(0, 0, 0, 0);
    
    UIView *content = UIView.new;
    [scroll addSubview:content];
    content.KFC.edgesZero().width(UIScreen.mainScreen.bounds.size.width);
    
    CGFloat y = 20;
    
    // 1. 基础水平按钮（图片+文字）
    {
        UILabel *tip = [self tipLabel:@"1. 水平按钮(图左文右)" y:y];
        [content addSubview:tip];
        y += 30;
        
        ZLButton *btn = ZLBtnH;
        btn.image(@"魔法棒")
            .title(@"水平按钮")
            .systemFont(15)
            .titleFirst
            .alignCenter
            .titleColor(@"#333333")
            .spacing(8)
            .flexSpacing
            .inset(20, 16, 20, 16)
//            .inset(0, 0, 0, 0)

            .corner(8)
            .bgColor(UIColor.orangeColor)
            .shColor(UIColor.redColor)
            .addSubview(btn.zl_lab
                        .z_square(4)
                        .bgColor(UIColor.redColor)
                        .z_top(10)
                        .z_trailing(10)
                        .circle(YES))
            .touchAction(^(ZLButton *b) {
                NSLog(@"水平按钮点击");
            });
        [content addSubview:btn];
        btn.KFC.top(y).leading(20);
        y += 60;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            btn.spacing(30).inset(10, 10, 10, 10);
        });
    }
    return;
    // 2. 垂直按钮（图上文下）
    {
        UILabel *tip = [self tipLabel:@"2. 垂直按钮(图上文下)" y:y];
        [content addSubview:tip];
        y += 30;
        
        ZLButton *btn = ZLBtnV;
        btn.image(@"魔法棒").imageSize(40, 40).title(@"垂直按钮").systemFont(13)
            .titleColor(@"#666666").spacing(6).inset(12, 16, 12, 16)
            .corner(12).bgColor(@"#E8F5E9");
        [content addSubview:btn];
        btn.KFC.top(y).leading(20);
        y += 100;
    }
    
    // 3. 文字在前（titleFirst）
    {
        UILabel *tip = [self tipLabel:@"3. 文字在前(titleFirst)" y:y];
        [content addSubview:tip];
        y += 30;
        
        ZLButton *btn = ZLBtnH.titleFirst;
        btn.title(@"文字在前")
            .image(@"赞")
            .titleFirst
            .mediumFont(15)
            .titleColor(UIColor.whiteColor)
            .spacing(6)
            .inset(15, 25, 15, 25)
            .corner(20)
            .bgColor(@"#4A90D9");
        [content addSubview:btn];
        btn.KFC.top(y).leading(20);
        y += 60;
    }
    
    // 4. 弹性间距（flexSpacing）
    {
        UILabel *tip = [self tipLabel:@"4. 弹性间距(flexSpacing)" y:y];
        [content addSubview:tip];
        y += 30;
        
        ZLButton *btn = ZLBtnH.flexSpacing;
        btn.image(@"分享").title(@"弹性间距").systemFont(15).titleColor(@"#333333")
            .inset(10, 16, 10, 16).bgColor(@"#FFF3E0").corner(8);
        [content addSubview:btn];
        btn.KFC.top(y).leading(20).trailing(20);
        btn.z_height(44);
        y += 60;
    }
    
    // 5. 固定图片大小 + 选中状态
    {
        UILabel *tip = [self tipLabel:@"5. 选中状态切换" y:y];
        [content addSubview:tip];
        y += 30;
        
        ZLButton *btn = ZLBtnH;
        btn.image(@"赞").selectImage(@"魔法棒").title(@"点击选中").selectTitle(@"已选中")
            .titleColor(@"#999999").selectTitleColor(@"#FF5722")
            .imageSize(24, 24).systemFont(14).spacing(6)
            .inset(8, 16, 8, 16).corner(8).bgColor(@"#FAFAFA")
            .border(1, @"#E0E0E0")
            .touchAction(^(ZLButton *b) {
                b.select(!b.isSelected);
            });
        [content addSubview:btn];
        btn.KFC.top(y).leading(20);
        y += 60;
    }
    
    // 6. 防抖 + 阴影
    {
        UILabel *tip = [self tipLabel:@"6. 防抖2秒 + 阴影" y:y];
        [content addSubview:tip];
        y += 30;
        
        ZLButton *btn = ZLBtnH;
        btn.title(@"防抖按钮").semiboldFont(16).titleColor(UIColor.whiteColor)
            .inset(12, 24, 12, 24).corner(22).bgColor(@"#FF5722")
            .debounce(2.0)
            .shColor(@"#FF5722").shOffset(0, 4).shOpacity(0.3).shRadius(8)
            .masksToBounds(NO)
            .touchAction(^(ZLButton *b) {
                NSLog(@"防抖按钮点击");
            });
        [content addSubview:btn];
        btn.KFC.top(y).leading(20);
        y += 70;
    }
    
    // 7. userActive/inactiveStyle
    {
        UILabel *tip = [self tipLabel:@"7. 可用/不可用样式" y:y];
        [content addSubview:tip];
        y += 30;
        
        __block ZLButton *ref;
        ZLButton *btn = ZLBtnH;
        btn.toPtr(&ref).title(@"不可用状态").systemFont(15)
            .inset(10, 20, 10, 20).corner(8)
            .activeStyle(^(ZLButton *b) {
                b.bgColor(@"#4CAF50").titleColor(UIColor.whiteColor);
                b.layoutTitle = @"可用状态";
            })
            .inactiveStyle(^(ZLButton *b) {
                b.bgColor(@"#E0E0E0").titleColor(@"#999999");
                b.layoutTitle = @"不可用状态";
            })
            .userActive(NO);
        [content addSubview:btn];
        btn.KFC.top(y).leading(20);
        
        // 切换按钮
        ZLButton *toggleBtn = ZLBtnH;
        toggleBtn.title(@"切换").systemFont(13).titleColor(@"#4A90D9")
            .inset(8, 12, 8, 12).corner(6).border(1, @"#4A90D9")
            .touchAction(^(ZLButton *b) {
                ref.userActive(!ref.isUserInteractionEnabled);
            });
        [content addSubview:toggleBtn];
        toggleBtn.KFC.top(y).leading(200);
        y += 60;
    }
    
    // 8. 圆形按钮
    {
        UILabel *tip = [self tipLabel:@"8. 圆形按钮" y:y];
        [content addSubview:tip];
        y += 30;
        
        ZLButton *btn = ZLBtnV;
        btn.image(@"分享").imageSize(24, 24).bgColor(@"#E3F2FD")
            .circle(YES).z_square(60);
        [content addSubview:btn];
        btn.KFC.top(y).leading(20);
        y += 80;
    }
    
    // 9. 背景图片
    {
        UILabel *tip = [self tipLabel:@"9. 背景图片" y:y];
        [content addSubview:tip];
        y += 30;
        
        ZLButton *btn = ZLBtnH;
        btn.bgImage(@"猫狗通用-分离焦虑").bgImageAspectFill
            .title(@"背景图片按钮").boldFont(16).titleColor(UIColor.whiteColor)
            .inset(12, 20, 12, 20).corner(8).masksToBounds(YES);
        [content addSubview:btn];
        btn.KFC.top(y).leading(20);
        btn.z_size(200, 60);
        y += 80;
    }
    
    // 10. 扩大点击区域 + imageTouchOnly
    {
        UILabel *tip = [self tipLabel:@"10. 扩大点击区域" y:y];
        [content addSubview:tip];
        y += 30;
        
        ZLButton *btn = ZLBtnH;
        btn.image(@"赞").imageSize(20, 20).title(@"扩大点击").systemFont(13)
            .titleColor(@"#333333").spacing(4).bgColor(@"#FFF9C4").corner(6)
            .inset(6, 12, 6, 12)
            .touchAreaEdge(10, 10, 10, 10)
            .touchAction(^(ZLButton *b) {
                NSLog(@"扩大区域被点击");
            });
        [content addSubview:btn];
        btn.KFC.top(y).leading(20);
        y += 60;
    }
    
    // 底部留白
    UIView *spacer = UIView.new;
    [content addSubview:spacer];
    spacer.KFC.top(y).leading(0).size(1, 40);
    
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(spacer.mas_bottom);
    }];
}

- (UILabel *)tipLabel:(NSString *)text y:(CGFloat)y {
    ZLLabel *lab = ZLLab;
    lab.txt(text).systemFont(13).color(@"#999999");
    lab.KFC.top(y).leading(20);
    return lab;
}

@end
