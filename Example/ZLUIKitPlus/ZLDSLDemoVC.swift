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
    private let stack  = VStackView()
        .align(.start)
        .spacing(16)
        .insets(.all(10))
    
    // Combine
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DSL 用法 Demo"
        view.backgroundColor = UIColor.systemBackground
        
        stack.wrapScrollView()
            .box
            .addToFull(view)
        buildSections()
    }
    
    
    
    // MARK: - helpers
    private func addSection(_ title: String) {
        let label = Label()
        label.dsl
            .insets(.init(top: 10, leading: 16, bottom: 10, trailing: 16))
            .text(title,color: UIColor.systemGray,fontSize: 13)
            .multipleLines()
            .bgColor(.systemGray6)
            .radius(8)
        stack.addArrangedSubview(label)
    }
    
    private func addPad(_ height: CGFloat = 16) {
        stack.insertSpacing(height)
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
            .size(w: 80, h: 40)
        
        addDemo(note: "bgColor(.systemBlue)  radius(16)  masksToBounds()", view: v1)
        
        // alpha
        let v2 = UIView()
        v2.dsl
            .bgColor(UIColor.systemRed)
            .radius(12)
            .alpha(0.4)
            .size(w: 80, h: 40)
       
        addDemo(note: "alpha(0.4) — 半透明", view: v2)
        
        // hidden(false) — 显示
        let v3 = UIView()
        v3.dsl
            .bgColor(UIColor.systemGreen)
            .radius(12)
            .hidden(false)   // 明确可见
            .size(w: 80, h: 40)
       
        addDemo(note: "hidden(false) — 明确设置为可见", view: v3)
        
        // corner — 仅指定角
        let v4 = UIView()
        v4.dsl
            .bgColor(UIColor.systemOrange)
            .corner([.layerMinXMinYCorner, .layerMaxXMaxYCorner], radius: 20)
            .size(w: 80, h: 60)
     
        addDemo(note: "corner([.topLeft, .bottomRight], radius:20) — 对角圆角", view: v4)
        
        // tintColor
        let img = UIImageView(image: UIImage(systemName: "star.fill"))
        img.dsl
            .tintColor(UIColor.systemPurple)
            .contentMode(.scaleAspectFit)
            .square(36)
       
        addDemo(note: "tintColor(.systemPurple) — 系统图标着色", view: img)
        
        // tag
        let tagView = UIView()
        tagView.dsl
            .bgColor(UIColor.systemTeal)
            .radius(8)
            .tag(101)
            .size(w: 60, h: 30)
       
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
            .size(w: 100, h: 44)
        addDemo(note: "border(color:.systemBlue, w:2) — 一步设置颜色+宽度", view: v1)
        
        // borderColor + borderWidth 分步
        let v2 = UIView()
        v2.dsl
            .bgColor(UIColor.white)
            .borderColor(color: UIColor.systemRed)
            .borderWidth(w: 1.5)
            .radius(10)
            .size(w: 100, h: 44)
      
        addDemo(note: "borderColor() + borderWidth() — 分步设置", view: v2)
        
        // shadow
        let v3 = UIView()
        v3.dsl
            .bgColor(UIColor.white)
            .radius(12)
            .shadowColor(color: UIColor.black)
            .shadowOffset(w: 0, h: 4)
            .shadowRadius(8)
            .shadowOpacity(0.2)
            .size(w:120, h: 50)
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
            //
            let v2 = UIView()
            v2.dsl
                .bgColor(UIColor.systemBlue)
                .size(w: 44, h: 44)
                .margin(.all(8))   // 上下内缩 8
            v2
            
            let v3 = UIView()
            v3.dsl
                .bgColor(UIColor.systemRed)
                .size(w: 44, h: 44)
            v3
        }
        addDemo(note: "spacing(16) — 后置间距  margin(t:s:b:e:) — 外边距", view: hStack4)
        
        // align — 交叉轴对齐
        let hStack5 = HStackView(spacing: 8) {
            
            UILabel().dsl
                .text("start")
                .textColor(.white)
                .bgColor(.systemBlue)
                .radius(6)
                .align(.start)   // 靠上
                .height(28)
            
            
            UILabel().dsl
                .text("center")
                .textColor(.white)
                .bgColor(.systemOrange)
                .radius(6)
                .align(.center)  // 居中
                .height(28)
            
            
            UILabel().dsl
                .text("end")
                .textColor(.white)
                .bgColor(.systemGreen)
                .radius(6)
                .align(.end)     // 靠下
                .height(28)
            
            
            UILabel().dsl
                .text("fill")
                .textColor(.white)
                .bgColor(.systemRed)
                .radius(6)
                .align(.fill)    // 填满
            
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
        
        var stateIdx = 0
        let states: [OrderState] = [.pending, .paid, .done]
        
        let row1 = HStackView(spacing: 10) {
            let label = Label()
            label.dsl
                .textColor(UIColor.white)
                .font(14, weight: .semibold)
                .radius(8)
                .textAlignment(.center)
                .size(w: 90, h: 32)
                .when(OrderState.pending) {lab, _ in
                    lab.dsl.bgColor(.systemOrange).text("待支付")
                }
                .when(OrderState.paid) {lab,_ in
                    lab.dsl.bgColor(.systemBlue).text("已支付")
                }
                .when(OrderState.done) { lab, _ in
                    
                    lab.dsl.bgColor(.systemGreen).text("已完成")
                }
                .sendState(OrderState.pending)
            
            UIButton().dsl
                .title("切换状态 →")
                .titleColor(.systemBlue)
                .tapAction { _ in
                    stateIdx = (stateIdx + 1) % states.count
                    label.dsl.sendState(states[stateIdx])
                }
        }
        
        
        addDemo(note: "when(value) + sendValue — 枚举状态切换样式", view: row1)
        
        // 2. when(match) — 条件匹配：进度条颜色
        
        var progress = 0
        
        let row2 = HStackView(spacing: 10) {
            let progressLab = Label()
            progressLab.dsl
                .text("0%")
                .textColor(UIColor.white)
                .font(14, weight: .bold)
                .radius(8)
                .textAlignment(.center)
                .size(w: 110, h: 32)
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
                }.otherwise({ lab , v in
                    lab.text = "\(v)"
                    lab.backgroundColor = .red
                })
                .sendState(0)
            
            
            UIButton().dsl
                .title("+25%")
                .titleColor(.systemBlue)
                .tapAction { _ in
                    progress = (progress + 25) % 125
                    progressLab.dsl.sendState(progress)
                }
        }
        
        
        
        addDemo(note: "when(Type.self, match:) — 按数值区间匹配，点击+25%", view: row2)
        
        // 3. otherwise — 无匹配时的默认处理
        let fallbackLab = Label()
        fallbackLab.dsl
            .text("?")
            .textColor(UIColor.white)
            .font(14, weight: .bold)
            .radius(8)
            .textAlignment(.center)
            .size(w: 120, h: 32)
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
            .sendState("unknown_state")   // 触发 otherwise
        
        addDemo(note: "otherwise — 无匹配时的兜底回调", view: fallbackLab)
        
        // 4. bind(Combine Publisher)
        
        
        var isOnline = false
        
        
        let row4 = HStackView(spacing: 12) {
            let bindLab = Label()
            bindLab.dsl
                .text("等待消息…")
                .font(14)
                .textColor(UIColor.white)
                .bgColor(UIColor.systemGray2)
                .radius(8)
                .textAlignment(.center)
                .size(w: 180, h: 36)
                .when(String.self, match: { $0 == "online" }) { lab, _ in
                    lab.text = "在线 🟢"
                    lab.backgroundColor = UIColor.systemGreen
                }
                .when("offline") { lab, _ in
                    lab.text = "离线 🔴"
                    lab.backgroundColor = UIColor.systemRed
                }.whenNil { lab in
                    lab.text = "无状态"
                }.otherwise { lab , _ in
                    lab.text = "未知状态"
                    lab.backgroundColor = UIColor.systemGray
                }
            
            UIButton().dsl
                .title("发送状态")
                .titleColor(.systemBlue)
                .tapAction {[weak bindLab] btn in
                    isOnline.toggle()
                    bindLab?.dsl.stateStore?.send(isOnline ? "online" : "offline")
                }
        }
        
        
        addDemo(note: "bind(publisher) — 订阅 Combine Publisher，自动触发样式更新", view: row4)
    }
    
    // MARK: ⑫ apply — 同时配置 dsl + dStyle + flex
    private func demo12_Apply() {
        addSection("⑫ apply — dsl + dStyle + flex 一次性配置三个维度")
        
        // apply(dsl:dStyle:flex:) — 在 StackView 内部使用
        // 提前创建 view，避免在 builder 内执行 Void 语句
        let v1 = Label()
        v1.dsl.apply {
                $0.text("apply dsl")
                    .textColor(.white)
                    .bgColor(.systemBlue)
                    .radius(8)
            } flex: {
                $0.flex(1).height(40)
            }
        
        
        let v2 = Label()
        v2.dsl.apply {
            $0.text("apply dStyle")
                .textColor(UIColor.white)
                .bgColor(UIColor.systemGray)
                .radius(8)
                .masksToBounds()
        } dStyle: {
            $0.when("active") { lab, _ in
                lab.backgroundColor = UIColor.systemGreen
                lab.text = "激活 ✓"
            }
            .when("inactive") { lab, _ in
                lab.backgroundColor = UIColor.systemGray
                lab.text = "apply dStyle"
            }
        } flex: {
            $0.flex(0).height(40)
        }
        
        v2.dStyle.sendState("active")
        
        let container = HStackView(spacing: 8) {
            v1
            v2
        }
        addDemo(note: "apply(dsl:dStyle:flex:) — 三个维度一次配置完毕", view: container)
        
        // 独立 apply(dsl:dStyle:box:) — StackView 外用 box 做约束
        let v3 = Label()
        v3.dsl
            .textAlignment(.center)
            .size(w: 200, h: 40)
            .apply(
                dsl: { d in
                    d.text("apply + box 约束")
                        .textColor(UIColor.white)
                        .bgColor(UIColor.systemPurple)
                        .radius(10)
                },
                dStyle: { ds in
                    ds.when(Bool.self, match: { $0 }) { lab, _ in
                        lab.backgroundColor = UIColor.systemPurple
                    }
                },
                box: nil
            )
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
