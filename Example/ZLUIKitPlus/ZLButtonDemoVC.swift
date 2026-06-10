//
//  ZLButtonDemoVC.swift
//  ZLUIKitPlus_Example
//
//  Button（ZLButton）详细用法 Demo
//
//  Button 继承 UIButton，同时遵循 ViewStyleable。
//  新增属性（全部支持链式调用返回 Self）：
//  • axis             — 内容排列方向（.horizontal / .vertical）
//  • contentOrder     — 图文顺序（.imageFirst / .titleFirst）
//  • verticalAlign    — 交叉轴垂直对齐（.center/.start/.end/.fill）
//  • horizontalAlign  — 主轴/交叉轴水平对齐（.center/.start/.end/.fill）
//  • spacing          — 图文间距（默认 4pt）
//  • flexibleSpacing  — 图文间弹性间隔（图靠一边，文靠另一边）
//  • insets           — 内容与边界的间距（UIEdgeInsets）
//  • imageSize        — 强制指定图片宽高
//  • titleSize        — 强制指定文字宽高
//  • imageMarge(start:end:) — 图片在交叉轴方向的 start/end 额外偏移
//  • titleMarge(start:end:) — 文字在交叉轴方向的 start/end 额外偏移
//  • tapInterval      — 防重复点击间隔（秒）
//  • imgTouchOnly     — 是否只有图片区域响应点击
//  • touchAreaEdgeInsets — 扩展点击热区
//  继承 ViewStyleable：gradColors/gradDirection/border/shadow/cornerRadii/radius

import UIKit
import ZLUIKitPlus

class ZLButtonDemoVC: ZLDemoBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Button Demo"
    }

    override func setupDemos() {
        demoAxis()
        demoContentOrder()
        demoAlign()
        demoSpacing()
        demoInsets()
        demoImageTitleSize()
        demoImageTitleMarge()
        demoTapInterval()
        demoTouchArea()
        demoImgTouchOnly()
        demoViewStyleable()
    }

    // MARK: 辅助：带文字+图片的 Button
    private func makeBtn(title: String,
                         imageName: String? = nil,
                         bg: UIColor = .systemBlue) -> Button {
        let btn = Button()
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        btn.backgroundColor = bg
        if let name = imageName {
            btn.setImage(UIImage(systemName: name), for: .normal)
            btn.tintColor = .white
        }
        return btn
    }

    // MARK: - ① axis
    private func demoAxis() {
        addSection("① axis — 内容排列方向")
        addNote("• axis(.horizontal)：图文水平排列（默认值）\n• axis(.vertical)：图文垂直排列")

        let btn1 = makeBtn(title: "水平排列 axis(.horizontal)", imageName: "star.fill")
        btn1.axis(.horizontal).spacing(8).insets(UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)).radius(10)
        addDemo(btn1, height: 44)
        addCaption("axis(.horizontal)：图文水平排列（默认）")

        let btn2 = makeBtn(title: "垂直排列 axis(.vertical)", imageName: "house.fill")
        btn2.axis(.vertical).spacing(6).insets(UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)).radius(12)
        addDemo(btn2)
        addCaption("axis(.vertical)：图文垂直排列（图在上，文在下，默认 imageFirst）")

        addSeparator()
    }

    // MARK: - ② contentOrder
    private func demoContentOrder() {
        addSection("② contentOrder — 图文顺序")
        addNote("• contentOrder(.imageFirst)：图片在前（水平→图左文右，垂直→图上文下）\n• contentOrder(.titleFirst)：文字在前（水平→文左图右，垂直→文上图下）")

        let btn1 = makeBtn(title: "图左文右 (.imageFirst)", imageName: "chevron.right", bg: .systemGreen)
        btn1.axis(.horizontal).contentOrder(.imageFirst).spacing(8)
            .insets(UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)).radius(10)
        addDemo(btn1, height: 44)
        addCaption("contentOrder(.imageFirst)：水平，图片在左")

        let btn2 = makeBtn(title: "文左图右 (.titleFirst)", imageName: "chevron.right", bg: .systemOrange)
        btn2.axis(.horizontal).contentOrder(.titleFirst).spacing(8)
            .insets(UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)).radius(10)
        addDemo(btn2, height: 44)
        addCaption("contentOrder(.titleFirst)：水平，文字在左")

        let btn3 = makeBtn(title: "图上文下", imageName: "house.fill", bg: .systemPurple)
        btn3.axis(.vertical).contentOrder(.imageFirst).spacing(6)
            .insets(UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)).radius(12)
        addDemo(btn3)
        addCaption("axis(.vertical) + contentOrder(.imageFirst)：图上文下")

        let btn4 = makeBtn(title: "文上图下", imageName: "arrow.down.circle.fill", bg: .systemIndigo)
        btn4.axis(.vertical).contentOrder(.titleFirst).spacing(6)
            .insets(UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)).radius(12)
        addDemo(btn4)
        addCaption("axis(.vertical) + contentOrder(.titleFirst)：文上图下")

        addSeparator()
    }

    // MARK: - ③ align
    private func demoAlign() {
        addSection("③ horizontalAlign / verticalAlign — 对齐方式")
        addNote("水平排列时：\n• horizontalAlign 控制主轴（水平）对齐\n• verticalAlign 控制交叉轴（垂直）对齐\n\n可选值：.center（居中，默认）/ .start（靠起点）/ .end（靠终点）/ .fill（拉伸填充）")

        // horizontalAlign demo
        let aligns: [(ButtonAlign, String, UIColor)] = [
            (.start,  "horizontalAlign(.start)：内容靠左",   .systemBlue),
            (.center, "horizontalAlign(.center)：内容居中",  .systemGreen),
            (.end,    "horizontalAlign(.end)：内容靠右",     .systemOrange),
        ]
        for (align, caption, color) in aligns {
            let btn = makeBtn(title: "按钮文字", imageName: "star.fill", bg: color)
            btn.axis(.horizontal).spacing(8)
                .horizontalAlign(align)
                .verticalAlign(.center)
                .insets(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
                .radius(8)
            addDemo(btn, height: 44)
            addCaption(caption)
        }

        // verticalAlign demo (垂直排列时生效)
        addNote("垂直排列时 verticalAlign 控制主轴（垂直）对齐：")
        let vBtn = makeBtn(title: "文字", imageName: "photo.fill", bg: .systemTeal)
        vBtn.axis(.vertical).spacing(4).contentOrder(.imageFirst)
            .verticalAlign(.center)   // 内容在垂直方向居中
            .horizontalAlign(.center)   // 水平方向拉伸
            .imageSize(CGSize(width: 24, height: 24))
            .insets(UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
        addDemo(vBtn, height: 60)
        addCaption("axis(.vertical) + verticalAlign(.center) + horizontalAlign(.fill)")

        addSeparator()
    }

    // MARK: - ④ spacing / flexibleSpacing
    private func demoSpacing() {
        addSection("④ spacing / flexibleSpacing — 图文间距")
        addNote("• spacing(_ v: CGFloat)：图文之间固定间距（默认 4pt）\n• flexibleSpacing(_ v: Bool)：true 时图文之间插入弹性空间，图靠起点，文靠终点（或反之，取决于 contentOrder）")

        // 不同间距对比
        for sp in [0, 4, 12, 24] {
            let btn = makeBtn(title: "spacing(\(sp))", imageName: "star.fill", bg: .systemBlue)
            btn.axis(.horizontal).spacing(CGFloat(sp))
                .insets(UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)).radius(10)
            addDemo(btn, height: 44)
            addCaption("spacing(\(sp))：图文间距 \(sp)pt")
        }

        // flexibleSpacing
        let flexBtn = makeBtn(title: "弹性间距 flexibleSpacing(true)", imageName: "chevron.right", bg: .systemGreen)
        flexBtn.axis(.horizontal)
            .flexibleSpacing(true)
            .insets(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
            .radius(10)
        addDemo(flexBtn, height: 44)
        addCaption("flexibleSpacing(true)：图片靠左，文字靠右（弹性撑满中间）")

        addSeparator()
    }

    // MARK: - ⑤ insets
    private func demoInsets() {
        addSection("⑤ insets — 内容与边界的间距")
        addNote("insets: UIEdgeInsets 控制图文内容与按钮边界之间的间距，影响按钮的固有尺寸（intrinsicContentSize 基于 insets）。")

        let cases: [(UIEdgeInsets, String)] = [
            (.zero,                                     "insets = .zero：无内边距"),
            (UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20), "insets(10, 20, 10, 20)：上下10左右20"),
            (UIEdgeInsets(top: 4, left: 40, bottom: 4, right: 40),   "insets(4, 40, 4, 40)：上下小左右大"),
        ]
        for (inset, cap) in cases {
            let btn = makeBtn(title: "按钮", bg: .systemPurple)
            btn.insets(inset).radius(10)
            addDemo(btn)
            addCaption(cap)
        }

        addSeparator()
    }

    // MARK: - ⑥ imageSize / titleSize
    private func demoImageTitleSize() {
        addSection("⑥ imageSize / titleSize — 固定图片/文字尺寸")
        addNote("• imageSize(CGSize)：强制指定 imageView 的宽高（默认 (-1,-1) 表示不限制）\n• titleSize(CGSize)：强制指定 titleLabel 的宽高（-1 表示该方向不限制）")

        // imageSize
        let btn1 = makeBtn(title: "imageSize(16×16)", imageName: "star.fill", bg: .systemBlue)
        btn1.axis(.horizontal).imageSize(CGSize(width: 16, height: 16)).spacing(8)
            .insets(UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)).radius(10)
        addDemo(btn1, height: 44)
        addCaption("imageSize(16×16)：图片限制为 16pt")

        let btn2 = makeBtn(title: "imageSize(36×36)", imageName: "photo.fill", bg: .systemGreen)
        btn2.axis(.horizontal).imageSize(CGSize(width: 36, height: 36)).spacing(10)
            .insets(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)).radius(12)
        addDemo(btn2)
        addCaption("imageSize(36×36)：图片限制为 36pt")

        // titleSize
        let btn3 = makeBtn(title: "固定宽度文字区域", bg: .systemOrange)
        btn3.titleLabel?.numberOfLines = 0
        btn3.titleSize(CGSize(width: 80, height: -1))   // 宽度固定 80pt，高度自适应
            .insets(UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)).radius(10)
        addDemo(btn3)
        addCaption("titleSize(width:80, height:-1)：文字区域宽度固定为80，高度自适应（-1=不限制）")

        addSeparator()
    }

    // MARK: - ⑦ imageMarge / titleMarge
    private func demoImageTitleMarge() {
        addSection("⑦ imageMarge / titleMarge — 交叉轴方向偏移")
        addNote("• imageMarge(start: end:)：图片在交叉轴方向的额外偏移（start=顶部/左部，end=底部/右部）\n• titleMarge(start: end:)：文字在交叉轴方向的额外偏移\n两者均为普通方法（Void 返回），需单独调用（不在链式之内）。")

        // 图片下移，文字上移
        let btn1 = makeBtn(title: "图片偏下 / 文字偏上", imageName: "arrow.up.and.down", bg: .systemBrown)
        btn1.axis(.horizontal).spacing(10)
            .insets(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)).radius(10)
        btn1.imageMarge(start: 0, end: 8)   // 图片底部 +8pt（交叉轴 end 方向）
        btn1.titleMarge(start: 8, end: 0)   // 文字顶部 +8pt（交叉轴 start 方向）
        addDemo(btn1, height: 50)
        addCaption("imageMarge(start:0, end:8) + titleMarge(start:8, end:0)：图片偏下，文字偏上")

        // 图片上移，文字下移
        let btn2 = makeBtn(title: "图片偏上 / 文字偏下", imageName: "arrow.up.and.down", bg: .systemTeal)
        btn2.axis(.horizontal).spacing(10)
            .insets(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)).radius(10)
        btn2.imageMarge(start: 8, end: 0)
        btn2.titleMarge(start: 0, end: 8)
        addDemo(btn2, height: 50)
        addCaption("imageMarge(start:8, end:0) + titleMarge(start:0, end:8)：图片偏上，文字偏下")

        // 使用 StartEndInsets 直接赋属性
        addNote("也可直接设置 imageMarge / titleMarge 属性（StartEndInsets 结构体）：")
        let btn3 = makeBtn(title: "属性赋值方式", imageName: "star.fill", bg: .systemPink)
        btn3.axis(.horizontal).spacing(8)
            .insets(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)).radius(10)
        btn3.imageMarge = StartEndInsets(start: 4, end: 4)  // 直接设置属性
        btn3.titleMarge = StartEndInsets(start: 2, end: 6)
        addDemo(btn3, height: 50)
        addCaption("btn.imageMarge = StartEndInsets(start:4, end:4)：直接属性赋值")

        addSeparator()
    }

    // MARK: - ⑧ tapInterval
    private func demoTapInterval() {
        addSection("⑧ tapInterval — 防重复点击")
        addNote("tapInterval(_ v: CGFloat) 设置点击后的冷却时间（秒）。点击触发后 isUserInteractionEnabled 自动置为 false，延时后恢复。内部在 sendAction(_:to:for:) 中实现，对所有事件均生效。")

        let countLabel = UILabel()
        countLabel.text = "点击次数: 0"
        countLabel.font = .monospacedDigitSystemFont(ofSize: 16, weight: .medium)
        countLabel.textAlignment = .center
        addDemo(countLabel, height: 30)

        var count = 0
        let btn = makeBtn(title: "点我（tapInterval = 1.5s，快速连点无效）", bg: .systemRed)
        btn.tapInterval(1.5)
            .insets(UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
            .radius(10)
        if #available(iOS 14.0, *) {
            btn.addAction(UIAction { [weak countLabel] _ in
                count += 1
                countLabel?.text = "点击次数: \(count)"
            }, for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }
        addDemo(btn, height: 48)
        addCaption("tapInterval(1.5)：点击后 1.5s 内按钮 isUserInteractionEnabled=false，防止重复提交")

        // 对比：无限制按钮
        var count2 = 0
        let btn2 = makeBtn(title: "对比：无限制按钮", bg: .systemGray)
        btn2.insets(UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)).radius(10)
        let countLabel2 = UILabel()
        countLabel2.text = "点击次数: 0"
        countLabel2.font = .systemFont(ofSize: 14)
        countLabel2.textAlignment = .center
        if #available(iOS 14.0, *) {
            btn2.addAction(UIAction { [weak countLabel2] _ in
                count2 += 1
                countLabel2?.text = "点击次数: \(count2)"
            }, for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }
        addDemo(countLabel2, height: 24)
        addDemo(btn2, height: 44)
        addCaption("tapInterval(0) 无限制，快速连点每次均触发")

        addSeparator()
    }

    // MARK: - ⑨ touchAreaEdgeInsets
    private func demoTouchArea() {
        addSection("⑨ touchAreaEdgeInsets — 扩展点击热区")
        addNote("touchAreaEdgeInsets(UIEdgeInsets) 将点击响应区域向四周扩展，但视觉大小不变。内部重写 point(inside:with:) 实现，适合小图标按钮提升可点击性。")

        let container = UIView()
        container.backgroundColor = UIColor.systemGray.withAlphaComponent(0.08)
        container.layer.cornerRadius = 10
        container.clipsToBounds = true

        let btn = Button()
        btn.setTitle("小按钮（热区 +30pt）", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.touchAreaEdgeInsets(UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30))
        btn.addTarget(self, action: #selector(touchAreaTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(btn)
        NSLayoutConstraint.activate([
            btn.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            btn.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])
        addDemo(container, height: 100)
        addCaption("视觉小但热区大：点击中心区域外 30pt 范围内也可触发；适合图标按钮")

        addSeparator()
    }

    @objc private func touchAreaTapped() {
        print("[Button Demo] touchAreaEdgeInsets 点击触发！")
    }

    // MARK: - ⑩ imgTouchOnly
    private func demoImgTouchOnly() {
        addSection("⑩ imgTouchOnly — 仅图片区域响应点击")
        addNote("imgTouchOnly = true 时，point(inside:with:) 只判断 imageView 区域（可结合 touchAreaEdgeInsets 扩展图片热区）。适合图片+文字组合但只希望图片可点击的场景。")

        let btn = makeBtn(title: "点文字区域无效，点图片才触发", imageName: "hand.tap.fill", bg: .systemRed)
        btn.imgTouchOnly(true)
            .spacing(10)
            .insets(UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20))
            .radius(12)
        btn.addTarget(self, action: #selector(imgTouchOnlyTapped), for: .touchUpInside)
        addDemo(btn, height: 48)
        addCaption("imgTouchOnly(true)：只有 imageView 区域才响应 touch，点文字无效")

        addSeparator()
    }

    @objc private func imgTouchOnlyTapped() {
        print("[Button Demo] imgTouchOnly - 图片区域被点击！")
    }

    // MARK: - ⑪ ViewStyleable（继承 View 的样式能力）
    private func demoViewStyleable() {
        addSection("⑪ ViewStyleable — Button 的样式能力")
        addNote("Button 也遵循 ViewStyleable，可使用全部渐变/描边/阴影/圆角链式 API。")

        // 渐变 + 阴影
        let btn1 = makeBtn(title: "渐变 + 阴影 Button", imageName: "bolt.fill")
        btn1.gradColors([.systemOrange, .systemRed])
            .gradDirection(start: CGPoint(x: 0, y: 0.5), end: CGPoint(x: 1, y: 0.5))
            .shadowColor(color: .systemRed)
            .shadowOffset(w: 0, h: 5)
            .shadowRadius(radius: 10)
            .shadowOpacity(opacity: 0.35)
            .radius(22)
            .spacing(8)
            .insets(UIEdgeInsets(top: 14, left: 28, bottom: 14, right: 28))

        let wrap1 = UIView()
        wrap1.addSubview(btn1)
        btn1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btn1.topAnchor.constraint(equalTo: wrap1.topAnchor, constant: 10),
            btn1.centerXAnchor.constraint(equalTo: wrap1.centerXAnchor),
            btn1.bottomAnchor.constraint(equalTo: wrap1.bottomAnchor, constant: -10),
        ])
        addDemo(wrap1, height: 68)
        addCaption("gradColors + gradDirection + shadow* + radius：ViewStyleable 链式全组合")

        // 描边按钮
        let btn2 = Button()
        btn2.setTitle("描边按钮（Ghost Button）", for: .normal)
        btn2.setTitleColor(.systemBlue, for: .normal)
        btn2.backgroundColor = .white
        btn2.border(color: .systemBlue, w: 1.5)
            .radius(22)
            .insets(UIEdgeInsets(top: 12, left: 28, bottom: 12, right: 28))
        addDemo(btn2)
        addCaption("border(color: .systemBlue, w: 1.5) + radius(22)：描边幽灵按钮")

        // 渐变 + 描边 + 独立圆角
        let btn3 = Button()
        btn3.setTitle("渐变 + 描边 + 独立圆角", for: .normal)
        btn3.setTitleColor(.white, for: .normal)
        btn3.gradColors([.systemGreen, .systemTeal])
            .border(color: .white, w: 1.5)
            .cornerRadii(16, 0, 0, 16)
            .insets(UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20))
        addDemo(btn3, height: 48)
        addCaption("gradColors + border + cornerRadii(16,0,0,16)：左侧两角圆角")

        addSeparator()
        addNote("Button 完整 API 速查：\n• axis(.horizontal/.vertical) — 排列方向\n• contentOrder(.imageFirst/.titleFirst) — 图文顺序\n• verticalAlign(.center/.start/.end/.fill) — 垂直对齐\n• horizontalAlign(.center/.start/.end/.fill) — 水平对齐\n• spacing(CGFloat) — 图文间距\n• flexibleSpacing(Bool) — 弹性间距\n• insets(UIEdgeInsets) — 内容边距\n• imageSize(CGSize) / titleSize(CGSize) — 固定图文尺寸\n• imageMarge(start:end:) / titleMarge(start:end:) — 交叉轴偏移（Void方法）\n• tapInterval(CGFloat) — 防重复点击冷却时间\n• imgTouchOnly(Bool) — 仅图片区域响应点击\n• touchAreaEdgeInsets(UIEdgeInsets) — 扩展热区\n• 继承 ViewStyleable 全部样式 API")
    }
}
