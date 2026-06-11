//
//  ZLViewDemoVC.swift
//  ZLUIKitPlus_Example
//
//  View（ZLView）/ ViewStyleable 详细用法 Demo
//
//  ViewStyleable 协议由 View 和 Button 共同遵循，提供：
//  • gradColors(_:)         — 渐变色（颜色数组）
//  • gradDirection(start:end:) — 渐变方向（起点/终点 CGPoint，单位坐标）
//  • borderColor(color:)    — 描边颜色
//  • borderWidth(w:)        — 描边宽度
//  • border(color:w:)       — 一次同时设置颜色+宽度
//  • shadowColor(color:)    — 阴影颜色（同时设置默认 opacity/radius/offset）
//  • shadowOffset(w:h:)     — 阴影偏移
//  • shadowRadius(radius:)  — 阴影模糊半径
//  • shadowOpacity(opacity:)— 阴影不透明度
//  • cornerRadii(_:_:_:_:)  — 四角独立圆角（topLeading, topTrailing, bottomLeading, bottomTrailing）
//  • radius(_:)             — 四角统一圆角（等价于 cornerRadii(r,r,r,r)）
//  所有方法均返回 Self，支持链式调用。

import UIKit
import ZLUIKitPlus

class ZLViewDemoVC: ZLDemoBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "View / ViewStyleable Demo"
    }

    override func setupDemos() {
        demoBackgroundAndRadius()
        demoGradColors()
        demoGradDirection()
        demoBorder()
        demoShadow()
        demoCornerRadii()
        demoChain()
    }

    // MARK: - ① backgroundColor + radius
    private func demoBackgroundAndRadius() {
        addSection("① backgroundColor + radius（统一圆角）")
        addNote("radius(_ r: CGFloat) 等价于 cornerRadii(r, r, r, r)，四角一致。View 重写了 backgroundColor 以配合 ViewStyle 的 CAShapeLayer，确保渐变/描边时背景色正确。")

        let v1 = View()
        v1.backgroundColor = .systemBlue
        v1.radius(0)
        addDemo(v1, height: 50)
        addCaption("radius(0)：无圆角")

        let v2 = View()
        v2.backgroundColor = .systemBlue
        v2.radius(10)
        addDemo(v2, height: 50)
        addCaption("radius(10)：圆角 10pt")

        let v3 = View()
        v3.backgroundColor = .systemBlue
        v3.radius(25)
        addDemo(v3, height: 50)
        addCaption("radius(25)：圆角 25pt（高度一半 = 左右半圆）")

        addSeparator()
    }

    // MARK: - ② gradColors
    private func demoGradColors() {
        addSection("② gradColors — 渐变色")
        addNote("gradColors([UIColor]?) 接受颜色数组，数量不限。内部使用 CAGradientLayer + CAShapeLayer mask 实现，支持圆角裁剪。传 nil 移除渐变。")

        let v1 = View()
        v1.gradColors([UIColor.systemPurple, UIColor.systemPink])
        v1.radius(12)
        addDemo(v1, height: 60)
        addCaption("gradColors([.systemPurple, .systemPink])：两色渐变（默认方向：左上→右下）")

        let v2 = View()
        v2.gradColors([UIColor.systemRed, UIColor.systemOrange, .systemYellow])
        v2.radius(12)
        addDemo(v2, height: 60)
        addCaption("gradColors([red, orange, yellow])：三色渐变")

        let v3 = View()
        v3.gradColors([UIColor.systemBlue, UIColor.systemGreen, .systemTeal, UIColor.red])
        v3.radius(12)
        addDemo(v3, height: 60)
        addCaption("gradColors([blue, green, teal, cyan])：四色渐变")

        addSeparator()
    }

    // MARK: - ③ gradDirection
    private func demoGradDirection() {
        addSection("③ gradDirection — 渐变方向")
        addNote("gradDirection(start: CGPoint, end: CGPoint) 使用单位坐标系（0~1）。默认 start=(0,0) end=(1,1) 即左上→右下。")

        let directions: [(CGPoint, CGPoint, String)] = [
            (CGPoint(x: 0,   y: 0),   CGPoint(x: 1,   y: 1),   "左上→右下（默认）"),
            (CGPoint(x: 0,   y: 0.5), CGPoint(x: 1,   y: 0.5), "水平：左→右"),
            (CGPoint(x: 0.5, y: 0),   CGPoint(x: 0.5, y: 1),   "垂直：上→下"),
            (CGPoint(x: 1,   y: 0),   CGPoint(x: 0,   y: 1),   "右上→左下"),
        ]
        for (start, end, name) in directions {
            let v = View()
            v.gradColors([UIColor.systemBlue, UIColor.systemPink])
            v.gradDirection(start: start, end: end)
            v.radius(12)
            addDemo(v, height: 56)
            addCaption("gradDirection(start:\(start), end:\(end))  — \(name)")
        }

        addSeparator()
    }

    // MARK: - ④ border
    private func demoBorder() {
        addSection("④ border — 描边")
        addNote("• border(color:w:) 一步设置颜色+宽度\n• borderColor(color:) 单独设颜色\n• borderWidth(w:) 单独设宽度\n描边底层使用 CAShapeLayer.strokeColor + lineWidth，支持圆角裁剪。")

        // 一步设置
        let v1 = View()
        v1.backgroundColor = .white
        v1.border(color: UIColor.systemBlue, w: 2.0)
        v1.radius(12)
        addDemo(v1, height: 50)
        addCaption("border(color: .systemBlue, w: 2.0)")

        // 分开设置
        let v2 = View()
        v2.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.08)
        v2.borderColor(color: UIColor.systemOrange)
        v2.borderWidth(w: 1.5)
        v2.radius(8)
        addDemo(v2, height: 50)
        addCaption("borderColor(color: .systemOrange) + borderWidth(w: 1.5)：分开调用")

        // 描边 + 渐变背景
        let v3 = View()
        v3.gradColors([UIColor.systemPurple, UIColor.systemBlue])
        v3.border(color: UIColor.white, w: 2.0)
        v3.radius(16)
        addDemo(v3, height: 60)
        addCaption("gradColors + border(color: .white, w:2)：渐变背景 + 白色描边")

        // 粗边框
        let v4 = View()
        v4.backgroundColor = .systemYellow.withAlphaComponent(0.2)
        v4.border(color: UIColor.systemYellow, w: 4.0)
        v4.radius(12)
        addDemo(v4, height: 50)
        addCaption("border(color:w:4.0)：粗边框")

        addSeparator()
    }

    // MARK: - ⑤ shadow
    private func demoShadow() {
        addSection("⑤ shadow — 阴影")
        addNote("• shadowColor(color:) — 设阴影色，同时将 layer.shadowOpacity=0.2 / radius=8 / offset=(0,2) / masksToBounds=false\n• shadowOffset(w:h:) — 阴影偏移\n• shadowRadius(radius:) — 模糊半径\n• shadowOpacity(opacity:) — 透明度（0~1）\n阴影和圆角可同时使用，内部通过 shadowPath 确保性能。")

        // 默认阴影
        let v1 = View()
        v1.backgroundColor = .white
        v1.radius(12)
        v1.shadowColor(color: UIColor.black)
        // 默认：opacity=0.2, radius=8, offset=(0,2)
        let wrap1 = UIView()
        wrap1.addSubview(v1)
        v1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v1.topAnchor.constraint(equalTo: wrap1.topAnchor, constant: 8),
            v1.leadingAnchor.constraint(equalTo: wrap1.leadingAnchor, constant: 8),
            v1.trailingAnchor.constraint(equalTo: wrap1.trailingAnchor, constant: -8),
            v1.bottomAnchor.constraint(equalTo: wrap1.bottomAnchor, constant: -8),
            v1.heightAnchor.constraint(equalToConstant: 56)
        ])
        addDemo(wrap1, height: 72)
        addCaption("shadowColor(color: .black)：默认 opacity=0.2 / radius=8 / offset=(0,2)")

        // 完整自定义阴影
        let v2 = View()
        v2.backgroundColor = .white
        v2.radius(14)
        v2.shadowColor(color: UIColor.systemBlue)
        v2.shadowOffset(w: 0, h: 8)
        v2.shadowRadius(radius: 14)
        v2.shadowOpacity(opacity: 0.3)
        let wrap2 = UIView()
        wrap2.addSubview(v2)
        v2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v2.topAnchor.constraint(equalTo: wrap2.topAnchor, constant: 8),
            v2.leadingAnchor.constraint(equalTo: wrap2.leadingAnchor, constant: 8),
            v2.trailingAnchor.constraint(equalTo: wrap2.trailingAnchor, constant: -8),
            v2.bottomAnchor.constraint(equalTo: wrap2.bottomAnchor, constant: -8),
            v2.heightAnchor.constraint(equalToConstant: 56)
        ])
        addDemo(wrap2, height: 72)
        addCaption("shadowColor(.systemBlue) + shadowOffset(0,8) + shadowRadius(14) + shadowOpacity(0.3)")

        // 侧向阴影
        let v3 = View()
        v3.backgroundColor = .white
        v3.radius(10)
        v3.shadowColor(color: UIColor.black)
        v3.shadowOffset(w: 6, h: 0)
        v3.shadowRadius(radius: 6)
        v3.shadowOpacity(opacity: 0.15)
        let wrap3 = UIView()
        wrap3.addSubview(v3)
        v3.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v3.topAnchor.constraint(equalTo: wrap3.topAnchor, constant: 8),
            v3.leadingAnchor.constraint(equalTo: wrap3.leadingAnchor, constant: 8),
            v3.trailingAnchor.constraint(equalTo: wrap3.trailingAnchor, constant: -8),
            v3.bottomAnchor.constraint(equalTo: wrap3.bottomAnchor, constant: -8),
            v3.heightAnchor.constraint(equalToConstant: 56)
        ])
        addDemo(wrap3, height: 72)
        addCaption("shadowOffset(w:6, h:0)：侧向阴影")

        addSeparator()
    }

    // MARK: - ⑥ cornerRadii 独立四角
    private func demoCornerRadii() {
        addSection("⑥ cornerRadii — 四角独立圆角")
        addNote("cornerRadii(_ topLeading: CGFloat, _ topTrailing: CGFloat, _ bottomLeading: CGFloat, _ bottomTrailing: CGFloat)\n参数依次为：左上、右上、左下、右下。底层用 UIBezierPath 手动绘制每个角，支持任意组合。RTL 布局下 leading/trailing 自动翻转。")

        let cases: [(CGFloat, CGFloat, CGFloat, CGFloat, String)] = [
            (20, 0, 0, 20, "左上+右下圆角（对角）"),
            (0, 20, 20, 0, "右上+左下圆角（对角）"),
            (20, 20, 0, 0, "只有上方圆角"),
            (0, 0, 20, 20, "只有下方圆角"),
            (20, 0, 0, 0, "只有左上角圆角"),
            (24, 0, 0, 24, "气泡样式（左上+右下，常见于聊天气泡）"),
        ]

        for (tl, tr, bl, br, name) in cases {
            let v = View()
            v.backgroundColor = .systemIndigo
            v.cornerRadii(tl, tr, bl, br)
            addDemo(v, height: 60)
            addCaption("cornerRadii(\(Int(tl)), \(Int(tr)), \(Int(bl)), \(Int(br)))：\(name)")
        }

        addSeparator()
    }

    // MARK: - ⑦ 链式调用综合示例
    private func demoChain() {
        addSection("⑦ 链式调用综合示例")
        addNote("所有 ViewStyleable 方法均返回 Self，可无限链式调用。")

        // 渐变 + 圆角 + 阴影
        let v1 = View()
        v1
            .gradColors([UIColor.systemOrange,UIColor .systemRed])
            .gradDirection(start: CGPoint(x: 0, y: 0.5), end: CGPoint(x: 1, y: 0.5))
            .shadowColor(color: UIColor.systemRed)
            .shadowOffset(w: 0, h: 6)
            .shadowRadius(radius: 12)
            .shadowOpacity(opacity: 0.35)
            .radius(24)
        let wrap1 = UIView()
        wrap1.addSubview(v1)
        v1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v1.topAnchor.constraint(equalTo: wrap1.topAnchor, constant: 10),
            v1.leadingAnchor.constraint(equalTo: wrap1.leadingAnchor),
            v1.trailingAnchor.constraint(equalTo: wrap1.trailingAnchor),
            v1.bottomAnchor.constraint(equalTo: wrap1.bottomAnchor, constant: -10),
            v1.heightAnchor.constraint(equalToConstant: 70)
        ])
        addDemo(wrap1, height: 90)
        addCaption("链式：gradColors + gradDirection + shadowColor + shadowOffset + shadowRadius + shadowOpacity + radius")

        // 渐变 + 描边 + 独立圆角
        let v2 = View()
        v2
            .gradColors([UIColor(red: 0.1, green: 0.5, blue: 1, alpha: 1),
                         UIColor(red: 0.4, green: 0.1, blue: 0.9, alpha: 1)])
            .border(color: UIColor.white, w: 2)
            .cornerRadii(20, 0, 0, 20)
        addDemo(v2, height: 60)
        addCaption("链式：gradColors + border(color: .white, w:2) + cornerRadii(20,0,0,20)")

        addSeparator()
        addNote("ViewStyleable 接口总览（View 和 Button 均遵循）：\n• gradColors([UIColor]?) — 渐变颜色\n• gradDirection(start:end:) — 渐变方向（单位坐标）\n• borderColor(color:) / borderWidth(w:) / border(color:w:) — 描边\n• shadowColor(color:) — 阴影色（设置后默认参数自动激活）\n• shadowOffset(w:h:) / shadowRadius(radius:) / shadowOpacity(opacity:) — 精细调整阴影\n• cornerRadii(topLeading,topTrailing,bottomLeading,bottomTrailing) — 四角独立\n• radius(_ r:) — 四角统一圆角")
    }
}
