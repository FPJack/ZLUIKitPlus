//
//  ZLSceneDelegate.h
//  ZLUIKitPlus
//
//  UIScene 适配：每个 UIWindowScene 的生命周期与 window 由这里管理
//

@import UIKit;

API_AVAILABLE(ios(13.0))
@interface ZLSceneDelegate : UIResponder <UIWindowSceneDelegate>

@property (strong, nonatomic, nullable) UIWindow *window;

@end
