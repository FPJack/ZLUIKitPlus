
import UIKit
import ZLFlexKit
@objc(ZLLabel)
open class Label: UILabel {
    @objc
    public var insets: NSDirectionalEdgeInsets = .zero {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }
    
    @discardableResult
    public func insets(_ insets: EdgeInsets) -> Self {
        self.insets = insets.directionalEdgeInsets
        return self
    }
    

    open override func drawText(in rect: CGRect) {

        let isRTL = effectiveUserInterfaceLayoutDirection == .rightToLeft

        let insetRect = rect.inset(by: UIEdgeInsets(
            top: insets.top,
            left: isRTL ? insets.trailing : insets.leading,
            bottom: insets.bottom,
            right: isRTL ? insets.leading : insets.trailing
        ))

        super.drawText(in: insetRect)
    }
    
    
    open override var intrinsicContentSize: CGSize {
        
        var size = super.intrinsicContentSize
        
        size.width += insets.leading + insets.trailing
        
        size.height += insets.top + insets.bottom
        
        return size
        
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        
        let fitSize = super.sizeThatFits(
            
            CGSize(
                
                width: size.width - insets.leading - insets.trailing,
                
                height: size.height - insets.top - insets.bottom
                
            )
            
        )
        
        return CGSize(
            
            width: fitSize.width + insets.leading + insets.trailing,
            
            height: fitSize.height + insets.top + insets.bottom
            
        )
        
    }
}


extension Label {
    @objc(tapAction)
    @available(swift, obsoleted: 1, renamed: "tapAction(_:)")
    var tapActionObjc: ((_ block: ((Label) -> Void)?) -> Label) {
        { block in
            if let block = block {
                return self.tapAction(block)
            }
            return self
        }
    }
}

extension DSL where Base: Label {
    @discardableResult
    public func insets(_ insets: NSDirectionalEdgeInsets) -> Self {
        self.view.insets = insets
        return self
    }
    
    @discardableResult
    public func insets(_ insets: EdgeInsets) -> Self {
        self.view.insets = insets.directionalEdgeInsets
        return self
    }
}

