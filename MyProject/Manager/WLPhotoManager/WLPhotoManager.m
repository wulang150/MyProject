//
//  WLPhotoManager.m
//  MyProject
//
//  Created by anker on 2018/12/20.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "WLPhotoManager.h"
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>

@implementation WLPhotoManager

//拍照 NSCameraUsageDescription
+ (void)getPhotoFromCamera:(UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>*)viewCtl
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    __weak typeof(self) weakSelf = self;
    //未决定的
    if(status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(granted) {
                    [self getPhotoFromCamera:viewCtl];
                }
            });
        }];
        return;
    }
    if(status == AVAuthorizationStatusDenied) {    //已经拒绝的
        //TODO:mike need authorize
        [self openAuthorSet:viewCtl title:@"拍摄权限" content:@"跳转到开启拍摄权限？"];
        return;
    }
    if (status == AVAuthorizationStatusRestricted) { // 此应用程序没有被授权访问的照片数据。可能是家长控制权限。
//        NSLog(@"因为系统原因, 无法访问相机");
        [self errorTip:viewCtl title:@"提示" content:@"因为系统原因, 无法访问相机"];
        return;
    }
    
    //拍照
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = viewCtl;
        [viewCtl presentViewController:imagePicker animated:YES completion:nil];
    }
}
//相册 NSPhotoLibraryUsageDescription
+ (void)getPhotoFromLibrary:(UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>*)viewCtl
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) { // 此应用程序没有被授权访问的照片数据。可能是家长控制权限。
//        NSLog(@"因为系统原因, 无法访问相册");
        [self errorTip:viewCtl title:@"提示" content:@"因为系统原因, 无法访问相册"];
        return;
    }
    if (status == PHAuthorizationStatusDenied) { // 用户拒绝访问相册
        [self openAuthorSet:viewCtl title:@"相册权限" content:@"跳转到开启相册权限？"];
        return;
    }
    if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                    // 放一些使用相册的代码
                    [self getPhotoFromLibrary:viewCtl];
                }
            });
        }];
        return;
    }
    
    //相册
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = viewCtl;
        [viewCtl presentViewController:imagePicker animated:YES completion:nil];
        
    }
}

//调到开启权限的对话框
+ (void)openAuthorSet:(UIViewController *)viewCtl title:(NSString *)title content:(NSString *)content
{
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIDevice currentDevice] systemVersion].floatValue < 10.0) {
            url = [NSURL URLWithString:@"prefs:root=privacy"];
            
        }
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        }
    }];
    [ac addAction:action];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ;
    }];
    
    [ac addAction:action2];
    [viewCtl presentViewController:ac animated:YES completion:nil];
}

//错误提示
+ (void)errorTip:(UIViewController *)viewCtl title:(NSString *)title content:(NSString *)content
{
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [ac addAction:action];

    [viewCtl presentViewController:ac animated:YES completion:nil];
}

@end
