//
//  ZLWrapperViewDemoVC.swift
//  ZLUIKitPlus_Example
//
//  WrapperView（ZLWrapperView）详细用法 Demo
//
//  WrapperView 继承自 View（因此也遵循 ViewStyleable），
//  专门用于「将任意 UIView 用内边距包裹」，避免手写 NSLayoutConstraint。
//
//  核心 API：
//  • static wrap(with view: UIView) -> WrapperView  — 工厂方法快速创建
//  • insets(_ top, _ leading, _ bottom, _ trailing) -> Self  — 设置内边距
//  • insetsZero() -> Self  — 内边距全零
//  • contentView: UIView?  — 弱引用指向被包裹的视图

import UIKit
import ZLUIKitPlus

class ZLWrapperViewDemoVC: ZLDemoBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "WrapperView Demo"
    }

    override func setupDemos() {
        demoWrapBasic()
        demoInsetsZero()
        demoDynamicInsets()
        demoViewStyleable()
        demoContentView()
        demoRealWorldCases()
    }

    // MARK: - ① wrap(with:) + insets
    private func demoWrapBasic() {
        addSection("① wrap(with:) + insets — 快速包裹")
        addNote("WrapperView.wrap(with: someView) 创建包裹器，链式调用 .insets(top, leading, bottom, trailing) 设置内边距。内部自动生成 NSLayoutConstraint，无需手写约束。")

        // 包裹 Label
        let label1 = UILabel()
        label1.text = "被 WrapperView 包裹的 UILabel"
        label1.textColor = .white
        let wrapper1 = WrapperView.wrap(with: label1)
            .insets(12, 20, 12, 20)   // top=12, leading=20, bottom=12, trailing=20
        wrapper1.backgroundColor = .systemBlue
        wrapper1.radius(10)
        addDemo(wrapper1)
        addCaption("WrapperView.wrap(with: label).insets(12, 20, 12, 20)：上下12，左右20")

        // 包裹多行 Label
        let label2 = UILabel()
        label2.text = "多行文字\n第二行内容\n第三行内容"
        label2.numberOfLines = 0
        label2.textColor = .systemGreen
        let wrapper2 = WrapperView.wrap(with: label2)
            .insets(16, 16, 16, 16)
        wrapper2.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
        wrapper2.radius(12)
        wrapper2.border(color: UIColor.systemGreen, w: 1)
        addDemo(wrapper2)
        addCaption("包裹多行 UILabel — 高度自动撑开")

        // 包裹 UIButton
        let btn = UIButton(type: .system)
        btn.setTitle("包裹的原生 UIButton", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        let wrapper3 = WrapperView.wrap(with: btn)
            .insets(8, 24, 8, 24)
        wrapper3.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.08)
        wrapper3.radius(20)
        wrapper3.border(color: UIColor.systemBlue, w: 1)
        addDemo(wrapper3)
        addCaption("WrapperView.wrap(with: UIButton).insets(8, 24, 8, 24)")

        addSeparator()
    }

    // MARK: - ② insetsZero
    private func demoInsetsZero() {
        addSection("② insetsZero() — 内边距全为零")
        addNote("insetsZero() 等价于 insets(0, 0, 0, 0)，contentView 与 WrapperView 四边完全重合。常用于需要统一圆角/背景但内容本身已有内边距的场景。")

        let label = UILabel()
        label.text = "insetsZero：contentView 与 WrapperView 边界重合"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        let wrapper = WrapperView.wrap(with: label)
            .insetsZero()
        wrapper.backgroundColor = .systemOrange
        wrapper.radius(10)
        addDemo(wrapper)
        addCaption("insetsZero()：上下左右均为 0")

        addSeparator()
    }

    // MARK: - ③ 动态修改 insets
    private func demoDynamicInsets() {
        addSection("③ 动态修改 insets")
        addNote("insets() 内部先 deactivate 旧约束再 activate 新约束，可以多次调用，新值会覆盖旧值，布局自动更新。")

        let innerLabel = UILabel()
        innerLabel.text = "点击按钮切换内边距大小"
        innerLabel.textAlignment = .center
        innerLabel.textColor = .white

        let wrapper = WrapperView.wrap(with: innerLabel)
            .insets(8, 16, 8, 16)    // 初始内边距
        wrapper.backgroundColor = .systemPurple
        wrapper.radius(10)
        addDemo(wrapper)

        let btn = UIButton(type: .system)
        btn.setTitle("▶ 切换 insets（小↔大）", for: .normal)
        btn.backgroundColor = .systemPurple.withAlphaComponent(0.15)
        btn.layer.cornerRadius = 8
        btn.clipsToBounds = true

        var isLarge = false
        if #available(iOS 14.0, *) {
            btn.addAction(UIAction { [weak wrapper] _ in
                isLarge.toggle()
                if isLarge {
                    wrapper?.insets(24, 48, 24, 48)  // 大内边距
                } else {
                    wrapper?.insets(8, 16, 8, 16)    // 小内边距
                }
            }, for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }
        addDemo(btn, height: 40)
        addCaption("多次调用 insets() 动态更新，内部自动处理约束生命周期")

        addSeparator()
    }

    // MARK: - ④ ViewStyleable 样式（继承自 View）
    private func demoViewStyleable() {
        addSection("④ ViewStyleable 样式（WrapperView 继承自 View）")
        addNote("WrapperView 继承自 View，因此也遵循 ViewStyleable，可使用全部样式链式 API。")

        // 渐变背景 + 圆角
        let l1 = UILabel()
        l1.text = "渐变背景 + 圆角"
        l1.textColor = .white
        l1.font = .boldSystemFont(ofSize: 15)
        let w1 = WrapperView.wrap(with: l1).insets(14, 20, 14, 20)
        w1.gradColors([UIColor.systemBlue, UIColor.systemPurple])
        w1.gradDirection(start: CGPoint(x: 0, y: 0.5), end: CGPoint(x: 1, y: 0.5))
        w1.radius(14)
        addDemo(w1)
        addCaption("gradColors + gradDirection + radius：WrapperView 也支持渐变")

        // 阴影卡片效果
        let l2 = UILabel()
        l2.text = "  阴影卡片效果"
        l2.textColor = .darkText
        l2.font = .systemFont(ofSize: 14)
        let w2 = WrapperView.wrap(with: l2).insets(16, 20, 16, 20)
        w2.backgroundColor = .white
        w2.radius(12)
        w2.shadowColor(color: UIColor.black)
        w2.shadowOffset(w: 0, h: 4)
        w2.shadowRadius(radius: 10)
        w2.shadowOpacity(opacity: 0.12)
        let padder = UIView()
        padder.addSubview(w2)
        w2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            w2.topAnchor.constraint(equalTo: padder.topAnchor, constant: 8),
            w2.leadingAnchor.constraint(equalTo: padder.leadingAnchor),
            w2.trailingAnchor.constraint(equalTo: padder.trailingAnchor),
            w2.bottomAnchor.constraint(equalTo: padder.bottomAnchor, constant: -8),
        ])
        addDemo(padder, height: 80)
        addCaption("backgroundColor + radius + shadow* — 阴影卡片样式")

        // 描边样式
        let l3 = UILabel()
        l3.text = "描边样式"
        l3.textColor = .systemGreen
        l3.font = .systemFont(ofSize: 14, weight: .medium)
        l3.textAlignment = .center
        let w3 = WrapperView.wrap(with: l3).insets(10, 24, 10, 24)
        w3.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.05)
        w3.border(color: UIColor.systemGreen, w: 1.5)
        w3.radius(20)
        addDemo(w3)
        addCaption("border(color:w:) + radius：描边样式")

        addSeparator()
    }

    // MARK: - ⑤ contentView 弱引用
    private func demoContentView() {
        addSection("⑤ contentView — 弱引用访问被包裹视图")
        addNote("WrapperView.contentView 是 weak var，指向传入 wrap(with:) 的那个视图。可以在外部通过 contentView 访问或修改被包裹的视图。")

        let innerLabel = UILabel()
        innerLabel.text = "通过 contentView 修改文字颜色"
        innerLabel.textColor = .darkText
        innerLabel.font = .systemFont(ofSize: 14)
        innerLabel.numberOfLines = 0

        let wrapper = WrapperView.wrap(with: innerLabel)
            .insets(12, 16, 12, 16)
        wrapper.backgroundColor = UIColor.systemGray.withAlphaComponent(0.05)
        wrapper.radius(10)
        wrapper.border(color: UIColor.systemGray4, w: 1)
        addDemo(wrapper)

        let btn = UIButton(type: .system)
        btn.setTitle("▶ 通过 wrapper.contentView 修改文字颜色", for: .normal)
        btn.backgroundColor = UIColor.systemGray.withAlphaComponent(0.1)
        btn.layer.cornerRadius = 8
        btn.clipsToBounds = true

        let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemOrange, .darkText]
        var colorIndex = 0
        if #available(iOS 14.0, *) {
            btn.addAction(UIAction { [weak wrapper] _ in
                (wrapper?.contentView as? UILabel)?.textColor = colors[colorIndex % colors.count]
                colorIndex += 1
            }, for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }
        addDemo(btn, height: 40)
        addCaption("wrapper.contentView as? UILabel — 通过弱引用访问被包裹视图并修改其属性")

        addSeparator()
    }

    // MARK: - ⑥ 实际应用场景
    private func demoRealWorldCases() {
        addSection("⑥ 实际应用场景")

        // 场景1：状态标签（成功/失败/警告）
        addNote("场景1 — 状态标签")
        let statusStack = UIStackView()
        statusStack.axis = .horizontal
        statusStack.spacing = 10
        statusStack.alignment = .center

        let statuses: [(String, UIColor)] = [
            ("✓ 成功", .systemGreen),
            ("✗ 失败", .systemRed),
            ("⚠ 警告", .systemOrange),
            ("● 进行中", .systemBlue),
        ]
        for (text, color) in statuses {
            let l = UILabel()
            l.text = text
            l.textColor = color
            l.font = .systemFont(ofSize: 12, weight: .medium)
            let w = WrapperView.wrap(with: l).insets(4, 10, 4, 10)
            w.backgroundColor = color.withAlphaComponent(0.1)
            w.border(color: color.withAlphaComponent(0.4), w: 1)
            w.radius(12)
            statusStack.addArrangedSubview(w)
        }
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        statusStack.addArrangedSubview(spacer)
        addDemo(statusStack, height: 36)
        addCaption("状态标签：wrap + insets(4,10,4,10) + border + radius(12)")

        // 场景2：卡片布局
        addNote("场景2 — 内容卡片")
        let cardContent = UIStackView()
        cardContent.axis = .vertical
        cardContent.spacing = 6

        let titleL = UILabel()
        titleL.text = "ZLUIKitPlus"
        titleL.font = .boldSystemFont(ofSize: 17)

        let descL = UILabel()
        descL.text = "轻量级 UIKit 扩展库，包含 Label / View / Button / WrapperView / PairView 等组件"
        descL.numberOfLines = 0
        descL.font = .systemFont(ofSize: 13)
        descL.textColor = .systemGray

        cardContent.addArrangedSubview(titleL)
        cardContent.addArrangedSubview(descL)

        let card = WrapperView.wrap(with: cardContent).insets(16, 16, 16, 16)
        card.backgroundColor = .white
        card.radius(14)
        card.shadowColor(color: UIColor.black)
        card.shadowOffset(w: 0, h: 3)
        card.shadowRadius(radius: 8)
        card.shadowOpacity(opacity: 0.08)

        let cardPadder = UIView()
        cardPadder.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: cardPadder.topAnchor, constant: 8),
            card.leadingAnchor.constraint(equalTo: cardPadder.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: cardPadder.trailingAnchor),
            card.bottomAnchor.constraint(equalTo: cardPadder.bottomAnchor, constant: -8),
        ])
        addDemo(cardPadder)
        addCaption("内容卡片：wrap(with: UIStackView) + insets(16,16,16,16) + shadow")

        addSeparator()
        addNote("WrapperView API 总结：\n• static wrap(with:) — 工厂方法，创建 WrapperView 并设置 contentView\n• insets(_ top, _ leading, _ bottom, _ trailing) -> Self — 设置四边内边距（可多次调用）\n• insetsZero() -> Self — 清零内边距\n• contentView: UIView? — 弱引用指向被包裹视图\n• 继承 View 所有 ViewStyleable 能力（渐变/描边/阴影/圆角）")
    }
}
