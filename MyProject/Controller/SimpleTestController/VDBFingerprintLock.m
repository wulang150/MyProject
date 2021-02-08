//
//		File Name:		VDBFingerprintLock.m
//		Product Name:	MyProject
//		Author:			anker@Tmac
//		Created Date:	2019/10/18 11:31 AM
//		
// * Copyright © 2019 Anker Innovations Technology Limited All Rights Reserved.
// * The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
//		All rights reserved.
//'--------------------------------------------------------------------'
	

#import "VDBFingerprintLock.h"

#import <LocalAuthentication/LocalAuthentication.h>

static VDBFingerprintLock* g_fingerprintLock = nil ;
static dispatch_once_t g_onceToken;

@interface VDBFingerprintLock()
@property (nonatomic , strong) LAContext* context;


@end

@implementation VDBFingerprintLock

- (instancetype)init{
    if(self = [super init]){
        if(@available(iOS 8.0, *)){
            _context =  [[LAContext alloc] init];
            [self checkUnlockSupportType];
        }
    }
    return self;
}

+ (VDBFingerprintLock *)shareInstance{
    dispatch_once(&g_onceToken, ^{
        g_fingerprintLock = [[VDBFingerprintLock alloc] init];
    });
    return g_fingerprintLock;
}



- (void)logout{
    g_fingerprintLock = nil;
    g_onceToken = 0;
}

+ (VDBUnlockSupportType)checkUnlockSupportType:(int *)canEvaluatePolicy{
    VDBUnlockSupportType supportType = VDBUnlockType_TouchID;
    // 检测设备是否支持TouchID或者FaceID
    if (@available(iOS 8.0, *)) {
        LAContext* LAContent = [[LAContext alloc] init];
        NSError *authError = nil;
        BOOL isCanEvaluatePolicy = [LAContent canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError];
        *canEvaluatePolicy = 0;
        if (@available(iOS 11.0, *)) {
            switch (LAContent.biometryType) {
                case LABiometryNone:
                {
                }
                    break;
                case LABiometryTypeTouchID:
                {
                    supportType = VDBUnlockType_TouchID;
                }
                    break;
                case LABiometryTypeFaceID:
                {
                    supportType = VDBUnlockType_FaceID;
                }
                    break;
                default:
                    break;
            }
        }
        
        if(isCanEvaluatePolicy&&!authError){
            *canEvaluatePolicy = 1;
        }
    }
    
    NSLog(@"VDBUnlockType>>>>>>>%zi  %d",supportType, *canEvaluatePolicy);
    return supportType;
}

+ (void)unlockWithResultBlock:(VDBUnlockResultBlock)block{
    int succ = 0;
    VDBUnlockSupportType supportType = [self checkUnlockSupportType:&succ];
    if(!succ){
        NSLog(@"此设备不支持或者关闭ToucID或FaceID登录！");
        if(block){
            block(VDBUnlockFailed,@"");
        }
        return;
    }
    
    LAContext* jcontext = [[LAContext alloc] init];
    jcontext.localizedFallbackTitle = @"输入密码";
    
    LAPolicy policyType = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    if (@available(iOS 9.0, *)) {
        policyType = LAPolicyDeviceOwnerAuthentication;
    }
    
    NSString* str ;
    if(supportType == VDBUnlockType_TouchID){
        str = @"通过Home键验证已有手机指纹";
    }else if(supportType == VDBUnlockType_FaceID){
        str = @"请正对屏幕启动脸部识别";
    }
    [jcontext evaluatePolicy:policyType localizedReason:str reply:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"验证成功");
                if(block){
                    block(VDBUnlockSuccess,@"");
                }
            });
        }else if(error){
            switch (error.code) {
                case LAErrorAuthenticationFailed:{
                    NSLog(@"验证失败");
                    break;
                }
                case LAErrorUserCancel:{
                    NSLog(@"被用户手动取消");
                }
                    break;
                case LAErrorUserFallback:{
                    NSLog(@"用户不使用TouchID或FaceID,选择手动输入密码");
                }
                    break;
                case LAErrorSystemCancel:{
                    NSLog(@"TouchID或FaceID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                }
                    break;
                case LAErrorPasscodeNotSet:{
                    NSLog(@"TouchID或FaceID 无法启动,因为用户没有设置密码");
                }
                    break;
                case LAErrorTouchIDNotEnrolled:{
                    NSLog(@"TouchID或FaceID 无法启动,因为用户没有设置");
                }
                    break;
                case LAErrorTouchIDNotAvailable:{
                    NSLog(@"TouchID或FaceID 无效");
                }
                    break;
                case LAErrorTouchIDLockout:{
                    NSLog(@"TouchID或FaceID 被锁定(连续多次验证失败,系统需要用户手动输入密码)");
                }
                    break;
                case LAErrorAppCancel:{
                    NSLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                }
                    break;
                case LAErrorInvalidContext:{
                    NSLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                }
                    break;
                default:
                    break;
            }
        }
    }];
}

- (VDBUnlockSupportType)checkUnlockSupportType{
    VDBUnlockSupportType supportType = VDBUnlockType_None;
    // 检测设备是否支持TouchID或者FaceID
    if (@available(iOS 8.0, *)) {
        LAContext* LAContent = [[LAContext alloc] init];
        NSError *authError = nil;
        BOOL isCanEvaluatePolicy = [LAContent canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError];
        if (authError) {
            NSLog(@"检测设备是否支持TouchID或者FaceID失败！\n error : == %@",authError.localizedDescription);
        } else {
            if (isCanEvaluatePolicy) {
                // 判断设备支持TouchID还是FaceID
                if (@available(iOS 11.0, *)) {
                    switch (LAContent.biometryType) {
                        case LABiometryNone:
                        {
                        }
                            break;
                        case LABiometryTypeTouchID:
                        {
                            supportType = VDBUnlockType_TouchID;
                        }
                            break;
                        case LABiometryTypeFaceID:
                        {
                            supportType = VDBUnlockType_FaceID;
                        }
                            break;
                        default:
                            break;
                    }
                } else {
                    // Fallback on earlier versions
                    NSLog(@"iOS 11之前不需要判断 biometryType");
                    // 因为iPhoneX起始系统版本都已经是iOS11.0，所以iOS11.0系统版本下不需要再去判断是否支持faceID，直接走支持TouchID逻辑即可。
                    supportType = VDBUnlockType_TouchID;
                }
                
            }
        }
    } else {
        // Fallback on earlier versions
    }
    
    self.supportType = supportType;
    return supportType;
}

- (void)unlockWithResultBlock:(VDBUnlockResultBlock)block{
    
    if(self.supportType == VDBUnlockType_None){
        //[self errorTipWithMessage:@"此设备未设置ToucID或FaceID,请使用手势登录" WithIsReturn:NO];
        NSLog(@"此设备不支持ToucID或FaceID登录！");
        return;
    }
    LAContext* jcontext = self.context;
    jcontext.localizedFallbackTitle = @"输入密码";
    
    LAPolicy policyType = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    if (@available(iOS 9.0, *)) {
        policyType = LAPolicyDeviceOwnerAuthentication;
    }
    
    NSError* error = nil;
    if ([jcontext canEvaluatePolicy:policyType error:&error]) {
        
        NSString* str ;
        if(self.supportType == VDBUnlockType_TouchID){
            str = @"通过Home键验证已有手机指纹";
        }else if(self.supportType == VDBUnlockType_FaceID){
            str = @"请正对屏幕启动脸部识别";
        }
        [jcontext evaluatePolicy:policyType localizedReason:str reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"验证成功");
                    if(block){
                        block(VDBUnlockSuccess,@"");
                    }
                });
            }else if(error){
                switch (error.code) {
                    case LAErrorAuthenticationFailed:{
                        NSLog(@"验证失败");
                        break;
                    }
                    case LAErrorUserCancel:{
                        NSLog(@"被用户手动取消");
                    }
                        break;
                    case LAErrorUserFallback:{
                        NSLog(@"用户不使用TouchID或FaceID,选择手动输入密码");
                    }
                        break;
                    case LAErrorSystemCancel:{
                        NSLog(@"TouchID或FaceID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                    }
                        break;
                    case LAErrorPasscodeNotSet:{
                        NSLog(@"TouchID或FaceID 无法启动,因为用户没有设置密码");
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled:{
                        NSLog(@"TouchID或FaceID 无法启动,因为用户没有设置");
                    }
                        break;
                    case LAErrorTouchIDNotAvailable:{
                        NSLog(@"TouchID或FaceID 无效");
                    }
                        break;
                    case LAErrorTouchIDLockout:{
                        NSLog(@"TouchID或FaceID 被锁定(连续多次验证失败,系统需要用户手动输入密码)");
                    }
                        break;
                    case LAErrorAppCancel:{
                        NSLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                    }
                        break;
                    case LAErrorInvalidContext:{
                        NSLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                    }
                        break;
                    default:
                        break;
                }
            }
        }];
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(block){
                block(VDBUnlockFailed,@"TouchID失效");
            }
        });
        
    }
}
@end
