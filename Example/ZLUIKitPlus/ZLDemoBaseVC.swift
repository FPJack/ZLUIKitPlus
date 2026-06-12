//
//  ZLDemoBaseVC.swift
//  ZLUIKitPlus_Example
//

import UIKit
import ZLUIKitPlus
import ZLFlexKit
// MARK: - Demo 基础控制器，提供滚动容器和辅助布局方法
class ZLDemoBaseVC: UIViewController {

    let scrollView = UIScrollView()
    let stackView: StackView = {
        
        
        
        let sv = StackView()
        sv.axis = .vertical
        sv.spacing = 16
        sv.justifyContent = .fill
        sv.alignment = .fill
        sv.insets = UIEdgeInsets(top: 20, left: 16, bottom: 40, right: 16)
//        sv.isLayoutMarginsRelativeArrangement = true
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.96, alpha: 1)
        setupScrollView()
        setupDemos()
    }

    /// 子类重写该方法添加 demo
    func setupDemos() {}

    private func setupScrollView() {
        stackView.wrapScrollView().box.addToFull(view)
    }

    // MARK: - 辅助方法

    /// 添加区块标题（蓝色胶囊）
    func addSection(_ text: String) {
        let wv = WrapperView.wrap(with: {
            let l = UILabel()
            l.text = text
            l.font = .boldSystemFont(ofSize: 16)
            l.textColor = .white
            return l
        }()).insets(10, 14, 10, 14)
        wv.backgroundColor = .systemBlue
        wv.radius(10)
        stackView.addArrangedSubview(wv)
    }

    /// 添加灰色说明文字
    func addNote(_ text: String) {
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize: 12)
        l.textColor = .systemGray
        l.numberOfLines = 0
        stackView.addArrangedSubview(l)
    }

    /// 添加斜体注释（紧跟在 demo 视图下方）
    func addCaption(_ text: String) {
        let l = UILabel()
        l.text = "↑ " + text
        l.font = .italicSystemFont(ofSize: 12)
        l.textColor = UIColor.systemGray2
        l.numberOfLines = 0
        stackView.addArrangedSubview(l)
    }

    /// 添加分隔线
    func addSeparator() {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.85, alpha: 1)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 1).isActive = true
        stackView.addArrangedSubview(v)
    }

    /// 添加固定高度的视图
    func addDemo(_ view: UIView, height: CGFloat = 0) {
        view.translatesAutoresizingMaskIntoConstraints = false
        if height > 0 {
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        stackView.addArrangedSubview(view)
    }

    /// 创建带颜色 + 文字的矩形（作为占位图片）
    func makeImage(color: UIColor = .systemBlue,
                   size: CGSize = CGSize(width: 20, height: 20)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
}
