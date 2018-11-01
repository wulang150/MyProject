//
//  CollectDataAssistManager.h
//  BleMultiConnect
//
//  Created by WANG DONG on 2018/6/6.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ProjectType @"ProjectType"
#define DeviceType  @"DeviceType"
#define DateType    @"DateType"
#define DeviceMac    @"DeviceMac"
@interface CollectDataAssistManager : NSObject
/**
 根据文件名称获取到采集数据上传的参数
 
 @param fileLastPath 文件名称
 @return 返回上传采集数据需要的参数
 */
+ (NSDictionary *)conventUploadType:(NSString *)fileLastPath;
@end
