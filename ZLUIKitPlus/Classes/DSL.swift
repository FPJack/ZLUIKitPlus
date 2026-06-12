//
//  DSL.swift
//  ZLUIKitPlus
//
//  Created by admin on 2026/6/12.
//

import ZLFlexKit



public struct DSL<Base: UIView>: StackViewDSL {
    ///附属view
    public let view: Base
    
    ///系统约束布局属性
    public var box: LayoutBox {
        view.box
    }
    ///弹性布局属性
    public var flex: FlexItemSwift<Base> {
        view.flex
    }
    
    ///装饰属性
    @available(iOS 13.0, *)
    public var decor: Decoration<Base> {
        view.decor
    }
    
    ///StackView DSL协议方法
    public func getDslView() -> UIView? {
        view
    }
    init(view: Base) {
        self.view = view
    }
}


public protocol DSLCompatible where Self: UIView {}

extension DSLCompatible {
    public var dsl: DSL<Self> {
        DSL(view: self)
    }
}
extension UIView: DSLCompatible,TapActionable {}


public extension DSL {
    @discardableResult
    func addSubview(_ subview: UIView) -> Self {
        view.addSubview(subview)
        return self
    }
    
    @discardableResult
    func insertSubview(_ subview: UIView, at index: Int) -> Self {
        view.insertSubview(subview, at: index)
        return self
    }
    
    @discardableResult
    func backgroundColor(_ color: ColorRepresentable?) -> Self {
        view.backgroundColor = color?.getColor
        
        return self
    }
    @discardableResult
    func hidden(_ hidden: Bool) -> Self {
        view.isHidden = hidden
        return self
    }
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        view.alpha = alpha
        return self
    }
    
    @discardableResult
    func contentMode(_ mode: UIView.ContentMode ) -> Self {
        view.contentMode = mode
        return self
    }
    
    @discardableResult
    func tintColor(_ color: ColorRepresentable?) -> Self {
        view.tintColor = color?.getColor
        return self
    }
    
    @discardableResult
    func borderColor(color: ColorRepresentable?) -> Self {
        view.layer.borderColor = color?.getColor?.cgColor
        return self
    }
    
    @discardableResult
    func borderWidth(w: Double) -> Self {
        view.layer.borderWidth = CGFloat(w)
        return self
    }
    
    @discardableResult
    func border(color: ColorRepresentable?, w: Double) -> Self {
        return borderColor(color: color).borderWidth(w: w)
    }
    @discardableResult
    func shadowColor(color: ColorRepresentable?) -> Self {
        view.layer.shadowColor = color?.getColor?.cgColor
        return self
    }
    @discardableResult
    func shadowOffset(w: Double,h: Double) -> Self {
        view.layer.shadowOffset = CGSize(width: w, height: h)
        return self
    }
    @discardableResult
    func shadowRadius(radius: Double) -> Self {
        view.layer.shadowRadius = radius
        return self
    }
    @discardableResult
    func shadowOpacity(opacity: Float) -> Self {
        view.layer.shadowOpacity = opacity
        return self
    }
    @discardableResult
    func radius(_ radius: CGFloat) -> Self {
        view.layer.cornerRadius = radius
        return self
    }
    @discardableResult
    @available(iOS 11.0, *)
    func corner(_ corners: CACornerMask, radius: CGFloat) -> Self {
        view.layer.cornerRadius = radius
        view.layer.maskedCorners = corners
        return self
    }
    @discardableResult
    func masksToBounds(_ masks: Bool = true) -> Self {
        view.layer.masksToBounds = masks
        return self
    }
    
    @discardableResult
    func tapAction(_ action: @escaping (Base) -> Void) -> Self {
        view.tapAction {action($0)}
        return self
    }
    
    @discardableResult
    func height(_ height: NumberConvertible) -> Self {
        view.heightAnchor.constraint(equalToConstant: height.cgFloat).isActive = true
        return self
    }
    
    @discardableResult
    func width(_ width: NumberConvertible) -> Self {
        view.widthAnchor.constraint(equalToConstant: width.cgFloat).isActive = true
        return self
    }
    
    @discardableResult
    func size(w: NumberConvertible,h: NumberConvertible) -> Self {
        width(w.cgFloat).height(h.cgFloat)
    }
    
    @discardableResult
    func square(_ side: NumberConvertible) -> Self {
        width(side).height(side)
    }
    
    
    @discardableResult
    func compression(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        view.setContentCompressionResistancePriority(priority, for: axis)
        return self
    }
    
    @discardableResult
    func hugging(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        view.setContentHuggingPriority(priority, for: axis)
        return self
    }
    
    @discardableResult
    func isUserInteractionEnabled(_ enabled: Bool) -> Self {
        view.isUserInteractionEnabled = enabled
        return self
    }
    
    @discardableResult
    func tag(_ tag: Int) -> Self {
        view.tag = tag
        return self
    }
}



public extension DSL where Base: UILabel {
    /// MARK: - UILabel
    
    @discardableResult
    func text(_ text: String?) -> Self {
        view.text = text
        return self
    }
    
    @discardableResult
    func textColor(_ color: ColorRepresentable?) -> Self {
        view.textColor = color?.getColor
        return self
    }
    
    @discardableResult
    func font(_ font: UIFont?) -> Self {
        view.font = font
        return self
    }
    
    @discardableResult
    func fontSize(_ size: CGFloat) -> Self {
        self.font(.systemFont(ofSize: size))
    }
    
    @discardableResult
    func text(_ text: String?, color: ColorRepresentable? = nil, fontSize: CGFloat? = nil) -> Self {
        view.text = text
        if let color = color {
            view.textColor = color.getColor
        }
        if let fontSize = fontSize {
            view.font = .systemFont(ofSize: fontSize)
        }
        return self
    }
    
    @discardableResult
    func numberOfLines(_ lines: Int) -> Self {
        view.numberOfLines = lines
        return self
    }
    
    @discardableResult
    func singleLine() -> Self {
        view.numberOfLines = 1
        return self
    }
    
    @discardableResult
    func multipleLines() -> Self {
        view.numberOfLines = 0
        return self
    }
    
    @discardableResult
    func twoLines() -> Self {
        view.numberOfLines = 2
        return self
    }
    
    @discardableResult
    func attributedText(_ text: NSAttributedString?) -> Self {
        view.attributedText = text
        return self
    }
    
    @discardableResult
    func adjustsFontSizeToFitWidth(_ adjusts: Bool) -> Self {
        view.adjustsFontSizeToFitWidth = adjusts
        return self
    }
    
    @discardableResult
    func preferredMaxLayoutWidth(_ width: CGFloat) -> Self {
        view.preferredMaxLayoutWidth = width
        return self
    }
    
    @discardableResult
    func shadowColor(_ color: ColorRepresentable?) -> Self {
        view.shadowColor = color?.getColor
        return self
    }
    
    @discardableResult
    func shadowOffset(w: Double,h: Double) -> Self {
        view.shadowOffset = CGSize(width: w, height: h)
        return self
    }
}

/// MARK: - UIButton
public extension DSL where Base: UIButton {
    @discardableResult
    func title(_ title: String?, for state: UIControl.State = .normal) -> Self {
        view.setTitle(title, for: state)
        return self
    }
    @discardableResult
    func titleColor(_ color: ColorRepresentable?, for state: UIControl.State = .normal) -> Self {
        view.setTitleColor(color?.getColor, for: state)
        return self
    }
    @discardableResult
    func font(_ font: UIFont?) -> Self {
        view.titleLabel?.font = font
        return self
    }
    @discardableResult
    func fontSize(_ size: CGFloat) -> Self {
        self.font(.systemFont(ofSize: size))
    }
    @discardableResult
    func image(_ image: ImageSource?, for state: UIControl.State = .normal) -> Self {
        view.setImage(image?.img, for: state)
        return self
    }
    @discardableResult
    func backgroundImage(_ image: ImageSource?, for state: UIControl.State = .normal) -> Self {
        view.setBackgroundImage(image?.img, for: state)
        return self
    }
    @discardableResult
    func selected(_ selected: Bool) -> Self {
        view.isSelected = selected
        return self
    }
    @discardableResult
    func highlighted(_ highlighted: Bool) -> Self {
        view.isHighlighted = highlighted
        return self
    }
    @discardableResult
    func enabled(_ enabled: Bool) -> Self {
        view.isEnabled = enabled
        return self
    }
    @discardableResult
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) -> Self {
        view.addTarget(target, action: action, for: controlEvents)
        return self
    }
}


/// MARK: - UIImageView
extension DSL where Base: UIImageView {
    @discardableResult
    ///设置图片，可以是图片名称或者UIImage对象
    public func image(_ image: ImageSource? = nil) -> Self {
        guard let image = image else {
            view.image = nil
            return self
        }
        view.image = image.img
        return self
    }
    @discardableResult
    public func url(_ url: String?, placeholder: ImageSource? = nil) -> Self {
        UIImageView.imageLoader?(view,url, placeholder?.img)
        return self
    }
}


extension DSL where Base: UISwitch {
    @discardableResult
    public func setOn(_ on: Bool, animated: Bool) -> Self{
        view.setOn(on, animated: animated)
        return self
    }
    
    @discardableResult
    public func onTintColor(_ color: ColorRepresentable?) -> Self {
        view.onTintColor = color?.getColor
        return self
    }
    @discardableResult
    public func thumbTintColor(_ color: ColorRepresentable?) -> Self {
        view.thumbTintColor = color?.getColor
        return self
    }
    
    @discardableResult
    public func onImage(_ image: ImageSource) -> Self {
        view.onImage = image.img
        return self
    }
    
    @discardableResult
    public func offImage(_ image: ImageSource) -> Self {
        view.offImage = image.img
        return self
    }
}

extension DSL where Base: UITextField {
    @discardableResult
    public func text(_ text: String?) -> Self {
        view.text = text
        return self
    }
    
    @discardableResult
    public func placeholder(_ placeholder: String?) -> Self {
        view.placeholder = placeholder
        return self
    }
    
    @discardableResult
    public func textColor(_ color: ColorRepresentable?) -> Self {
        view.textColor = color?.getColor
        return self
    }
    
    @discardableResult
    public func font(_ font: UIFont?) -> Self {
        view.font = font
        return self
    }
    
    @discardableResult
    public func fontSize(_ size: CGFloat) -> Self {
        self.font(.systemFont(ofSize: size))
    }
    
    @discardableResult
    func text(_ text: String?, color: ColorRepresentable? = nil, fontSize: CGFloat? = nil) -> Self {
        view.text = text
        if let color = color {
            view.textColor = color.getColor
        }
        if let fontSize = fontSize {
            view.font = .systemFont(ofSize: fontSize)
        }
        return self
    }
    
    @discardableResult
    public func borderStyle(_ style: UITextField.BorderStyle) -> Self {
        view.borderStyle = style
        return self
    }
    
    @discardableResult
    public func textAlignment(_ alignment: NSTextAlignment) -> Self {
        view.textAlignment = alignment
        return self
    }
    
    @discardableResult
    public func isSecureTextEntry(_ secure: Bool) -> Self {
        view.isSecureTextEntry = secure
        return self
    }
    
    @discardableResult
    public func clearButtonMode(_ mode: UITextField.ViewMode) -> Self {
        view.clearButtonMode = mode
        return self
    }
    
    @discardableResult
    public func leftView(_ view: UIView?, mode: UITextField.ViewMode) -> Self {
        self.view.leftView = view
        return self
    }
    
    @discardableResult
    public func rightView(_ view: UIView?, mode: UITextField.ViewMode) -> Self
    {
        self.view.rightView = view
        return self
    }
    
    @discardableResult
    public func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) -> Self {
        view.addTarget(target, action: action, for: controlEvents)
        return self
    }
    
    @discardableResult
    public func delegate(_ delegate: UITextFieldDelegate?) -> Self {
        view.delegate = delegate
        return self
    }
}
