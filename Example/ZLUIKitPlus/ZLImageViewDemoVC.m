#import "ZLImageViewDemoVC.h"
#import <ZLUIKitPlus/ZLUIKitPlus.h>

@implementation ZLImageViewDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZLImageView Demo";
    self.view.backgroundColor = UIColor.whiteColor;
    
    CGFloat y = 100;
    
    // 1. 基础图片 + 链式设置
    {
        ZLLabel *tip = ZLLab;
        tip.txt(@"1. 基础图片").systemFont(13).color(@"#999999");
        [self.view addSubview:tip];
        tip.KFC.top(y).leading(20);
        y += 25;
        
        ZLImageView *imgView = ZLImageView.new;
        imgView
        .img(@"魔法棒")
        .aspectFit
        .addTo(self.view)
        .z_top(120)
        .z_leading(20)
        .z_square(80);
        y += 100;
    }
    
    // 2. 圆形图片
    {
        ZLLabel *tip = ZLLab;
        tip.txt(@"2. 圆形图片").systemFont(13).color(@"#999999");
        [self.view addSubview:tip];
        tip.KFC.top(y).leading(20);
        y += 25;
        
        ZLImageView *imgView = ZLImageView.new;
        imgView.img(@"猫狗通用-分离焦虑").aspectFill.circle(YES);
        [self.view addSubview:imgView];
        imgView.KFC.top(y).leading(20).square(80);
        y += 100;
    }
    
    // 3. 圆角 + 边框
    {
        ZLLabel *tip = ZLLab;
        tip.txt(@"3. 圆角+边框").systemFont(13).color(@"#999999");
        [self.view addSubview:tip];
        tip.KFC.top(y).leading(20);
        y += 25;
        
        ZLImageView *imgView = ZLImageView.new;
        imgView.img(@"分享").aspectFit.corner(12).border(2, @"#4A90D9").bgColor(@"#E3F2FD");
        [self.view addSubview:imgView];
        imgView.KFC.top(y).leading(20).size(80, 80);
        y += 100;
    }
    
    // 4. 高亮图片切换
    {
        ZLLabel *tip = ZLLab;
        tip.txt(@"4. 高亮图片切换(点击切换)").systemFont(13).color(@"#999999");
        [self.view addSubview:tip];
        tip.KFC.top(y).leading(20);
        y += 25;
        
        ZLImageView *imgView = ZLImageView.new;
        imgView.img(@"赞").hlImg(@"魔法棒").aspectFit
            .tapAction(^(ZLImageView *iv) {
                iv.highlight(!iv.isHighlighted);
            });
        [self.view addSubview:imgView];
        imgView.KFC.top(y).leading(20).size(60, 60);
        y += 80;
    }
    
    // 5. 透明度 + 背景色
    {
        ZLLabel *tip = ZLLab;
        tip.txt(@"5. 透明度0.5 + 背景色").systemFont(13).color(@"#999999");
        [self.view addSubview:tip];
        tip.KFC.top(y).leading(20);
        y += 25;
        
        ZLImageView *imgView = ZLImageView.new;
        imgView.img(@"猫狗通用-分离焦虑").aspectFit.alphaValue(0.5).bgColor(@"#FFECB3").corner(8);
        [self.view addSubview:imgView];
        imgView.KFC.top(y).leading(20).size(80, 80);
        y += 100;
    }
    
    // 6. toPtr + then
    {
        ZLLabel *tip = ZLLab;
        tip.txt(@"6. toPtr赋值 + then回调").systemFont(13).color(@"#999999");
        [self.view addSubview:tip];
        tip.KFC.top(y).leading(20);
        y += 25;
        
        __block ZLImageView *ref;
        ZLImageView *imgView = ZLImageView.new;
        imgView.toPtr(&ref).then(^(ZLImageView *iv) {
            iv.img(@"分享").aspectFit.bgColor(@"#E8F5E9").corner(8);
        });
        [self.view addSubview:imgView];
        imgView.KFC.top(y).leading(20).size(60, 60);
    }
}

@end
