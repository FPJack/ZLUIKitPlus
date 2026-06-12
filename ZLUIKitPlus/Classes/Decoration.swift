//
//  Decoration.swift
//  ZLUIKitPlus
//
//  Created by admin on 2026/6/12.
//
import Combine
import ZLFlexKit
public struct DecorRule<Value> {
    let match: (Value) -> Bool
    let action: (UIView, Value) -> Void
}
@available(iOS 13.0, *)
public final class Decoration<T: UIView>: StackViewDSL {
    
    public weak var view: T?
    
    private var rules: [DecorRule<Any>] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(view: T) {
        self.view = view
    }
    
    public func getDslView() -> UIView? {
        view
    }
}

@available(iOS 13.0, *)
extension Decoration {
    @discardableResult
    public func when<Value>(
        _ type: Value.Type = (Any).self,
        match: @escaping (Value) -> Bool,
        do action: @escaping (T, Value) -> Void
    ) -> Self {
        
        let rule = DecorRule<Any>(
            match: { value in
                guard let v = value as? Value else { return false }
                return match(v)
            },
            action: { view, value in
                guard let v = value as? Value,
                      let view = view as? T else { return }
                action(view, v)
            }
        )
        
        rules.append(rule)
        return self
    }
    
    
    @discardableResult
    
    public func when<Value: Equatable>(
        
        _ value: Value,
        
        do action: @escaping (T,Value) -> Void
        
    ) -> Self {
        
        let rule = DecorRule<Any>(
            
            match: { input in
                
                guard let v = input as? Value else { return false }
                
                return v == value
                
            },
            
            action: { view, value in
                
                guard let v = value as? Value,
                      let view = view as? T else { return }
                action(view, v)
                
            }

        )
        rules.append(rule)
        return self
        
    }
    
}
@available(iOS 13.0, *)
extension Decoration {
    
    func handle(_ value: Any) {
        
        guard let view = view else { return }
        
        for rule in rules {
            if rule.match(value) {
                rule.action(view, value)
                break
            }
        }
    }
}

@available(iOS 13.0, *)
extension Decoration {
    @discardableResult
    public func bind<P: Publisher>(
        _ publisher: P
    ) -> Self where P.Failure == Never {
        publisher
            .sink { [weak self] value in
                self?.handle(value)
            }
            .store(in: &cancellables)
        return self
    }
}



@available(iOS 13.0, *)
extension Decoration {
    // MARK: - 发送值进行装饰
    @discardableResult
    public func sendValue(_ value: Any) -> Self{
        handle(value)
        return self
    }
}

public protocol Decoratable where Self: UIView {}



private let key = "zl_decoration"
@available(iOS 13.0, *)
extension Decoratable {
    public var decor: Decoration<Self>  {
        /// 通过关联属性存储起来
        if let decoration = objc_getAssociatedObject(self, key) as? Decoration<Self> {
            return decoration
        } else {
            let decoration = Decoration(view: self)
            objc_setAssociatedObject(self, key, decoration, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return decoration
        }
    }
}

extension UIView: Decoratable {}
@available(iOS 13.0, *)
extension Decoration {
    ///系统约束布局属性
    public var box: LayoutBox? {
        view?.box 
    }
    ///弹性布局属性
    public var flex: FlexItemSwift<T>? {
        view?.flex
    }
}

extension FlexItemSwift {
    @available(iOS 13.0, *)
    public var decor: Decoration<T>? {
        view?.decor
    }
}
