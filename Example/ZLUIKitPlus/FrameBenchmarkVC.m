// FrameBenchmarkVC.m
// 测试纯 Frame 手动布局：三层嵌套结构，与 UIStackView/ZLStackView/Masonry 横向对比
// 结构等价：外层水平排列 kOuter 列，每列垂直排列 kMiddle 行，每行水平排列 kInner 个叶子 Label

#import "FrameBenchmarkVC.h"
#import <mach/mach.h>

static const NSInteger kOuter  = 2;
static const NSInteger kMiddle = 50;
static const NSInteger kInner  = 10;

static uint64_t frameNowNs(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC_RAW, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ULL + ts.tv_nsec;
}
static double frameMemMB(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    return task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size) == KERN_SUCCESS
        ? info.resident_size / 1024.0 / 1024.0 : -1;
}

@interface FrameBenchmarkVC ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel      *statsLabel;
@end

@implementation FrameBenchmarkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Frame Benchmark";
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.98 alpha:1];

    // ── 统计面板 ──
    self.statsLabel = [UILabel new];
    self.statsLabel.numberOfLines = 0;
    self.statsLabel.font = [UIFont fontWithName:@"Menlo" size:12] ?: [UIFont systemFontOfSize:12];
    self.statsLabel.textColor = [UIColor colorWithRed:0.20 green:0.10 blue:0.40 alpha:1];
    self.statsLabel.backgroundColor = [UIColor colorWithRed:0.93 green:0.91 blue:0.98 alpha:1];
    self.statsLabel.layer.cornerRadius = 10;
    self.statsLabel.layer.masksToBounds = YES;
    self.statsLabel.text = @"  正在构建...";
    [self.view addSubview:self.statsLabel];

    // ── 滚动容器 ──
    self.scrollView = [UIScrollView new];
    [self.view addSubview:self.scrollView];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self buildAndMeasure];
    });
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat topY = 0;
    if (@available(iOS 11.0, *)) {
        topY = self.view.safeAreaInsets.top;
    } else {
        topY = self.topLayoutGuide.length;
    }

    // statsLabel 自适应高度
    CGFloat labelW = self.view.bounds.size.width - 24;
    CGSize fitSize = [self.statsLabel sizeThatFits:CGSizeMake(labelW, CGFLOAT_MAX)];
    self.statsLabel.frame = CGRectMake(12, topY + 8, labelW, fitSize.height);

    // scrollView
    CGFloat scrollY = CGRectGetMaxY(self.statsLabel.frame) + 8;
    self.scrollView.frame = CGRectMake(0, scrollY, self.view.bounds.size.width, self.view.bounds.size.height - scrollY);
}

- (void)buildAndMeasure {
    double memBefore = frameMemMB();

    CGFloat padding   = 8.0;
    CGFloat colGap    = 6.0;
    CGFloat rowGap    = 4.0;
    CGFloat rowH      = 28.0;
    CGFloat totalW    = self.view.bounds.size.width - padding * 2;
    CGFloat colW      = (totalW - colGap * (kOuter - 1)) / kOuter;
    CGFloat cellW     = colW / kInner;
    CGFloat totalH    = kMiddle * rowH + (kMiddle - 1) * rowGap;

    // ══════════════════════════════════════
    //  阶段1：创建所有 UIView + UILabel 对象，直接设置 frame
    // ══════════════════════════════════════
    uint64_t t0 = frameNowNs();

    UIView *root = [[UIView alloc] initWithFrame:CGRectMake(padding, padding, totalW, totalH)];

    for (NSInteger i = 0; i < kOuter; i++) {
        CGFloat colX = i * (colW + colGap);
        UIView *col = [[UIView alloc] initWithFrame:CGRectMake(colX, 0, colW, totalH)];
        [root addSubview:col];

        for (NSInteger j = 0; j < kMiddle; j++) {
            CGFloat rowY = j * (rowH + rowGap);
            UIView *row = [[UIView alloc] initWithFrame:CGRectMake(0, rowY, colW, rowH)];
            row.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
            row.layer.borderWidth = 0.5;
            row.layer.cornerRadius = 4;
            row.clipsToBounds = YES;
            [col addSubview:row];

            for (NSInteger k = 0; k < kInner; k++) {
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(k * cellW, 0, cellW, rowH)];
                lab.text = [NSString stringWithFormat:@"%ld·%ld·%ld", (long)i, (long)j, (long)k];
                lab.font = [UIFont systemFontOfSize:9];
                lab.textAlignment = NSTextAlignmentCenter;
                lab.adjustsFontSizeToFitWidth = YES;
                CGFloat hue = (i * kMiddle * kInner + j * kInner + k)
                              / (CGFloat)(kOuter * kMiddle * kInner);
                lab.backgroundColor = [UIColor colorWithHue:hue saturation:0.35 brightness:0.92 alpha:1];
                [row addSubview:lab];
            }
        }
    }

    uint64_t t1 = frameNowNs();
    double createMs = (t1 - t0) / 1e6;

    // ══════════════════════════════════════
    //  阶段2：addSubview 到滚动容器
    // ══════════════════════════════════════
    uint64_t t2 = frameNowNs();

    [self.scrollView addSubview:root];
    self.scrollView.contentSize = CGSizeMake(totalW + padding * 2, totalH + padding * 2);

    uint64_t t3 = frameNowNs();
    double addViewMs = (t3 - t2) / 1e6;

    // ══════════════════════════════════════
    //  阶段3：强制 Layout（frame 布局几乎无需计算，作为基准对比）
    // ══════════════════════════════════════
    uint64_t t4 = frameNowNs();
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    uint64_t t5 = frameNowNs();
    double layoutMs = (t5 - t4) / 1e6;

    double memAfter = frameMemMB();
    double totalMs  = createMs + addViewMs + layoutMs;
    NSInteger totalNodes = kOuter + kOuter * kMiddle + kOuter * kMiddle * kInner;

    NSString *stats = [NSString stringWithFormat:
        @"\n"
        @"  【Frame 手动布局 性能报告】\n"
        @"  ─────────────────────────────────\n"
        @"  嵌套结构  : 3层  %ld × %ld × %ld\n"
        @"  总节点数  : %ld（叶子 %ld）\n"
        @"  ─────────────────────────────────\n"
        @"  ① 创建+frame设置 : %8.3f ms\n"
        @"  ② addSubview     : %8.3f ms\n"
        @"  ③ layoutIfNeeded : %8.3f ms\n"
        @"  ─────────────────────────────────\n"
        @"  合计耗时         : %8.3f ms\n"
        @"  内存增量         : %8.2f MB\n"
        @"  内存前/后        : %.1f / %.1f MB\n",
        (long)kOuter, (long)kMiddle, (long)kInner,
        (long)totalNodes, (long)(kOuter * kMiddle * kInner),
        createMs, addViewMs, layoutMs,
        totalMs, memAfter - memBefore, memBefore, memAfter];

    self.statsLabel.text = stats;

    // 重新计算 statsLabel 高度
    [self.view setNeedsLayout];

    NSLog(@"\n%@", stats);
    NSLog(@"========== Frame Benchmark END ==========");
}

@end
