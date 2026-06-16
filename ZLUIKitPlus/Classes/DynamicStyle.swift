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


public enum MatchPolicy {
    /// 匹配到一个后立即停止
    case first
    
    /// 执行所有匹配的规则
    case all
}

@available(iOS 13.0, *)
public final class DynamicViewStyle<T: UIView>: StackViewDSL {
    
    public weak var view: T?
    
    private var rules: [DecorRule<Any>] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private var policy: MatchPolicy = .first
    
    private var defaultAction: ((T, Any) -> Void)?
    
    init(view: T) {
        self.view = view
    }
    
    public func getDslView() -> UIView? {
        view
    }
}

@available(iOS 13.0, *)
extension DynamicViewStyle {
    @discardableResult
    public func matchPolicy(_ policy: MatchPolicy) -> Self {
        self.policy = policy
        return self
    }
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
    
    
    @discardableResult
    public func otherwise(
        _ action: @escaping (T, Any) -> Void
    ) -> Self {
        
        defaultAction = action
        
        return self
    }
    
}




@available(iOS 13.0, *)
extension DynamicViewStyle {
    
    func handle(_ value: Any,policy: MatchPolicy? = nil) {
        
        guard let view = view else { return }
        
        let p = policy ?? .first
        
        var matched = false
        
        for rule in rules {
            if rule.match(value) {
                matched = true
                rule.action(view, value)
                if p == .first {
                    break
                }
            }
        }
        if !matched {
            defaultAction?(view, value)
        }
    }
}

@available(iOS 13.0, *)
extension DynamicViewStyle {
    @discardableResult
    public func bind<P: Publisher>(
        _ publisher: P
    ) -> Self where P.Failure == Never {
        publisher
            .sink { [weak self] value in
                if Thread.isMainThread {
                    self?.handle(value)
                } else {
                    DispatchQueue.main.async { [weak self] in
                        self?.handle(value)
                    }
                }
            }
            .store(in: &cancellables)
        return self
    }
}



@available(iOS 13.0, *)
extension DynamicViewStyle {
    // MARK: - 发送值进行装饰
    @discardableResult
    public func sendValue(_ value: Any,policy: MatchPolicy? = nil) -> Self{
        handle(value,policy: policy)
        return self
    }
}

public protocol DynamicStylable where Self: UIView {}



private let key = "zl_decoration"
@available(iOS 13.0, *)
extension DynamicStylable {
    /// 动态配置样式
    public var dStyle: DynamicViewStyle<Self>  {
        /// 通过关联属性存储起来
        if let decoration = objc_getAssociatedObject(self, key) as? DynamicViewStyle<Self> {
            return decoration
        } else {
            let decoration = DynamicViewStyle(view: self)
            objc_setAssociatedObject(self, key, decoration, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return decoration
        }
    }
}

extension UIView: DynamicStylable {}
@available(iOS 13.0, *)
extension DynamicViewStyle {
    ///系统约束布局属性
    public var box: LayoutBox? {
        view?.box
    }
}

