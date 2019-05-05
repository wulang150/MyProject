//
//  LocalNotifyManager.m
//  PushServer
//
//  Created by  Tmac on 2017/8/21.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "LocalNotifyManager.h"
#import <UIKit/UIKit.h>

@interface LocalNotifyManager()
{
    NSMutableDictionary *notifyDic;
}
@end

@implementation LocalNotifyManager

+ (id)sharedInstanced
{
    static LocalNotifyManager *safe;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        safe = [[LocalNotifyManager alloc] init];
    });
    
    return safe;
}

- (id)init
{
    if(self = [super init])
    {
        notifyDic = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)registerNotify
{
    //  1.如果是iOS8请求用户权限
//    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0)
    {
    
        /*
         UIUserNotificationType:
         
         UIUserNotificationTypeBadge   = 1 << 0, // 接收到通知可更改程序的应用图标
         UIUserNotificationTypeSound   = 1 << 1, // 接收到通知可播放声音
         UIUserNotificationTypeAlert   = 1 << 2, // 接收到通知课提示内容
         如果你需要使用多个类型,可以使用 "|" 来连接
         */
        
        //      向用户请求通知权限
        //      categories暂时传入nil
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
        {
            [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
        }
    }
}

- (void)pushLocalNotification:(NSString *)title alertBody:(NSString *)alertBody infoDic:(NSDictionary *)infoDic
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        
        NSDate *now=[NSDate new];
        notification.fireDate=[now dateByAddingTimeInterval:0.1]; //触发通知的时间
        //            notification.repeatInterval = NSCalendarUnitYear; //循环次数，kCFCalendarUnitWeekday一周一次
        
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.alertBody = alertBody;
        notification.alertTitle = title;
        notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
        
        //下面设置本地通知发送的消息内容
        if(infoDic)
            notification.userInfo = infoDic;
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
    }
    
    NSLog(@"pushLocalNotification");
}

//发送本地通知
//flag通知的唯一标示
- (void)pushLocalNotification:(NSString *)title alertBody:(NSString *)alertBody flag:(NSString *)flag infoDic:(NSDictionary *)infoDic
{
    if(flag==nil||flag.length==0)
        return;
    
    [self removeLocalNotification:flag];
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        
        NSDate *now=[NSDate new];
        notification.fireDate=[now dateByAddingTimeInterval:0.1]; //触发通知的时间
        //            notification.repeatInterval = NSCalendarUnitYear; //循环次数，kCFCalendarUnitWeekday一周一次
        
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.alertBody = alertBody;
        notification.alertTitle = title;
        notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
        
        //下面设置本地通知发送的消息，这个消息可以接受
        NSMutableDictionary *mul = [[NSMutableDictionary alloc] initWithDictionary:@{flag:flag}];
        if(infoDic)
            [mul addEntriesFromDictionary:infoDic];
        notification.userInfo = mul;
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        [notifyDic setObject:notification forKey:flag];
        
    }
    
    NSLog(@"pushLocalNotification");
    
}

//清除特定的通知,flag通知的唯一标示
- (void)removeLocalNotification:(NSString *)flag
{
    //按我的理解，这里获取的不是所有的通知，而是在通知队列中的，如果已经显示出来的通知不会在这里
    NSArray *arr = [[UIApplication sharedApplication] scheduledLocalNotifications];

    for (UILocalNotification *noti in arr)
    {
        NSString *notiID = [noti.userInfo objectForKey:flag];
        
        if ([notiID isEqualToString:flag])
        {
            
            [[UIApplication sharedApplication] cancelLocalNotification:noti];
            NSLog(@"remove Notification%@",flag);
        }
    }
    
    UILocalNotification *notity = [notifyDic objectForKey:flag];
    if(notity)
    {
        [[UIApplication sharedApplication] cancelLocalNotification:notity];
        [notifyDic removeObjectForKey:flag];
        
        NSLog(@"remove Notification%@",flag);
    }
    
}

@end
