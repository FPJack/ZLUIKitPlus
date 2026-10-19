//
//  ZLSceneDelegate.m
//  ZLUIKitPlus
//
//  UIScene 适配：构建 window 并设置根控制器
//

#import "ZLSceneDelegate.h"

@implementation ZLSceneDelegate

- (void)scene:(UIScene *)scene
willConnectToSession:(UISceneSession *)session
      options:(UISceneConnectionOptions *)connectionOptions
{
    if (![scene isKindOfClass:[UIWindowScene class]]) { return; }
    UIWindowScene *windowScene = (UIWindowScene *)scene;

    // 若 Info.plist 中配置了 UISceneStoryboardFile，系统会自动创建 window 与根控制器
    if (self.window == nil) {
        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    } else {
        self.window.windowScene = windowScene;
    }

    if (self.window.rootViewController == nil) {
        // 兜底：手动从 Main.storyboard 创建根控制器
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        self.window.rootViewController = [sb instantiateInitialViewController];
    }

    [self.window makeKeyAndVisible];
}

- (void)sceneDidDisconnect:(UIScene *)scene
{
    // 场景被系统释放时调用（场景可能稍后重新连接）
}

- (void)sceneDidBecomeActive:(UIScene *)scene
{
    // 场景从非活跃变为活跃，恢复暂停的任务
}

- (void)sceneWillResignActive:(UIScene *)scene
{
    // 场景将要变为非活跃（来电、多任务切换等）
}

- (void)sceneWillEnterForeground:(UIScene *)scene
{
    // 场景从后台进入前台
}

- (void)sceneDidEnterBackground:(UIScene *)scene
{
    // 场景进入后台，释放共享资源、保存数据
}

@end
