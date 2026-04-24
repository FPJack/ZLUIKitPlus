#import "ZLTagListViewDemoVC.h"
#import <ZLUIKitPlus/ZLUIKitPlus.h>

@interface ZLTagListViewDemoVC () <ZLTagListViewDataSource>
@property (nonatomic, strong) NSArray<NSString *> *tags;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation ZLTagListViewDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZLTagListView Demo";
    self.view.backgroundColor = UIColor.whiteColor;
    self.selectedIndex = -1;
    self.tags = @[@"Swift", @"Objective-C", @"Flutter", @"React Native", @"SwiftUI",
                  @"UIKit", @"Combine", @"CoreData", @"ARKit", @"Metal",
                  @"iOS", @"macOS", @"watchOS", @"tvOS", @"visionOS"];
    
    CGFloat y = 100;
    
    // 1. 基础标签列表(Delegate方式)
    {
        ZLLabel *tip = ZLLab;
        tip.txt(@"1. Delegate方式(点击选中)").systemFont(13).color(@"#999999");
        [self.view addSubview:tip];
        tip.KFC.top(y).leading(20);
        y += 25;
        
        ZLTagListView *tagList = ZLTagListView.new;
        tagList.dataSource = self;
        tagList.lineSpacing = 10;
        tagList.itemSpacing = 10;
        tagList.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        tagList.alignment = ZLTagAlignmentStart;
        tagList.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        tagList.layer.cornerRadius = 8;
        [self.view addSubview:tagList];
        tagList.KFC.top(y).leading(16).trailing(16).height(150);
        [tagList reloadData];
        y += 170;
    }
    
    // 2. Block方式(ZLBlockTagListView)
    {
        ZLLabel *tip = ZLLab;
        tip.txt(@"2. Block方式(ZLBlockTagListView)").systemFont(13).color(@"#999999");
        [self.view addSubview:tip];
        tip.KFC.top(y).leading(20);
        y += 25;
        
        NSArray *colors = @[@"#FF5722", @"#4CAF50", @"#2196F3", @"#9C27B0", @"#FF9800"];
        NSArray *items = @[@"热门", @"推荐", @"新品", @"折扣", @"限时"];
        
        ZLBlockTagListView *blockTag = [[ZLBlockTagListView alloc]
            initWithFrame:CGRectZero
            numberOfTags:^NSInteger(ZLBlockTagListView *tv) {
                return items.count;
            }
            dequeueView:^UIView *(ZLBlockTagListView *tv, UIView *view, NSInteger index) {
                ZLLabel *lab = (ZLLabel *)view;
                if (!lab) {
                    lab = ZLLab;
                }
                lab.txt(items[index]).mediumFont(14).color(UIColor.whiteColor)
                    .bgColor(colors[index % colors.count])
                    .insets(6, 16, 6, 16).corner(14);
                return lab;
            }];
        blockTag.lineSpacing = 10;
        blockTag.itemSpacing = 10;
        blockTag.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        blockTag.didSelectTag = ^(ZLBlockTagListView *tv, NSInteger index) {
            NSLog(@"Block标签点击: %@", items[index]);
        };
        blockTag.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        blockTag.layer.cornerRadius = 8;
        [self.view addSubview:blockTag];
        blockTag.KFC.top(y).leading(16).trailing(16).height(60);
        [blockTag reloadData];
        y += 80;
    }
    
    // 3. 居中对齐
    {
        ZLLabel *tip = ZLLab;
        tip.txt(@"3. 居中对齐(alignment=Center)").systemFont(13).color(@"#999999");
        [self.view addSubview:tip];
        tip.KFC.top(y).leading(20);
        y += 25;
        
        NSArray *items = @[@"A", @"BB", @"CCC", @"DDDD", @"EE"];
        ZLBlockTagListView *centerTag = [[ZLBlockTagListView alloc]
            initWithFrame:CGRectZero
            numberOfTags:^NSInteger(ZLBlockTagListView *tv) {
                return items.count;
            }
            dequeueView:^UIView *(ZLBlockTagListView *tv, UIView *view, NSInteger index) {
                ZLLabel *lab = (ZLLabel *)view ?: ZLLab;
                lab.txt(items[index]).systemFont(14).color(@"#333333")
                    .bgColor(@"#E0E0E0").insets(6, 14, 6, 14).corner(12);
                return lab;
            }];
        centerTag.alignment = ZLTagAlignmentCenter;
        centerTag.lineSpacing = 8;
        centerTag.itemSpacing = 8;
        centerTag.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        centerTag.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        centerTag.layer.cornerRadius = 8;
        [self.view addSubview:centerTag];
        centerTag.KFC.top(y).leading(16).trailing(16).height(55);
        [centerTag reloadData];
        y += 75;
    }
    
    // 4. 水平滚动
    {
        ZLLabel *tip = ZLLab;
        tip.txt(@"4. 水平滚动(horizontalScroll=YES)").systemFont(13).color(@"#999999");
        [self.view addSubview:tip];
        tip.KFC.top(y).leading(20);
        y += 25;
        
        NSArray *items = @[@"北京", @"上海", @"广州", @"深圳", @"杭州", @"成都", @"武汉", @"南京", @"西安", @"重庆"];
        ZLBlockTagListView *hTag = [[ZLBlockTagListView alloc]
            initWithFrame:CGRectZero
            numberOfTags:^NSInteger(ZLBlockTagListView *tv) {
                return items.count;
            }
            dequeueView:^UIView *(ZLBlockTagListView *tv, UIView *view, NSInteger index) {
                ZLLabel *lab = (ZLLabel *)view ?: ZLLab;
                lab.txt(items[index]).systemFont(14).color(@"#4A90D9")
                    .bgColor(@"#E3F2FD").insets(8, 16, 8, 16).corner(16);
                return lab;
            }];
        hTag.horizontalScroll = YES;
        hTag.lineSpacing = 8;
        hTag.itemSpacing = 10;
        hTag.contentInset = UIEdgeInsetsMake(8, 10, 8, 10);
        hTag.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        hTag.layer.cornerRadius = 8;
        [self.view addSubview:hTag];
        hTag.KFC.top(y).leading(16).trailing(16).height(52);
        [hTag reloadData];
    }
}

#pragma mark - ZLTagListViewDataSource

- (NSInteger)numberOfTagsInTagListView:(ZLTagListView *)tagListView {
    return self.tags.count;
}

- (UIView *)tagListView:(ZLTagListView *)tagListView dequeueView:(UIView *)view forTagAtIndex:(NSInteger)index {
    ZLLabel *lab = (ZLLabel *)view;
    if (!lab) {
        lab = ZLLab;
    }
    BOOL selected = (index == self.selectedIndex);
    lab.txt(self.tags[index]).systemFont(13)
        .color(selected ? UIColor.whiteColor : @"#333333")
        .bgColor(selected ? @"#4A90D9" : @"#E8E8E8")
        .insets(6, 12, 6, 12).corner(12);
    return lab;
}

- (void)tagListView:(ZLTagListView *)tagListView didSelectTagAtIndex:(NSInteger)index {
    self.selectedIndex = index;
    [tagListView reloadData];
    NSLog(@"选中标签: %@", self.tags[index]);
}

@end
