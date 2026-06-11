import UIKit
import ZLFlexKit
private var storageKey: UInt8 = 0
public extension UIView {
     var zl_storage: NSMutableDictionary {
        if let dict = objc_getAssociatedObject(self, &storageKey) as? NSMutableDictionary {
            return dict
        }
        let dict = NSMutableDictionary()
        objc_setAssociatedObject(
            self,
            &storageKey,
            dict,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        return dict
    }
    
    
    private func getView<T: CreatableView>(_ type: T.Type,_ key: String) -> T {
        if let v = zl_storage[key] as? T {return v}
        let v = T()
        zl_storage[key] = v
        addSubview(v)
        return v
    }
    ///第一组
    @objc
    var zl_btn: Button {
        getView(Button.self, #function)
    }
    
    @objc
    var zl_lab: Label {
        getView(Label.self, #function)
    }
    
    @objc
    var zl_imgView: UIImageView {
        getView(UIImageView.self, #function)
    }
    
    @objc
    var zl_stackView: StackView {
        getView(StackView.self, #function)
    }
    
    
    ///第二组
    @objc
    var zl_altBtn: Button {
        getView(Button.self, #function)
        
    }
    @objc
    var zl_altLab: Label {
        getView(Label.self, #function)
        
    }
    @objc
    var zl_altImgView: UIImageView {
        getView(UIImageView.self, #function)
        
    }
    @objc
    var zl_altStackView: StackView {
        getView(StackView.self, #function)
        
    }
    
    
    ///第三组
    @objc
    var zl_extraBtn: Button {
        getView(Button.self, #function)
        
    }
    @objc
    var zl_extraLab: Label {
        getView(Label.self, #function)
        
    }
    @objc
    var zl_extraImgView: UIImageView {
        getView(UIImageView.self, #function)
        
    }
    @objc
    var zl_extraStackView: StackView {
        getView(StackView.self, #function)
        
    }
    
    ///成对view
    @objc
    var zl_pairLab: PairLabelView {
        getView(PairLabelView.self, #function)
        
    }
    @objc
    var zl_pairImg: PairImageView {
        getView(PairImageView.self, #function)
        
    }
    @objc
    var zl_pairBtn: PairButtonView {
        getView(PairButtonView.self, #function)
        
    }
    @objc
    var zl_pairStackView: PairStackView {
        getView(PairStackView.self, #function)
        
    }
    @objc
    var zl_imgViewLab: ImgLabelView {
        getView(ImgLabelView.self, #function)
        
    }
    @objc
    var zl_imgViewBtn: ImgButtonView {
        getView(ImgButtonView.self, #function)
        
    }
    @objc
    var zl_btnImgView: ButtonImgView {
        getView(ButtonImgView.self, #function)
        
    }
    @objc
    var zl_btnLabel: ButtonLabView {
        getView(ButtonLabView.self, #function)
        
    }
    @objc
    var zl_labelBtn: LabButtonView {
        getView(LabButtonView.self, #function)
        
    }
    @objc
    var zl_labImgView: LabelImgView {
        getView(LabelImgView.self, #function)
        
    }
    
    @objc
    var zl_wrapView: WrapperView {
             let key = #function
             if let view = zl_storage[key] as? WrapperView {return view}
             let view = WrapperView.wrap(with: self)
             zl_storage[key] = view
             return view
    }
}



// MARK: - 内部手势点击事件
final class _ZLViewTapGesture: UITapGestureRecognizer {
    var action: ((UIView) -> Void)?
    init(view: UIView, action: @escaping (UIView) -> Void) {
        super.init(target: nil, action: nil)
        self.action = action
        self.addTarget(self, action: #selector(handleTap))
        if !view.isUserInteractionEnabled {
            view.isUserInteractionEnabled = true
        }
        view.addGestureRecognizer(self)
    }
    @objc private func handleTap() {
        if let view = self.view {
            action?(view)
        }
    }
}

public protocol TapActionable where Self: UIView {
    func tapAction(_ action: @escaping (Self) -> Void) -> Self
}
private let tapActionKey = "zl_tapAction"
extension TapActionable {
   @discardableResult
   public func tapAction(_ action: @escaping (Self) -> Void) -> Self {
       let key = tapActionKey
       zl_storage[key] = action
       let tapKey = "\(key)_gesture"
       if zl_storage[tapKey] == nil {
           let tap =  _ZLViewTapGesture(view: self) { view in
               let block = self.zl_storage[key] as? (Self) -> Void
               block?(view as! Self)
           }
           zl_storage[tapKey] = tap
       }
       return self
    }
}







public struct Style<Base: UIView> {
    
   public let base: Base
    
   public var layout: Layout {
        base.layout
   }
   public var flex: FlexItem {
        base.flex
   }
}

public protocol StyleCompatible where Self: UIView {}

extension StyleCompatible {
    public var style: Style<Self> {
        Style(base: self)
    }
}
extension UIView: StyleCompatible,TapActionable {}


public extension Style {
    @discardableResult
    func backgroundColor(_ color: ColorRepresentable?) -> Self {
        base.backgroundColor = color?.getColor
        return self
    }
    @discardableResult
    func hidden(_ hidden: Bool) -> Self {
        base.isHidden = hidden
        return self
    }
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        base.alpha = alpha
        return self
    }
    
    @discardableResult
    func contentMode(_ mode: UIView.ContentMode ) -> Self {
        base.contentMode = mode
        return self
    }
    
    @discardableResult
    func tintColor(_ color: ColorRepresentable?) -> Self {
        base.tintColor = color?.getColor
        return self
    }
    
    @discardableResult
    func borderColor(color: ColorRepresentable?) -> Self {
        base.layer.borderColor = color?.getColor?.cgColor
        return self
    }
    
    @discardableResult
    func borderWidth(w: Double) -> Self {
        base.layer.borderWidth = CGFloat(w)
        return self
    }
    
    @discardableResult
    func border(color: ColorRepresentable?, w: Double) -> Self {
        return borderColor(color: color).borderWidth(w: w)
    }
    @discardableResult
    func shadowColor(color: ColorRepresentable?) -> Self {
        base.layer.shadowColor = color?.getColor?.cgColor
        return self
    }
    @discardableResult
    func shadowOffset(w: Double,h: Double) -> Self {
        base.layer.shadowOffset = CGSize(width: w, height: h)
        return self
    }
    @discardableResult
    func shadowRadius(radius: Double) -> Self {
        base.layer.shadowRadius = radius
        return self
    }
    @discardableResult
    func shadowOpacity(opacity: Float) -> Self {
        base.layer.shadowOpacity = opacity
        return self
    }
    @discardableResult
    func radius(_ radius: CGFloat) -> Self {
        base.layer.cornerRadius = radius
        return self
    }
    @discardableResult
    @available(iOS 11.0, *)
    func corner(_ corners: CACornerMask, radius: CGFloat) -> Self {
        base.layer.cornerRadius = radius
        base.layer.maskedCorners = corners
        return self
    }
    @discardableResult
    func masksToBounds(_ masks: Bool = true) -> Self {
        base.layer.masksToBounds = masks
        return self
    }
    
    @discardableResult
    func tapAction(_ action: @escaping (Base) -> Void) -> Self {
        base.tapAction {action($0)}
        return self
    }
    
    @discardableResult
    func height(_ height: NumberConvertible) -> Self {
        base.heightAnchor.constraint(equalToConstant: height.cgFloat).isActive = true
        return self
    }
    
    @discardableResult
    func width(_ width: NumberConvertible) -> Self {
        base.widthAnchor.constraint(equalToConstant: width.cgFloat).isActive = true
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
    func compressionResistance(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        base.setContentCompressionResistancePriority(priority, for: axis)
        return self
    }
    
    @discardableResult
    func hugging(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        base.setContentHuggingPriority(priority, for: axis)
        return self
    }
}


extension Style where Base: UILabel {
    @discardableResult
    func text(_ text: String?) -> Self {
        base.text = text
        return self
    }
    
    @discardableResult
    func textColor(_ color: ColorRepresentable?) -> Self {
        base.textColor = color?.getColor
        return self
    }
    
    @discardableResult
    func font(_ font: UIFont?) -> Self {
        base.font = font
        return self
    }
    
    @discardableResult
    func fontSize(_ size: CGFloat) -> Self {
        self.font(.systemFont(ofSize: size))
    }
    
    @discardableResult
    func text(_ text: String?, color: ColorRepresentable? = nil, fontSize: CGFloat? = nil) -> Self {
        base.text = text
        if let color = color {
            base.textColor = color.getColor
        }
        if let fontSize = fontSize {
            base.font = .systemFont(ofSize: fontSize)
        }
        return self
    }
    
    @discardableResult
    func numberOfLines(_ lines: Int) -> Self {
        base.numberOfLines = lines
        return self
    }
    
    @discardableResult
    func singleLine() -> Self {
        base.numberOfLines = 1
        return self
    }
    
    @discardableResult
    func multipleLines() -> Self {
        base.numberOfLines = 0
        return self
    }
    
    @discardableResult
    func twoLines() -> Self {
        base.numberOfLines = 2
        return self
    }
}
extension Style where Base: UIButton {
    func title(_ title: String?, for state: UIControl.State = .normal) -> Self {
        base.setTitle(title, for: state)
        return self
    }
    
    func titleColor(_ color: ColorRepresentable?, for state: UIControl.State = .normal) -> Self {
        base.setTitleColor(color?.getColor, for: state)
        return self
    }
    
    func font(_ font: UIFont?) -> Self {
        base.titleLabel?.font = font
        return self
    }
    
    func fontSize(_ size: CGFloat) -> Self {
        self.font(.systemFont(ofSize: size))
    }
    
    func image(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        base.setImage(image, for: state)
        return self
    }
    
    func backgroundImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        base.setBackgroundImage(image, for: state)
        return self
    }
    
    func selected(_ selected: Bool) -> Self {
        base.isSelected = selected
        return self
    }
    
    func highlighted(_ highlighted: Bool) -> Self {
        base.isHighlighted = highlighted
        return self
    }
    
    func enabled(_ enabled: Bool) -> Self {
        base.isEnabled = enabled
        return self
    }
}



extension Style where Base: UIImageView {
    @discardableResult
    ///设置图片，可以是图片名称或者UIImage对象
    public func image(_ image: ImageSource? = nil) -> Self {
        guard let image = image else {
            base.image = nil
            return self
        }
        base.image = image.img
        return self
    }
    
    
    @discardableResult
    public func url(_ url: String?, placeholder: ImageSource? = nil) -> Self {
        UIImageView.imageLoader?(base,url, placeholder?.img)
        return self
    }
}
