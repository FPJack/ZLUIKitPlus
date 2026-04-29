#import "ZLPairViewDemoVC.h"
//#import <ZLUIKitPlus/ZLUIKitPlus.h>
#import <Masonry/Masonry.h>
#import "ZLStackView.h"
@interface SwitchA: UISwitch
@end
@implementation SwitchA

- (NSLayoutXAxisAnchor *)leadingAnchor {
    return [super leadingAnchor];
}

@end
@interface SwitchB: UISwitch
@end
@implementation SwitchB

- (NSLayoutXAxisAnchor *)leadingAnchor {
    return [super leadingAnchor];
}

@end
@interface TestStackView: UIStackView
@end
@implementation TestStackView

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"TestStackView --layoutSubviews");
}
- (void)updateConstraints {
    [super updateConstraints];
    NSLog(@"TestStackView --updateConstraints");
}

@end
@implementation ZLPairViewDemoVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    {
//        UIStackView *stackView = TestStackView.new;
//        [stackView addArrangedSubview:UISwitch.new];
//        [stackView addArrangedSubview:UISwitch.new];
//        [stackView addArrangedSubview:UISwitch.new];
//        [self.view addSubview:stackView];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            stackView.arrangedSubviews.firstObject.hidden = YES;   stackView.arrangedSubviews.firstObject.hidden = NO;
//            stackView.arrangedSubviews.firstObject.hidden = YES;
//            stackView.arrangedSubviews.firstObject.hidden = NO;
//
//
//        });
//        [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
//           make.center.mas_equalTo(self.view);
//        }];
    }
   

   
    self.view.backgroundColor = UIColor.orangeColor;
    
//    {
//        UIView *view = UIView.new;
//        view.backgroundColor = UIColor.blueColor;
//        UISwitch *sw = UISwitch.new;
//        [view addSubview:sw];
//        [sw mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(0);
//        }];
//        [self.view addSubview:view];
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.mas_equalTo(0);
//        }];
//        return;
//    }
    
    ZLStackView *stackView = [ZLStackView new];
    stackView.horizontal = YES;
    stackView.backgroundColor = UIColor.redColor;
    [self.view addSubview:stackView];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
//        make.height.mas_equalTo(200);
//        make.width.mas_equalTo(300);

    }];
    UILabel *label = UILabel.new;
    label.text = @"dddd";
    label.backgroundColor = UIColor.blueColor;
    [stackView addArrangedSubview:label];
    [stackView setCustomSpacing:20 afterView:label];
    [stackView setCustomAlignmentStartSpacing:20 forView:label];
    [stackView setCustomAlignmentEndSpacing:40 forView:label];
    [stackView setCustomAlignment:ZLAlignEnd forView:label];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       // label.text = @"adfdsafdsfasdffadsf";
    });
    stackView.alignment = ZLAlignCenter;
    stackView.justify = ZlJustifyFill;
    stackView.spacing = 10;
    
    [stackView addArrangedSubview:SwitchA.new];
    
    {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//        [btn setTitle:@"" forState:UIControlStateNormal];
//        [btn setBackgroundColor:UIColor.greenColor];
//        [stackView addArrangedSubview:btn];
        
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        label.hidden = YES;
        
//        stackView.horizontal = YES;
//        stackView.alignment = ZLAlignStart;
//        stackView.justify = ZlJustifySpaceEvenly;
    });
//    [stackView addArrandgeView:UIButton.new];

    
    
   
    {
        UIStackView *stackView = [[UIStackView alloc] init];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.alignment = UIStackViewAlignmentFill;
        stackView.distribution = UIStackViewDistributionFill;
        stackView.spacing = 10;
        stackView.backgroundColor = UIColor.greenColor;
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.view addSubview:stackView];
//        UILabel *label = UILabel.new;
//        label.text = @"dasdfddasdfddasdfddasdfddasdfddasdfddasdfddasdfddasdfddasdfddasdfddasdfddasdfddasdfddasdfd";
//        label.backgroundColor = UIColor.orangeColor;
//        [stackView addArrangedSubview:label];
//        [stackView addArrangedSubview:UISwitch.new];
//        [stackView addArrangedSubview:UISwitch.new];
//        
//        [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.mas_equalTo(self.view);
//            make.height.mas_equalTo(200);
//            make.width.mas_equalTo(300);
//        }];
    }
    
}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.title = @"ZLPairView Demo";
//    self.view.backgroundColor = UIColor.whiteColor;
//    
//    UIScrollView *scroll = UIScrollView.new;
//    [self.view addSubview:scroll];
//    scroll.KFC.edge(0, 0, 0, 0);
//    
//    UIView *content = UIView.new;
//    [scroll addSubview:content];
//    content.KFC.edgesZero().width(UIScreen.mainScreen.bounds.size.width);
//    
//    CGFloat y = 20;
//    
//    // 1. ZLPairLabelView 水平(两个Label)
//    {
//        ZLLabel *tip = ZLLab;
//        tip.txt(@"1. PairLabelView 水平(两个Label)").systemFont(13).color(@"#999999");
//        [content addSubview:tip];
//        tip.KFC.top(y).leading(20);
//        y += 25;
//        
//        ZLPairLabelView *pair = ZLPairLabelView.new;
//        pair.horizontal(YES).spacing(10).align(ZLAlignCenter)
//            .insets(10, 16, 10, 16).corner(8)
//            .thenFirst(^(ZLLabel *first) {
//                first.txt(@"标题:").boldFont(15).color(@"#333333");
//            })
//            .thenSecond(^(ZLLabel *second) {
//                second.txt(@"这是内容文本").systemFont(14).color(@"#666666");
//            });
//        pair.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
//        [content addSubview:pair];
//        pair.KFC.top(y).leading(20);
//        y += 60;
//    }
//    
//    // 2. ZLPairLabelView 垂直
//    {
//        ZLLabel *tip = ZLLab;
//        tip.txt(@"2. PairLabelView 垂直").systemFont(13).color(@"#999999");
//        [content addSubview:tip];
//        tip.KFC.top(y).leading(20);
//        y += 25;
//        
//        ZLPairLabelView *pair = ZLPairLabelView.new;
//        pair.horizontal(NO).spacing(6).align(ZLAlignCenter)
//            .insets(12, 20, 12, 20).corner(12)
//            .thenFirst(^(ZLLabel *first) {
//                first.txt(@"99").boldFont(24).color(@"#FF5722");
//            })
//            .thenSecond(^(ZLLabel *second) {
//                second.txt(@"积分").systemFont(12).color(@"#999999");
//            });
//        pair.backgroundColor = [UIColor colorWithRed:1.0 green:0.95 blue:0.9 alpha:1];
//        [content addSubview:pair];
//        pair.KFC.top(y).leading(20);
//        y += 90;
//    }
//    
//    // 3. ZLPairImgLabelView (图片+文字)
//    {
//        ZLLabel *tip = ZLLab;
//        tip.txt(@"3. PairImgLabelView(图+文)").systemFont(13).color(@"#999999");
//        [content addSubview:tip];
//        tip.KFC.top(y).leading(20);
//        y += 25;
//        
//        ZLPairImgLabelView *pair = ZLPairImgLabelView.new;
//        pair.horizontal(YES).spacing(10).align(ZLAlignCenter)
//            .insets(10, 16, 10, 16).corner(8)
//            .thenFirst(^(ZLImageView *imgView) {
//                imgView.img(@"赞").aspectFit;
//                imgView.KFC.square(30);
//            })
//            .thenSecond(^(ZLLabel *label) {
//                label.txt(@"点赞 128").mediumFont(15).color(@"#333333");
//            });
//        pair.backgroundColor = [UIColor colorWithRed:0.93 green:0.96 blue:1.0 alpha:1];
//        [content addSubview:pair];
//        pair.KFC.top(y).leading(20);
//        y += 65;
//    }
//    
//    // 4. ZLPairImgLabelView 垂直（图上文下）
//    {
//        ZLLabel *tip = ZLLab;
//        tip.txt(@"4. PairImgLabelView 垂直(图上文下)").systemFont(13).color(@"#999999");
//        [content addSubview:tip];
//        tip.KFC.top(y).leading(20);
//        y += 25;
//        
//        ZLPairImgLabelView *pair = ZLPairImgLabelView.new;
//        pair.horizontal(NO).spacing(8).align(ZLAlignCenter)
//            .insets(16, 20, 16, 20).corner(12)
//            .thenFirst(^(ZLImageView *imgView) {
//                imgView.img(@"魔法棒").aspectFit;
//                imgView.KFC.square(48);
//            })
//            .thenSecond(^(ZLLabel *label) {
//                label.txt(@"魔法棒").systemFont(13).color(@"#666666");
//            });
//        pair.backgroundColor = [UIColor colorWithRed:0.9 green:1.0 blue:0.9 alpha:1];
//        [content addSubview:pair];
//        pair.KFC.top(y).leading(20);
//        y += 110;
//    }
//    
//    // 5. ZLPairButtonView (两个按钮)
//    {
//        ZLLabel *tip = ZLLab;
//        tip.txt(@"5. PairButtonView(两个按钮)").systemFont(13).color(@"#999999");
//        [content addSubview:tip];
//        tip.KFC.top(y).leading(20);
//        y += 25;
//        
//        ZLPairButtonView *pair = ZLPairButtonView.new;
//        
//        pair.horizontal(YES).spacing(12).align(ZLAlignCenter)
//            .thenFirst(^(ZLButton *btn) {
//                btn.title(@"取消").systemFont(15).titleColor(@"#666666")
//                    .inset(8, 24, 8, 24).corner(8).bgColor(@"#F0F0F0");
//            })
//            .thenSecond(^(ZLButton *btn) {
//                btn.title(@"确定").systemFont(15).titleColor(UIColor.whiteColor)
//                    .inset(8, 24, 8, 24).corner(8).bgColor(@"#4A90D9");
//            });
//        [content addSubview:pair];
//        pair.KFC.top(y).leading(20);
//        y += 60;
//    }
//    
//    // 6. ZLPairImageView (两张图片)
//    {
//        ZLLabel *tip = ZLLab;
//        tip.txt(@"6. PairImageView(两张图片)").systemFont(13).color(@"#999999");
//        [content addSubview:tip];
//        tip.KFC.top(y).leading(20);
//        y += 25;
//        
//        ZLPairImageView *pair = ZLPairImageView.new;
//        pair.horizontal(YES).spacing(12).align(ZLAlignCenter)
//            .thenFirst(^(ZLImageView *img) {
//                img.img(@"分享").aspectFit.corner(8).bgColor(@"#E3F2FD");
//                img.KFC.square(60);
//            })
//            .thenSecond(^(ZLImageView *img) {
//                img.img(@"猫狗通用-分离焦虑").aspectFill.circle(YES);
//                img.KFC.square(60);
//            });
//        [content addSubview:pair];
//        pair.KFC.top(y).leading(20);
//        y += 80;
//    }
//    
//    // 7. fill + flexibleSpacing
//    {
//        ZLLabel *tip = ZLLab;
//        tip.txt(@"7. fill+flexibleSpacing(撑满)").systemFont(13).color(@"#999999");
//        [content addSubview:tip];
//        tip.KFC.top(y).leading(20);
//        y += 25;
//        
//        ZLPairLabelView *pair = ZLPairLabelView.new;
//        pair.horizontal(YES).spacing(10).hJustify(ZlJustifyFill).flexibleSpacing(YES)
//            .insets(10, 16, 10, 16).corner(8)
//            .thenFirst(^(ZLLabel *first) {
//                first.txt(@"左侧标题").mediumFont(15).color(@"#333333");
//            })
//            .thenSecond(^(ZLLabel *second) {
//                second.txt(@"右侧内容").systemFont(14).color(@"#999999");
//                second.textAlignment = NSTextAlignmentRight;
//            });
//        pair.backgroundColor = [UIColor colorWithRed:1.0 green:0.98 blue:0.9 alpha:1];
//        [content addSubview:pair];
//        pair.KFC.top(y).leading(20).trailing(20);
//        y += 60;
//    }
//    
//    // 8. tapAction
//    {
//        ZLLabel *tip = ZLLab;
//        tip.txt(@"8. tapAction(点击事件)").systemFont(13).color(@"#999999");
//        [content addSubview:tip];
//        tip.KFC.top(y).leading(20);
//        y += 25;
//        
//        ZLPairImgLabelView *pair = ZLPairImgLabelView.new;
//        pair.horizontal(YES).spacing(8).align(ZLAlignCenter)
//            .insets(10, 16, 10, 16).corner(8)
//            .thenFirst(^(ZLImageView *img) {
//                img.img(@"分享").aspectFit;
//                img.KFC.square(24);
//            })
//            .thenSecond(^(ZLLabel *lab) {
//                lab.txt(@"点击分享").mediumFont(14).color(@"#4A90D9");
//            })
//            .tapAction(^(UIView *view) {
//                NSLog(@"分享被点击");
//            });
//        
//        pair.backgroundColor = [UIColor colorWithRed:0.93 green:0.96 blue:1.0 alpha:1];
//        [content addSubview:pair];
//        pair.KFC.top(y).leading(20);
//        y += 60;
//    }
//    
//    // 底部留白
//    UIView *spacer = UIView.new;
//    [content addSubview:spacer];
//    spacer.KFC.top(y).leading(0).size(1, 40);
//    [content mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(spacer.mas_bottom);
//    }];
//}

@end
