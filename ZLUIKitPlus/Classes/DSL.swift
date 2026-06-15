//
//  DSL.swift
//  ZLUIKitPlus
//
//  Created by admin on 2026/6/12.
//

import ZLFlexKit
import Combine
public struct DSL<Base: UIView>: StackViewDSL {
    ///附属view
    public let view: Base
    
    ///系统约束布局属性
    public var box: LayoutBox {
        view.box
    }
    
    ///弹性布局属性
    var flex: FlexItem {
        view.flex
    }
    
    ///动态装饰属性
    @available(iOS 13.0, *)
    var dStyle: DynamicViewStyle<Base> {
        view.dStyle
    }
    
    ///StackView DSL协议方法
    public func getDslView() -> UIView? {
        view
    }
    init(view: Base) {
        self.view = view
    }
    
    @discardableResult
    @available(iOS 13.0, *)
    public func apply(
        dsl: ((DSL) -> Void)? = nil,
        dStyle: ((DynamicViewStyle<Base>) -> Void)? = nil,
        flex:((FlexItem) -> Void)? = nil) -> Self {
        dsl?(self)
        dStyle?(self.dStyle)
        flex?(self.flex)
        return self
    }
    
    @discardableResult
    public func apply(
        dsl: ((DSL) -> Void)? = nil,
        flex:((FlexItem) -> Void)? = nil) -> Self {
        dsl?(self)
        flex?(self.flex)
        return self
    }
    
    @discardableResult
    public func apply(
        dsl: ((DSL) -> Void)? = nil,
        box:((LayoutBox) -> Void)? = nil) -> Self {
        dsl?(self)
        box?(self.box)
        return self
    }
}


public protocol DSLCompatible where Self: UIView {}

extension DSLCompatible {
    ///StackView之外布局优先调用DSL
    public var dsl: DSL<Self> {
        DSL(view: self)
    }
    
    
    ///StackView 里面布局优先调用这个函数
    public func flex(_ p: Void? = nil) -> DSL<Self> {
        dsl
    }
}
extension UIView: DSLCompatible,TapActionable {}


///view通用属性和方法
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

/// 弹性布局
extension DSL {
    
    /// 设置弹性布局的间距属性，
    /// - Parameter spacing: 一个数字类型的值，表示子视图之间的间距，可以是整数、浮点数等类型。该值会被转换为CGFloat类型，并应用于弹性布局的spacing属性。
    /// - Returns: 返回当前DSL实例，便于链式调用
    @discardableResult
    public func spacing(_ spacing: NumberConvertible) -> Self {
        flex.spacing = spacing.cgFloat
        return self
    }
    
    
    
    /// 设置当前View纵轴方向的对齐方式，
    /// - Parameter align: <#align description#>
    /// - Returns: <#description#>
    @discardableResult
    public func alignSelf(_ align: FlexItemCrossAlign) -> Self {
        flex.alignSelf = align
        return self
    }
    
    
    
    /// 设置当前View 在弹性布局中的外边距
    /// - Parameter margin: <#margin description#>
    /// - Returns: <#description#>
    @discardableResult
    public func margin(_ margin: NSDirectionalEdgeInsets) -> Self {
        flex.margin = margin
        return self
    }
    
    
    
    /// 设置当前View 在弹性布局中的外边距
    /// - Parameters:
    ///   - top: <#top description#>
    ///   - leading: <#leading description#>
    ///   - bottom: <#bottom description#>
    ///   - trailing: <#trailing description#>
    /// - Returns: <#description#>
    @discardableResult
    public func margin(top: NumberConvertible? = nil,leading: NumberConvertible? = nil,  bottom: NumberConvertible? = nil,trailing: NumberConvertible? = nil) -> Self {
        flex.margin(top: top,leading: leading,bottom: bottom,trailing: trailing)
        return self
    }
    
    
    
    ///  设置当前View 后面的最小间距
    /// - Parameter spacing: <#spacing description#>
    /// - Returns: <#description#>
    @discardableResult
    public func minSpacing(_ spacing: NumberConvertible) -> Self {
        flex.minSpacing = spacing.cgFloat
        return self
    }
    
    
    /// 设置当前View 后面的最大间距
    /// - Parameter spacing: <#spacing description#>
    /// - Returns: <#description#>
    @discardableResult
    public func maxSpacing(_ spacing: NumberConvertible) -> Self {
        flex.maxSpacing = spacing.cgFloat
        return self
    }
    
    
    
    /// 设置当前View 后面是否为弹性空间
    /// - Parameter isFlex: <#isFlex description#>
    /// - Returns: <#description#>
    @discardableResult
    public func isFlexibleSpace(_ isFlex: Bool) -> Self {
        flex.isFlexibleSpace = isFlex
        return self
    }
    
    
    /// 设置当前View 的弹性系数，决定了在弹性布局中该View如何分配剩余空间
    /// - Parameter value: <#value description#>
    /// - Returns: <#description#>
    @discardableResult
    public func flex(_ value: Int) -> Self {
        flex.flex = value
        return self
    }
    
    
    /// 设置当前View 的高度，决定了在弹性布局中该View的尺寸
    /// - Parameter height: <#height description#>
    /// - Returns: <#description#>
    @discardableResult
    public func height(_ height: NumberConvertible) -> Self {
        flex.height = height.cgFloat
        return self
    }
    
    
    /// 设置当前View 的宽度，决定了在弹性布局中该View的尺寸
    /// - Parameter width: <#width description#>
    /// - Returns: <#description#>
    @discardableResult
    public func width(_ width: NumberConvertible) -> Self {
        flex.width = width.cgFloat
        return self
    }
    
    
    /// 设置当前View 的最小宽度，决定了在弹性布局中该View的尺寸不能小于这个值
    /// - Parameter width: <#width description#>
    /// - Returns: <#description#>
    @discardableResult
    public func minWidth(_ width: NumberConvertible) -> Self {
        flex.minWidth = width.cgFloat
        return self
    }
    
    
    
    ///  设置当前View 的最大宽度，决定了在弹性布局中该View的尺寸不能大于这个值
    /// - Parameter width: <#width description#>
    /// - Returns: <#description#>
    @discardableResult
    public func maxWidth(_ width: NumberConvertible) -> Self {
        flex.maxWidth = width.cgFloat
        return self
    }
    
    
    
    /// 设置当前View 的最小高度，决定了在弹性布局中该View的尺寸不能小于这个值
    /// - Parameter height: <#height description#>
    /// - Returns: <#description#>
    @discardableResult
    public func minHeight(_ height: NumberConvertible) -> Self {
        flex.minHeight = height.cgFloat
        return self
    }
    
    
    
    ///  设置当前View 的最大高度，决定了在弹性布局中该View的尺寸不能大于这个值
    /// - Parameter height: <#height description#>
    /// - Returns: <#description#>
    @discardableResult
    public func maxHeight(_ height: NumberConvertible) -> Self {
        flex.maxHeight = height.cgFloat
        return self
    }
    
    
    
    ///  设置当前View 的尺寸，决定了在弹性布局中该View的宽度和高度
    /// - Parameters:
    ///   - w: <#w description#>
    ///   - h: <#h description#>
    /// - Returns: <#description#>
    @discardableResult
    public func size(w: NumberConvertible,h: NumberConvertible) -> Self {
        flex.size = CGSize(width: w.cgFloat, height: h.cgFloat)
        return self
    }
    
    
    /// 设置当前View 的尺寸为一个正方形，决定了在弹性布局中该View的宽度和高度相等
    /// - Parameter side: <#side description#>
    /// - Returns: <#description#>
    @discardableResult
    public func square(_ side: NumberConvertible) -> Self {
        width(side).height(side)
    }
}


///动态装饰
@available(iOS 13.0, *)
public extension DSL {
    
    
    
    /// 根据一个值的类型和满足条件来触发动态装饰的更新
    /// - Parameters:
    ///   - type: 要匹配的值的类型，默认为Any
    ///   - match: 一个闭包，接受一个值并返回一个布尔值，表示该值是否满足触发条件
    ///   - action: 一个闭包，接受当前视图和匹配的值，当条件满足时执行，用于更新视图的装饰
    /// - Returns: 返回当前DSL实例，便于链式调用
    @discardableResult
    func when<Value>(
        _ type: Value.Type = (Any).self,
        match: @escaping (Value) -> Bool,
        do action: @escaping (Base, Value) -> Void
    ) -> Self {
        self.dStyle.when(type, match: match, do: action)
        return self
    }
    
    
    
    /// 根据一个值是否等于某个特定值来触发动态装饰的更新
    /// - Parameters:
    ///   - value: 要比较的值，必须是可比较的类型
    ///   - action: 一个闭包，接受当前视图和比较的值，当条件满足时执行，用于更新视图的装饰
    /// - Returns: 返回当前DSL实例，便于链式调用
    @discardableResult
    func when<Value: Equatable>(
        _ value: Value,
        do action: @escaping (Base,Value) -> Void
    ) -> Self {
        self.dStyle.when(value, do: action)
        return self
    }
    
    
    /// 绑定一个Publisher，Publisher发送新值时触发动态装饰的更新
    /// - Parameter publisher: 一个Publisher，必须满足Failure类型为Never，当Publisher发送新值时，动态装饰会根据新的值进行更新
    /// - Returns: 返回当前DSL实例，便于链式调用
    @discardableResult
    func bind<P: Publisher>(
        _ publisher: P
    ) -> Self where P.Failure == Never {
        self.dStyle.bind(publisher)
        return self
    }
    
    /// 发送一个值，触发动态装饰的更新
    /// - Parameter value: 要发送的值，可以是任何类型，当调用此方法时，动态装饰会根据这个值进行更新
    /// - Returns: 返回当前DSL实例，便于链式调用
    @discardableResult
    func sendValue(_ value: Any) -> Self{
        self.dStyle.sendValue(value)
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
