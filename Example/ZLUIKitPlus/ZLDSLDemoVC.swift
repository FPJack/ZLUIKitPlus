/**
 ZLDSLDemoVC.swift
 ZLUIKitPlus DSL 完整用法演示

 章节：
 ① 通用属性     bgColor / alpha / hidden / radius / corner / masksToBounds / tintColor / contentMode / tag
 ② 边框 & 阴影  border / borderColor / borderWidth / shadow系列
 ③ 手势         tapAction
 ④ 布局优先级   compression / hugging
 ⑤ Label 专属   text / textColor / font / numberOfLines / singleLine / multipleLines / twoLines / attributedText / adjustsFontSizeToFitWidth / shadowColor / shadowOffset
 ⑥ UIButton 专属 title / titleColor / font / fontSize / image / selected / enabled
 ⑦ UIImageView  image / contentMode
 ⑧ UISwitch     setOn / onTintColor / thumbTintColor
 ⑨ UITextField  placeholder / textColor / borderStyle / isSecureTextEntry / clearButtonMode
 ⑩ flex 布局    spacing / align / margin / flex / width / height / size / square / minWidth / maxWidth / isFlexibleSpace
 ⑪ dStyle 动态装饰  when(match) / when(value) / otherwise / sendValue / bind(Combine)
 ⑫ apply        dsl + dStyle + flex 同时配置
 */

import UIKit
import ZLUIKitPlus
import ZLFlexKit
import Combine

final class ZLDSLDemoVC: UIViewController {

    // MARK: - scroll container
    private let scroll = UIScrollView()
    private let stack  = UIStackView()

    // Combine
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DSL 用法 Demo"
        view.backgroundColor = UIColor.systemBackground

        setupScroll()
        buildSections()
    }

    // MARK: - layout
    private func setupScroll() {
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -40),
            stack.widthAnchor.constraint(equalTo: scroll.widthAnchor),
        ])
    }

    // MARK: - helpers
    private func addSection(_ title: String) {
        let bg = UIView()
        bg.backgroundColor = UIColor.systemGray6
        let lb = UILabel()
        lb.text = title
        lb.font = .systemFont(ofSize: 13, weight: .bold)
        lb.textColor = UIColor.systemGray
        lb.translatesAutoresizingMaskIntoConstraints = false
        bg.addSubview(lb)
        NSLayoutConstraint.activate([
            lb.leadingAnchor.constraint(equalTo: bg.leadingAnchor, constant: 16),
            lb.trailingAnchor.constraint(equalTo: bg.trailingAnchor, constant: -16),
            lb.topAnchor.constraint(equalTo: bg.topAnchor, constant: 10),
            lb.bottomAnchor.constraint(equalTo: bg.bottomAnchor, constant: -10),
        ])
        stack.addArrangedSubview(bg)
    }

    private func addPad(_ height: CGFloat = 16) {
        let sp = UIView()
        sp.translatesAutoresizingMaskIntoConstraints = false
        sp.heightAnchor.constraint(equalToConstant: height).isActive = true
        stack.addArrangedSubview(sp)
    }

    /// 把单个演示 view 包进带说明的容器，加入主 stack
    private func addDemo(note: String, view demoView: UIView) {
        let container = UIView()
        let note_lb = UILabel()
        note_lb.text = note
        note_lb.font = .systemFont(ofSize: 12)
        note_lb.textColor = UIColor.secondaryLabel
        note_lb.numberOfLines = 0
        note_lb.translatesAutoresizingMaskIntoConstraints = false
        demoView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(note_lb)
        container.addSubview(demoView)
        NSLayoutConstraint.activate([
            note_lb.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
            note_lb.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            note_lb.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            demoView.topAnchor.constraint(equalTo: note_lb.bottomAnchor, constant: 8),
            demoView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            demoView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
        ])
        stack.addArrangedSubview(container)
    }

    /// 多个 view 横排
    private func addRow(note: String, views: [UIView]) {
        let container = UIView()
        let note_lb = UILabel()
        note_lb.text = note
        note_lb.font = .systemFont(ofSize: 12)
        note_lb.textColor = UIColor.secondaryLabel
        note_lb.numberOfLines = 0
        note_lb.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(note_lb)
        NSLayoutConstraint.activate([
            note_lb.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
            note_lb.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            note_lb.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
        ])
        var prevAnchor = note_lb.bottomAnchor
        var prevLeading = container.leadingAnchor
        for (i, v) in views.enumerated() {
            v.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(v)
            NSLayoutConstraint.activate([
                v.topAnchor.constraint(equalTo: prevAnchor, constant: 8),
                v.leadingAnchor.constraint(equalTo: prevLeading, constant: 16),
            ])
            if i == views.count - 1 {
                v.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12).isActive = true
            }
            prevLeading = v.trailingAnchor
            prevAnchor  = note_lb.bottomAnchor
        }
        stack.addArrangedSubview(container)
    }

    // MARK: ─────────────────────────────────────────
    // MARK: 组装所有章节
    // MARK: ─────────────────────────────────────────
    private func buildSections() {
        demo01_CommonProps()
        demo02_BorderShadow()
        demo03_TapAction()
        demo04_ContentPriority()
        demo05_Label()
        demo06_Button()
        demo07_ImageView()
        demo08_Switch()
        demo09_TextField()
        demo10_FlexLayout()
        demo11_DynamicStyle()
        demo12_Apply()
    }

    // MARK: ① 通用属性
    private func demo01_CommonProps() {
        addSection("① 通用属性  bgColor / alpha / hidden / radius / corner / masksToBounds / tintColor / tag")

        // bgColor + radius + masksToBounds
        let v1 = UIView()
        v1.dsl
            .bgColor(UIColor.systemBlue)
            .radius(16)
            .masksToBounds()
            .size(w: 80, h: 40)
       
        addDemo(note: "bgColor(.systemBlue)  radius(16)  masksToBounds()", view: v1)

        // alpha
        let v2 = UIView()
        v2.dsl
            .bgColor(UIColor.systemRed)
            .radius(12)
            .alpha(0.4)
        v2.widthAnchor.constraint(equalToConstant: 80).isActive = true
        v2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addDemo(note: "alpha(0.4) — 半透明", view: v2)

        // hidden(false) — 显示
        let v3 = UIView()
        v3.dsl
            .bgColor(UIColor.systemGreen)
            .radius(12)
            .hidden(false)   // 明确可见
        v3.widthAnchor.constraint(equalToConstant: 80).isActive = true
        v3.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addDemo(note: "hidden(false) — 明确设置为可见", view: v3)

        // corner — 仅指定角
        let v4 = UIView()
        v4.dsl
            .bgColor(UIColor.systemOrange)
            .corner([.layerMinXMinYCorner, .layerMaxXMaxYCorner], radius: 20)
            .masksToBounds()
        v4.widthAnchor.constraint(equalToConstant: 80).isActive = true
        v4.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addDemo(note: "corner([.topLeft, .bottomRight], radius:20) — 对角圆角", view: v4)

        // tintColor
        let img = UIImageView(image: UIImage(systemName: "star.fill"))
        img.dsl
            .tintColor(UIColor.systemPurple)
            .contentMode(.scaleAspectFit)
        img.widthAnchor.constraint(equalToConstant: 36).isActive = true
        img.heightAnchor.constraint(equalToConstant: 36).isActive = true
        addDemo(note: "tintColor(.systemPurple) — 系统图标着色", view: img)

        // tag
        let tagView = UIView()
        tagView.dsl
            .bgColor(UIColor.systemTeal)
            .radius(8)
            .tag(101)
        tagView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        tagView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addDemo(note: "tag(101) — 设置 tag，tag=\(tagView.tag)", view: tagView)
    }

    // MARK: ② 边框 & 阴影
    private func demo02_BorderShadow() {
        addSection("② 边框 & 阴影  border / borderColor / borderWidth / shadowColor / shadowOffset / shadowRadius / shadowOpacity")

        // border 一次性设置
        let v1 = UIView()
        v1.dsl
            .bgColor(UIColor.white)
            .border(color: UIColor.systemBlue, w: 2)
            .radius(10)
            .masksToBounds()
        v1.widthAnchor.constraint(equalToConstant: 100).isActive = true
        v1.heightAnchor.constraint(equalToConstant: 44).isActive = true
        addDemo(note: "border(color:.systemBlue, w:2) — 一步设置颜色+宽度", view: v1)

        // borderColor + borderWidth 分步
        let v2 = UIView()
        v2.dsl
            .bgColor(UIColor.white)
            .borderColor(color: UIColor.systemRed)
            .borderWidth(w: 1.5)
            .radius(10)
            .masksToBounds()
        v2.widthAnchor.constraint(equalToConstant: 100).isActive = true
        v2.heightAnchor.constraint(equalToConstant: 44).isActive = true
        addDemo(note: "borderColor() + borderWidth() — 分步设置", view: v2)

        // shadow
        let v3 = UIView()
        v3.dsl
            .bgColor(UIColor.white)
            .radius(12)
            .shadowColor(color: UIColor.black)
            .shadowOffset(w: 0, h: 4)
            .shadowRadius(radius: 8)
            .shadowOpacity(opacity: 0.2)
        v3.widthAnchor.constraint(equalToConstant: 120).isActive = true
        v3.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addDemo(note: "shadow — color + offset + radius + opacity", view: v3)
    }

    // MARK: ③ 手势
    private func demo03_TapAction() {
        addSection("③ 手势  tapAction")

        let lb = Label()
        lb.dsl
            .text("点我 👆")
            .textColor(UIColor.white)
            .font(15, weight: .semibold)
            .bgColor(UIColor.systemIndigo)
            .radius(10)
            .masksToBounds()
            .tapAction { [weak lb] _ in
                lb?.text = "已点击 ✅"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    lb?.text = "点我 👆"
                }
            }
        lb.textAlignment = .center
        lb.widthAnchor.constraint(equalToConstant: 120).isActive = true
        lb.heightAnchor.constraint(equalToConstant: 44).isActive = true
        addDemo(note: "tapAction — 链式添加点击回调", view: lb)
    }

    // MARK: ④ 布局优先级
    private func demo04_ContentPriority() {
        addSection("④ 布局优先级  compression / hugging")

        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 8

        // 高 hugging — 不拉伸
        let l1 = UILabel()
        l1.dsl
            .text("不拉伸")
            .textColor(UIColor.white)
            .font(13)
            .bgColor(UIColor.systemGreen)
            .radius(6)
            .masksToBounds()
            .hugging(.required, for: .horizontal)
        l1.textAlignment = .center
        l1.heightAnchor.constraint(equalToConstant: 32).isActive = true

        // 低 hugging — 填满剩余空间
        let l2 = UILabel()
        l2.dsl
            .text("自动填满 ←→")
            .textColor(UIColor.white)
            .font(13)
            .bgColor(UIColor.systemOrange)
            .radius(6)
            .masksToBounds()
            .hugging(.defaultLow, for: .horizontal)
            .compression(.required, for: .horizontal)
        l2.textAlignment = .center
        l2.heightAnchor.constraint(equalToConstant: 32).isActive = true

        [l1, l2].forEach { row.addArrangedSubview($0) }
        row.heightAnchor.constraint(equalToConstant: 32).isActive = true
        addDemo(note: "hugging(.required) = 不拉伸  hugging(.defaultLow) = 填满", view: row)
    }

    // MARK: ⑤ Label 专属
    private func demo05_Label() {
        addSection("⑤ Label 专属  text / textColor / font / numberOfLines / singleLine / multipleLines / twoLines / attributedText / adjustsFontSizeToFitWidth / shadowColor / shadowOffset")

        // text + font + textColor
        let l1 = Label()
        l1.dsl
            .text("Hello DSL", color: UIColor.systemBlue, fontSize: 18)
        addDemo(note: "text(_:color:fontSize:) — 一步设置文本+颜色+字号", view: l1)

        // font weight
        let l2 = Label()
        l2.dsl
            .text("粗体 Semibold 16pt")
            .font(16, weight: .semibold)
            .textColor(UIColor.label)
        addDemo(note: "font(_ size: CGFloat, weight:) — 字号+字重", view: l2)

        // singleLine vs multipleLines
        let l3 = Label()
        l3.dsl
            .text("这是一段很长的文字，singleLine 截断 —— 超出部分用省略号表示，不换行")
            .singleLine()
            .textColor(UIColor.label)
            .font(14)
        l3.widthAnchor.constraint(equalToConstant: 300).isActive = true
        addDemo(note: "singleLine() — 单行截断", view: l3)

        let l4 = Label()
        l4.dsl
            .text("这是一段很长的文字，multipleLines 允许换行\n第二行 / 第三行都可以显示出来")
            .multipleLines()
            .textColor(UIColor.label)
            .font(14)
        l4.widthAnchor.constraint(equalToConstant: 260).isActive = true
        addDemo(note: "multipleLines() — 不限行数", view: l4)

        let l5 = Label()
        l5.dsl
            .text("这是三行以上内容，twoLines 仅显示两行，超出截断")
            .twoLines()
            .textColor(UIColor.label)
            .font(14)
        l5.widthAnchor.constraint(equalToConstant: 240).isActive = true
        addDemo(note: "twoLines() — 最多两行", view: l5)

        // numberOfLines
        let l6 = Label()
        l6.dsl
            .text("numberOfLines(3) — 限定三行")
            .numberOfLines(3)
            .font(14)
            .textColor(UIColor.label)
        addDemo(note: "numberOfLines(3) — 手动指定行数", view: l6)

        // adjustsFontSizeToFitWidth
        let l7 = Label()
        l7.dsl
            .text("字号自动缩小以适应宽度 adjustsFontSizeToFitWidth")
            .singleLine()
            .font(20)
            .textColor(UIColor.systemPurple)
            .adjustsFontSizeToFitWidth(true)
        l7.widthAnchor.constraint(equalToConstant: 200).isActive = true
        addDemo(note: "adjustsFontSizeToFitWidth(true) — 超宽自动缩字号", view: l7)

        // attributedText
        let attr = NSMutableAttributedString(string: "红色 + 删除线 + 蓝色")
        attr.addAttribute(.foregroundColor, value: UIColor.systemRed, range: NSRange(location: 0, length: 3))
        attr.addAttribute(.strikethroughStyle, value: 2, range: NSRange(location: 5, length: 3))
        attr.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: NSRange(location: 9, length: 3))
        let l8 = Label()
        l8.dsl
            .attributedText(attr)
            .font(15)
        addDemo(note: "attributedText — 富文本（多色+删除线）", view: l8)

        // shadowColor + shadowOffset
        let l9 = Label()
        l9.dsl
            .text("文字阴影 Shadow")
            .font(20, weight: .bold)
            .textColor(UIColor.systemIndigo)
            .shadowColor(UIColor.black.withAlphaComponent(0.3))
            .shadowOffset(w: 1, h: 2)
        addDemo(note: "shadowColor + shadowOffset — 文字阴影", view: l9)
    }

    // MARK: ⑥ UIButton 专属
    private func demo06_Button() {
        addSection("⑥ UIButton 专属  title / titleColor / font / fontSize / image / selected / enabled / addTarget")

        // title + titleColor + fontSize
        let b1 = UIButton(type: .system)
        b1.dsl
            .title("普通按钮")
            .titleColor(UIColor.white)
            .fontSize(15)
            .bgColor(UIColor.systemBlue)
            .radius(10)
            .masksToBounds()
        b1.widthAnchor.constraint(equalToConstant: 120).isActive = true
        b1.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addDemo(note: "title + titleColor + fontSize", view: b1)

        // selected 状态
        let b2 = UIButton(type: .system)
        b2.dsl
            .title("未选中", for: .normal)
            .title("已选中 ✓", for: .selected)
            .titleColor(UIColor.systemGray, for: .normal)
            .titleColor(UIColor.systemGreen, for: .selected)
            .fontSize(14)
            .bgColor(UIColor.systemGray6)
            .radius(10)
            .masksToBounds()
            .selected(true)   // 初始为 selected
            .tapAction { btn in
                btn.isSelected.toggle()
            }
        b2.widthAnchor.constraint(equalToConstant: 140).isActive = true
        b2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addDemo(note: "selected(true) — 初始选中态，点击切换", view: b2)

        // enabled(false)
        let b3 = UIButton(type: .system)
        b3.dsl
            .title("不可点击")
            .titleColor(UIColor.systemGray3, for: .disabled)
            .fontSize(14)
            .bgColor(UIColor.systemGray5)
            .radius(10)
            .masksToBounds()
            .enabled(false)
        b3.widthAnchor.constraint(equalToConstant: 120).isActive = true
        b3.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addDemo(note: "enabled(false) — 禁用状态", view: b3)

        // image + backgroundImage
        let b4 = UIButton(type: .system)
        b4.dsl
            .image(UIImage(systemName: "heart.fill"), for: .normal)
            .title(" 收藏")
            .titleColor(UIColor.systemPink)
            .fontSize(14)
            .tintColor(UIColor.systemPink)
            .bgColor(UIColor.systemPink.withAlphaComponent(0.1))
            .radius(10)
            .masksToBounds()
        b4.widthAnchor.constraint(equalToConstant: 100).isActive = true
        b4.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addDemo(note: "image(_:for:) — 设置图标", view: b4)
    }

    // MARK: ⑦ UIImageView 专属
    private func demo07_ImageView() {
        addSection("⑦ UIImageView 专属  image / contentMode / url")

        let iv1 = UIImageView()
        iv1.dsl
            .image(UIImage(systemName: "photo.fill"))
            .tintColor(UIColor.systemBlue)
            .contentMode(.scaleAspectFit)
            .bgColor(UIColor.systemGray6)
            .radius(12)
            .masksToBounds()
        iv1.widthAnchor.constraint(equalToConstant: 80).isActive = true
        iv1.heightAnchor.constraint(equalToConstant: 80).isActive = true
        addDemo(note: "image(_:)  contentMode(.scaleAspectFit)", view: iv1)

        let iv2 = UIImageView()
        iv2.dsl
            .image(UIImage(systemName: "person.crop.circle.fill"))
            .tintColor(UIColor.systemPurple)
            .contentMode(.scaleAspectFill)
            .bgColor(UIColor.systemPurple.withAlphaComponent(0.1))
            .radius(40)
            .masksToBounds()
        iv2.widthAnchor.constraint(equalToConstant: 80).isActive = true
        iv2.heightAnchor.constraint(equalToConstant: 80).isActive = true
        addDemo(note: "radius(40) + masksToBounds() — 圆形头像", view: iv2)

        // url 演示（需要 SDWebImage）
        let iv3 = UIImageView()
        iv3.dsl
            .url("https://picsum.photos/80", placeholder: UIImage(systemName: "photo"))
            .contentMode(.scaleAspectFill)
            .radius(8)
            .masksToBounds()
        iv3.widthAnchor.constraint(equalToConstant: 80).isActive = true
        iv3.heightAnchor.constraint(equalToConstant: 80).isActive = true
        addDemo(note: "url(_:placeholder:) — 网络图片（需配置 imageLoader）", view: iv3)
    }

    // MARK: ⑧ UISwitch
    private func demo08_Switch() {
        addSection("⑧ UISwitch  setOn / onTintColor / thumbTintColor")

        let sw1 = UISwitch()
        sw1.dsl
            .setOn(true, animated: false)
            .onTintColor(UIColor.systemGreen)
            .thumbTintColor(UIColor.white)
        addDemo(note: "setOn(true)  onTintColor(.systemGreen)  thumbTintColor(.white)", view: sw1)

        let sw2 = UISwitch()
        sw2.dsl
            .setOn(false, animated: false)
            .onTintColor(UIColor.systemOrange)
            .thumbTintColor(UIColor.systemYellow)
        addDemo(note: "setOn(false)  onTintColor(.systemOrange)  thumbTintColor(.systemYellow)", view: sw2)
    }

    // MARK: ⑨ UITextField
    private func demo09_TextField() {
        addSection("⑨ UITextField  text / placeholder / textColor / font / borderStyle / isSecureTextEntry / clearButtonMode / leftView")

        let tf1 = UITextField()
        tf1.dsl
            .placeholder("请输入用户名")
            .textColor(UIColor.label)
            .fontSize(15)
            .borderStyle(.roundedRect)
            .clearButtonMode(.whileEditing)
        tf1.widthAnchor.constraint(equalToConstant: 260).isActive = true
        addDemo(note: "placeholder + borderStyle(.roundedRect) + clearButtonMode", view: tf1)

        let tf2 = UITextField()
        tf2.dsl
            .placeholder("请输入密码")
            .textColor(UIColor.label)
            .fontSize(15)
            .borderStyle(.roundedRect)
            .isSecureTextEntry(true)
        tf2.widthAnchor.constraint(equalToConstant: 260).isActive = true
        addDemo(note: "isSecureTextEntry(true) — 密码输入框", view: tf2)

        // leftView 图标
        let tf3 = UITextField()
        let iconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconView.tintColor = UIColor.systemGray
        iconView.frame = CGRect(x: 0, y: 0, width: 32, height: 20)
        iconView.contentMode = .scaleAspectFit
        tf3.dsl
            .placeholder("搜索")
            .fontSize(15)
            .borderStyle(.roundedRect)
            .leftView(iconView, mode: .always)
        tf3.widthAnchor.constraint(equalToConstant: 260).isActive = true
        addDemo(note: "leftView(_:mode:) — 左侧图标", view: tf3)
    }

    // MARK: ⑩ flex 布局属性（在 StackView 中使用）
    private func demo10_FlexLayout() {
        addSection("⑩ flex 布局  spacing / align / margin / flex / width / height / size / square / minWidth / maxWidth / isFlexibleSpace")

        // flex(1) — 按比例分配宽度
        let hStack = HStackView {
            let v1 = UIView()
            v1.dsl
                .bgColor(UIColor.systemBlue)
                .flex(1)       // 占 1 份
            v1

            let v2 = UIView()
            v2.dsl
                .bgColor(UIColor.systemOrange)
                .flex(2)       // 占 2 份
            v2

            let v3 = UIView()
            v3.dsl
                .bgColor(UIColor.systemGreen)
                .flex(1)       // 占 1 份
            v3
        }
        hStack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        hStack.widthAnchor.constraint(equalToConstant: 300).isActive = true
        addDemo(note: "flex(1):flex(2):flex(1) — 按比例 1:2:1 分配宽度", view: hStack)

        // fixed size — width / height / size / square
        let hStack2 = HStackView {
            let v1 = UIView()
            v1.dsl
                .bgColor(UIColor.systemPurple)
                .size(w: 60, h: 36)   // 固定宽高
            v1

            let v2 = UIView()
            v2.dsl
                .bgColor(UIColor.systemTeal)
                .square(36)           // 正方形
            v2

            let v3 = UIView()
            v3.dsl
                .bgColor(UIColor.systemRed)
                .width(80)
                .height(36)           // 宽 + 高分开
            v3
        }
        hStack2.spacing = 8
        addDemo(note: "size(w:h:) / square(_) / width+height — 固定尺寸", view: hStack2)

        // minWidth / maxWidth
        let hStack3 = HStackView {
            let v1 = UIView()
            v1.dsl
                .bgColor(UIColor.systemYellow)
                .minWidth(60)    // 最小 60
                .maxWidth(120)   // 最大 120
                .height(36)
                .flex(1)
            v1

            let v2 = UIView()
            v2.dsl
                .bgColor(UIColor.systemOrange)
                .minWidth(60)
                .maxWidth(120)
                .height(36)
                .flex(1)
            v2
        }
        hStack3.widthAnchor.constraint(equalToConstant: 300).isActive = true
        addDemo(note: "minWidth + maxWidth — 限定弹性宽度区间", view: hStack3)

        // spacing + margin
        let hStack4 = HStackView {
            let v1 = UIView()
            v1.dsl
                .bgColor(UIColor.systemGreen)
                .size(w: 44, h: 44)
                .spacing(16)     // 后面间距 16
            v1

            let v2 = UIView()
            v2.dsl
                .bgColor(UIColor.systemBlue)
                .size(w: 44, h: 44)
                .margin(t: 8, s: 0, b: 8, e: 0)   // 上下内缩 8
            v2

            let v3 = UIView()
            v3.dsl
                .bgColor(UIColor.systemRed)
                .size(w: 44, h: 44)
            v3
        }
        addDemo(note: "spacing(16) — 后置间距  margin(t:s:b:e:) — 外边距", view: hStack4)

        // align — 交叉轴对齐
        let hStack5 = HStackView {
            let v1 = UILabel()
            v1.dsl
                .text("start")
                .textColor(UIColor.white)
                .bgColor(UIColor.systemBlue)
                .radius(6)
                .align(.start)   // 靠上
                .height(28)
            v1

            let v2 = UILabel()
            v2.dsl
                .text("center")
                .textColor(UIColor.white)
                .bgColor(UIColor.systemOrange)
                .radius(6)
                .align(.center)  // 居中
                .height(28)
            v2

            let v3 = UILabel()
            v3.dsl
                .text("end")
                .textColor(UIColor.white)
                .bgColor(UIColor.systemGreen)
                .radius(6)
                .align(.end)     // 靠下
                .height(28)
            v3

            let v4 = UILabel()
            v4.dsl
                .text("fill")
                .textColor(UIColor.white)
                .bgColor(UIColor.systemRed)
                .radius(6)
                .align(.fill)    // 填满
            v4
        }
        hStack5.spacing = 8
        hStack5.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addDemo(note: "align — .start / .center / .end / .fill 交叉轴对齐", view: hStack5)

        // isFlexibleSpace
        let hStack6 = HStackView {
            let l1 = UILabel()
            l1.dsl
                .text("左侧")
                .font(14)
                .textColor(UIColor.label)
            l1

            let sp = UIView()
            sp.dsl.isFlexibleSpace(true)   // 弹性空白，推开右侧
            sp

            let l2 = UILabel()
            l2.dsl
                .text("右侧")
                .font(14)
                .textColor(UIColor.label)
            l2
        }
        hStack6.widthAnchor.constraint(equalToConstant: 300).isActive = true
        addDemo(note: "isFlexibleSpace(true) — 弹性空白，推右侧到末端", view: hStack6)
    }

    // MARK: ⑪ dStyle 动态装饰
    private func demo11_DynamicStyle() {
        addSection("⑪ dStyle 动态装饰  when(match) / when(value) / otherwise / sendValue / bind(Combine)")

        // 1. when(value) + sendValue — 枚举状态驱动样式
        enum OrderState { case pending, paid, done }

        let stateLab = Label()
        stateLab.dsl
            .text("待支付")
            .textColor(UIColor.white)
            .font(14, weight: .semibold)
            .radius(8)
            .masksToBounds()

        stateLab.dsl
            .when(OrderState.pending) { lab, _ in
                lab.text = "待支付"
                lab.backgroundColor = UIColor.systemOrange
            }
            .when(OrderState.paid) { lab, _ in
                lab.text = "已支付"
                lab.backgroundColor = UIColor.systemBlue
            }
            .when(OrderState.done) { lab, _ in
                lab.text = "已完成 ✓"
                lab.backgroundColor = UIColor.systemGreen
            }
            .sendValue(OrderState.pending)

        stateLab.widthAnchor.constraint(equalToConstant: 90).isActive = true
        stateLab.heightAnchor.constraint(equalToConstant: 32).isActive = true
        stateLab.textAlignment = .center

        var stateIdx = 0
        let states: [OrderState] = [.pending, .paid, .done]
        let stateBtn = UIButton(type: .system)
        stateBtn.setTitle("切换状态 →", for: .normal)
        stateBtn.onTap { [weak stateLab] _ in
            stateIdx = (stateIdx + 1) % states.count
            stateLab?.dsl.sendValue(states[stateIdx])
        }

        let row1 = UIStackView(arrangedSubviews: [stateLab, stateBtn])
        row1.axis = .horizontal
        row1.spacing = 12
        row1.alignment = .center
        addDemo(note: "when(value) + sendValue — 枚举状态切换样式", view: row1)

        // 2. when(match) — 条件匹配：进度条颜色
        let progressLab = Label()
        progressLab.dsl
            .text("0%")
            .textColor(UIColor.white)
            .font(14, weight: .bold)
            .radius(8)
            .masksToBounds()
        progressLab.textAlignment = .center

        progressLab.dsl
            .when(Int.self, match: { $0 < 30 }) { lab, v in
                lab.text = "\(v)%  危险"
                lab.backgroundColor = UIColor.systemRed
            }
            .when(Int.self, match: { $0 < 70 }) { lab, v in
                lab.text = "\(v)%  一般"
                lab.backgroundColor = UIColor.systemOrange
            }
            .when(Int.self, match: { $0 <= 100 }) { lab, v in
                lab.text = "\(v)%  良好"
                lab.backgroundColor = UIColor.systemGreen
            }
            .sendValue(0)

        progressLab.widthAnchor.constraint(equalToConstant: 110).isActive = true
        progressLab.heightAnchor.constraint(equalToConstant: 32).isActive = true

        var progress = 0
        let progressBtn = UIButton(type: .system)
        progressBtn.setTitle("+25%", for: .normal)
        progressBtn.onTap { [weak progressLab] _ in
            progress = min(progress + 25, 100)
            if progress > 100 { progress = 0 }
            progressLab?.dStyle.sendValue(progress)
        }

        let row2 = UIStackView(arrangedSubviews: [progressLab, progressBtn])
        row2.axis = .horizontal
        row2.spacing = 12
        row2.alignment = .center
        addDemo(note: "when(Type.self, match:) — 按数值区间匹配，点击+25%", view: row2)

        // 3. otherwise — 无匹配时的默认处理
        let fallbackLab = Label()
        fallbackLab.dsl
            .text("?")
            .textColor(UIColor.white)
            .font(14, weight: .bold)
            .radius(8)
            .masksToBounds()
        fallbackLab.textAlignment = .center
        fallbackLab.widthAnchor.constraint(equalToConstant: 120).isActive = true
        fallbackLab.heightAnchor.constraint(equalToConstant: 32).isActive = true

        fallbackLab.dsl
            .when("success") { lab, _ in
                lab.text = "成功 ✅"
                lab.backgroundColor = UIColor.systemGreen
            }
            .when("error") { lab, _ in
                lab.text = "错误 ❌"
                lab.backgroundColor = UIColor.systemRed
            }
            .otherwise { lab, value in
                lab.text = "未知: \(value)"
                lab.backgroundColor = UIColor.systemGray
            }
            .sendValue("unknown_state")   // 触发 otherwise

        addDemo(note: "otherwise — 无匹配时的兜底回调", view: fallbackLab)

        // 4. bind(Combine Publisher)
        let subject = PassthroughSubject<String, Never>()
        let bindLab = Label()
        bindLab.dsl
            .text("等待消息…")
            .font(14)
            .textColor(UIColor.white)
            .bgColor(UIColor.systemGray2)
            .radius(8)
            .masksToBounds()
        bindLab.textAlignment = .center
        bindLab.widthAnchor.constraint(equalToConstant: 180).isActive = true
        bindLab.heightAnchor.constraint(equalToConstant: 36).isActive = true

        bindLab.dsl
            .bind(subject)
            .when("online") { lab, _ in
                lab.text = "在线 🟢"
                lab.backgroundColor = UIColor.systemGreen
            }
            .when("offline") { lab, _ in
                lab.text = "离线 🔴"
                lab.backgroundColor = UIColor.systemRed
            }

        var isOnline = false
        let sendBtn = UIButton(type: .system)
        sendBtn.setTitle("发送状态", for: .normal)
        sendBtn.onTap { _ in
            isOnline.toggle()
            subject.send(isOnline ? "online" : "offline")
        }

        let row4 = UIStackView(arrangedSubviews: [bindLab, sendBtn])
        row4.axis = .horizontal
        row4.spacing = 12
        row4.alignment = .center
        addDemo(note: "bind(publisher) — 订阅 Combine Publisher，自动触发样式更新", view: row4)
    }

    // MARK: ⑫ apply — 同时配置 dsl + dStyle + flex
    private func demo12_Apply() {
        addSection("⑫ apply — dsl + dStyle + flex 一次性配置三个维度")

        // apply(dsl:dStyle:flex:) — 在 StackView 内部使用
        // 提前创建 view，避免在 builder 内执行 Void 语句
        let v1 = Label()
        v1.textAlignment = .center
        v1.dsl.apply(
            dsl: { d in
                d.text("apply dsl")
                 .textColor(UIColor.white)
                 .bgColor(UIColor.systemBlue)
                 .radius(8)
                 .masksToBounds()
            },
            flex: { f in
                f.flex = 1
                f.height = 40
            }
        )

        let v2 = Label()
        v2.textAlignment = .center
        v2.dsl.apply(
            dsl: { d in
                d.text("apply dStyle")
                 .textColor(UIColor.white)
                 .bgColor(UIColor.systemGray)
                 .radius(8)
                 .masksToBounds()
            },
            dStyle: { ds in
//                ds.when("active") { lab, _ in
//                    lab.backgroundColor = UIColor.systemGreen
//                    lab.text = "激活 ✓"
//                }
//                .when("inactive") { lab, _ in
//                    lab.backgroundColor = UIColor.systemGray
//                    lab.text = "apply dStyle"
//                }
            },
            flex: { f in
                f.flex = 1
                f.height = 40
            }
        )
        v2.dStyle.sendValue("active")

        let container = HStackView {
            v1
            v2
        }
        container.spacing = 8
        addDemo(note: "apply(dsl:dStyle:flex:) — 三个维度一次配置完毕", view: container)

        // 独立 apply(dsl:dStyle:box:) — StackView 外用 box 做约束
        let v3 = Label()
        v3.dsl.apply(
            dsl: { d in
                d.text("apply + box 约束")
                 .textColor(UIColor.white)
                 .bgColor(UIColor.systemPurple)
                 .radius(10)
                 .masksToBounds()
            },
            dStyle: { ds in
                ds.when(Bool.self, match: { $0 }) { lab, _ in
                    lab.backgroundColor = UIColor.systemPurple
                }
            },
            box: nil
        )
        v3.textAlignment = .center
        v3.heightAnchor.constraint(equalToConstant: 40).isActive = true
        v3.widthAnchor.constraint(equalToConstant: 200).isActive = true
        addDemo(note: "apply(dsl:dStyle:) — StackView 外通过 AutoLayout 约束", view: v3)
    }
}

// MARK: - UIButton tap helper (iOS 13 compatible)
private extension UIView {
    func onTap(_ action: @escaping (UIView) -> Void) {
        let gr = ClosureTapGesture(action: action)
        addGestureRecognizer(gr)
        isUserInteractionEnabled = true
    }
}

private class ClosureTapGesture: UITapGestureRecognizer {
    private let action: (UIView) -> Void
    init(action: @escaping (UIView) -> Void) {
        self.action = action
        super.init(target: nil, action: nil)
        addTarget(self, action: #selector(fire))
    }
    @objc private func fire() {
        guard let v = view else { return }
        action(v)
    }
}
