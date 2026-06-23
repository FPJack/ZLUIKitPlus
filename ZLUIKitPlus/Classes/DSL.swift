//
//  DX.swift
//  ZLUIKitPlus
//
//  Created by admin on 2026/6/23.
//

import Foundation
import ZLFlexKit
import Combine


public protocol DSLCompatible {
    associatedtype A
    var view: A {get}
}
extension DSLCompatible where A: UIView {
    
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
    var dStyle: DynamicViewStyle<A> {
        view.dStyle
    }
    
    
    @available(iOS 13.0, *)
    ///自动bind的状态存储器
    public var stateStore: CurrentValueSubject<Any?, Never>? {
        view.dStyle.stateStore
    }
}

///动态装饰
@available(iOS 13.0, *)
public extension DSLCompatible where A: UIView {
    
    
    
    /// 根据一个值的类型和满足条件来触发动态装饰的更新
    /// - Parameters:
    ///   - type: 要匹配的值的类型，默认为Any
    ///   - match: 一个闭包，接受一个值并返回一个布尔值，表示该值是否满足触发条件
    ///   - action: 一个闭包，接受当前视图和匹配的值，当条件满足时执行，用于更新视图的装饰
    /// - Returns: 返回当前DSL实例，便于链式调用
    @discardableResult
    func when<State: Equatable>(
        _ type: State.Type ,
        match: @escaping (State) -> Bool,
        do action: @escaping (A, State) -> Void
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
        do action: @escaping (A,Value) -> Void
    ) -> Self {
        self.dStyle.when(value, do: action)
        return self
    }
    
    
    @discardableResult
    func whenNil(
        do action: @escaping (A) -> Void
    ) -> Self {
        self.dStyle.whenNil(do: action)
        return self
    }
    
    
    /// 没有匹配到任何值的时候调用
    /// - Parameter action: <#action description#>
    /// - Returns: <#description#>
    @discardableResult
    func otherwise(
        _ action: @escaping (A, Any) -> Void
    ) -> Self {
        self.dStyle.otherwise(action)
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
    func sendState(_ state: Any?,policy: MatchPolicy? = nil) -> Self{
        self.dStyle.sendState(state,policy: policy)
        return self
    }
    
    
    @discardableResult
    func style(_ style: (Self) -> Void) -> Self {
        style(self)
        return self
    }
    @discardableResult
    func state(_ state: (DynamicViewStyle<A>) -> Void) -> Self {
        state(self.dStyle)
        return self
    }
    @discardableResult
    func box(_ box:(LayoutBox) -> Void) -> Self {
        box(self.box)
        return self
    }
    
}


///view通用属性和方法
public extension DSLCompatible where A: UIView {
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
    
    
    ///将当前视图添加到指定的父视图中,需要手动布局
    @discardableResult
    func addTo(_ superview: UIView,) -> Self {
        superview.addSubview(view)
        return self
    }
    
    ///将当前视图添加到指定的父视图中，并设置边距为0，使其填满父视图
    @discardableResult
    func addToFull(_ superview: UIView) -> Self {
       self.view.box.addToFull(superview)
       return self
    }
    
    @discardableResult
    func bgColor(_ color: ColorRepresentable?) -> Self {
        view.backgroundColor = color?.getColor
        return self
    }
    
    @discardableResult
    func bgColor(_ color: UIColor?) -> Self {
        view.backgroundColor = color
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
    func tintColor(_ color: UIColor?) -> Self {
        view.tintColor = color
        return self
    }
    
    @discardableResult
    func borderColor(color: ColorRepresentable?) -> Self {
        view.layer.borderColor = color?.getColor?.cgColor
        return self
    }
    @discardableResult
    func borderColor(color: UIColor?) -> Self {
        view.layer.borderColor = color?.cgColor
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
    func border(color: UIColor?, w: Double) -> Self {
        return borderColor(color: color).borderWidth(w: w)
    }
    @discardableResult
    func shadowColor(color: ColorRepresentable?) -> Self {
        view.layer.shadowColor = color?.getColor?.cgColor
        return self
    }
    @discardableResult
    func shadowColor(color: UIColor?) -> Self {
        view.layer.shadowColor = color?.cgColor
        return self
    }
    @discardableResult
    func shadowOffset(w: Double,h: Double) -> Self {
        view.layer.shadowOffset = CGSize(width: w, height: h)
        return self
    }
    @discardableResult
    func shadowRadius(_ radius: Double) -> Self {
        view.layer.shadowRadius = radius
        return self
    }
    @discardableResult
    func shadowOpacity(_ opacity: Float) -> Self {
        view.layer.shadowOpacity = opacity
        return self
    }
    @discardableResult
    func radius(_ radius: CGFloat) -> Self {
        view.layer.cornerRadius = radius
        return self.masksToBounds()
    }
    @discardableResult
    @available(iOS 11.0, *)
    func corner(_ corners: CACornerMask, radius: CGFloat) -> Self {
        view.layer.cornerRadius = radius
        view.layer.maskedCorners = corners
        return self.masksToBounds()
    }
    @discardableResult
    func masksToBounds(_ masks: Bool = true) -> Self {
        view.layer.masksToBounds = masks
        return self
    }
    
    @discardableResult
    func tapAction(_ action: @escaping (A) -> Void) -> Self {
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
    
    
    
    /// 设置当前View 的高度，决定了在弹性布局中该View的尺寸
    /// - Parameter height: <#height description#>
    /// - Returns: <#description#>
    @discardableResult
    func height(_ height: NumberConvertible) -> Self {
        flex.height = height.cgFloat
        return self
    }
    
    
    /// 设置当前View 的宽度，决定了在弹性布局中该View的尺寸
    /// - Parameter width: <#width description#>
    /// - Returns: <#description#>
    @discardableResult
    func width(_ width: NumberConvertible) -> Self {
        flex.width = width.cgFloat
        return self
    }
    
    
    /// 设置当前View 的最小宽度，决定了在弹性布局中该View的尺寸不能小于这个值
    /// - Parameter width: <#width description#>
    /// - Returns: <#description#>
    @discardableResult
    func minWidth(_ width: NumberConvertible) -> Self {
        flex.minWidth = width.cgFloat
        return self
    }
    
    
    
    ///  设置当前View 的最大宽度，决定了在弹性布局中该View的尺寸不能大于这个值
    /// - Parameter width: <#width description#>
    /// - Returns: <#description#>
    @discardableResult
    func maxWidth(_ width: NumberConvertible) -> Self {
        flex.maxWidth = width.cgFloat
        return self
    }
    
    
    
    /// 设置当前View 的最小高度，决定了在弹性布局中该View的尺寸不能小于这个值
    /// - Parameter height: <#height description#>
    /// - Returns: <#description#>
    @discardableResult
    func minHeight(_ height: NumberConvertible) -> Self {
        flex.minHeight = height.cgFloat
        return self
    }
    
    
    
    ///  设置当前View 的最大高度，决定了在弹性布局中该View的尺寸不能大于这个值
    /// - Parameter height: <#height description#>
    /// - Returns: <#description#>
    @discardableResult
    func maxHeight(_ height: NumberConvertible) -> Self {
        flex.maxHeight = height.cgFloat
        return self
    }
    
    
    
    ///  设置当前View 的尺寸，决定了在弹性布局中该View的宽度和高度
    /// - Parameters:
    ///   - w: <#w description#>
    ///   - h: <#h description#>
    /// - Returns: <#description#>
    @discardableResult
    func size(w: NumberConvertible,h: NumberConvertible) -> Self {
        flex.size = CGSize(width: w.cgFloat, height: h.cgFloat)
        return self
    }
    
    
    /// 设置当前View 的尺寸为一个正方形，决定了在弹性布局中该View的宽度和高度相等
    /// - Parameter side: <#side description#>
    /// - Returns: <#description#>
    @discardableResult
    func square(_ side: NumberConvertible) -> Self {
        width(side).height(side)
    }
    
    @discardableResult
    func assign(to binding: inout A) -> Self {
        binding = view
        return self
    }
    @discardableResult
    func assign(to binding: inout A?) -> Self {
        binding = view
        return self
    }
}


public extension DSLCompatible where A: UILabel {
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
    func textColor(_ color: UIColor?) -> Self {
        view.textColor = color
        return self
    }
    
    @discardableResult
    func font(_ font: UIFont?) -> Self {
        view.font = font
        UIFont.systemFont(ofSize: 13, weight: .semibold)
        return self
    }
    
    @discardableResult
    func font(_ size: CGFloat,weight: UIFont.Weight? = .regular) -> Self {
        view.font = .systemFont(ofSize: size, weight: weight ?? .regular)
        return self
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
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        view.textAlignment = alignment
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
    func shadowColor(_ color: UIColor?) -> Self {
        view.shadowColor = color
        return self
    }
    
    @discardableResult
    func shadowOffset(w: Double,h: Double) -> Self {
        view.shadowOffset = CGSize(width: w, height: h)
        return self
    }
}

/// MARK: - UIButton
public extension DSLCompatible where A: UIButton {
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
    func titleColor(_ color: UIColor?, for state: UIControl.State = .normal) -> Self {
        view.setTitleColor(color, for: state)
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
extension DSLCompatible where A: UIImageView {
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


extension DSLCompatible where A: UISwitch {
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
    public func onTintColor(_ color: UIColor?) -> Self {
        view.onTintColor = color
        return self
    }
    @discardableResult
    public func thumbTintColor(_ color: ColorRepresentable?) -> Self {
        view.thumbTintColor = color?.getColor
        return self
    }
    @discardableResult
    public func thumbTintColor(_ color: UIColor?) -> Self {
        view.thumbTintColor = color
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

extension DSLCompatible where A: UITextField {
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
    public func textColor(_ color: UIColor?) -> Self {
        view.textColor = color
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
    func text(_ text: String?, color: UIColor? = nil, fontSize: CGFloat? = nil) -> Self {
        view.text = text
        if let color = color {
            view.textColor = color
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


public extension DSLCompatible where A: UIScrollView {
    @discardableResult
    func delegate(_ delegate: UIScrollViewDelegate?) -> Self {
        view.delegate = delegate
        return self
    }
    
    @discardableResult
    func contentOffset(_ offset: CGPoint) -> Self {
        view.contentOffset = offset
        return self
    }
    
    @discardableResult
    func contentSize(_ size: CGSize) -> Self {
        view.contentSize = size
        return self
    }
    
    @discardableResult
    func contentInset(_ insets: UIEdgeInsets) -> Self {
        view.contentInset = insets
        return self
    }
    
    @discardableResult
    func bounces(_ on: Bool) -> Self {
        view.bounces = on
        return self
    }
    
    @discardableResult
    func showsVIndicator(_ show: Bool) -> Self{
        view.showsVerticalScrollIndicator = show
        return self
    }
    
    @discardableResult
    func showsHIndicator(_ show: Bool) -> Self {
        view.showsHorizontalScrollIndicator = show
        return self
    }
    
    @discardableResult
    func isPagingEnabled(_ enabled: Bool) -> Self {
        view.isPagingEnabled = enabled
        return self
    }
    
    @discardableResult
    func isScrollEnabled(_ enabled: Bool) -> Self {
        view.isScrollEnabled = enabled
        return self
    }

    
    
    @discardableResult
    func keyboardDismissMode(_ mode: UIScrollView.KeyboardDismissMode) -> Self {
        view.keyboardDismissMode = mode
        return self
    }
    
    
    @discardableResult
    func scrollsToTop(_ scrolls: Bool) -> Self {
        view.scrollsToTop = scrolls
        return self
    }
}




public struct DSLImpl<Base: UIView>: StackViewDSL, DSLCompatible {
    public typealias A = Base
    public let view: Base
    public func getDslView() -> UIView? {
        view
    }
}


public protocol DXCompatible: DSLCompatible {}

public extension DXCompatible where A: UIView {
    /// 设置弹性布局的间距属性，
    /// - Parameter spacing: 一个数字类型的值，表示子视图之间的间距，可以是整数、浮点数等类型。该值会被转换为CGFloat类型，并应用于弹性布局的spacing属性。
    /// - Returns: 返回当前DSL实例，便于链式调用
    @discardableResult
    func spacing(_ spacing: NumberConvertible) -> Self {
        flex.spacing = spacing.cgFloat
        return self
    }
    
    
    
    /// 设置当前View纵轴方向的对齐方式，
    /// - Parameter align: <#align description#>
    /// - Returns: <#description#>
    @discardableResult
    func align(_ align: FlexItemCrossAlign) -> Self {
        flex.alignSelf = align
        return self
    }
    
    
    
    /// 设置当前View 在弹性布局中的外边距
    /// - Parameter margin: <#margin description#>
    /// - Returns: <#description#>
    @discardableResult
    func margin(_ margin: NSDirectionalEdgeInsets) -> Self {
        flex.margin = margin
        return self
    }
    
    
    
    /// 设置当前View 在弹性布局中的外边距 top,start,bottom,end
    @discardableResult
    func margin(_ marge: EdgeInsets) -> Self {
        flex.margin(marge)
        return self
    }
    
    
    
    ///  设置当前View 后面的最小间距
    /// - Parameter spacing: <#spacing description#>
    /// - Returns: <#description#>
    @discardableResult
    func minSpacing(_ spacing: NumberConvertible) -> Self {
        flex.minSpacing = spacing.cgFloat
        return self
    }
    
    
    /// 设置当前View 后面的最大间距
    /// - Parameter spacing: <#spacing description#>
    /// - Returns: <#description#>
    @discardableResult
    func maxSpacing(_ spacing: NumberConvertible) -> Self {
        flex.maxSpacing = spacing.cgFloat
        return self
    }
    
    
    
    /// 设置当前View 后面是否为弹性空间
    /// - Parameter isFlex: <#isFlex description#>
    /// - Returns: <#description#>
    @discardableResult
    func isFlexibleSpace(_ isFlex: Bool) -> Self {
        flex.isFlexibleSpace = isFlex
        return self
    }
    
    
    /// 设置当前View 的弹性系数，决定了在弹性布局中该View如何分配剩余空间
    /// - Parameter value: <#value description#>
    /// - Returns: <#description#>
    @discardableResult
    func flex(_ value: Int) -> Self {
        flex.flex = value
        return self
    }
    
}

public extension DXCompatible where A: UIView {
    @discardableResult
    func flex(_ flex: (FlexItem) -> Void) -> Self {
        flex(self.flex)
        return self
    }
}

public struct DXImpl<Base: UIView>: StackViewDSL, DXCompatible {
    public typealias A = Base
    public let view: Base
    public func getDslView() -> UIView? {
        view
    }
}


public protocol DSLXCompatible where Self: UIView {}
extension UIView: DSLXCompatible,TapActionable {}

extension DSLXCompatible {
    ///链式配置view的属性
    public var ds: DSLImpl<Self> {
        DSLImpl(view: self)
    }
    
    /// ds + flex
    public var dx: DXImpl<Self> {
        DXImpl(view: self)
    }
    
    static public var ds: DSLImpl<Self> {
        DSLImpl(view: Self())
    }
    static public var dx: DXImpl<Self> {
        DXImpl(view: Self())
    }
}

extension DSLXCompatible where Self: UIButton {
    static public var ds: DSLImpl<Self> {
        DSLImpl(view: Self(type: .custom))
    }
    static public var dx: DXImpl<Self> {
        DXImpl(view: Self(type: .custom))
    }
}


