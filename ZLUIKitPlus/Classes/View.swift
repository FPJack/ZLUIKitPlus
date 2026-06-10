
import UIKit
@objc(ZLView)
open class View: UIView,ViewStyleable {
    lazy  public var viewStyle: ViewStyle = {
       ViewStyle(view: self)
    }()
    override public var backgroundColor: UIColor? {
        get {
            return viewStyle.backgroundColor
        }
        set {
            viewStyle.backgroundColor = newValue
        }
    }
    public func superBackgroundColor() -> UIColor? {
         super.backgroundColor
    }
    public func superSetBackgroundColor(_ color: UIColor?) {
        super.backgroundColor = color
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        viewStyle.layoutSubviews()
    }
}



public extension View {
    @objc(gradColors)
    @available(swift, obsoleted: 1, renamed: "gradColors(_:)")
    var gradColorsObjc: (_ colors: [UIColor]?) -> View {
        { colors in
            self.gradColors(colors)
        }
    }
    
    @objc(gradDirection)
    @available(swift, obsoleted: 1, renamed: "gradDirection(start:end:)")
    var gradDirectionObjc: (_ start: CGPoint, _ end: CGPoint) -> View {
        { start, end in
            self.gradDirection(start: start, end: end)
        }
    }
    
    @objc(borderColor)
    @available(swift, obsoleted: 1, renamed: "borderColor(_:)")
    var borderColorObjc: (_ color: UIColor?) -> View {
        { color in
            self.borderColor(color: color)
        }
    }
    
    @objc(borderWidth)
    @available(swift, obsoleted: 1, renamed: "borderWidth(_:)")
    var borderWidthObjc: (_ width: CGFloat) -> View {
        { width in
            self.borderWidth(w: width)
        }
    }
    
    @objc(border)
    @available(swift, obsoleted: 1, renamed: "border(color:width:)")
    var borderObjc: (_ color: UIColor?, _ width: CGFloat) -> View {
        { color, width in
            self.border(color: color, w: width)
        }
    }
    @objc(shadowColor)
    @available(swift, obsoleted: 1, renamed: "shadowColor(_:)")
    var shadowColorObjc: (_ color: UIColor?) -> View {
        { color in
            self.shadowColor(color: color)
        }
    }
    
    @objc(shadowOffset)
    @available(swift, obsoleted: 1, renamed: "shadowOffset(_:_:)")
    var shadowOffsetObjc: (_ width: CGFloat, _ height: CGFloat) -> View {
        { w, h in
            self.shadowOffset(w: w, h: h)
        }
    }
    
    @objc(shadowRadius)
    @available(swift, obsoleted: 1, renamed: "shadowRadius(_:)")
    var shadowRadiusObjc: (_ radius: CGFloat) -> View {
        { radius in
            self.shadowRadius(radius: radius)
        }
    }
    
    @objc(shadowOpacity)
    @available(swift, obsoleted: 1, renamed: "shadowOpacity(_:)")
    var shadowOpacityObjc: (_ opacity: Float) -> View {
        { opacity in
            self.shadowOpacity(opacity: opacity)
        }
    }
    @objc(cornerRadii)
    @available(swift, obsoleted: 1, renamed: "cornerRadii(_:_:_:_:)")
    var cornerRadiiObjc: (_ tl: CGFloat, _ tr: CGFloat, _ bl: CGFloat, _ br: CGFloat) -> View {
        { tl, tr, bl, br in
            self.cornerRadii(tl, tr, bl, br)
        }
    }
    
    @objc(radius)
    @available(swift, obsoleted: 1, renamed: "radius(_:)")
    var radiusObjc: (_ radius: CGFloat) -> View {
        { r in
            self.radius(r)
        }
    }
}




@objc(ZLWrapperView)
open class WrapperView: View {

    // MARK: - Public
    @objc
    public private(set) weak var contentView: UIView?

    @objc(insets)
    @available(swift, obsoleted: 1, renamed: "insets(_:_:_:_:)")
    public var insetsObjc: ((_ top: CGFloat,
                         _ leading: CGFloat,
                         _ bottom: CGFloat,
                         _ trailing: CGFloat) -> WrapperView) {
        return { [weak self] top, leading, bottom, trailing in
            guard let self = self else { return WrapperView() }
            return self.insets(top, leading, bottom, trailing)
        }
    }

    // MARK: - Private
    private var constraintsArr: [NSLayoutConstraint]?
    private var _contentInsets: UIEdgeInsets?

    // MARK: - Override
    override open func updateConstraints() {
        if constraintsArr == nil {
            super.updateConstraints()
            return
        }
        NSLayoutConstraint.activate(constraintsArr!)
        self.constraintsArr!.removeAll()
        self.constraintsArr = nil
        super.updateConstraints()
    }

    // MARK: - Factory
    public static func wrap(with view: UIView) -> WrapperView {
        let wrap = WrapperView(frame: view.frame)
        wrap.contentView = view
        wrap.addSubview(view)
        return wrap.insets(0, 0, 0, 0)
    }

    // MARK: - Convenience
    @discardableResult
    public func insetsZero() -> Self {
        return insets(0, 0, 0, 0)
    }
    
    
    /// 设置内边距 - top, leading, bottom, trailing
    @discardableResult
    public func insets(_ top: CGFloat,
                       _ leading: CGFloat,
                       _ bottom: CGFloat,
                       _ trailing: CGFloat) -> Self {
        let newInsets = UIEdgeInsets(top: top,
                                     left: leading,
                                     bottom: bottom,
                                     right: trailing)

        if let old = self._contentInsets,
           old == newInsets {
            return self
        }

        self._contentInsets = newInsets

        if let constraints = self.constraintsArr {
            NSLayoutConstraint.deactivate(constraints)
        }

        guard let contentView = self.contentView else { return self }

        contentView.translatesAutoresizingMaskIntoConstraints = false

        let cs = [
            contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: top),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leading),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -bottom),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -trailing)
        ]

        self.constraintsArr = cs
        self.setNeedsUpdateConstraints()

        return self
    }
}

