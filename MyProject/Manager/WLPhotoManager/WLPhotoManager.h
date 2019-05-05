//
//  WLPhotoManager.h
//  MyProject
//
//  Created by anker on 2018/12/20.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSInteger, WLPhotoType) {
//    WLPhotoType_Take,
//    WLPhotoType_Get
//};

NS_ASSUME_NONNULL_BEGIN

@interface WLPhotoManager : NSObject

//拍照
+ (void)getPhotoFromCamera:(UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>*)viewCtl;
//相册
+ (void)getPhotoFromLibrary:(UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>*)viewCtl;

@end

NS_ASSUME_NONNULL_END
