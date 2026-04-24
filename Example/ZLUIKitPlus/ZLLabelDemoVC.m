#import "ZLLabelDemoVC.h"
#import <ZLUIKitPlus/ZLUIKitPlus.h>

@implementation ZLLabelDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZLLabel Demo";
    self.view.backgroundColor = UIColor.whiteColor;
    
    CGFloat y = 100;
    
    // 1. 基础文本 + 字体颜色
    {
        ZLLabel *lab = ZLLab;
        lab.txt(@"1. 基础文本 systemFont(16)").systemFont(16).color(@"#333333");
        [self.view addSubview:lab];
        lab.KFC.top(y).leading(20);
        y += 40;
    }
    
    // 2. mediumFont + 颜色hex
    {
        ZLLabel *lab = ZLLab;
        lab.txt(@"2. mediumFont(18) + 颜色").mediumFontColor(18, @"#FF5722");
        [self.view addSubview:lab];
        lab.KFC.top(y).leading(20);
        y += 40;
    }
    
    // 3. semiboldFont + boldFont
    {
        ZLLabel *lab = ZLLab;
        lab.txt(@"3. semiboldFont(20)").semiboldFont(20).color(@"#4A90D9");
        [self.view addSubview:lab];
        lab.KFC.top(y).leading(20);
        y += 40;
        
        ZLLabel *lab2 = ZLLab;
        lab2.txt(@"   boldFont(20)").boldFont(20).color(@"#4CAF50");
        [self.view addSubview:lab2];
        lab2.KFC.top(y).leading(20);
        y += 40;
    }
    
    // 4. 内边距(insets)
    {
        ZLLabel *lab = ZLLab;
        lab.txt(@"4. 内边距 insets(8,16,8,16)").systemFont(14).color(@"#333333")
            .insets(8, 16, 8, 16).bgColor(@"#E3F2FD").corner(8);
        [self.view addSubview:lab];
        lab.KFC.top(y).leading(20);
        y += 50;
    }
    
    // 5. 多行文字
    {
        ZLLabel *lab = ZLLab;
        lab.txt(@"5. 多行文字演示，设置lines(0)和txtMaxWidth限制宽度，文本会自动换行显示，这是一段较长的测试文本。")
            .systemFont(14).color(@"#666666").lines(0)
            .txtMaxWidth(UIScreen.mainScreen.bounds.size.width - 40);
        [self.view addSubview:lab];
        lab.KFC.top(y).leading(20);
        y += 70;
    }
    
    // 6. 高亮文本切换
    {
        ZLLabel *lab = ZLLab;
        lab.txt(@"6. 点击切换高亮").hlTxt(@"高亮状态文本").systemFont(15)
            .color(@"#333333").hlColor(@"#FF5722")
            .bgColor(@"#FFF9C4").insets(8, 16, 8, 16).corner(6)
            .tapAction(^(ZLLabel *l) {
                l.highlight(!l.isHighlighted);
            });
        [self.view addSubview:lab];
        lab.KFC.top(y).leading(20);
        y += 50;
    }
    
    // 7. 圆角 + 边框 + 阴影
    {
        ZLLabel *lab = ZLLab;
        lab.txt(@"7. 边框+阴影").mediumFont(14).color(@"#333333")
            .insets(10, 20, 10, 20).corner(12)
            .border(1, @"#4A90D9").bgColor(UIColor.whiteColor)
            .shColor(@"#000000").shOffset(0, 2).shOpacity(0.15).shRadius(6)
            .masksToBounds(NO);
        [self.view addSubview:lab];
        lab.KFC.top(y).leading(20);
        y += 60;
    }
    
    // 8. 圆形标签
    {
        ZLLabel *lab = ZLLab;
        lab.txt(@"8").boldFont(14).color(UIColor.whiteColor)
            .bgColor(@"#FF5722").circle(YES);
        [self.view addSubview:lab];
        lab.KFC.top(y).leading(20).size(32, 32);
        
        ZLLabel *desc = ZLLab;
        desc.txt(@"← 圆形标签 circle(YES)").systemFont(13).color(@"#999999");
        [self.view addSubview:desc];
        desc.KFC.top(y + 6).leading(60);
        y += 50;
    }
    
    // 9. 属性文本
    {
        ZLLabel *lab = ZLLab;
        lab.attributeTxtBK(^NSAttributedString *(ZLLabel *l) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"9. 属性文本: " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
            [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"红色加粗" attributes:@{
                NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
                NSForegroundColorAttributeName: UIColor.redColor
            }]];
            [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@" + 蓝色" attributes:@{
                NSFontAttributeName: [UIFont systemFontOfSize:14],
                NSForegroundColorAttributeName: UIColor.blueColor
            }]];
            return attr;
        });
        [self.view addSubview:lab];
        lab.KFC.top(y).leading(20);
        y += 40;
    }
    
    // 10. 4方向不同圆角
    {
        ZLLabel *lab = ZLLab;
        lab.txt(@"10. 不同方向圆角").systemFont(14).color(UIColor.whiteColor)
            .insets(10, 16, 10, 16).bgColor(@"#9C27B0")
            .cornerRadii(16, 0, 0, 16);
        [self.view addSubview:lab];
        lab.KFC.top(y).leading(20);
        y += 50;
    }
}

@end
