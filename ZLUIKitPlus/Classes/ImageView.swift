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

extension UIImageView {
    @objc
    static public var imageLoader: ((UIImageView,String?, UIImage?) -> Void)? = {
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
}


@objc(ZLImageView)
open class ImageView: UIImageView {
   
    @objc(tapAction)
    @available(swift, obsoleted: 1, renamed: "tapAction(_:)")
    public var tapActionObjc: ((_ block: ((ImageView) -> Void)?) -> ImageView) {
        { block in
            if let block = block {
                return self.tapAction(block)
            }
            return self
        }
    }
    
    @objc(setImage)
    @available(swift, obsoleted: 1, renamed: "image(_:)")
    public var imageObjc: (_ image: AnyObject?) -> ImageView {
        { image in
            if let img = image as? ImageSource {
                self.dsl.image(img)
            }
            return self
        }
    }
    
    @objc(setUrl)
    @available(swift, obsoleted: 1, renamed: "url(_:placeholder:)")
    public var urlObjc: (_ url: String?, _ placeholder: AnyObject?) -> ImageView {
        { url, placeholder in
            if placeholder != nil, let placeholder = placeholder as? ImageSource {
                 self.dsl.url(url, placeholder: placeholder)
                return self
            }
             self.dsl.url(url, placeholder: nil)
             return self
        }
    }
    
}
