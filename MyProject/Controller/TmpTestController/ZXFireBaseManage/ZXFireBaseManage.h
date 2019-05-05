//
//  ZXFireBaseManage.h
//  BatteryCam
//
//  Created by Anker on 2019/3/27.
//  Copyright © 2019 oceanwing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXFireBaseManage : NSObject

+ (void)reportEvent:(NSString *)event;

+ (void)reportEvent:(NSString *)event withParameters:(NSDictionary *_Nullable)params;

@end

NS_ASSUME_NONNULL_END
