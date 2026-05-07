#import "ZLShadowCornerDemoVC.h"
#import "ZLShadowCornerView.h"
#import <Masonry/Masonry.h>

// 内部辅助：带圆角阴影的卡片 View，持有 ZLShadowCornerView 配置对象
@interface ZLShadowCardView : UIView
@property (nonatomic, strong) ZLShadowCornerView *cfg;
@end
@implementation ZLShadowCardView
- (instancetype)init {
    self = [super init];
    _cfg = ZLShadowCornerView.new;
    _cfg.view = self;
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [_cfg update]; // bounds 确定后刷新路径
}
@end

// --------------------------------------------------

@implementation ZLShadowCornerDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"圆角 + 阴影";
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];

    UIScrollView *scroll = UIScrollView.new;
    [self.view addSubview:scroll];
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    UIView *content = UIView.new;
    [scroll addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(self.view);
    }];

    CGFloat y = 30;
    CGFloat left = 30;

    // --------------------------------------------------
    // 1. 统一圆角 + 阴影
    // --------------------------------------------------
    [self addTip:@"1. 统一圆角 (radius=16) + 阴影" y:y content:content]; y += 30;
    {
        ZLShadowCardView *v = ZLShadowCardView.new;
        v.backgroundColor   = UIColor.whiteColor;
        v.cfg.cornerRadius  = 16;
        v.cfg.shadowColor   = UIColor.blackColor;
        v.cfg.shadowOpacity = 0.15;
        v.cfg.shadowRadius  = 8;
        v.cfg.shadowOffset  = CGSizeMake(0, 4);
        [content addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(y); make.leading.mas_equalTo(left);
            make.size.mas_equalTo(CGSizeMake(200, 80));
        }];
        [self addLabel:@"统一圆角 16pt" to:v]; y += 110;
    }

    // --------------------------------------------------
    // 2. 每个角不同圆角 + 阴影
    // --------------------------------------------------
    [self addTip:@"2. 每个角不同圆角 (TL=0 TR=24 BL=24 BR=0)" y:y content:content]; y += 30;
    {
        ZLShadowCardView *v = ZLShadowCardView.new;
        v.backgroundColor       = [UIColor colorWithRed:0.29 green:0.56 blue:0.89 alpha:1];
        v.cfg.topLeftRadius     = 0;
        v.cfg.topRightRadius    = 24;
        v.cfg.bottomLeftRadius  = 24;
        v.cfg.bottomRightRadius = 0;
        v.cfg.shadowColor       = [UIColor colorWithRed:0.29 green:0.56 blue:0.89 alpha:1];
        v.cfg.shadowOpacity     = 0.4;
        v.cfg.shadowRadius      = 10;
        v.cfg.shadowOffset      = CGSizeMake(0, 6);
        [content addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(y); make.leading.mas_equalTo(left);
            make.size.mas_equalTo(CGSizeMake(200, 80));
        }];
        [self addLabel:@"TL=0 TR=24 BL=24 BR=0" to:v]; y += 110;
    }

    // --------------------------------------------------
    // 3. 链式 API
    // --------------------------------------------------
    [self addTip:@"3. 链式 API" y:y content:content]; y += 30;
    {
        ZLShadowCardView *v = ZLShadowCardView.new;
        v.backgroundColor = [UIColor colorWithRed:0.98 green:0.36 blue:0.35 alpha:1];
        v.cfg.corners(8, 8, 30, 30);
        v.cfg.shadow([UIColor colorWithRed:0.98 green:0.36 blue:0.35 alpha:1], 0.45, 12, CGSizeMake(0, 6));
        [content addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(y); make.leading.mas_equalTo(left);
            make.size.mas_equalTo(CGSizeMake(200, 80));
        }];
        [self addLabel:@"链式 TL=8 TR=8 BL=30 BR=30" to:v]; y += 110;
    }

    // --------------------------------------------------
    // 4. 仅顶部圆角
    // --------------------------------------------------
    [self addTip:@"4. 仅顶部圆角 (TL=20 TR=20 BL=0 BR=0)" y:y content:content]; y += 30;
    {
        ZLShadowCardView *v = ZLShadowCardView.new;
        v.backgroundColor       = [UIColor colorWithRed:0.30 green:0.69 blue:0.31 alpha:1];
        v.cfg.topLeftRadius     = 20;
        v.cfg.topRightRadius    = 20;
        v.cfg.bottomLeftRadius  = 0;
        v.cfg.bottomRightRadius = 0;
        v.cfg.shadowColor       = UIColor.blackColor;
        v.cfg.shadowOpacity     = 0.12;
        v.cfg.shadowRadius      = 6;
        v.cfg.shadowOffset      = CGSizeMake(0, -2);
        [content addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(y); make.leading.mas_equalTo(left);
            make.size.mas_equalTo(CGSizeMake(200, 80));
        }];
        [self addLabel:@"仅顶部圆角" to:v]; y += 110;
    }

    // --------------------------------------------------
    // 5. 气泡形圆角，无阴影
    // --------------------------------------------------
    [self addTip:@"5. 气泡形圆角 (TL=4 TR=20 BL=20 BR=20)" y:y content:content]; y += 30;
    {
        ZLShadowCardView *v = ZLShadowCardView.new;
        v.backgroundColor       = [UIColor colorWithRed:1 green:0.92 blue:0.23 alpha:1];
        v.cfg.topLeftRadius     = 4;
        v.cfg.topRightRadius    = 20;
        v.cfg.bottomLeftRadius  = 20;
        v.cfg.bottomRightRadius = 20;
        v.cfg.shadowOpacity     = 0;
        [content addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(y); make.leading.mas_equalTo(left);
            make.size.mas_equalTo(CGSizeMake(200, 80));
        }];
        [self addLabel:@"气泡形（无阴影）" to:v]; y += 110;
    }

    // 底部留白
    UIView *spacer = UIView.new;
    [content addSubview:spacer];
    [spacer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(y); make.leading.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(1, 40));
    }];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(spacer.mas_bottom);
    }];
}

- (void)addTip:(NSString *)text y:(CGFloat)y content:(UIView *)content {
    UILabel *lab = UILabel.new;
    lab.text = text;
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    [content addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(y); make.leading.mas_equalTo(30);
    }];
}

- (void)addLabel:(NSString *)text to:(UIView *)v {
    UILabel *lab = UILabel.new;
    lab.text = text;
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = UIColor.whiteColor;
    lab.textAlignment = NSTextAlignmentCenter;
    [v addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.leading.trailing.mas_equalTo(0);
    }];
}

@end
