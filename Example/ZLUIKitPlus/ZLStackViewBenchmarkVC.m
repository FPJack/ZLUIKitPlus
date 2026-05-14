// ZLStackViewBenchmarkVC.m
// 测试 ZLStackView：三层嵌套，全部渲染到屏幕上，打印性能数据

#import "ZLStackViewBenchmarkVC.h"
#import <ZLUIKitPlus/ZLUIKitPlus.h>
#import "ZLStackView.h"
#import "ZLLabel.h"
#import <mach/mach.h>

static const NSInteger kOuter  = 3;
static const NSInteger kMiddle = 40;
static const NSInteger kInner  = 3;

static uint64_t zbNowNs(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC_RAW, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ULL + ts.tv_nsec;
}
static double zbMemMB(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    return task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size) == KERN_SUCCESS
        ? info.resident_size / 1024.0 / 1024.0 : -1;
}

@interface ZLStackViewBenchmarkVC ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel      *statsLabel;
@end

@implementation ZLStackViewBenchmarkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZLStackView Benchmark";
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.98 blue:0.97 alpha:1];

    self.statsLabel = [UILabel new];
    self.statsLabel.numberOfLines = 0;
    self.statsLabel.font = [UIFont fontWithName:@"Menlo" size:12] ?: [UIFont systemFontOfSize:12];
    self.statsLabel.textColor = [UIColor colorWithRed:0.05 green:0.3 blue:0.1 alpha:1];
    self.statsLabel.backgroundColor = [UIColor colorWithRed:0.92 green:1.0 blue:0.94 alpha:1];
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

    self.scrollView = [UIScrollView new];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.statsLabel.bottomAnchor constant:8],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self buildAndMeasure];
    });
}

- (void)buildAndMeasure {
    double memBefore = zbMemMB();

    // ── 阶段1：创建 ──
    uint64_t t0 = zbNowNs();

    ZLStackView *root = ZLStackView.horizontal.justifyFillEqually.alignFill.space(6);

    for (NSInteger i = 0; i < kOuter; i++) {
        ZLStackView *col = ZLStackView.vertical.justifyFillEqually.alignFill.space(4);
        for (NSInteger j = 0; j < kMiddle; j++) {
            ZLStackView *row = ZLStackView.horizontal.justifyFillEqually.alignFill.space(2)
                .border(0.5, @"#DDDDDD").corner(4).masksToBounds(YES).height(10);
            for (NSInteger k = 0; k < kInner; k++) {
                CGFloat hue = (i * kMiddle * kInner + j * kInner + k)
                              / (CGFloat)(kOuter * kMiddle * kInner);
                UIColor *bg = [UIColor colorWithHue:hue saturation:0.35 brightness:0.92 alpha:1];
                ZLLabel *lab = ZLLab
                    .txt([NSString stringWithFormat:@"%ld·%ld·%ld", i, j, k])
                    .systemFont(9).color(@"#333333").bgColor(bg).textAlignCenter;
                [row addArrangedSubview:lab];
            }
            [col addArrangedSubview:row];
        }
        [root addArrangedSubview:col];
    }

    uint64_t t1 = zbNowNs();
    double createMs = (t1 - t0) / 1e6;

    // ── 阶段2：addSubview + 约束 ──
    uint64_t t2 = zbNowNs();
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
    uint64_t t3 = zbNowNs();
    double addViewMs = (t3 - t2) / 1e6;

    // ── 阶段3：layout ──
    uint64_t t4 = zbNowNs();
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    uint64_t t5 = zbNowNs();
    double layoutMs = (t5 - t4) / 1e6;

    double memAfter = zbMemMB();
    double totalMs  = createMs + addViewMs + layoutMs;
    NSInteger totalNodes = kOuter + kOuter * kMiddle + kOuter * kMiddle * kInner;

    NSString *stats = [NSString stringWithFormat:
        @"\n"
        @"  【ZLStackView 性能报告】\n"
        @"  ─────────────────────────────────\n"
        @"  嵌套结构  : 3层  %ld × %ld × %ld\n"
        @"  总节点数  : %ld（叶子 %ld）\n"
        @"  ─────────────────────────────────\n"
        @"  ① 创建耗时      : %8.3f ms\n"
        @"  ② addSubview    : %8.3f ms\n"
        @"  ③ layoutIfNeeded: %8.3f ms\n"
        @"  ─────────────────────────────────\n"
        @"  合计耗时        : %8.3f ms\n"
        @"  内存增量        : %8.2f MB\n"
        @"  内存前/后       : %.1f / %.1f MB\n",
        (long)kOuter, (long)kMiddle, (long)kInner,
        (long)totalNodes, (long)(kOuter * kMiddle * kInner),
        createMs, addViewMs, layoutMs,
        totalMs, memAfter - memBefore, memBefore, memAfter];

    self.statsLabel.text = stats;
    NSLog(@"\n%@", stats);
    NSLog(@"========== ZLStackView Benchmark END ==========");
}

@end
