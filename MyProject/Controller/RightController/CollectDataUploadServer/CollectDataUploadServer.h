//
//  CollectDataUploadServer.h
//  BleMultiConnect
//
//  Created by WANG DONG on 2018/5/30.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectDataUploadServer : NSObject
/**
 *  上传Log信息到服务器
 *
 *  @param filePath 文件路径
 *  @param type     上传文件的类型
 *  @param block    服务器返回结果
 */

+ (void)postLogInfoToServe:(NSString *)filePath withType:(NSString *)type block:(void(^)(BOOL succ, id result))block;
/**
 上传ZIP文件到服务器
 */
//+ (void)collectDataUplaodRecursiveToServer;

//上传特定的文件
+ (void)collectUploadWithFilePath:(NSString *)filePath;

@end
