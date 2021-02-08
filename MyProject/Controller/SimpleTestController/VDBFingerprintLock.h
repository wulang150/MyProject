//
//		File Name:		VDBFingerprintLock.h
//		Product Name:	MyProject
//		Author:			anker@Tmac
//		Created Date:	2019/10/18 11:31 AM
//		
// * Copyright © 2019 Anker Innovations Technology Limited All Rights Reserved.
// * The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
//		All rights reserved.
//'--------------------------------------------------------------------'
	

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//支持的登录方式
typedef NS_ENUM(NSInteger ,VDBUnlockSupportType) {
    VDBUnlockType_None = 0,//既不支持指纹，也不支持脸部识别
    VDBUnlockType_TouchID,//指纹解锁
    VDBUnlockType_FaceID//脸部识别
};


//登录回调类型
typedef NS_ENUM(NSInteger ,VDBUnlockResult) {
    VDBUnlockFailed = 0,//失败
    VDBUnlockSuccess//成功
};

typedef void(^VDBUnlockResultBlock)(VDBUnlockResult result , NSString* errMsg);

@interface VDBFingerprintLock : NSObject

@property(nonatomic,assign) VDBUnlockSupportType supportType;//支持的登录方式

+ (VDBFingerprintLock *)shareInstance;//单例

- (void)logout;

- (VDBUnlockSupportType)checkUnlockSupportType;//检测支持的登录方式

//返回当前手机支持的是什么登录方法（faceID或TouchID），具体是否有效或有权限，就看canEvaluatePolicy值
+ (VDBUnlockSupportType)checkUnlockSupportType:(int *)canEvaluatePolicy;
+ (void)unlockWithResultBlock:(VDBUnlockResultBlock)block;

- (void)unlockWithResultBlock:(VDBUnlockResultBlock)block;//登录回调结果(在调用此方法前，需要调用上面的方式获取登录的支持方式)

@end

NS_ASSUME_NONNULL_END
