//
//  Color.swift
//  ZLUIKitPlus
//
//  Created by admin on 2026/6/11.
//

import Foundation
public func ColorFromHexStr(_ hexStr: String) -> UIColor {
    var str = hexStr.trimmingCharacters(in: .whitespacesAndNewlines)
    if str.hasPrefix("0x") { str = String(str.dropFirst(2)) }
    if str.hasPrefix("#") { str = String(str.dropFirst()) }
    let hexInt = UInt32(str, radix: 16) ?? 0
    let r = CGFloat((hexInt >> 16) & 0xFF) / 255.0
    let g = CGFloat((hexInt >> 8) & 0xFF) / 255.0
    let b = CGFloat(hexInt & 0xFF) / 255.0
    return UIColor(red: r, green: g, blue: b, alpha: 1.0)
}
public func ColorFromObj(_ obj: AnyObject?) -> UIColor? {
    if let color = obj as? UIColor { return color }
    if let str = obj as? String { return ColorFromHexStr(str) }
    return nil
}
public protocol ColorRepresentable {
    var getColor: UIColor? {get}
}
extension String: ColorRepresentable {
    public var getColor: UIColor? {
        if #available(iOS 11.0, *) {
            if let color = UIColor(named: self) {
                return color
            } else {
                return ColorFromHexStr(self)
            }
        } else {
            return ColorFromHexStr(self)
        }
    }
}

extension UIColor: ColorRepresentable {
    public var getColor: UIColor? { self }
}
///颜色来源，可以是颜色名称（支持系统颜色和十六进制字符串）或者UIColor对象
