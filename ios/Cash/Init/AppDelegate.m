//
//  AppDelegate.m
//  CashLoad
//
//  Created by 陈浩停 on 2017/9/12.
//  Copyright © 2017年 陈浩停. All rights reserved.
//

#import "AppDelegate.h"
#import "BeginUseViewController.h"
#import "IINavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BeginUseViewController *BUVc = [[BeginUseViewController alloc] init];
    IINavigationController *BUNav = [[IINavigationController alloc] initWithRootViewController:BUVc];
    self.window.rootViewController = BUNav;
    [self.window makeKeyAndVisible];
    
    
    [self umengTJ];
    return YES;
}

//友盟统计
-(void)umengTJ{
    [MobClick setLogEnabled:YES];
    

    //数据统计 add by kaka 2017.03.31
    UMConfigInstance.appKey = UMengTJKey;
    UMConfigInstance.channelId = nil;
    //    UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用设置
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
