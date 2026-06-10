
import UIKit
import ZLFlexKit
private var storageKey: UInt8 = 0
public extension UIView {
    private var zl_storage: NSMutableDictionary {
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


