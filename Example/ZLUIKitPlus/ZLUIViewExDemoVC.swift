//
//  ZLUIViewExDemoVC.swift
//  ZLUIKitPlus_Example
//
//  UIViewEx 扩展属性详细用法 Demo
//
//  UIViewEx 的核心机制：
//  每个 zl_* 属性第一次访问时，会自动创建对应视图并通过 addSubview 加入当前视图，
//  同时将其存入 zl_storage（AssociatedObject 字典），之后每次访问返回同一实例。
//  无需在外部声明子视图属性，直接用 view.zl_btn / view.zl_lab 等访问即可。
//
//  分组说明（同类型可有多个）：
//  第一组：zl_btn / zl_lab / zl_imgView / zl_stackView
//  第二组：zl_altBtn / zl_altLab / zl_altImgView / zl_altStackView
//  第三组：zl_extraBtn / zl_extraLab / zl_extraImgView / zl_extraStackView
//  成对视图：zl_pairLab / zl_pairImg / zl_pairBtn / zl_pairStackView /
//            zl_imgViewLab / zl_imgViewBtn / zl_btnImgView / zl_btnLabel /
//            zl_labelBtn / zl_labImgView
//  包裹视图：zl_wrapView

import UIKit
import ZLUIKitPlus
import ZLFlexKit

class ZLUIViewExDemoVC: ZLDemoBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIViewEx 扩展属性 Demo"
    }

    override func setupDemos() {
        addNote(
            "zl_* 属性的核心原理：首次访问自动创建视图、addSubview 到当前 view 并缓存，" +
            "后续访问始终返回同一实例。无需在外部声明子视图变量。"
        )
        addSeparator()

        demoGroup1()
        demoMultiGroup()
        demoStackView()
        demoPairViews()
        demoWrapView()
    }

    // MARK: ══════════════════════════════════════
    // MARK: ① 第一组 — zl_btn / zl_lab / zl_imgView
    // MARK: ══════════════════════════════════════
    private func demoGroup1() {
        addSection("① 第一组：zl_btn / zl_lab / zl_imgView")
        addNote(
            "直接在任意 UIView 上访问 zl_btn / zl_lab / zl_imgView，\n" +
            "首次访问自动创建并 addSubview，无需手动声明属性。\n" +
            "演示：一个用户信息行（头像 + 姓名 + 关注按钮）"
        )

        // ── 用户信息行 cell ──
        let cell = UIView()
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 12
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.06
        cell.layer.shadowRadius = 8
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        addDemo(cell, height: 68)

        // 直接用 zl_* 属性配置子视图，首次访问自动创建+addSubview
        cell.zl_imgView.image = UIImage(systemName: "person.circle.fill")
        cell.zl_imgView.tintColor = .systemBlue
        cell.zl_imgView.contentMode = .scaleAspectFit
        cell.zl_imgView.layer.cornerRadius = 22
        cell.zl_imgView.clipsToBounds = true

        cell.zl_lab.text = "张三"
        cell.zl_lab.font = .systemFont(ofSize: 16, weight: .semibold)

        cell.zl_altLab.text = "iOS Developer"
        cell.zl_altLab.font = .systemFont(ofSize: 12)
        cell.zl_altLab.textColor = .systemGray

        cell.zl_btn.setTitle("关注", for: .normal)
        cell.zl_btn.setTitleColor(.white, for: .normal)
        cell.zl_btn.backgroundColor = .systemBlue
        cell.zl_btn.radius(14)
        cell.zl_btn.insets(UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))

        // 布局（首次访问已 addSubview，只需加约束）
        [cell.zl_imgView, cell.zl_lab, cell.zl_altLab, cell.zl_btn].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            cell.zl_imgView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 14),
            cell.zl_imgView.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            cell.zl_imgView.widthAnchor.constraint(equalToConstant: 44),
            cell.zl_imgView.heightAnchor.constraint(equalToConstant: 44),

            cell.zl_lab.leadingAnchor.constraint(equalTo: cell.zl_imgView.trailingAnchor, constant: 10),
            cell.zl_lab.topAnchor.constraint(equalTo: cell.zl_imgView.topAnchor, constant: 4),
            cell.zl_lab.trailingAnchor.constraint(lessThanOrEqualTo: cell.zl_btn.leadingAnchor, constant: -8),

            cell.zl_altLab.leadingAnchor.constraint(equalTo: cell.zl_lab.leadingAnchor),
            cell.zl_altLab.topAnchor.constraint(equalTo: cell.zl_lab.bottomAnchor, constant: 2),
            cell.zl_altLab.trailingAnchor.constraint(lessThanOrEqualTo: cell.zl_btn.leadingAnchor, constant: -8),

            cell.zl_btn.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -14),
            cell.zl_btn.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
        ])
        addCaption(
            "cell.zl_imgView / cell.zl_lab / cell.zl_altLab / cell.zl_btn\n" +
            "首次访问自动创建并 addSubview，无需声明属性变量"
        )

        // ── 同一实例验证 ──
        addNote("✅ 惰性单例验证：两次访问 zl_btn 返回同一个实例")
        let verifyView = UIView()
        let first  = verifyView.zl_btn   // 第一次访问：创建 + addSubview
        let second = verifyView.zl_btn   // 第二次访问：直接从缓存返回
        let isSame = first === second
        let verifyLabel = UILabel()
        verifyLabel.text = "verifyView.zl_btn === verifyView.zl_btn → \(isSame ? "✅ 同一实例" : "❌ 不同实例")"
        verifyLabel.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        verifyLabel.textColor = isSame ? .systemGreen : .systemRed
        stackView.addArrangedSubview(verifyLabel)

        addSeparator()
    }

    // MARK: ══════════════════════════════════════
    // MARK: ② 多组共存 — 同类型最多 3 个
    // MARK: ══════════════════════════════════════
    private func demoMultiGroup() {
        addSection("② 多组共存：三组 Label / Button / ImageView")
        addNote(
            "同一 view 上需要多个同类型子视图时，使用三个不同命名的属性组：\n" +
            "第一组：zl_btn / zl_lab / zl_imgView\n" +
            "第二组：zl_altBtn / zl_altLab / zl_altImgView\n" +
            "第三组：zl_extraBtn / zl_extraLab / zl_extraImgView\n" +
            "三组各自独立缓存，互不干扰。"
        )

        // ── 演示：一张商品卡片，用 3 个 Label 显示名称/价格/销量 ──
        let card = View()
        card.backgroundColor = .white
        card.radius(14)
        card.shadowColor(color: UIColor.black)
        card.shadowOffset(w: 0, h: 3)
        card.shadowRadius(radius: 8)
        card.shadowOpacity(opacity: 0.08)
        addDemo(card, height: 110)

        // 三个 Label：名称、价格、销量
        card.zl_lab.text = "AirPods Pro（第三代）"
        card.zl_lab.font = .systemFont(ofSize: 15, weight: .semibold)

        card.zl_altLab.text = "¥ 1,899"
        card.zl_altLab.font = .systemFont(ofSize: 16, weight: .bold)
        card.zl_altLab.textColor = .systemRed

        card.zl_extraLab.text = "月销 12万+"
        card.zl_extraLab.font = .systemFont(ofSize: 12)
        card.zl_extraLab.textColor = .systemGray

        // 两个 Button：加购 + 收藏
        card.zl_btn.setTitle("加入购物车", for: .normal)
        card.zl_btn.setTitleColor(.white, for: .normal)
        card.zl_btn.backgroundColor = .systemOrange
        card.zl_btn.radius(10)
        card.zl_btn.insets(UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 14))

        card.zl_altBtn.setTitle("♥", for: .normal)
        card.zl_altBtn.setTitleColor(.systemRed, for: .normal)
        card.zl_altBtn.titleLabel?.font = .systemFont(ofSize: 18)
        card.zl_altBtn.backgroundColor = UIColor.systemRed.withAlphaComponent(0.08)
        card.zl_altBtn.radius(10)
        card.zl_altBtn.insets(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))

        // ImageView：商品图
        card.zl_imgView.image = UIImage(systemName: "airpodspro")
        card.zl_imgView.tintColor = .systemGray3
        card.zl_imgView.contentMode = .scaleAspectFit
        card.zl_imgView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.05)
        card.zl_imgView.layer.cornerRadius = 8
        card.zl_imgView.clipsToBounds = true

        // 布局
        [card.zl_imgView, card.zl_lab, card.zl_altLab, card.zl_extraLab,
         card.zl_btn, card.zl_altBtn].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            // 图片
            card.zl_imgView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            card.zl_imgView.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            card.zl_imgView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
            card.zl_imgView.widthAnchor.constraint(equalToConstant: 86),

            // 名称
            card.zl_lab.leadingAnchor.constraint(equalTo: card.zl_imgView.trailingAnchor, constant: 10),
            card.zl_lab.topAnchor.constraint(equalTo: card.topAnchor, constant: 14),
            card.zl_lab.trailingAnchor.constraint(lessThanOrEqualTo: card.trailingAnchor, constant: -10),

            // 价格
            card.zl_altLab.leadingAnchor.constraint(equalTo: card.zl_lab.leadingAnchor),
            card.zl_altLab.topAnchor.constraint(equalTo: card.zl_lab.bottomAnchor, constant: 4),

            // 销量
            card.zl_extraLab.leadingAnchor.constraint(equalTo: card.zl_lab.leadingAnchor),
            card.zl_extraLab.topAnchor.constraint(equalTo: card.zl_altLab.bottomAnchor, constant: 2),

            // 加购按钮
            card.zl_btn.leadingAnchor.constraint(equalTo: card.zl_lab.leadingAnchor),
            card.zl_btn.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),

            // 收藏按钮
            card.zl_altBtn.leadingAnchor.constraint(equalTo: card.zl_btn.trailingAnchor, constant: 8),
            card.zl_altBtn.centerYAnchor.constraint(equalTo: card.zl_btn.centerYAnchor),
        ])
        addCaption(
            "zl_lab（名称）/ zl_altLab（价格）/ zl_extraLab（销量）\n" +
            "zl_btn（加购）/ zl_altBtn（收藏）/ zl_imgView（商品图）\n" +
            "三组属性各自独立，同一视图最多支持 3 个 Button / Label / ImageView"
        )
        addSeparator()
    }

    // MARK: ══════════════════════════════════════
    // MARK: ③ zl_stackView / zl_altStackView / zl_extraStackView
    // MARK: ══════════════════════════════════════
    private func demoStackView() {
        addSection("③ zl_stackView / zl_altStackView / zl_extraStackView")
        addNote(
            "zl_stackView 系列与 StackView（ZLFlexKit）一样使用。\n" +
            "首次访问自动创建并 addSubview，可直接配置 axis / alignment 并添加子视图。\n" +
            "演示：用 zl_stackView（水平）嵌套 zl_altStackView（垂直）组成布局。"
        )

        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 12
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.05
        container.layer.shadowRadius = 6
        container.layer.shadowOffset = .zero
        addDemo(container, height: 100)

        // zl_stackView：水平排列，作为整行容器
        container.zl_stackView.axis = .horizontal
        container.zl_stackView.alignment = .center
        container.zl_stackView.spacing(12)
        container.zl_stackView.insets(UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14))

        // zl_altStackView：垂直排列，放主信息
        container.zl_altStackView.axis = .vertical
        container.zl_altStackView.spacing(3)
        container.zl_altStackView.flex.flex = 1

        // zl_extraStackView：垂直排列，放副信息/标签
        container.zl_extraStackView.axis = .vertical
        container.zl_extraStackView.alignment = .end
        container.zl_extraStackView.spacing(4)

        // 配置 zl_imgView 作为头像
        container.zl_imgView.image = UIImage(systemName: "creditcard.fill")
        container.zl_imgView.tintColor = .systemGreen
        container.zl_imgView.contentMode = .scaleAspectFit
        container.zl_imgView.flex.size = CGSize(width: 36, height: 36)

        // 主信息（两行 label）
        let nameLabel = UILabel()
        nameLabel.text = "微信支付"
        nameLabel.font = .systemFont(ofSize: 14, weight: .medium)

        let timeLabel = UILabel()
        timeLabel.text = "06-10  14:32"
        timeLabel.font = .systemFont(ofSize: 12)
        timeLabel.textColor = .systemGray

        container.zl_altStackView.addArrangedSubview(nameLabel)
        container.zl_altStackView.addArrangedSubview(timeLabel)

        // 副信息（金额 + 状态）
        let amountLabel = UILabel()
        amountLabel.text = "-¥ 128.00"
        amountLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        amountLabel.textColor = .systemRed

        let statusLabel = Label()
        statusLabel.text = "已完成"
        statusLabel.font = .systemFont(ofSize: 11)
        statusLabel.textColor = .systemGreen
        statusLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
        statusLabel.insets = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        statusLabel.layer.cornerRadius = 8
        statusLabel.clipsToBounds = true

        container.zl_extraStackView.addArrangedSubview(amountLabel)
        container.zl_extraStackView.addArrangedSubview(statusLabel)

        // 将所有子 StackView 组装到 zl_stackView
        container.zl_stackView.addArrangedSubview(container.zl_imgView)
        container.zl_stackView.addArrangedSubview(container.zl_altStackView)
        container.zl_stackView.addArrangedSubview(container.zl_extraStackView)

        // 将 zl_stackView 约束到 container
        container.zl_stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.zl_stackView.topAnchor.constraint(equalTo: container.topAnchor),
            container.zl_stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            container.zl_stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            container.zl_stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
        addCaption(
            "zl_stackView（水平行容器）嵌套\n" +
            "zl_altStackView（垂直主信息，flex:1）+\n" +
            "zl_extraStackView（垂直副信息，靠右）"
        )
        addSeparator()
    }

    // MARK: ══════════════════════════════════════
    // MARK: ④ 成对 PairView 属性
    // MARK: ══════════════════════════════════════
    private func demoPairViews() {
        addSection("④ 成对 PairView 属性")
        addNote(
            "PairView 系列属性同样遵循惰性单例原则，首次访问自动创建并 addSubview。\n" +
            "通过 thenFirst / thenSecond 配置两个子视图，\n" +
            "通过 flexibleSpacing / minSpacing / firstFlex / secondFlex 控制布局。"
        )

        // ── zl_pairLab：PairLabelView（左标题 + 右内容）──
        addNote("zl_pairLab — PairLabelView（Label + Label）")
        let row1 = UIView()
        row1.backgroundColor = .white
        row1.layer.cornerRadius = 10
        addDemo(row1, height: 44)

        row1.zl_pairLab.thenFirst { label in
            label.text = "收货地址"
            label.font = .systemFont(ofSize: 14)
            label.textColor = .systemGray
        }
        row1.zl_pairLab.thenSecond { label in
            label.text = "北京市朝阳区三里屯 88 号"
            label.font = .systemFont(ofSize: 14)
            label.textAlignment = .right
            label.numberOfLines = 1
        }
        row1.zl_pairLab.flexibleSpacing(true)
        row1.zl_pairLab.insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)

        row1.zl_pairLab.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            row1.zl_pairLab.topAnchor.constraint(equalTo: row1.topAnchor),
            row1.zl_pairLab.leadingAnchor.constraint(equalTo: row1.leadingAnchor),
            row1.zl_pairLab.trailingAnchor.constraint(equalTo: row1.trailingAnchor),
            row1.zl_pairLab.bottomAnchor.constraint(equalTo: row1.bottomAnchor),
        ])
        addCaption("row.zl_pairLab — 左标题 + 右内容，flexibleSpacing(true)")

        // ── zl_imgViewLab：ImgLabelView（icon + 文字）──
        addNote("zl_imgViewLab — ImgLabelView（UIImageView + Label）")
        let row2 = UIView()
        row2.backgroundColor = .white
        row2.layer.cornerRadius = 10
        addDemo(row2, height: 44)

        row2.zl_imgViewLab.thenFirst { iv in
            iv.image = UIImage(systemName: "mappin.circle.fill")
            iv.tintColor = .systemRed
            iv.contentMode = .scaleAspectFit
            iv.flex.size = CGSize(width: 22, height: 22)
        }
        row2.zl_imgViewLab.thenSecond { label in
            label.text = "定位：北京市"
            label.font = .systemFont(ofSize: 14)
        }
        row2.zl_imgViewLab.minSpacing(8)
        row2.zl_imgViewLab.insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        row2.zl_imgViewLab.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            row2.zl_imgViewLab.topAnchor.constraint(equalTo: row2.topAnchor),
            row2.zl_imgViewLab.leadingAnchor.constraint(equalTo: row2.leadingAnchor),
            row2.zl_imgViewLab.trailingAnchor.constraint(equalTo: row2.trailingAnchor),
            row2.zl_imgViewLab.bottomAnchor.constraint(equalTo: row2.bottomAnchor),
        ])
        addCaption("row.zl_imgViewLab — icon 靠左 + label 靠右")

        // ── zl_labImgView：LabelImgView（文字 + 箭头）──
        addNote("zl_labImgView — LabelImgView（Label + UIImageView）")
        let row3 = UIView()
        row3.backgroundColor = UIColor.systemGray6
        row3.layer.cornerRadius = 10
        addDemo(row3, height: 44)

        row3.zl_labImgView.thenFirst { label in
            label.text = "查看全部订单"
            label.font = .systemFont(ofSize: 14)
            label.flex.flex = 1
        }
        row3.zl_labImgView.thenSecond { iv in
            iv.image = UIImage(systemName: "chevron.right")
            iv.tintColor = .systemGray3
            iv.contentMode = .scaleAspectFit
            iv.flex.size = CGSize(width: 14, height: 14)
        }
        row3.zl_labImgView.minSpacing(6)
        row3.zl_labImgView.insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        row3.zl_labImgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            row3.zl_labImgView.topAnchor.constraint(equalTo: row3.topAnchor),
            row3.zl_labImgView.leadingAnchor.constraint(equalTo: row3.leadingAnchor),
            row3.zl_labImgView.trailingAnchor.constraint(equalTo: row3.trailingAnchor),
            row3.zl_labImgView.bottomAnchor.constraint(equalTo: row3.bottomAnchor),
        ])
        addCaption("row.zl_labImgView — label(flex:1) + 箭头 icon 靠右")

        // ── zl_pairBtn：PairButtonView（两个按钮）──
        addNote("zl_pairBtn — PairButtonView（Button + Button）")
        let row4 = UIView()
        row4.backgroundColor = .white
        row4.layer.cornerRadius = 10
        addDemo(row4, height: 52)

        row4.zl_pairBtn.thenFirst { btn in
            btn.setTitle("取消订单", for: .normal)
            btn.setTitleColor(.systemGray, for: .normal)
            btn.backgroundColor = UIColor.systemGray.withAlphaComponent(0.1)
            btn.radius(10)
            btn.flex.flex = 1
        }
        row4.zl_pairBtn.thenSecond { btn in
            btn.setTitle("再次购买", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.backgroundColor = .systemOrange
            btn.radius(10)
            btn.flex.flex = 1
        }
        row4.zl_pairBtn.minSpacing(12)
        row4.zl_pairBtn.insets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)
        row4.zl_pairBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            row4.zl_pairBtn.topAnchor.constraint(equalTo: row4.topAnchor),
            row4.zl_pairBtn.leadingAnchor.constraint(equalTo: row4.leadingAnchor),
            row4.zl_pairBtn.trailingAnchor.constraint(equalTo: row4.trailingAnchor),
            row4.zl_pairBtn.bottomAnchor.constraint(equalTo: row4.bottomAnchor),
        ])
        addCaption("row.zl_pairBtn — 两按钮各 flex:1 等宽，minSpacing(12)")

        // ── zl_imgViewBtn：ImgButtonView（头像 + 关注按钮）──
        addNote("zl_imgViewBtn — ImgButtonView（UIImageView + Button）")
        let row5 = UIView()
        row5.backgroundColor = .white
        row5.layer.cornerRadius = 10
        addDemo(row5, height: 60)

        row5.zl_imgViewBtn.thenFirst { iv in
            iv.image = UIImage(systemName: "person.circle.fill")
            iv.tintColor = .systemGray3
            iv.contentMode = .scaleAspectFit
            iv.flex.size = CGSize(width: 44, height: 44)
        }
        row5.zl_imgViewBtn.thenSecond { btn in
            btn.setTitle("+ 关注", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.backgroundColor = .systemBlue
            btn.radius(14)
            btn.insets(UIEdgeInsets(top: 7, left: 18, bottom: 7, right: 18))
        }
        row5.zl_imgViewBtn.flexibleSpacing(true)
        row5.zl_imgViewBtn.insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        row5.zl_imgViewBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            row5.zl_imgViewBtn.topAnchor.constraint(equalTo: row5.topAnchor),
            row5.zl_imgViewBtn.leadingAnchor.constraint(equalTo: row5.leadingAnchor),
            row5.zl_imgViewBtn.trailingAnchor.constraint(equalTo: row5.trailingAnchor),
            row5.zl_imgViewBtn.bottomAnchor.constraint(equalTo: row5.bottomAnchor),
        ])
        addCaption("row.zl_imgViewBtn — 头像靠左，关注按钮靠右（flexibleSpacing）")

        // ── zl_btnLabel：ButtonLabView（点赞 + 数量）──
        addNote("zl_btnLabel — ButtonLabView（Button + Label）")
        let row6 = UIView()
        row6.backgroundColor = .white
        row6.layer.cornerRadius = 10
        addDemo(row6, height: 44)

        row6.zl_btnLabel.thenFirst { btn in
            btn.setTitle("❤️", for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 20)
            btn.flex.size = CGSize(width: 36, height: 36)
        }
        row6.zl_btnLabel.thenSecond { label in
            label.text = "3,456 人点赞"
            label.font = .systemFont(ofSize: 13)
            label.textColor = .systemGray
        }
        row6.zl_btnLabel.minSpacing(6)
        row6.zl_btnLabel.insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        row6.zl_btnLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            row6.zl_btnLabel.topAnchor.constraint(equalTo: row6.topAnchor),
            row6.zl_btnLabel.leadingAnchor.constraint(equalTo: row6.leadingAnchor),
            row6.zl_btnLabel.trailingAnchor.constraint(equalTo: row6.trailingAnchor),
            row6.zl_btnLabel.bottomAnchor.constraint(equalTo: row6.bottomAnchor),
        ])
        addCaption("row.zl_btnLabel — 点赞按钮 + 数量 label")

        // ── zl_labelBtn：LabButtonView（文字 + 更换）──
        addNote("zl_labelBtn — LabButtonView（Label + Button）")
        let row7 = UIView()
        row7.backgroundColor = UIColor.systemGray6
        row7.layer.cornerRadius = 10
        addDemo(row7, height: 44)

        row7.zl_labelBtn.thenFirst { label in
            label.text = "当前版本：v3.2.1"
            label.font = .systemFont(ofSize: 14)
            label.flex.flex = 1
        }
        row7.zl_labelBtn.thenSecond { btn in
            btn.setTitle("检查更新", for: .normal)
            btn.setTitleColor(.systemBlue, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 13)
            btn.insets(UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 0))
        }
        row7.zl_labelBtn.minSpacing(8)
        row7.zl_labelBtn.insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        row7.zl_labelBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            row7.zl_labelBtn.topAnchor.constraint(equalTo: row7.topAnchor),
            row7.zl_labelBtn.leadingAnchor.constraint(equalTo: row7.leadingAnchor),
            row7.zl_labelBtn.trailingAnchor.constraint(equalTo: row7.trailingAnchor),
            row7.zl_labelBtn.bottomAnchor.constraint(equalTo: row7.bottomAnchor),
        ])
        addCaption("row.zl_labelBtn — label(flex:1) + 操作按钮靠右")

        // ── zl_btnImgView：ButtonImgView（播放 + 封面）──
        addNote("zl_btnImgView — ButtonImgView（Button + UIImageView）")
        let row8 = UIView()
        row8.backgroundColor = .white
        row8.layer.cornerRadius = 10
        addDemo(row8, height: 52)

        row8.zl_btnImgView.thenFirst { btn in
            btn.setTitle("▶ 播放", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.backgroundColor = .systemGreen
            btn.radius(12)
            btn.insets(UIEdgeInsets(top: 9, left: 18, bottom: 9, right: 18))
        }
        row8.zl_btnImgView.thenSecond { iv in
            iv.image = UIImage(systemName: "music.note.list")
            iv.tintColor = .systemGreen
            iv.contentMode = .scaleAspectFit
            iv.flex.size = CGSize(width: 26, height: 26)
        }
        row8.zl_btnImgView.flexibleSpacing(true)
        row8.zl_btnImgView.insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        row8.zl_btnImgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            row8.zl_btnImgView.topAnchor.constraint(equalTo: row8.topAnchor),
            row8.zl_btnImgView.leadingAnchor.constraint(equalTo: row8.leadingAnchor),
            row8.zl_btnImgView.trailingAnchor.constraint(equalTo: row8.trailingAnchor),
            row8.zl_btnImgView.bottomAnchor.constraint(equalTo: row8.bottomAnchor),
        ])
        addCaption("row.zl_btnImgView — 播放按钮靠左，音乐图标靠右")

        // ── zl_pairImg：PairImageView（两图并排）──
        addNote("zl_pairImg — PairImageView（UIImageView + UIImageView）")
        let row9 = UIView()
        row9.backgroundColor = .white
        row9.layer.cornerRadius = 10
        addDemo(row9, height: 56)

        row9.zl_pairImg.thenFirst { iv in
            iv.image = UIImage(systemName: "photo.fill")
            iv.tintColor = .systemBlue
            iv.contentMode = .scaleAspectFit
            iv.flex.size = CGSize(width: 36, height: 36)
        }
        row9.zl_pairImg.thenSecond { iv in
            iv.image = UIImage(systemName: "photo.on.rectangle")
            iv.tintColor = .systemGreen
            iv.contentMode = .scaleAspectFit
            iv.flex.size = CGSize(width: 36, height: 36)
        }
        row9.zl_pairImg.minSpacing(12)
        row9.zl_pairImg.insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        row9.zl_pairImg.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            row9.zl_pairImg.topAnchor.constraint(equalTo: row9.topAnchor),
            row9.zl_pairImg.leadingAnchor.constraint(equalTo: row9.leadingAnchor),
            row9.zl_pairImg.trailingAnchor.constraint(equalTo: row9.trailingAnchor),
            row9.zl_pairImg.bottomAnchor.constraint(equalTo: row9.bottomAnchor),
        ])
        addCaption("row.zl_pairImg — 两图并排，minSpacing(12)")

        // ── zl_pairStackView：PairStackView（两列数据）──
        addNote("zl_pairStackView — PairStackView（StackView + StackView）")
        let row10 = UIView()
        row10.backgroundColor = .white
        row10.layer.cornerRadius = 10
        addDemo(row10, height: 64)

        row10.zl_pairStackView.thenFirst { sv in
            sv.axis = .vertical
            sv.spacing = 2
            sv.alignment = .center
            sv.flex.flex = 1
            let t = UILabel(); t.text = "关注"; t.font = .systemFont(ofSize: 11); t.textColor = .systemGray
            let n = UILabel(); n.text = "128"; n.font = .boldSystemFont(ofSize: 17)
            sv.addArrangedSubview(n)
            sv.addArrangedSubview(t)
        }
        row10.zl_pairStackView.thenSecond { sv in
            sv.axis = .vertical
            sv.spacing = 2
            sv.alignment = .center
            sv.flex.flex = 1
            let t = UILabel(); t.text = "粉丝"; t.font = .systemFont(ofSize: 11); t.textColor = .systemGray
            let n = UILabel(); n.text = "2.3万"; n.font = .boldSystemFont(ofSize: 17)
            sv.addArrangedSubview(n)
            sv.addArrangedSubview(t)
        }
        row10.zl_pairStackView.insets = UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 14)
        row10.zl_pairStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            row10.zl_pairStackView.topAnchor.constraint(equalTo: row10.topAnchor),
            row10.zl_pairStackView.leadingAnchor.constraint(equalTo: row10.leadingAnchor),
            row10.zl_pairStackView.trailingAnchor.constraint(equalTo: row10.trailingAnchor),
            row10.zl_pairStackView.bottomAnchor.constraint(equalTo: row10.bottomAnchor),
        ])
        addCaption("row.zl_pairStackView — 两列统计数据，各 flex:1 等宽")

        addSeparator()
    }

    // MARK: ══════════════════════════════════════
    // MARK: ⑤ zl_wrapView — WrapperView 包裹当前视图
    // MARK: ══════════════════════════════════════
    private func demoWrapView() {
        addSection("⑤ zl_wrapView — WrapperView 包裹当前视图")
        addNote(
            "zl_wrapView 与其他属性不同：\n" +
            "它调用 WrapperView.wrap(with: self)，\n" +
            "将当前视图（self）作为 contentView 包裹进 WrapperView。\n" +
            "返回的 WrapperView 是 self 的父级，需要加入页面并设置 insets。\n\n" +
            "适合给已有视图快速加上内边距，无需手动创建 WrapperView 并 addSubview。"
        )

        // 演示1：给 UILabel 加内边距
        addNote("演示1：给 Label 加内边距（Tag 效果）")
        let tagLabel = Label()
        tagLabel.text = "NEW"
        tagLabel.font = .boldSystemFont(ofSize: 12)
        tagLabel.textColor = .white

        // 访问 zl_wrapView 后 tagLabel 已成为 wrapperView 的 contentView
        let wv1 = tagLabel.zl_wrapView
        wv1.insets(4, 12, 4, 12)
        wv1.backgroundColor = .systemRed
        wv1.radius(12)
        stackView.addArrangedSubview(wv1)
        addCaption("label.zl_wrapView.insets(4, 12, 4, 12) — 直接给 Label 套上带内边距的 WrapperView")

        // 演示2：给 Button 加内边距包裹
        addNote("演示2：给 Button 套上带背景/圆角的 WrapperView")
        let innerBtn = Button()
        innerBtn.setTitle("立即抢购", for: .normal)
        innerBtn.setTitleColor(.white, for: .normal)
        innerBtn.titleLabel?.font = .boldSystemFont(ofSize: 15)

        let wv2 = innerBtn.zl_wrapView
        wv2.insets(14, 30, 14, 30)
        wv2.gradColors([UIColor.systemOrange, UIColor.systemRed])
        wv2.gradDirection(start: CGPoint(x: 0, y: 0.5), end: CGPoint(x: 1, y: 0.5))
        wv2.radius(24)
        wv2.shadowColor(color: UIColor.systemRed)
        wv2.shadowOffset(w: 0, h: 5)
        wv2.shadowOpacity(opacity: 0.3)
        let wv2Padder = UIView()
        wv2Padder.addSubview(wv2)
        wv2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wv2.topAnchor.constraint(equalTo: wv2Padder.topAnchor, constant: 8),
            wv2.centerXAnchor.constraint(equalTo: wv2Padder.centerXAnchor),
            wv2.bottomAnchor.constraint(equalTo: wv2Padder.bottomAnchor, constant: -8),
        ])
        stackView.addArrangedSubview(wv2Padder)
        addCaption(
            "btn.zl_wrapView.insets(...)\n" +
            "  .gradColors([orange, red])\n" +
            "  .radius(24) — 一行套上渐变+圆角+阴影样式"
        )

        // 演示3：zl_wrapView 是同一实例
        addNote("演示3：zl_wrapView 也是惰性单例，多次访问返回同一个 WrapperView")
        let testView = UIView()
        let wA = testView.zl_wrapView
        let wB = testView.zl_wrapView
        let isSame = wA === wB
        let verifyLabel = UILabel()
        verifyLabel.text = "view.zl_wrapView === view.zl_wrapView → \(isSame ? "✅ 同一实例" : "❌ 不同实例")"
        verifyLabel.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        verifyLabel.textColor = isSame ? .systemGreen : .systemRed
        stackView.addArrangedSubview(verifyLabel)

        addSeparator()
        addNote(
            "UIViewEx 扩展属性总览：\n" +
            "【第一组】  zl_btn / zl_lab / zl_imgView / zl_stackView\n" +
            "【第二组】  zl_altBtn / zl_altLab / zl_altImgView / zl_altStackView\n" +
            "【第三组】  zl_extraBtn / zl_extraLab / zl_extraImgView / zl_extraStackView\n" +
            "【成对视图】zl_pairLab / zl_pairImg / zl_pairBtn / zl_pairStackView\n" +
            "           zl_imgViewLab / zl_imgViewBtn / zl_btnImgView\n" +
            "           zl_btnLabel / zl_labelBtn / zl_labImgView\n" +
            "【包裹视图】zl_wrapView（WrapperView.wrap(with: self)）\n\n" +
            "核心原理：首次访问 → 创建视图 + addSubview + 缓存到 zl_storage\n" +
            "         后续访问 → 直接从 zl_storage 返回缓存实例（惰性单例）"
        )
    }
}
