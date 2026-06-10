//
//  ZLPairViewDemoVC.swift
//  ZLUIKitPlus_Example
//
//  PairView 全部子类详细用法 Demo
//
//  PairView 继承自 StackView，封装了「两个固定类型子视图」的组合。
//  通过 thenFirst/thenSecond 闭包配置 first/second 视图，
//  提供布局控制 API（全部返回 Self，可链式）：
//  • minSpacing(_ : CGFloat)        — 两视图间最小间距
//  • maxSpacing(_ : CGFloat)        — 两视图间最大间距（与 min 配合弹性）
//  • flexibleSpacing(_ : Bool)      — first 靠起点，second 靠终点
//  • firstFlex(_ : Int)             — first 视图 flex 权重
//  • secondFlex(_ : Int)            — second 视图 flex 权重
//  • firstStart/firstEnd(_ :)       — first 视图交叉轴方向偏移
//  • secondStart/secondEnd(_ :)     — second 视图交叉轴方向偏移
//  • insets: UIEdgeInsets           — 整体内边距（继承 StackView）
//
//  子类列表（12 种）：
//  PairLabelView    — Label + Label
//  ImgLabelView     — UIImageView + Label
//  LabelImgView     — Label + UIImageView
//  PairImageView    — UIImageView + UIImageView
//  PairButtonView   — Button + Button
//  ImgButtonView    — UIImageView + Button
//  ButtonImgView    — Button + UIImageView
//  ButtonLabView    — Button + Label
//  LabButtonView    — Label + Button
//  ZLButtonStackView — Button + StackView
//  StackViewButton  — StackView + Button
//  PairStackView    — StackView + StackView

import UIKit
import ZLUIKitPlus
import ZLFlexKit   // 需要 StackView 类型（ZLButtonStackView/StackViewButton/PairStackView 的闭包参数）

class ZLPairViewDemoVC: ZLDemoBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PairView Demo"
    }

    override func setupDemos() {
        addNote("PairView 是基于 StackView 的两元素组合视图。所有子类通过 thenFirst / thenSecond 闭包配置 first/second 视图。布局控制 API 全部返回 Self 支持链式调用。")
        addSeparator()

        demoPairLabelView()
        demoImgLabelView()
        demoLabelImgView()
        demoPairImageView()
        demoPairButtonView()
        demoImgButtonView()
        demoButtonImgView()
        demoButtonLabView()
        demoLabButtonView()
        demoButtonStackView()
        demoStackViewButton()
        demoPairStackView()
        demoPairViewAPI()
    }

    // MARK: - 辅助：包裹 PairView 并添加背景
    private func wrap(_ pairView: UIView, height: CGFloat = 50, bg: UIColor = .white) -> UIView {
        pairView.backgroundColor = bg
        pairView.translatesAutoresizingMaskIntoConstraints = false
        pairView.heightAnchor.constraint(equalToConstant: height).isActive = true
        return pairView
    }

    // MARK: ① PairLabelView — Label + Label
    private func demoPairLabelView() {
        addSection("① PairLabelView — Label + Label")
        addNote("最常用的键值对布局：左侧标题 + 右侧内容。flexibleSpacing(true) 让两 Label 分别靠两端。")

        // 场景1：名称+价格（弹性间距）
        let pv1 = PairLabelView()
        pv1.thenFirst { label in
            label.text = "商品名称"
            label.font = .systemFont(ofSize: 15, weight: .medium)
        }
        pv1.thenSecond { label in
            label.text = "¥ 9,999"
            label.font = .systemFont(ofSize: 15, weight: .bold)
            label.textColor = .systemRed
        }
        pv1.flexibleSpacing(true)  // first 靠左，second 靠右
        pv1.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        addDemo(wrap(pv1, height: 44))
        addCaption("flexibleSpacing(true)：左标题靠左，右价格靠右")

        // 场景2：标签+值（固定最小间距）
        let pv2 = PairLabelView()
        pv2.thenFirst { label in
            label.text = "快递时间"
            label.font = .systemFont(ofSize: 13)
            label.textColor = .systemGray
        }
        pv2.thenSecond { label in
            label.text = "预计 2026-06-12 送达"
            label.font = .systemFont(ofSize: 13)
        }
        pv2.minSpacing(12)
        pv2.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        addDemo(wrap(pv2, height: 38))
        addCaption("minSpacing(12)：两 label 间距至少 12pt")

        addSeparator()
    }

    // MARK: ② ImgLabelView — UIImageView + Label
    private func demoImgLabelView() {
        addSection("② ImgLabelView — UIImageView + Label")
        addNote("图标在左，文字在右的常见组合（如列表 cell 的 icon + title）。")

        let pv = ImgLabelView()
        pv.thenFirst { iv in
            iv.image = UIImage(systemName: "star.fill")
            iv.tintColor = .systemYellow
            iv.contentMode = .scaleAspectFit
            iv.flex.size = CGSize(width: 22, height: 22)
        }
        pv.thenSecond { label in
            label.text = "五星好评推荐商品"
            label.font = .systemFont(ofSize: 14)
        }
        pv.minSpacing(10)
        pv.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        addDemo(wrap(pv, height: 40))
        addCaption("ImgLabelView：icon(22×22) + label，minSpacing(10)")

        addSeparator()
    }

    // MARK: ③ LabelImgView — Label + UIImageView
    private func demoLabelImgView() {
        addSection("③ LabelImgView — Label + UIImageView")
        addNote("文字在左，图标在右（如列表 cell 的 title + 箭头）。label 用 flex.flex=1 填满剩余空间。")

        let pv = LabelImgView()
        pv.thenFirst { label in
            label.text = "查看更多详情"
            label.font = .systemFont(ofSize: 14)
            label.flex.flex = 1  // 撑满剩余空间
        }
        pv.thenSecond { iv in
            iv.image = UIImage(systemName: "chevron.right")
            iv.tintColor = .systemGray3
            iv.contentMode = .scaleAspectFit
            iv.flex.size = CGSize(width: 14, height: 14)
        }
        pv.minSpacing(8)
        pv.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        pv.layer.cornerRadius = 8
        pv.clipsToBounds = true
        addDemo(wrap(pv, height: 44, bg: UIColor.systemGray6))
        addCaption("LabelImgView：label.flex.flex=1 填满空间，箭头靠右")

        addSeparator()
    }

    // MARK: ④ PairImageView — UIImageView + UIImageView
    private func demoPairImageView() {
        addSection("④ PairImageView — UIImageView + UIImageView")
        addNote("两图并排，可用于展示两个状态图标、对比图等。minSpacing+maxSpacing 控制弹性间距区间。")

        let pv = PairImageView()
        pv.thenFirst { iv in
            iv.image = UIImage(systemName: "photo.fill")
            iv.tintColor = .systemBlue
            iv.contentMode = .scaleAspectFit
            iv.flex.size = CGSize(width: 36, height: 36)
        }
        pv.thenSecond { iv in
            iv.image = UIImage(systemName: "photo.on.rectangle")
            iv.tintColor = .systemGreen
            iv.contentMode = .scaleAspectFit
            iv.flex.size = CGSize(width: 36, height: 36)
        }
        pv.minSpacing(12).maxSpacing(30)
        pv.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        addDemo(wrap(pv, height: 54))
        addCaption("PairImageView：minSpacing(12) + maxSpacing(30) — 弹性间距区间")

        addSeparator()
    }

    // MARK: ⑤ PairButtonView — Button + Button
    private func demoPairButtonView() {
        addSection("⑤ PairButtonView — Button + Button")
        addNote("双按钮布局（如取消/确认对话框）。secondFlex(1)/firstFlex(1) 按比例分配空间。")

        // 等宽双按钮
        let pv1 = PairButtonView()
        pv1.thenFirst { btn in
            btn.setTitle("取消", for: .normal)
            btn.setTitleColor(.systemGray, for: .normal)
            btn.backgroundColor = UIColor.systemGray.withAlphaComponent(0.1)
            btn.radius(10)
        }
        pv1.thenSecond { btn in
            btn.setTitle("确定", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.backgroundColor = .systemBlue
            btn.radius(10)
        }
        pv1.firstFlex(1).secondFlex(1).minSpacing(12)
        pv1.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        addDemo(wrap(pv1, height: 44))
        addCaption("firstFlex(1) + secondFlex(1)：两按钮等宽分配")

        // 1:2 比例
        let pv2 = PairButtonView()
        pv2.thenFirst { btn in
            btn.setTitle("取消", for: .normal)
            btn.setTitleColor(.systemRed, for: .normal)
            btn.backgroundColor = UIColor.systemRed.withAlphaComponent(0.08)
            btn.radius(10)
        }
        pv2.thenSecond { btn in
            btn.setTitle("立即购买（2倍宽）", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.backgroundColor = .systemRed
            btn.radius(10)
        }
        pv2.firstFlex(1).secondFlex(2).minSpacing(12)
        pv2.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        addDemo(wrap(pv2, height: 44))
        addCaption("firstFlex(1) + secondFlex(2)：1:2 宽度比例")

        addSeparator()
    }

    // MARK: ⑥ ImgButtonView — UIImageView + Button
    private func demoImgButtonView() {
        addSection("⑥ ImgButtonView — UIImageView + Button")
        addNote("头像/图片在左，操作按钮在右。flexibleSpacing 让图片靠左、按钮靠右。")

        let pv = ImgButtonView()
        pv.thenFirst { iv in
            iv.image = UIImage(systemName: "person.circle.fill")
            iv.tintColor = .systemGray3
            iv.contentMode = .scaleAspectFit
            iv.flex.size = CGSize(width: 44, height: 44)
        }
        pv.thenSecond { btn in
            btn.setTitle("+ 关注", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.backgroundColor = .systemBlue
            btn.radius(14)
            btn.insets(UIEdgeInsets(top: 6, left: 18, bottom: 6, right: 18))
        }
        pv.flexibleSpacing(true)
        pv.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        addDemo(wrap(pv, height: 56))
        addCaption("ImgButtonView：头像靠左，关注按钮靠右（flexibleSpacing）")

        addSeparator()
    }

    // MARK: ⑦ ButtonImgView — Button + UIImageView
    private func demoButtonImgView() {
        addSection("⑦ ButtonImgView — Button + UIImageView")
        addNote("操作按钮在左，图片在右。常见于播放器控件、媒体封面等。")

        let pv = ButtonImgView()
        pv.thenFirst { btn in
            btn.setTitle("▶ 播放", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.backgroundColor = .systemGreen
            btn.radius(12)
            btn.insets(UIEdgeInsets(top: 8, left: 18, bottom: 8, right: 18))
        }
        pv.thenSecond { iv in
            iv.image = UIImage(systemName: "music.note.list")
            iv.tintColor = .systemGreen
            iv.contentMode = .scaleAspectFit
            iv.flex.size = CGSize(width: 28, height: 28)
        }
        pv.flexibleSpacing(true)
        pv.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        addDemo(wrap(pv, height: 52))
        addCaption("ButtonImgView：播放按钮靠左，音乐图标靠右")

        addSeparator()
    }

    // MARK: ⑧ ButtonLabView — Button + Label
    private func demoButtonLabView() {
        addSection("⑧ ButtonLabView — Button + Label")
        addNote("操作按钮在左，说明文字在右。常见于点赞/评论行。")

        let pv = ButtonLabView()
        pv.thenFirst { btn in
            btn.setTitle("❤️", for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 22)
            btn.flex.size = CGSize(width: 40, height: 40)
        }
        pv.thenSecond { label in
            label.text = "12,345 人点赞"
            label.font = .systemFont(ofSize: 13)
            label.textColor = .systemGray
        }
        pv.minSpacing(6)
        pv.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        addDemo(wrap(pv, height: 48))
        addCaption("ButtonLabView：点赞按钮 + 数量文字")

        addSeparator()
    }

    // MARK: ⑨ LabButtonView — Label + Button
    private func demoLabButtonView() {
        addSection("⑨ LabButtonView — Label + Button")
        addNote("文字在左（flex.flex=1 撑满），操作按钮在右。常见于选择行。")

        let pv = LabButtonView()
        pv.thenFirst { label in
            label.text = "已选：iPhone 15 Pro Max 256GB 深空黑"
            label.font = .systemFont(ofSize: 14)
            label.numberOfLines = 1
            label.flex.flex = 1
        }
        pv.thenSecond { btn in
            btn.setTitle("更换", for: .normal)
            btn.setTitleColor(.systemBlue, for: .normal)
            btn.insets(UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 0))
        }
        pv.minSpacing(8)
        pv.insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        pv.layer.cornerRadius = 8
        pv.clipsToBounds = true
        addDemo(wrap(pv, height: 44, bg: UIColor.systemGray6))
        addCaption("LabButtonView：label.flex.flex=1 填满，更换按钮靠右")

        addSeparator()
    }

    // MARK: ⑩ ZLButtonStackView — Button + StackView
    private func demoButtonStackView() {
        addSection("⑩ ZLButtonStackView — Button + StackView")
        addNote("按钮在左，StackView（可放多个子视图）在右。常见于「加入购物车 + 价格信息」布局。")

        let pv = ZLButtonStackView()
        pv.thenFirst { btn in
            btn.setImage(UIImage(systemName: "cart.fill"), for: .normal)
            btn.setTitle(" 加入购物车", for: .normal)
            btn.tintColor = .white
            btn.setTitleColor(.white, for: .normal)
            btn.backgroundColor = .systemOrange
            btn.radius(12)
            btn.insets(UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14))
        }
        pv.thenSecond { sv in
            sv.axis = .vertical
            sv.spacing = 2
            let price = UILabel()
            price.text = "到手价 ¥ 5,999"
            price.font = .systemFont(ofSize: 13, weight: .bold)
            price.textColor = .systemRed
            let tag = UILabel()
            tag.text = "已享满减优惠"
            tag.font = .systemFont(ofSize: 11)
            tag.textColor = .systemGray
            sv.addArrangedSubview(price)
            sv.addArrangedSubview(tag)
        }
        pv.minSpacing(12)
        pv.insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        addDemo(wrap(pv, height: 64))
        addCaption("ZLButtonStackView：购物车按钮左 + 价格信息 StackView 右")

        addSeparator()
    }

    // MARK: ⑪ StackViewButton — StackView + Button
    private func demoStackViewButton() {
        addSection("⑪ StackViewButton — StackView + Button")
        addNote("StackView 在左（flex.flex=1），按钮在右。常见于商品行。")

        let pv = StackViewButton()
        pv.thenFirst { sv in
            sv.axis = .vertical
            sv.spacing = 3
            sv.flex.flex = 1
            let title = UILabel()
            title.text = "AirPods Pro（第三代）"
            title.font = .systemFont(ofSize: 15, weight: .medium)
            let sub = UILabel()
            sub.text = "主动降噪 · MagSafe 充电盒"
            sub.font = .systemFont(ofSize: 12)
            sub.textColor = .systemGray
            sv.addArrangedSubview(title)
            sv.addArrangedSubview(sub)
        }
        pv.thenSecond { btn in
            btn.setTitle("¥1,899", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.backgroundColor = .systemBlue
            btn.radius(10)
            btn.insets(UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14))
        }
        pv.minSpacing(12)
        pv.insets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        addDemo(wrap(pv, height: 66))
        addCaption("StackViewButton：商品信息 StackView(flex:1) 左 + 购买按钮右")

        addSeparator()
    }

    // MARK: ⑫ PairStackView — StackView + StackView
    private func demoPairStackView() {
        addSection("⑫ PairStackView — StackView + StackView")
        addNote("两个 StackView 并排（各 flex.flex=1 等宽），常见于数据展示行（销量/好评）。")

        let pv = PairStackView()
        pv.thenFirst { sv in
            sv.axis = .vertical
            sv.spacing = 2
            sv.alignment = .center
            sv.flex.flex = 1
            let t = UILabel(); t.text = "累计销量"; t.font = .systemFont(ofSize: 11); t.textColor = .systemGray
            let v = UILabel(); v.text = "100万+"; v.font = .boldSystemFont(ofSize: 17)
            sv.addArrangedSubview(t)
            sv.addArrangedSubview(v)
        }
        pv.thenSecond { sv in
            sv.axis = .vertical
            sv.spacing = 2
            sv.alignment = .center
            sv.flex.flex = 1
            let t = UILabel(); t.text = "好评率"; t.font = .systemFont(ofSize: 11); t.textColor = .systemGray
            let v = UILabel(); v.text = "99.8%"; v.font = .boldSystemFont(ofSize: 17); v.textColor = .systemGreen
            sv.addArrangedSubview(t)
            sv.addArrangedSubview(v)
        }
        pv.insets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        addDemo(wrap(pv, height: 64))
        addCaption("PairStackView：两个竖向 StackView 各 flex:1 等宽排列")

        addSeparator()
    }

    // MARK: PairView 通用 API 说明
    private func demoPairViewAPI() {
        addSection("PairView 通用布局 API 总览")
        addNote(
            "以下 API 全部支持链式调用（返回 Self）：\n\n" +
            "• thenFirst { view in ... }     配置 first 视图\n" +
            "• thenSecond { view in ... }    配置 second 视图\n\n" +
            "间距控制：\n" +
            "• minSpacing(_ x: CGFloat)      两视图间最小间距\n" +
            "• maxSpacing(_ x: CGFloat)      两视图间最大间距\n" +
            "• flexibleSpacing(_ : Bool)     弹性间距（first靠起点，second靠终点）\n\n" +
            "权重控制：\n" +
            "• firstFlex(_ n: Int)           first 视图主轴 flex 权重\n" +
            "• secondFlex(_ n: Int)          second 视图主轴 flex 权重\n\n" +
            "交叉轴偏移：\n" +
            "• firstStart(_ x:) / firstEnd(_ x:)   first 视图交叉轴 start/end 偏移\n" +
            "• secondStart(_ x:) / secondEnd(_ x:)  second 视图交叉轴 start/end 偏移\n\n" +
            "继承 StackView：\n" +
            "• insets: UIEdgeInsets          整体内边距\n" +
            "• axis: StackViewAxis           排列方向（默认 .horizontal）"
        )
    }
}
