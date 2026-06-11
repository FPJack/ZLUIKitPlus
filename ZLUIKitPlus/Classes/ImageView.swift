//
//  ImageView.swift
//  ZLUIKitPlus
//
//  Created by admin on 2026/6/11.
//

import UIKit
public protocol ImageSource {}
extension ImageSource {
    var img: UIImage? {
        if let imageName = self as? String {
            return UIImage(named: imageName)
        } else if let img = self as? UIImage {
            return img
        }
        return nil
    }
}
    
extension String: ImageSource {}
extension UIImage: ImageSource {}
@objc(ZLImageView)
open class ImageView: UIImageView {
    ///默认内部SDWebImage 加载图片，外部block赋值自定义加载图片
    @objc
    static public var imageLoader: ((ImageView,String?, UIImage?) -> Void)? = {
       imgView, url, placeholder in
        let urlObj: URL?
        let selector =
        NSSelectorFromString("sd_setImageWithURL:placeholderImage:")
        if let url = url, let obj = URL(string: url) {
           if imgView.responds(to: selector) {
               imgView.perform(selector, with: obj, with: placeholder)
               return
           }
        }
        imgView.image = placeholder
    }
    
    
    @discardableResult
    ///设置图片，可以是图片名称或者UIImage对象
    public func image(_ image: ImageSource? = nil) -> Self {
        guard let image = image else {
            self.image = nil
            return self
        }
        self.image = image.img
        return self
    }
    
    @discardableResult
    public func tapAction(_ block: @escaping (Self) -> Void) -> Self {
        zl_tapAction {block($0)}
        
    }
    @discardableResult
    public func url(_ url: String?, placeholder: ImageSource? = nil) -> Self {
        ImageView.imageLoader?(self,url, placeholder?.img)
        return self
    }
}


public extension ImageView {
    @objc(tapAction)
    @available(swift, obsoleted: 1, renamed: "tapAction(_:)")
    var tapActionObjc: ((_ block: ((ImageView) -> Void)?) -> ImageView) {
        { block in
            if let block = block {
                return self.tapAction(block)
            }
            return self
        }
    }
    
    @objc(setImage)
    @available(swift, obsoleted: 1, renamed: "image(_:)")
    var imageObjc: (_ image: AnyObject?) -> ImageView {
        { image in
            if let img = image as? ImageSource {
                self.image(img)
            }
            return self
        }
    }
    
    @objc(setUrl)
    @available(swift, obsoleted: 1, renamed: "url(_:placeholder:)")
    var urlObjc: (_ url: String?, _ placeholder: AnyObject?) -> ImageView {
        { url, placeholder in
            if placeholder != nil, let placeholder = placeholder as? ImageSource {
               return self.url(url, placeholder: placeholder)
            }
           return self.url(url, placeholder: nil)
        }
    }
    
}
