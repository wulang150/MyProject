//
//  UIApplication+Extension.m
//  MyProject
//
//  Created by  Tmac on 2018/7/20.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "UIApplication+Extension.h"

@implementation UIApplication (Extension)

//获取最上层的controller
- (UIViewController *)topViewController
{
    UIWindow* window = self.keyWindow;
    UIViewController* vc = window.rootViewController;
    
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
        
    }
    
    return vc;
}

- (UINavigationController *)getNavigation
{
    UIWindow* window = self.keyWindow;
    UINavigationController* rootVc = (UINavigationController*)window.rootViewController;
    if(![rootVc isKindOfClass:[UINavigationController class]])
        return nil;
    return rootVc;
}

- (UIViewController *)getRightController:(id)controller
{
    UIViewController *vc = (UIViewController *)controller;
    if([vc isKindOfClass:[NSString class]])
    {
        NSString *name = (NSString *)controller;
        vc = [NSClassFromString(name) new];
    }
    if(![vc isKindOfClass:[UIViewController class]])
    {
        NSLog(@"controller error");
        return nil;
    }
    
    return vc;
}

//把某controller作为navigation的rootController
- (void)popToRootWithContrl:(id)controller
{
    UINavigationController *navigationVC = [self getNavigation];
    if(!navigationVC)
        return;
    UIViewController *vc = [self getRightController:controller];
    if(!vc)
        return;
    
    NSMutableArray * ctrlArray = [navigationVC.viewControllers mutableCopy];
//
//    for(UIViewController *vi in ctrlArray)
//    {
//        if([vi isKindOfClass:NSClassFromString(controllerName)])
//        {
//            [ctrlArray removeObject:vi];
//            break;
//        }
//    }
    [ctrlArray insertObject:vc atIndex:0];
    navigationVC.viewControllers = ctrlArray;
//    [rootVc popToViewController:vc animated:YES];
    [navigationVC popToRootViewControllerAnimated:YES];
}

- (void)popOrPushToContrl:(id)controller
{
    UINavigationController *navigationVC = [self getNavigation];
    if(!navigationVC)
        return;
    UIViewController *vc = [self getRightController:controller];
    if(!vc)
        return;
    id controll = nil;
    NSArray * ctrlArray = navigationVC.viewControllers;
    for(UIViewController *vi in ctrlArray)
    {
        if([vi isKindOfClass:[vc class]])
        {
            controll = vi;
            break;
        }
    }
    if(controll!=nil)
    {
        NSLog(@">>>>>>>>>old controller");
        [navigationVC popToViewController:controll animated:YES];
    }
    else
    {
        NSLog(@">>>>>>>>>new controller");
        [navigationVC pushViewController:vc animated:YES];
    }
}
@end
