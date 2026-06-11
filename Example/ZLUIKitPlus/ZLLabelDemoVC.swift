//
//  ZLLabelDemoVC.swift
//  ZLUIKitPlus_Example
//
//  Label（ZLLabel）详细用法 Demo
//  核心特性：insets 属性 — 为 UILabel 添加内边距
//  - drawText(in:) 已重写，文字绘制区域自动缩进
//  - intrinsicContentSize 自动将 insets 计算在内
//  - sizeThatFits(_:) 同样适配 insets
//  - RTL（从右到左）布局下 left/right 自动翻转

import UIKit
import ZLUIKitPlus

class ZLLabelDemoVC: ZLDemoBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Label Demo"
    }

    override func setupDemos() {

        // ──────────────────────────────────────────
        // MARK: 1. 基础用法 — 上下左右各 10pt 内边距
        // ──────────────────────────────────────────
        addSection("① 基础内边距 insets")
        addNote("Label 新增 insets: UIEdgeInsets 属性。设置后文字会在四个方向各留出对应间距，视图尺寸也会自动撑开。")

        let label1 = Label()
        label1.text = "insets = UIEdgeInsets(top:10, left:10, bottom:10, right:10)"
        label1.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.4)
        label1.insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        label1.layer.cornerRadius = 8
        label1.clipsToBounds = true
        
        
       
        addDemo(label1)
        addCaption("四边各 10pt — Label 尺寸自动包含 insets")

        // ──────────────────────────────────────────
        // MARK: 2. 胶囊 Tag 样式 — 上下小、左右大
        // ──────────────────────────────────────────
        addSection("② 胶囊 Tag 样式")
        addNote("上下 4pt + 左右 16pt，配合 cornerRadius = 14 实现常见 Tag 胶囊效果。由于 intrinsicContentSize 已计算 insets，无需手动设置宽高。")

        let tagStack = UIStackView()
        tagStack.axis = .horizontal
        tagStack.spacing = 8
        tagStack.alignment = .center

        let tagTexts = ["新品", "热卖", "限时折扣", "FREE"]
        let tagColors: [UIColor] = [.systemRed, .systemOrange, .systemGreen, .systemBlue]
        for (i, text) in tagTexts.enumerated() {
            let tag = Label()
            tag.text = text
            tag.font = .systemFont(ofSize: 12, weight: .medium)
            tag.textColor = .white
            tag.backgroundColor = tagColors[i]
            tag.insets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
            tag.layer.cornerRadius = 12
            tag.clipsToBounds = true
            tagStack.addArrangedSubview(tag)
        }
        // 末尾填充空白
        let spacer = UIView()
        tagStack.addArrangedSubview(spacer)
        addDemo(tagStack, height: 32)
        addCaption("insets(4, 12, 4, 12) + cornerRadius：胶囊 Tag，intrinsicContentSize 自动撑开，无需固定宽度")

        // ──────────────────────────────────────────
        // MARK: 3. 不对称内边距 — 左边距大
        // ──────────────────────────────────────────
        addSection("③ 不对称内边距（左缩进）")
        addNote("left 设 30pt，其余 8pt，模拟带图标前缀的文字行（图标位置由左 insets 预留）。")

        let label3 = Label()
        label3.text = "★  左侧预留 30pt 给图标  左边距 = 30pt"
        label3.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.1)
        label3.insets = UIEdgeInsets(top: 8, left: 30, bottom: 8, right: 8)
        label3.layer.cornerRadius = 8
        label3.clipsToBounds = true
        addDemo(label3)
        addCaption("insets(top:8, left:30, bottom:8, right:8)：左侧大缩进预留图标空间")

        // ──────────────────────────────────────────
        // MARK: 4. 多行文字 + insets
        // ──────────────────────────────────────────
        addSection("④ 多行文字 + insets")
        addNote("numberOfLines = 0 时，insets 同样正常工作。intrinsicContentSize 和 sizeThatFits 都会减去左右 insets 后计算文字换行，再加回来作为总尺寸。")

        let label4 = Label()
        label4.text = "多行 Label 演示：这是一段比较长的文字内容，用来演示 Label 在多行显示时，insets 属性依然正确生效。上下左右各留了 12pt 的内边距，整体高度由文字行数自动撑开，无需手动设置 heightAnchor。"
        label4.numberOfLines = 0
        label4.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.12)
        label4.insets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        label4.layer.cornerRadius = 10
        label4.clipsToBounds = true
        addDemo(label4)
        addCaption("numberOfLines=0 + insets — 高度自动撑开，无需 heightAnchor")

        // ──────────────────────────────────────────
        // MARK: 5. 仅上下内边距
        // ──────────────────────────────────────────
        addSection("⑤ 仅垂直方向内边距")
        addNote("left = 0, right = 0，只在垂直方向加间距，适合列表行的标题 Label 增加点击热区高度。")

        let label5 = Label()
        label5.text = "仅垂直方向留白 top=12, bottom=12"
        label5.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.15)
        label5.insets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        label5.layer.cornerRadius = 6
        label5.clipsToBounds = true
        addDemo(label5)
        addCaption("insets(top:12, left:0, bottom:12, right:0)：仅垂直方向留白")

        // ──────────────────────────────────────────
        // MARK: 6. insets 变更后自动刷新
        // ──────────────────────────────────────────
        addSection("⑥ insets 动态修改")
        addNote("insets 为 stored property，赋值后内部调用 invalidateIntrinsicContentSize() + setNeedsDisplay()，布局自动刷新，无需手动触发。")

        let label6 = Label()
        label6.text = "初始 insets = .zero，点击按钮切换到 (16, 24, 16, 24)"
        label6.numberOfLines = 0
        label6.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.15)
        label6.layer.cornerRadius = 8
        label6.clipsToBounds = true

        let toggleBtn = UIButton(type: .system)
        toggleBtn.setTitle("▶ 切换 insets", for: .normal)
        toggleBtn.backgroundColor = .systemOrange
        toggleBtn.setTitleColor(.white, for: .normal)
        toggleBtn.layer.cornerRadius = 8
        toggleBtn.clipsToBounds = true

        var isLargeInsets = false
        if #available(iOS 14.0, *) {
            toggleBtn.addAction(UIAction { [weak label6] _ in
                isLargeInsets.toggle()
                label6?.insets = isLargeInsets
                ? UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
                : .zero
            }, for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }

        addDemo(label6)
        addDemo(toggleBtn, height: 40)
        addCaption("insets 赋值后自动调用 invalidateIntrinsicContentSize，布局即时刷新")

        // ──────────────────────────────────────────
        // MARK: 7. RTL 自动适配说明
        // ──────────────────────────────────────────
        addSection("⑦ RTL（从右到左）自动适配")
        addNote("当 effectiveUserInterfaceLayoutDirection == .rightToLeft 时，Label 内部的 effectiveInsets 会自动将 left 和 right 互换，保证语义正确（leading/trailing 语义），无需外部特殊处理。")

        let label7 = Label()
        label7.text = "insets.left = 40（左边大缩进），RTL 布局下自动变为右边大缩进"
        label7.numberOfLines = 0
        label7.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.1)
        label7.insets = UIEdgeInsets(top: 8, left: 40, bottom: 8, right: 8)
        label7.layer.cornerRadius = 8
        label7.clipsToBounds = true
        addDemo(label7)
        addCaption("effectiveInsets 根据 effectiveUserInterfaceLayoutDirection 自动翻转 left/right")

        addSeparator()
        addNote("Label API 总结：\n• insets: UIEdgeInsets — 读写属性，赋值后自动刷新布局\n• drawText(in:) — 重写，绘制区域自动应用 insets\n• intrinsicContentSize — 重写，返回值包含 insets 宽高\n• sizeThatFits(_ size:) — 重写，计算适配尺寸时减去 insets 再计算，最后加回")
    }
}
