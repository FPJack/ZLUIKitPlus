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
final class _DynamicViewStyle: StackViewDSL {
    
     public weak var view: UIView?
    
     var rules: [DecorRule<Any>] = []
    
     var cancellables = Set<AnyCancellable>()
    
     var policy: MatchPolicy = .first
    
     var defaultAction: ((UIView, Any) -> Void)?
    
    init(view: UIView) {
        self.view = view
    }
    
    public func getDslView() -> UIView? {
        view
    }
    
    
    @discardableResult
    public func matchPolicy(_ policy: MatchPolicy) -> Self {
        self.policy = policy
        return self
    }
    @discardableResult
    public func when<Value>(
        _ type: Value.Type = (Any).self,
        match: @escaping (Value) -> Bool,
        do action: @escaping (UIView, Value) -> Void
    ) -> Self {
        
        let rule = DecorRule<Any>(
            match: { value in
                guard let v = value as? Value else { return false }
                return match(v)
            },
            action: { view, value in
                guard let v = value as? Value else { return }
                action(view, v)
            }
        )
        
        rules.append(rule)
        return self
    }
    
    
    @discardableResult
    
    public func when<Value: Equatable>(
        
        _ value: Value,
        
        do action: @escaping (UIView,Value) -> Void
        
    ) -> Self {
        
        let rule = DecorRule<Any>(
            
            match: { input in
                
                guard let v = input as? Value else { return false }
                
                return v == value
                
            },
            
            action: { view, value in
                
                guard let v = value as? Value else { return }
                action(view, v)
                
            }
            
        )
        rules.append(rule)
        return self
        
    }
    
    
    @discardableResult
    public func otherwise(
        _ action: @escaping (UIView, Any) -> Void
    ) -> Self {
        
        defaultAction = action
        
        return self
    }
    
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
    
    // MARK: - 发送值进行装饰
    @discardableResult
    public func sendValue(_ value: Any,policy: MatchPolicy? = nil) -> Self{
        handle(value,policy: policy)
        return self
    }
    
}


@available(iOS 13.0, *)
public final class DynamicViewStyle<T: UIView>: StackViewDSL {
    
    var style: _DynamicViewStyle?
    
    init(style: _DynamicViewStyle) {
        self.style = style
    }
    
    public func getDslView() -> UIView? {
        style?.getDslView()
    }
    
    
    @discardableResult
    public func matchPolicy(_ policy: MatchPolicy) -> Self {
        self.style?.policy = policy
        return self
    }
    @discardableResult
    public func when<Value>(
        _ type: Value.Type = (Any).self,
        match: @escaping (Value) -> Bool,
        do action: @escaping (T, Value) -> Void
    ) -> Self {
        self.style?.when(type, match: match) { view , value in
            guard let view = view as? T else { return }
            action(view, value)
        }
        return self
    }
    
    
    @discardableResult
    
    public func when<Value: Equatable>(
        
        _ value: Value,
        
        do action: @escaping (T,Value) -> Void
        
    ) -> Self {
        
        self.style?.when(value) { view, v in
            guard let view = view as? T else { return }
            action(view, v)
        }
        return self
        
    }
    
    
    @discardableResult
    public func otherwise(
        _ action: @escaping (T, Any) -> Void
    ) -> Self {
        self.style?.otherwise { view , value in
            guard let view = view as? T else { return }
            action(view, value)
        }
        return self
    }
    
    func handle(_ value: Any,policy: MatchPolicy? = nil) {
        self.style?.handle(value,policy: policy)
    }
    
    @discardableResult
    public func bind<P: Publisher>(
        _ publisher: P
    ) -> Self where P.Failure == Never {
        self.style?.bind(publisher)
        return self
    }
    
    // MARK: - 发送值进行装饰
    @discardableResult
    public func sendValue(_ value: Any,policy: MatchPolicy? = nil) -> Self{
        self.style?.handle(value,policy: policy)
        return self
    }
    
}



public protocol DynamicStylable where Self: UIView {}
extension UIView: DynamicStylable {}
private var key:      UInt8 = 0

@available(iOS 13.0, *)
extension DynamicStylable {
    /// 动态配置样式
    public var dStyle: DynamicViewStyle<Self>  {
        /// 通过关联属性存储起来
        var _style = objc_getAssociatedObject(self, &key) as? _DynamicViewStyle
        if _style == nil {
            _style = _DynamicViewStyle(view: self)
            objc_setAssociatedObject(self, &key, _style, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return DynamicViewStyle(style: _style!)
    }
}



