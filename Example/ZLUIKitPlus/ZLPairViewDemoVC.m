#import "ZLPairViewDemoVC.h"
#import <ZLUIKitPlus/ZLUIKitPlus.h>
#import <Masonry/Masonry.h>
#import "ZLStackView.h"
#import "ZLButton.h"
#import "ZLLayoutViewCfg.h"

@interface SwitchA: UISwitch
@end
@implementation SwitchA

- (NSLayoutXAxisAnchor *)leadingAnchor {
    return [super leadingAnchor];
}

@end
@interface Label  : UILabel

@end
@implementation Label
- (CGSize)intrinsicContentSize
{
    return CGSizeMake(-1, -1);
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
}
@end
@implementation ZLPairViewDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZLPairView Demo";
    self.view.backgroundColor = UIColor.whiteColor;
    
    ZLStackView *stackView;
    
    ZLStackView
        .vertical
        .justifyStart
        .space(20)
        .insetVer(100, 20)
        .addToFull(self.view)
        .assignToPtr(&stackView);
    
    // 1. ZLPairLabelView 水平(两个Label)
    {
        ZLLabel *tip = ZLLab;
        tip.txt(@"1. PairLabelView 水平(两个Label)").systemFont(13).color(@"#999999");
        stackView.add(tip);
        
        ZLPairLabelView *pair = ZLPairLabelView.new;
        
    
        
        pair.horizontal
            .minSpace(10)
            .alignStart
            .firstStartSpace(20)
            .shColor(UIColor.redColor)
            .thenFirst(^(ZLLabel *first) {
                first.txt(@"标题:").boldFont(15).color(@"#333333");
            })
            .thenSecond(^(ZLLabel *second) {
                second.txt(@"这是内容文本").systemFont(14).color(@"#666666");
            });
        pair.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        stackView.add(pair);

    }
    
    // 2. ZLPairLabelView 垂直
    {
        ZLLabel *tip = ZLLab;
        tip.txt(@"2. PairLabelView 垂直").systemFont(13).color(@"#999999");
        stackView.add(tip);

        
        ZLPairLabelView *pair = ZLPairLabelView.new;
        pair.horizontal.space(6).alignCenter
            .inset(12, 20, 12, 20)
            .thenFirst(^(ZLLabel *first) {
                first.txt(@"99").boldFont(24).color(@"#FF5722");
            })
            .thenSecond(^(ZLLabel *second) {
                second.txt(@"积分").systemFont(12).color(@"#999999");
            });
        pair.backgroundColor = [UIColor colorWithRed:1.0 green:0.95 blue:0.9 alpha:1];
        stackView.add(pair);

    }
    
   
    
   
}

@end
