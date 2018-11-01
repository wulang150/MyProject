//
//  CollectDataAssistManager.m
//  BleMultiConnect
//
//  Created by WANG DONG on 2018/6/6.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

#import "CollectDataAssistManager.h"

@implementation CollectDataAssistManager


/**
 根据文件名称获取到采集数据上传的参数

 @param fileLastPath 文件名称
 @return 返回上传采集数据需要的参数
 */
+ (NSDictionary *)conventUploadType:(NSString *)fileLastPath
{
//    SH_E89C_NickName_0606161615_1.zip

    NSArray *fileArray = [fileLastPath componentsSeparatedByString:@"_"];
    NSString *Device_Type = @"Non";
    NSString *Date_Type = @"Non";
    NSString *Device_Mac = @"F013C3FFFFFF";
    if (fileArray.count >0)
    {
        if ([fileArray[fileArray.count -1] isEqualToString:@"0.zip"])
        {
            Device_Type = @"手环类";
            Date_Type = @"心率";
        }
        else if ([fileArray[fileArray.count -1] isEqualToString:@"1.zip"]){
            Device_Type = @"手环类";
            Date_Type = @"血糖";
        }
        else if ([fileArray[fileArray.count -1] isEqualToString:@"2.zip"]){
            Device_Type = @"手环类";
            Date_Type = @"计步";
        }
        else if ([fileArray[fileArray.count -1] isEqualToString:@"3.zip"]){
            Device_Type = @"手环类";
            Date_Type = @"血糖&血压";
        }
        
        if (fileArray.count > 2)
        {
            Device_Mac = fileArray[1];
        }
    }

    return @{
             DeviceType:Device_Type,
             DateType:Date_Type,
             DeviceMac:Device_Mac,
             };
}
@end
