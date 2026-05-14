// MasonryBenchmarkVC.m
// 测试 Masonry 手动布局：三层嵌套结构，与 UIStackView/ZLStackView 横向对比
// 结构等价：外层水平排列 kOuter 列，每列垂直排列 kMiddle 行，每行水平排列 kInner 个叶子 Label

#import "MasonryBenchmarkVC.h"
#import <Masonry/Masonry.h>
#import <mach/mach.h>

static const NSInteger kOuter  = 3;
static const NSInteger kMiddle = 40;
static const NSInteger kInner  = 3;

static uint64_t masonryNowNs(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC_RAW, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ULL + ts.tv_nsec;
}
static double masonryMemMB(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    return task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size) == KERN_SUCCESS
        ? info.resident_size / 1024.0 / 1024.0 : -1;
}

@interface MasonryBenchmarkVC ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel      *statsLabel;
@end

@implementation MasonryBenchmarkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Masonry Benchmark";
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.97 blue:0.94 alpha:1];

    // ── 统计面板 ──
    self.statsLabel = [UILabel new];
    self.statsLabel.numberOfLines = 0;
    self.statsLabel.font = [UIFont fontWithName:@"Menlo" size:12] ?: [UIFont systemFontOfSize:12];
    self.statsLabel.textColor = [UIColor colorWithRed:0.35 green:0.20 blue:0.0 alpha:1];
    self.statsLabel.backgroundColor = [UIColor colorWithRed:1.0 green:0.97 blue:0.88 alpha:1];
    self.statsLabel.layer.cornerRadius = 10;
    self.statsLabel.layer.masksToBounds = YES;
    self.statsLabel.text = @"  正在构建...";
    self.statsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.statsLabel];
    [self.statsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).offset(8);
        make.leading.mas_equalTo(12);
        make.trailing.mas_equalTo(-12);
    }];

    // ── 滚动容器 ──
    self.scrollView = [UIScrollView new];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statsLabel.mas_bottom).offset(8);
        make.leading.trailing.bottom.mas_equalTo(0);
    }];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self buildAndMeasure];
    });
}

- (void)buildAndMeasure {
    double memBefore = masonryMemMB();

    // ══════════════════════════════════════
    //  阶段1：创建所有 UIView + UILabel 对象，手动配置
    // ══════════════════════════════════════
    uint64_t t0 = masonryNowNs();

    // 根容器（等价于外层水平 StackView）
    UIView *root = [UIView new];
    [self.scrollView addSubview:root];

    NSMutableArray<UIView *> *cols = [NSMutableArray array];

    for (NSInteger i = 0; i < kOuter; i++) {
        // 第二层：列容器（等价于垂直 StackView）
        UIView *col = [UIView new];
        [root addSubview:col];
        [cols addObject:col];

        NSMutableArray<UIView *> *rows = [NSMutableArray array];

        for (NSInteger j = 0; j < kMiddle; j++) {
            // 第三层：行容器（等价于水平 StackView）
            UIView *row = [UIView new];
            row.layer.borderColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
            row.layer.borderWidth = 0.5;
            row.layer.cornerRadius = 4;
            row.clipsToBounds = YES;
            [col addSubview:row];
            [rows addObject:row];

            NSMutableArray<UILabel *> *labels = [NSMutableArray array];
            for (NSInteger k = 0; k < kInner; k++) {
                UILabel *lab = [UILabel new];
                lab.text = [NSString stringWithFormat:@"%ld·%ld·%ld", i, j, k];
                lab.font = [UIFont systemFontOfSize:9];
                lab.textAlignment = NSTextAlignmentCenter;
                lab.adjustsFontSizeToFitWidth = YES;
                CGFloat hue = (i * kMiddle * kInner + j * kInner + k)
                              / (CGFloat)(kOuter * kMiddle * kInner);
                lab.backgroundColor = [UIColor colorWithHue:hue saturation:0.35 brightness:0.92 alpha:1];
                [row addSubview:lab];
                [labels addObject:lab];
            }

            // ── 叶子 Label 约束（等分行宽） ──
            for (NSInteger k = 0; k < kInner; k++) {
                UILabel *lab = labels[k];
                [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.mas_equalTo(0);
                    make.width.mas_equalTo(row).multipliedBy(1.0 / kInner);
                    make.leading.mas_equalTo(k == 0 ? row.mas_leading : labels[k-1].mas_trailing);
                }];
            }
            if (labels.count > 0) {
                [labels.lastObject mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.trailing.mas_equalTo(0);
                }];
            }
        }

        // ── 行容器约束（等分列高，固定高度） ──
        CGFloat rowH = 10.0;
        for (NSInteger j = 0; j < kMiddle; j++) {
            UIView *row = rows[j];
            [row mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.mas_equalTo(0);
//                make.height.mas_equalTo(rowH);
                make.top.mas_equalTo(j == 0 ? col.mas_top : rows[j-1].mas_bottom).offset(j == 0 ? 0 : 4);
            }];
        }
        if (rows.count > 0) {
            [rows.lastObject mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
            }];
        }
    }

    uint64_t t1 = masonryNowNs();
    double createMs = (t1 - t0) / 1e6;

    // ══════════════════════════════════════
    //  阶段2：根容器 & 列容器约束
    // ══════════════════════════════════════
    uint64_t t2 = masonryNowNs();

    CGFloat W = self.view.bounds.size.width - 16;
    [root mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(8);
        make.trailing.mas_equalTo(-8);
        make.bottom.mas_equalTo(-8);
        make.width.mas_equalTo(W);
    }];

    // 列容器等分根容器宽度
    for (NSInteger i = 0; i < kOuter; i++) {
        UIView *col = cols[i];
        [col mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(root).multipliedBy(1.0 / kOuter);
            make.leading.mas_equalTo(i == 0 ? root.mas_leading : cols[i-1].mas_trailing).offset(i == 0 ? 0 : 6);
        }];
    }
    if (cols.count > 0) {
        [cols.lastObject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(0);
        }];
    }

    uint64_t t3 = masonryNowNs();
    double addViewMs = (t3 - t2) / 1e6;

    // ══════════════════════════════════════
    //  阶段3：强制 Layout
    // ══════════════════════════════════════
    uint64_t t4 = masonryNowNs();
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    uint64_t t5 = masonryNowNs();
    double layoutMs = (t5 - t4) / 1e6;

    double memAfter = masonryMemMB();
    double totalMs  = createMs + addViewMs + layoutMs;
    NSInteger totalNodes = kOuter + kOuter * kMiddle + kOuter * kMiddle * kInner;

    NSString *stats = [NSString stringWithFormat:
        @"\n"
        @"  【Masonry 手动布局 性能报告】\n"
        @"  ─────────────────────────────────\n"
        @"  嵌套结构  : 3层  %ld × %ld × %ld\n"
        @"  总节点数  : %ld（叶子 %ld）\n"
        @"  ─────────────────────────────────\n"
        @"  ① 创建+约束设置  : %8.3f ms\n"
        @"  ② 根容器约束激活 : %8.3f ms\n"
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
    NSLog(@"\n%@", stats);
    NSLog(@"========== Masonry Benchmark END ==========");
}

@end
