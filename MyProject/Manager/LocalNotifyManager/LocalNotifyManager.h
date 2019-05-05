//
//  LocalNotifyManager.h
//  PushServer
//
//  Created by  Tmac on 2017/8/21.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotifyManager : NSObject

+ (id)sharedInstanced;

//注册，最好在appDelegate里面调用这个
- (void)registerNotify;


/*
 发送本地通知
 title：通知标题
 alertBody：通知内容
 infoDic：通知携带的内容
 */
- (void)pushLocalNotification:(NSString *)title alertBody:(NSString *)alertBody infoDic:(NSDictionary *)infoDic;
//flag通知的唯一标示，这个通知是唯一的，通知列表只会出现一种，不会重复
- (void)pushLocalNotification:(NSString *)title alertBody:(NSString *)alertBody flag:(NSString *)flag infoDic:(NSDictionary *)infoDic;

//清除特定的通知,flag通知的唯一标示
- (void)removeLocalNotification:(NSString *)flag;

@end
