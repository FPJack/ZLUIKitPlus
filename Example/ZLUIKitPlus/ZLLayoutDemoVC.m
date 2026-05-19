#import "ZLLayoutDemoVC.h"
#import <ZLUIKitPlus/ZLUIKitPlus.h>

@implementation ZLLayoutDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZLLayout Demo";
    self.view.backgroundColor = UIColor.whiteColor;
    
    
//    {
//        UIView *v = UIView.new;
//        v.backgroundColor = UIColor.orangeColor;
//        v.zl_layout.addTo(self.view).square(50).center();
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            v.zl_layout.clear.square(100).centerX(0).top(100);
//        });
//    }
//    return;

    UIScrollView *scroll = UIScrollView.new;
    [self.view addSubview:scroll];
    scroll.zl_layout.edgesZero();

    UIView *content = UIView.new;
    [scroll addSubview:content];
    content.zl_layout.edgesZero();
    content.zl_layout.widthTo(scroll.widthAnchor);

    CGFloat y = 20;

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 1. center() / centerX() / centerY() / centerOffset()
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        UILabel *title = [self sectionTitle:@"1. center / centerX / centerY / centerOffset"];
        [content addSubview:title];
        title.zl_layout.top(y).leading(16);
        y += 30;

        UIView *container = [self containerWithY:y inContent:content height:120];

        // center() — 完全居中
        UIView *v1 = [self colorBox:UIColor.systemRedColor text:@"center()"];
        [container addSubview:v1];
        v1.zl_layout.center().size(60, 30);

        // centerX(0) + top(10) — 水平居中，顶部偏移
        UIView *v2 = [self colorBox:UIColor.systemBlueColor text:@"centerX(0)"];
        [container addSubview:v2];
        v2.zl_layout.centerX(0).top(5).size(70, 24);

        // centerY(0) + leading(10) — 垂直居中，左边固定
        UIView *v3 = [self colorBox:UIColor.systemGreenColor text:@"centerY"];
        [container addSubview:v3];
        v3.zl_layout.centerY(0).leading(5).size(50, 24);

        // centerOffset(50, -20) — 偏移居中
        UIView *v4 = [self colorBox:UIColor.systemOrangeColor text:@"offset"];
        [container addSubview:v4];
        v4.zl_layout.centerOffset(50, -20).size(50, 24);

        y += 130;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 2. centerXTo / centerYTo — 相对其他 view 居中
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        UILabel *title = [self sectionTitle:@"2. centerXTo / centerYTo"];
        [content addSubview:title];
        title.zl_layout.top(y).leading(16);
        y += 30;

        UIView *container = [self containerWithY:y inContent:content height:80];

        // 参照 view
        UIView *ref = [self colorBox:UIColor.systemPurpleColor text:@"REF"];
        [container addSubview:ref];
        ref.zl_layout.leading(20).top(10).size(80, 60);

        // centerXTo(ref.centerXAnchor) — 水平对齐 ref 的中心
        UIView *v1 = [self colorBox:UIColor.systemTealColor text:@"centerXTo"];
        [container addSubview:v1];
        v1.zl_layout.centerXTo(ref.centerXAnchor, 0).bottom(-5).size(70, 20);

        // centerYTo(ref.centerYAnchor, 0) — 垂直对齐 ref 的中心
        UIView *v2 = [self colorBox:UIColor.systemPinkColor text:@"centerYTo"];
        [container addSubview:v2];
        v2.zl_layout.centerYTo(ref.centerYAnchor, 0).trailing(-20).size(70, 20);

        y += 90;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 3. centerXGreaterThanOrTo / centerXLessThanOrTo
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        UILabel *title = [self sectionTitle:@"3. centerX GreaterThan / LessThan"];
        [content addSubview:title];
        title.zl_layout.top(y).leading(16);
        y += 30;

        UIView *container = [self containerWithY:y inContent:content height:60];

        UIView *ref = [self colorBox:UIColor.darkGrayColor text:@"center"];
        [container addSubview:ref];
        ref.zl_layout.center().size(60, 30);

        // centerX >= ref.centerX + 50
        UIView *v1 = [self colorBox:UIColor.systemRedColor text:@">=+50"];
        [container addSubview:v1];
        v1.zl_layout.centerXGreaterThanOrTo(ref.centerXAnchor, 50).centerY(0).size(50, 24);

        // centerX <= ref.centerX - 50
        UIView *v2 = [self colorBox:UIColor.systemBlueColor text:@"<=-50"];
        [container addSubview:v2];
        v2.zl_layout.centerXLessThanOrTo(ref.centerXAnchor, -50).centerY(0).size(50, 24);

        y += 70;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 4. centerYGreaterThanOrTo / centerYLessThanOrTo
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        UILabel *title = [self sectionTitle:@"4. centerY GreaterThan / LessThan"];
        [content addSubview:title];
        title.zl_layout.top(y).leading(16);
        y += 30;

        UIView *container = [self containerWithY:y inContent:content height:100];

        UIView *ref = [self colorBox:UIColor.darkGrayColor text:@"ref"];
        [container addSubview:ref];
        ref.zl_layout.center().size(50, 30);

        // centerY >= ref.centerY + 20
        UIView *v1 = [self colorBox:UIColor.systemOrangeColor text:@">=+20"];
        [container addSubview:v1];
        v1.zl_layout.centerYGreaterThanOrTo(ref.centerYAnchor, 20).centerX(0).size(50, 24);

        // centerY <= ref.centerY - 20
        UIView *v2 = [self colorBox:UIColor.systemGreenColor text:@"<=-20"];
        [container addSubview:v2];
        v2.zl_layout.centerYLessThanOrTo(ref.centerYAnchor, -20).centerX(0).size(50, 24);

        y += 110;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 5. top / topTo / topGreaterThanOrTo / topLessThanOrTo
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        UILabel *title = [self sectionTitle:@"5. top / topTo / topGT / topLT"];
        [content addSubview:title];
        title.zl_layout.top(y).leading(16);
        y += 30;

        UIView *container = [self containerWithY:y inContent:content height:100];

        // top(10) — 距父视图顶部 10
        UIView *v1 = [self colorBox:UIColor.systemRedColor text:@"top(10)"];
        [container addSubview:v1];
        v1.zl_layout.top(10).leading(10).size(70, 24);

        // topTo(v1.bottomAnchor, 8) — 在 v1 下方 8pt
        UIView *v2 = [self colorBox:UIColor.systemBlueColor text:@"topTo(v1.bottom,8)"];
        [container addSubview:v2];
        v2.zl_layout.topTo(v1.bottomAnchor, 8).leading(10).size(130, 24);

        // topGreaterThanOrTo — top >= container.top + 50
        UIView *v3 = [self colorBox:UIColor.systemGreenColor text:@"top>=50"];
        [container addSubview:v3];
        v3.zl_layout.topGreaterThanOrTo(container.topAnchor, 50).leading(200).size(70, 24);

        // topLessThanOrTo — top <= container.top + 30
        UIView *v4 = [self colorBox:UIColor.systemOrangeColor text:@"top<=30"];
        [container addSubview:v4];
        v4.zl_layout.topLessThanOrTo(container.topAnchor, 30).trailing(-10).size(70, 24);

        y += 110;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 6. leading / leadingTo / leadingGT / leadingLT
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        UILabel *title = [self sectionTitle:@"6. leading / leadingTo / leadingGT / leadingLT"];
        [content addSubview:title];
        title.zl_layout.top(y).leading(16);
        y += 30;

        UIView *container = [self containerWithY:y inContent:content height:80];

        // leading(16) — 距父视图左边 16
        UIView *v1 = [self colorBox:UIColor.systemRedColor text:@"leading(16)"];
        [container addSubview:v1];
        v1.zl_layout.leading(16).top(10).size(80, 24);

        // leadingTo(v1.trailingAnchor, 12) — 在 v1 右边 12pt
        UIView *v2 = [self colorBox:UIColor.systemBlueColor text:@"leadingTo"];
        [container addSubview:v2];
        v2.zl_layout.leadingTo(v1.trailingAnchor, 12).top(10).size(70, 24);

        // leadingGreaterThanOrTo — leading >= 100
        UIView *v3 = [self colorBox:UIColor.systemGreenColor text:@"leading>=100"];
        [container addSubview:v3];
        v3.zl_layout.leadingGreaterThanOrTo(container.leadingAnchor, 100).top(45).size(90, 24);

        // leadingLessThanOrTo — leading <= 50
        UIView *v4 = [self colorBox:UIColor.systemOrangeColor text:@"leading<=50"];
        [container addSubview:v4];
        v4.zl_layout.leadingLessThanOrTo(container.leadingAnchor, 50).top(45).size(90, 24);

        y += 90;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 7. bottom / bottomTo / bottomGT / bottomLT
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        UILabel *title = [self sectionTitle:@"7. bottom / bottomTo / bottomGT / bottomLT"];
        [content addSubview:title];
        title.zl_layout.top(y).leading(16);
        y += 30;

        UIView *container = [self containerWithY:y inContent:content height:100];

        // bottom(-10) — 距父视图底部 10（注意负值表示向上偏移）
        UIView *v1 = [self colorBox:UIColor.systemRedColor text:@"bottom(-10)"];
        [container addSubview:v1];
        v1.zl_layout.bottom(-10).leading(10).size(80, 24);

        // bottomTo(v1.topAnchor, -8) — 在 v1 上方 8pt
        UIView *v2 = [self colorBox:UIColor.systemBlueColor text:@"bottomTo"];
        [container addSubview:v2];
        v2.zl_layout.bottomTo(v1.topAnchor, -8).leading(10).size(80, 24);

        // bottomGreaterThanOrTo — bottom >= container.bottom - 60（即不会太靠上）
        UIView *v3 = [self colorBox:UIColor.systemGreenColor text:@"bottom>=-60"];
        [container addSubview:v3];
        v3.zl_layout.bottomGreaterThanOrTo(container.bottomAnchor, -60).leading(200).size(90, 24);

        // bottomLessThanOrTo — bottom <= container.bottom - 30（即不会太靠下）
        UIView *v4 = [self colorBox:UIColor.systemOrangeColor text:@"bottom<=-30"];
        [container addSubview:v4];
        v4.zl_layout.bottomLessThanOrTo(container.bottomAnchor, -30).trailing(-10).size(90, 24);

        y += 110;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 8. trailing / trailingTo / trailingGT / trailingLT
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        UILabel *title = [self sectionTitle:@"8. trailing / trailingTo"];
        [content addSubview:title];
        title.zl_layout.top(y).leading(16);
        y += 30;

        UIView *container = [self containerWithY:y inContent:content height:80];

        // trailing(-16) — 距父视图右边 16
        UIView *v1 = [self colorBox:UIColor.systemRedColor text:@"trailing(-16)"];
        [container addSubview:v1];
        v1.zl_layout.trailing(-16).top(10).size(90, 24);

        // trailingTo(v1.leadingAnchor, -12) — 在 v1 左边 12pt
        UIView *v2 = [self colorBox:UIColor.systemBlueColor text:@"trailingTo"];
        [container addSubview:v2];
        v2.zl_layout.trailingTo(v1.leadingAnchor, -12).top(10).size(80, 24);

        // trailing(-16) + leading(16) — 左右都有间距
        UIView *v3 = [self colorBox:UIColor.systemPurpleColor text:@"leading+trailing 撑满"];
        [container addSubview:v3];
        v3.zl_layout.leading(16).trailing(-16).top(45).height(24);

        y += 90;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 9. width / widthTo / minWidth / maxWidth
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        UILabel *title = [self sectionTitle:@"9. width / widthTo / minWidth / maxWidth"];
        [content addSubview:title];
        title.zl_layout.top(y).leading(16);
        y += 30;

        UIView *container = [self containerWithY:y inContent:content height:130];

        // width(100)
        UIView *v1 = [self colorBox:UIColor.systemRedColor text:@"width(100)"];
        [container addSubview:v1];
        v1.zl_layout.top(5).leading(10).width(100).height(24);

        // widthTo(v1.widthAnchor) — 宽度等于 v1
        UIView *v2 = [self colorBox:UIColor.systemBlueColor text:@"widthTo(v1)"];
        [container addSubview:v2];
        v2.zl_layout.topTo(v1.bottomAnchor, 5).leading(10).widthTo(v1.widthAnchor).height(24);

        // minWidth(80) — 最小 80，内容不足时保持 80
        UILabel *v3 = [self colorBox:UIColor.systemGreenColor text:@"min80"];
        [container addSubview:v3];
        v3.zl_layout.topTo(v2.bottomAnchor, 5).leading(10).minWidth(80).height(24);

        // maxWidth(120) — 最大 120，超出时截断
        UILabel *v4 = [self colorBox:UIColor.systemOrangeColor text:@"maxW120 超长文字演示截断效果"];
        v4.clipsToBounds = YES;
        [container addSubview:v4];
        v4.zl_layout.topTo(v3.bottomAnchor, 5).leading(10).maxWidth(120).height(24);

        // width(0) 配合 leading+trailing 撑满（也能工作）
        UIView *v5 = [self colorBox:UIColor.systemPurpleColor text:@"leading+trailing撑宽"];
        [container addSubview:v5];
        v5.zl_layout.topTo(v4.bottomAnchor, 5).leading(10).trailing(-10).height(24);

        y += 140;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 10. height / heightTo / minHeight / maxHeight
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        UILabel *title = [self sectionTitle:@"10. height / heightTo / minHeight / maxHeight"];
        [content addSubview:title];
        title.zl_layout.top(y).leading(16);
        y += 30;

        UIView *container = [self containerWithY:y inContent:content height:120];

        // height(60)
        UIView *v1 = [self colorBox:UIColor.systemRedColor text:@"h(60)"];
        [container addSubview:v1];
        v1.zl_layout.top(5).leading(10).width(60).height(60);

        // heightTo(v1.heightAnchor) — 高度等于 v1
        UIView *v2 = [self colorBox:UIColor.systemBlueColor text:@"hTo(v1)"];
        [container addSubview:v2];
        v2.zl_layout.top(5).leadingTo(v1.trailingAnchor, 10).width(50).heightTo(v1.heightAnchor);

        // minHeight(40) — 最小 40
        UIView *v3 = [self colorBox:UIColor.systemGreenColor text:@"minH40"];
        [container addSubview:v3];
        v3.zl_layout.top(5).leadingTo(v2.trailingAnchor, 10).width(55).minHeight(40);

        // maxHeight(50) + top+bottom 拉伸（被 max 限制）
        UIView *v4 = [self colorBox:UIColor.systemOrangeColor text:@"maxH50"];
        [container addSubview:v4];
        v4.zl_layout.top(5).leadingTo(v3.trailingAnchor, 10).width(55).maxHeight(50);

        y += 130;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 11. size() / square()
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        UILabel *title = [self sectionTitle:@"11. size(w,h) / square(s)"];
        [content addSubview:title];
        title.zl_layout.top(y).leading(16);
        y += 30;

        UIView *container = [self containerWithY:y inContent:content height:80];

        // size(100, 40)
        UIView *v1 = [self colorBox:UIColor.systemRedColor text:@"size(100,40)"];
        [container addSubview:v1];
        v1.zl_layout.top(10).leading(10).size(100, 40);

        // square(60) — 正方形
        UIView *v2 = [self colorBox:UIColor.systemBlueColor text:@"square(60)"];
        v2.layer.cornerRadius = 30;
        v2.clipsToBounds = YES;
        [container addSubview:v2];
        v2.zl_layout.centerY(0).leadingTo(v1.trailingAnchor, 20).square(60);

        // square(40) — 小正方形
        UIView *v3 = [self colorBox:UIColor.systemGreenColor text:@"40"];
        v3.layer.cornerRadius = 20;
        v3.clipsToBounds = YES;
        [container addSubview:v3];
        v3.zl_layout.centerY(0).leadingTo(v2.trailingAnchor, 20).square(40);

        y += 90;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 12. edges() / edgesZero() / allEdges()
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        UILabel *title = [self sectionTitle:@"12. edges(t,l,b,r) / edgesZero() / allEdges(inset)"];
        [content addSubview:title];
        title.zl_layout.top(y).leading(16);
        y += 30;

        UIView *container = [self containerWithY:y inContent:content height:180];

        // edgesZero() — 贴满父视图
        UIView *box1 = UIView.new;
        box1.backgroundColor = [UIColor.systemRedColor colorWithAlphaComponent:0.1];
        box1.layer.borderWidth = 1;
        box1.layer.borderColor = UIColor.systemRedColor.CGColor;
        [container addSubview:box1];
        box1.zl_layout.top(5).leading(10).size(150, 50);
        UIView *inner1 = [self colorBox:UIColor.systemRedColor text:@"edgesZero()"];
        [box1 addSubview:inner1];
        inner1.zl_layout.edgesZero();

        // allEdges(8) — 四边留 8pt
        UIView *box2 = UIView.new;
        box2.backgroundColor = [UIColor.systemBlueColor colorWithAlphaComponent:0.1];
        box2.layer.borderWidth = 1;
        box2.layer.borderColor = UIColor.systemBlueColor.CGColor;
        [container addSubview:box2];
        box2.zl_layout.topTo(box1.bottomAnchor, 10).leading(10).size(150, 50);
        UIView *inner2 = [self colorBox:UIColor.systemBlueColor text:@"allEdges(8)"];
        [box2 addSubview:inner2];
        inner2.zl_layout.allEdges(8);

        // edges(4, 16, 4, 16) — 上下 4，左右 16
        UIView *box3 = UIView.new;
        box3.backgroundColor = [UIColor.systemGreenColor colorWithAlphaComponent:0.1];
        box3.layer.borderWidth = 1;
        box3.layer.borderColor = UIColor.systemGreenColor.CGColor;
        [container addSubview:box3];
        box3.zl_layout.topTo(box2.bottomAnchor, 10).leading(10).size(150, 50);
        UIView *inner3 = [self colorBox:UIColor.systemGreenColor text:@"edges(4,16,4,16)"];
        [box3 addSubview:inner3];
        inner3.zl_layout.edges(4, 16, 4, 16);

        y += 190;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 13. addTo() / addToFull()
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        UILabel *title = [self sectionTitle:@"13. addTo(superview) / addToFull(superview)"];
        [content addSubview:title];
        title.zl_layout.top(y).leading(16);
        y += 30;

        UIView *container = [self containerWithY:y inContent:content height:100];

        // addTo — 只添加到父视图，不设约束
        UIView *box1 = UIView.new;
        box1.backgroundColor = [UIColor.systemPurpleColor colorWithAlphaComponent:0.2];
        [container addSubview:box1];
        box1.zl_layout.top(5).leading(10).size(140, 40);

        UIView *child1 = [self colorBox:UIColor.systemPurpleColor text:@"addTo()"];
        child1.zl_layout.addTo(box1).center().size(80, 24);

        // addToFull — 添加并贴满
        UIView *box2 = UIView.new;
        box2.backgroundColor = [UIColor.systemIndigoColor colorWithAlphaComponent:0.2];
        [container addSubview:box2];
        box2.zl_layout.top(50).leading(10).size(140, 40);

        UIView *child2 = [self colorBox:UIColor.systemIndigoColor text:@"addToFull()"];
        child2.zl_layout.addToFull(box2);

        y += 110;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 14. addSubview() / addSubviewLayout()
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        UILabel *title = [self sectionTitle:@"14. addSubview(child) / addSubviewLayout(child, ^)"];
        [content addSubview:title];
        title.zl_layout.top(y).leading(16);
        y += 30;

        UIView *container = [self containerWithY:y inContent:content height:80];

        // addSubview — 给 container 添加子视图
        UIView *parent1 = UIView.new;
        parent1.backgroundColor = [UIColor.systemYellowColor colorWithAlphaComponent:0.3];
        [container addSubview:parent1];
        parent1.zl_layout.top(5).leading(10).size(150, 30);

        UIView *child1 = [self colorBox:UIColor.systemOrangeColor text:@"addSubview"];
        parent1.zl_layout.addSubview(child1);
        child1.zl_layout.edgesZero();

        // addSubviewLayout — 添加子视图并在 block 中设约束
        UIView *parent2 = UIView.new;
        parent2.backgroundColor = [UIColor.systemMintColor colorWithAlphaComponent:0.3];
        [container addSubview:parent2];
        parent2.zl_layout.top(40).leading(10).size(150, 30);

        UIView *child2 = [self colorBox:UIColor.systemTealColor text:@"addSubviewLayout"];
        parent2.zl_layout.addSubviewLayout(child2, ^(ZLLayout *layout) {
            layout.center().size(120, 20);
        });

        y += 90;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 15. tapAction — 点击事件
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        UILabel *title = [self sectionTitle:@"15. tapAction(^block) — 点击事件"];
        [content addSubview:title];
        title.zl_layout.top(y).leading(16);
        y += 30;

        UIView *container = [self containerWithY:y inContent:content height:60];

        UIView *tapView = [self colorBox:UIColor.systemIndigoColor text:@"点我切换颜色"];
        [container addSubview:tapView];
        tapView.zl_layout.center().size(160, 40);
        tapView.layer.cornerRadius = 8;

        __weak UIView *weakTap = tapView;
        tapView.zl_layout.tapAction(^(__kindof UIView *view) {
            static BOOL toggled = NO;
            toggled = !toggled;
            weakTap.backgroundColor = toggled ? UIColor.systemPinkColor : UIColor.systemIndigoColor;
        });

        y += 70;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 16. 链式组合：完整布局
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        UILabel *title = [self sectionTitle:@"16. 链式组合 — 卡片布局"];
        [content addSubview:title];
        title.zl_layout.top(y).leading(16);
        y += 30;

        UIView *container = [self containerWithY:y inContent:content height:100];

        // 模拟一个卡片
        UIView *card = UIView.new;
        card.backgroundColor = UIColor.whiteColor;
        card.layer.cornerRadius = 12;
        card.layer.shadowColor = UIColor.blackColor.CGColor;
        card.layer.shadowOpacity = 0.15;
        card.layer.shadowOffset = CGSizeMake(0, 2);
        card.layer.shadowRadius = 8;
        [container addSubview:card];
        card.zl_layout.top(10).leading(16).trailing(-16).bottom(-10);

        // 头像
        UIView *avatar = UIView.new;
        avatar.backgroundColor = UIColor.systemPurpleColor;
        avatar.layer.cornerRadius = 20;
        [card addSubview:avatar];
        avatar.zl_layout.leading(12).centerY(0).square(40);

        // 标题
        UILabel *nameLabel = UILabel.new;
        nameLabel.text = @"ZLLayout 链式布局";
        nameLabel.font = [UIFont boldSystemFontOfSize:15];
        [card addSubview:nameLabel];
        nameLabel.zl_layout.leadingTo(avatar.trailingAnchor, 10).top(15);

        // 副标题
        UILabel *subLabel = UILabel.new;
        subLabel.text = @"top / leading / trailing / center / size 组合";
        subLabel.font = [UIFont systemFontOfSize:12];
        subLabel.textColor = UIColor.grayColor;
        [card addSubview:subLabel];
        subLabel.zl_layout.leadingTo(avatar.trailingAnchor, 10).topTo(nameLabel.bottomAnchor, 4).trailing(-12);

        // 右侧箭头
        UILabel *arrow = UILabel.new;
        arrow.text = @"›";
        arrow.font = [UIFont systemFontOfSize:24];
        arrow.textColor = UIColor.lightGrayColor;
        [card addSubview:arrow];
        arrow.zl_layout.trailing(-12).centerY(0);

        y += 110;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 17. 多 view 相对布局综合
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        UILabel *title = [self sectionTitle:@"17. 多 view 相对约束综合"];
        [content addSubview:title];
        title.zl_layout.top(y).leading(16);
        y += 30;

        UIView *container = [self containerWithY:y inContent:content height:120];

        // A: 左上角
        UIView *vA = [self colorBox:UIColor.systemRedColor text:@"A"];
        [container addSubview:vA];
        vA.zl_layout.top(10).leading(10).size(60, 40);

        // B: A 的右边，和 A 顶部对齐
        UIView *vB = [self colorBox:UIColor.systemBlueColor text:@"B"];
        [container addSubview:vB];
        vB.zl_layout.topTo(vA.topAnchor, 0).leadingTo(vA.trailingAnchor, 10).size(80, 40);

        // C: A 的下方，和 A 左边对齐
        UIView *vC = [self colorBox:UIColor.systemGreenColor text:@"C"];
        [container addSubview:vC];
        vC.zl_layout.topTo(vA.bottomAnchor, 10).leadingTo(vA.leadingAnchor, 0).size(60, 40);

        // D: B 和 C 的交汇区域右下角
        UIView *vD = [self colorBox:UIColor.systemOrangeColor text:@"D"];
        [container addSubview:vD];
        vD.zl_layout.topTo(vB.bottomAnchor, 10).leadingTo(vC.trailingAnchor, 10).trailing(-10).bottom(-10);

        y += 130;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 18. 等宽分布（widthTo 配合多个 view）
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        UILabel *title = [self sectionTitle:@"18. widthTo — 等宽分布"];
        [content addSubview:title];
        title.zl_layout.top(y).leading(16);
        y += 30;

        UIView *container = [self containerWithY:y inContent:content height:60];

        NSArray *colors = @[UIColor.systemRedColor, UIColor.systemBlueColor,
                            UIColor.systemGreenColor, UIColor.systemOrangeColor];
        UIView *prev = nil;
        UIView *first = nil;
        for (NSInteger i = 0; i < 4; i++) {
            UIView *box = [self colorBox:colors[i] text:[NSString stringWithFormat:@"%ld", (long)i+1]];
            [container addSubview:box];

            if (i == 0) {
                box.zl_layout.leading(10).top(10).bottom(-10);
                first = box;
            } else {
                box.zl_layout.leadingTo(prev.trailingAnchor, 8).top(10).bottom(-10);
                box.zl_layout.widthTo(first.widthAnchor);  // 等宽
            }
            if (i == 3) {
                box.zl_layout.trailing(-10);
            }
            prev = box;
        }

        y += 70;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 19. 等高分布（heightTo 配合多个 view）
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        UILabel *title = [self sectionTitle:@"19. heightTo — 等高分布"];
        [content addSubview:title];
        title.zl_layout.top(y).leading(16);
        y += 30;

        UIView *container = [self containerWithY:y inContent:content height:160];

        NSArray *colors = @[UIColor.systemPinkColor, UIColor.systemTealColor,
                            UIColor.systemIndigoColor];
        UIView *prevV = nil;
        UIView *firstV = nil;
        for (NSInteger i = 0; i < 3; i++) {
            UIView *box = [self colorBox:colors[i] text:[NSString stringWithFormat:@"row%ld", (long)i+1]];
            [container addSubview:box];

            if (i == 0) {
                box.zl_layout.top(8).leading(10).trailing(-10);
                firstV = box;
            } else {
                box.zl_layout.topTo(prevV.bottomAnchor, 8).leading(10).trailing(-10);
                box.zl_layout.heightTo(firstV.heightAnchor);  // 等高
            }
            if (i == 2) {
                box.zl_layout.bottom(-8);
            }
            prevV = box;
        }

        y += 170;
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - 20. 综合实战 — 登录表单
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    {
        UILabel *title = [self sectionTitle:@"20. 综合实战 — 登录表单"];
        [content addSubview:title];
        title.zl_layout.top(y).leading(16);
        y += 30;

        UIView *container = [self containerWithY:y inContent:content height:200];

        // Logo
        UIView *logo = UIView.new;
        logo.backgroundColor = UIColor.systemBlueColor;
        logo.layer.cornerRadius = 30;
        [container addSubview:logo];
        logo.zl_layout.centerX(0).top(10).square(60);

        // 用户名输入框
        UITextField *userField = UITextField.new;
        userField.placeholder = @"请输入用户名";
        userField.borderStyle = UITextBorderStyleRoundedRect;
        [container addSubview:userField];
        userField.zl_layout.topTo(logo.bottomAnchor, 16).leading(30).trailing(-30).height(36);

        // 密码输入框
        UITextField *passField = UITextField.new;
        passField.placeholder = @"请输入密码";
        passField.borderStyle = UITextBorderStyleRoundedRect;
        passField.secureTextEntry = YES;
        [container addSubview:passField];
        passField.zl_layout.topTo(userField.bottomAnchor, 12).leading(30).trailing(-30).height(36);

        // 登录按钮
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        loginBtn.backgroundColor = UIColor.systemBlueColor;
        [loginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        loginBtn.layer.cornerRadius = 18;
        [container addSubview:loginBtn];
        loginBtn.zl_layout.topTo(passField.bottomAnchor, 20).leading(30).trailing(-30).height(36);

        y += 210;
    }

    // 最终设置 content 高度
    UIView *spacer = UIView.new;
    [content addSubview:spacer];
    spacer.zl_layout.top(y).leading(0).height(40).width(1);
    spacer.zl_layout.bottom(0);
}

#pragma mark - Helper

- (UIView *)containerWithY:(CGFloat)y inContent:(UIView *)content height:(CGFloat)h {
    UIView *container = UIView.new;
    container.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    container.layer.cornerRadius = 8;
    container.clipsToBounds = YES;
    [content addSubview:container];
    container.zl_layout.top(y).leading(12).trailing(-12).height(h);
    return container;
}

- (UILabel *)colorBox:(UIColor *)color text:(NSString *)text {
    UILabel *label = UILabel.new;
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = UIColor.whiteColor;
    label.backgroundColor = color;
    label.layer.cornerRadius = 4;
    label.clipsToBounds = YES;
    return label;
}

- (UILabel *)sectionTitle:(NSString *)text {
    UILabel *label = UILabel.new;
    label.text = text;
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = UIColor.darkGrayColor;
    return label;
}

@end
