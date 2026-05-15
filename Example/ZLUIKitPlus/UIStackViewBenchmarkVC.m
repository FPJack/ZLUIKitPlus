// UIStackViewBenchmarkVC.m
// 测试 UIStackView：三层嵌套，全部渲染到屏幕上，打印性能数据

#import "UIStackViewBenchmarkVC.h"
#import <mach/mach.h>
#import <ZLUIKitPlus/ZLUIKitPlus.h>
static const NSInteger kOuter  = 3;   // 第一层列数
static const NSInteger kMiddle = 40;   // 第二层行数
static const NSInteger kInner  = 3;   // 第三层列数（叶子）

static uint64_t benchNowNs(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC_RAW, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ULL + ts.tv_nsec;
}
static double benchMemMB(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    return task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size) == KERN_SUCCESS
        ? info.resident_size / 1024.0 / 1024.0 : -1;
}

@interface UIStackViewBenchmarkVC ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel      *statsLabel;
@end

@implementation UIStackViewBenchmarkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UIStackView Benchmark";
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.98 alpha:1];

    // ── 统计面板 ──
    self.statsLabel = [UILabel new];
    self.statsLabel.numberOfLines = 0;
    self.statsLabel.font = [UIFont fontWithName:@"Menlo" size:12] ?: [UIFont systemFontOfSize:12];
    self.statsLabel.textColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    self.statsLabel.backgroundColor = [UIColor colorWithRed:0.93 green:0.96 blue:1.0 alpha:1];
    self.statsLabel.layer.cornerRadius = 10;
    self.statsLabel.layer.masksToBounds = YES;
    self.statsLabel.text = @"  正在构建...";
    self.statsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.statsLabel];
    [NSLayoutConstraint activateConstraints:@[
        [self.statsLabel.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:8],
        [self.statsLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:12],
        [self.statsLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-12],
    ]];

    // ── 滚动容器 ──
    self.scrollView = [UIScrollView new];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.statsLabel.bottomAnchor constant:8],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];

    // 延迟一帧确保 view 尺寸已确定
    dispatch_async(dispatch_get_main_queue(), ^{
        [self buildAndMeasure];
    });
}

- (void)buildAndMeasure {
    double memBefore = benchMemMB();

    // ══════════════════════════════════════
    //  阶段1：创建所有 UIStackView 对象
    // ══════════════════════════════════════
    uint64_t t0 = benchNowNs();

    // 最外层：水平 StackView，包含 kOuter 列
    UIStackView *root = [[UIStackView alloc] init];
    root.axis        = UILayoutConstraintAxisHorizontal;
    root.distribution = UIStackViewDistributionFillEqually;
    root.alignment   = UIStackViewAlignmentFill;
    root.spacing     = 6;

    for (NSInteger i = 0; i < kOuter; i++) {
        // 第二层：垂直 StackView，包含 kMiddle 行
        UIStackView *col = [[UIStackView alloc] init];
        col.axis         = UILayoutConstraintAxisVertical;
        col.distribution = UIStackViewDistributionFillEqually;
        col.alignment    = UIStackViewAlignmentFill;
        col.spacing      = 4;
        for (NSInteger j = 0; j < kMiddle; j++) {
            // 第三层：水平 StackView，包含 kInner 个叶子 Label
            UIStackView *row = [[UIStackView alloc] init];
            row.axis         = UILayoutConstraintAxisHorizontal;
            row.distribution = UIStackViewDistributionFillEqually;
            row.alignment    = UIStackViewAlignmentFill;
            row.spacing      = 2;
            row.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
            row.layer.borderWidth = 0.5;
            row.layer.cornerRadius = 4;

            for (NSInteger k = 0; k < kInner; k++) {
                UILabel *lab = [[UILabel alloc] init];
                lab.text          = [NSString stringWithFormat:@"%ld·%ld·%ld", i, j, k];
                lab.font          = [UIFont systemFontOfSize:9];
                lab.textAlignment = NSTextAlignmentCenter;
                lab.adjustsFontSizeToFitWidth = YES;
                CGFloat hue = (i * kMiddle * kInner + j * kInner + k)
                              / (CGFloat)(kOuter * kMiddle * kInner);
                lab.backgroundColor = [UIColor colorWithHue:hue
                                                 saturation:0.35
                                                 brightness:0.92
                                                      alpha:1];
                [row addArrangedSubview:lab];

            }
            row.zl_layout.height(10);
            [col addArrangedSubview:row];
        }
        [root addArrangedSubview:col];
    }

    uint64_t t1 = benchNowNs();
    double createMs = (t1 - t0) / 1e6;

    // ══════════════════════════════════════
    //  阶段2：加入视图树 + 约束
    // ══════════════════════════════════════
    uint64_t t2 = benchNowNs();

    root.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:root];

    CGFloat W = self.view.bounds.size.width - 16;
    [NSLayoutConstraint activateConstraints:@[
        [root.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor constant:8],
        [root.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:8],
        [root.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor constant:-8],
        [root.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor constant:-8],
        [root.widthAnchor constraintEqualToConstant:W],
    ]];

    uint64_t t3 = benchNowNs();
    double addViewMs = (t3 - t2) / 1e6;

    // ══════════════════════════════════════
    //  阶段3：强制 Layout（约束求解）
    // ══════════════════════════════════════
    uint64_t t4 = benchNowNs();
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    uint64_t t5 = benchNowNs();
    double layoutMs = (t5 - t4) / 1e6;

    double memAfter  = benchMemMB();
    double memDelta  = memAfter - memBefore;
    double totalMs   = createMs + addViewMs + layoutMs;

    // ══════════════════════════════════════
    //  统计展示 & 控制台打印
    // ══════════════════════════════════════
    NSInteger totalNodes = kOuter + kOuter * kMiddle + kOuter * kMiddle * kInner;
    NSString *stats = [NSString stringWithFormat:
        @"\n"
        @"  【UIStackView 性能报告】\n"
        @"  ─────────────────────────────────\n"
        @"  嵌套结构  : 3层  %ld × %ld × %ld\n"
        @"  总节点数  : %ld（叶子 %ld）\n"
        @"  ─────────────────────────────────\n"
        @"  ① 创建耗时    : %8.3f ms\n"
        @"  ② addSubview  : %8.3f ms\n"
        @"  ③ layoutIfNeeded: %6.3f ms\n"
        @"  ─────────────────────────────────\n"
        @"  合计耗时      : %8.3f ms\n"
        @"  内存增量      : %8.2f MB\n"
        @"  内存前/后     : %.1f / %.1f MB\n",
        (long)kOuter, (long)kMiddle, (long)kInner,
        (long)totalNodes, (long)(kOuter * kMiddle * kInner),
        createMs, addViewMs, layoutMs,
        totalMs, memDelta, memBefore, memAfter];

    self.statsLabel.text = stats;

    NSLog(@"\n%@", stats);
    NSLog(@"========== UIStackView Benchmark END ==========");
}

@end
