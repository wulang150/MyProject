//
//  UIApplication+Extension.h
//  MyProject
//
//  Created by  Tmac on 2018/7/20.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Extension)

//获取最上层的controller
- (UIViewController *)topViewController;

//把某controller作为navigation的rootController，可以是name或者controller实例
- (void)popToRootWithContrl:(id)controller;
//pop或者push到某个controller，如果导航里已经有，就pop，没有就push，可以是name或者controller实例
- (void)popOrPushToContrl:(id)controller;
@end
