//
//  ZLAppDelegate.m
//  ZLUIKitPlus
//
//  Created by fanpeng on 04/24/2026.
//  Copyright (c) 2026 fanpeng. All rights reserved.
//

#import "ZLAppDelegate.h"
#import "ZLUIKitPlus-Swift.h"
@import ZLUIKitPlus;
@import ZLFlexKit;
@implementation ZLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//    ZLImageView.imageLoader = ^(NSString * _Nonnull, UIImage * _Nullable) {
//
//    };
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        ZLImageView *view = ZLImageView.new;
//        view.setUrl(@"https://gips3.baidu.com/it/u=3886271102,3123389489&fm=3028&app=3028&f=JPEG&fmt=auto?w=1280&h=960", @"猫狗通用-分离焦虑");
//        view.tapAction(^(ZLImageView * _Nonnull) {
//            NSLog(@"点击了图片");
//        });
//
//
//        view.layout.addTo(self.window).centerOffset(0, 0);
//    });
    return YES;
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application
configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession
                              options:(UISceneConnectionOptions *)options API_AVAILABLE(ios(13.0))
{
    // 返回 Info.plist 中 UIApplicationSceneManifest 里名为 "Default Configuration" 的场景配置
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration"
                                          sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application
didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions API_AVAILABLE(ios(13.0))
{
    // 用户在多任务界面关闭场景后调用，可在此释放对应场景的资源
}

#pragma mark - 以下为非场景相关的 App 级生命周期（场景相关的请使用 ZLSceneDelegate）

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate.
}

@end





