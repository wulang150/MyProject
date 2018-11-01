//
//  CollectDataUploadServer.m
//  BleMultiConnect
//
//  Created by WANG DONG on 2018/5/30.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

#import "CollectDataUploadServer.h"
#import "NetWorkBase.h"
#import "CollectDataMacro.h"
#import "CollectDataAssistManager.h"

@implementation CollectDataUploadServer

/**
 *  上传Log信息到服务器
 *
 *  @param filePath 文件路径
 *  @param type     上传文件的类型
 *  @param block    服务器返回结果
 */

+ (void)postLogInfoToServe:(NSString *)filePath withType:(NSString *)type block:(void(^)(BOOL succ, id result))block
{
    
//    NSDictionary *dic = @{@"File":filePath};
//    NSArray *fileArray = [[NSArray alloc] initWithObjects:dic, nil];
    
    NSDictionary *fileParaDic = [CollectDataAssistManager conventUploadType:filePath.lastPathComponent];
    //F0_13_C3_FF_FFFF
    NSMutableString *macStr = [NSMutableString stringWithString:fileParaDic[DeviceMac]];
    [macStr insertString:@"_" atIndex:2];
    [macStr insertString:@"_" atIndex:5];
    [macStr insertString:@"_" atIndex:8];
    [macStr insertString:@"_" atIndex:11];
    [macStr insertString:@"_" atIndex:14];
    NetWorkBase *post = [NetWorkBase new];
    
    NSDictionary *resultDic = @{@"path":[NSString stringWithFormat:@"/%@/%@/%@/",COLLECT_HEALTH_DATA,APPID_COLLECT_DATA,macStr],
                                @"file":filePath,
                                @"appid":APPID_COLLECT_DATA,
                                @"projecttype":@"健康",
                                @"devicetype":fileParaDic[DeviceType],
                                @"datetype":fileParaDic[DateType],
                                @"address":macStr,
                                };
    

//    NSLog(@">>>>%@",resultDic);
//    NSData *fileData = [NSData dataWithContentsOfURL:[NSURL URLWithString:filePath]];
//    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
//    [post uploadFiles:HttpCollectDataPostURL parameters:resultDic fileDic:@{@"file":filePath} withType:File_Zip withBlock:^(id result, BOOL succ) {
//
//        block(succ,result);
//    }];
    
//    [post SysUploadFiles:HttpCollectDataPostURL parameters:resultDic fileDic:@{@"file":filePath} withType:File_Zip withBlock:^(id result, BOOL succ) {
//        block(succ,result);
//    }];
    
    NSString *url = HttpCollectDataPostURL;
    url = @"https://dev.smartfenda.cn/bugdata/upload.php";
    resultDic = @{
                  @"appid":@"23507",
                  @"userid":@"100089"
                  };
    NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"IMG_0549" ofType:@"jpg"];
    NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"IMG_0550" ofType:@"jpg"];
    [post SysUploadFiles:url parameters:resultDic fileDic:@{@"image1":filePath,
                                                            @"image2":filePath1,
                                                            @"image3":filePath2
                                                            } withType:File_Zip withBlock:^(id result, BOOL succ) {
        block(succ,result);
    }];
    
//    [post uploadFiles:url parameters:resultDic fileDic:@{@"image1":filePath,
//                                                         @"image2":filePath1,
//                                                         @"image3":filePath2
//                                                         } withType:File_Zip withBlock:^(id result, BOOL succ) {
//                                                             block(succ,result);
//                                                         }];
    
}


//上传特定的文件
+ (void)collectUploadWithFilePath:(NSString *)filePath
{
    if(filePath.length<=0)
        return;
    
    [CollectDataUploadServer postLogInfoToServe:filePath withType:@"1" block:^(BOOL succ, id result) {
//        [[self class] deleteFile:filePath];
    }];
}

//删除指定的文件
+ (void)deleteFile:(NSString *)filepath
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL blDele= [fileManager removeItemAtPath:filepath error:nil];
    if (blDele)
    {
        NSLog(@"dele success");
    }
    else
    {
        NSLog(@"dele fail");
    }
}


@end
