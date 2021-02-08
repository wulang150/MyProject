//
//  ZXFireBaseManage.m
//  BatteryCam
//
//  Created by Anker on 2019/3/27.
//  Copyright © 2019 oceanwing. All rights reserved.
//

#import "ZXFireBaseManage.h"
//#import <FirebaseAnalytics/FIRAnalytics.h>

@implementation ZXFireBaseManage

+ (void)setUserPropertyWithValue:(nullable NSString *)value name:(NSString *)name{
//    [FIRAnalytics setUserPropertyString:value forName:name];
}

+ (void)reportEvent:(NSString *)event{
    
    [self reportEvent:event withParameters:nil];
}


+ (void)reportEvent:(NSString *)event withParameters:(NSDictionary *_Nullable)params{
    
//    [FIRAnalytics logEventWithName:event
//                        parameters:params];
}

@end
