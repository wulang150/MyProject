//
//  AppDelegate.m
//  MyProject
//
//  Created by  Tmac on 2017/6/29.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "TabBarBaseViewController.h"
#import <Bugly/Bugly.h>
#import "RunLoopTracker.h"
#import "SimpleViewController.h"
#import "TmpTestViewController.h"
#import <Firebase.h>

@interface AppDelegate ()
<BuglyDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //图标右上角数字设0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [XZLog initLog];
    
    //fireBase
//    [FIRApp configure];
    
    //配置bugly
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.debugMode = YES;
    config.blockMonitorEnable = YES;
    config.blockMonitorTimeout = 2.0;
    config.channel = @"bugly";
    config.delegate = self;
    config.consolelogEnable = YES;
    config.viewControllerTrackingEnable = YES;
    [Bugly startWithAppId:@"b72d30d389" developmentDevice:YES config:config];
    
    //性能问题
    [RunLoopTracker startTracking:[NSRunLoop mainRunLoop].getCFRunLoop];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];

//    //首页
//    ViewController *vc = [ViewController new];
    SimpleViewController *vc = [SimpleViewController new];
//    TmpTestViewController *vc = [TmpTestViewController new];
//    TabBarBaseViewController *vc = [TabBarBaseViewController new];
//    [self.window setRootViewController:vc];
    
    //导航
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    navi.navigationBarHidden = YES;
    
    [self.window setRootViewController:navi];
    
    
    
    
    return YES;
}

- (NSString * BLY_NULLABLE)attachmentForException:(NSException * BLY_NULLABLE)exception
{
    NSLog(@">>>>>>>>>>>>%@",exception);
    return @"this is exception";
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
