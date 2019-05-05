//
//  VideoConvertViewController.m
//  MyProject
//
//  Created by Anker on 2019/2/27.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "VideoConvertViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoConvertViewController ()
<UIImagePickerControllerDelegate>

@end

@implementation VideoConvertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView{
    
    [self setNavWithTitle:@"视频转换" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 200, 100, 30);
    [btn setTitle:@"录制" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}


- (void)btnAction:(UIButton *)sender{
//    UIImagePickerController *pickerCon = [[UIImagePickerController alloc]init];
//    pickerCon.sourceType = UIImagePickerControllerSourceTypeCamera;
//    pickerCon.mediaTypes = @[(NSString *)kUTTypeMovie];//设定相机为视频
//    pickerCon.cameraDevice = UIImagePickerControllerCameraDeviceRear;
////    pickerCon.videoMaximumDuration = 6;//最长拍摄时间
//    pickerCon.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;//拍摄质量
//    pickerCon.allowsEditing = NO;//是否可编辑
//    pickerCon.delegate = self;
//
//
//    [self presentViewController:pickerCon animated:YES completion:nil];
    
//    [self testMovToMp4];
//    [self testMp4ToMov];
    
    [self readMovieData];
}

//读取内容
- (void)readMovieData{
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    NSString *movie1 = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"movieH265.mp4"];
    NSString *movie2 = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"movieH265T.mp4"];
    
    NSData *data1 = [NSData dataWithContentsOfFile:movie1];
    NSData *data2 = [NSData dataWithContentsOfFile:movie2];
    
    NSLog(@"data1=%@",[data1 subdataWithRange:NSMakeRange(0, 1024*100)]);
    NSLog(@"data2=%@",[data2 subdataWithRange:NSMakeRange(0, 1024*100)]);
}

- (NSString *)moveToLocal:(NSString *)srcPath{
    if([srcPath isKindOfClass:[NSURL class]]){
        NSURL *url = (NSURL *)srcPath;
        srcPath = [url absoluteString];
    }
    srcPath = [srcPath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"test.MOV"];
    NSLog(@"src=%@  dec=%@",srcPath,filePath);
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    [fm copyItemAtPath:srcPath toPath:filePath error:nil];
    return filePath;
}

- (void)testMovToMp4{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    //    NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"IMG_2272.MOV"];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"IMG_H264.MOV"];
    //    NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"15_54_18_movie.mp4"];
    if(![fm fileExistsAtPath:filePath])
    {
        NSLog(@"no file");
        return;
    }
    
    [self mov2mp4:[NSURL fileURLWithPath:filePath]];
}

- (void)testMp4ToMov{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"output-cvt11.mp4"];
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"movieH264.mp4"];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"hevc_low.mp4"];
    if(![fm fileExistsAtPath:filePath])
    {
        NSLog(@"no file");
        return;
    }
    
    [self mp4ToMov:[NSURL fileURLWithPath:filePath]];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"视频录制完成...");
    NSLog(@"%@",info);
    NSURL *fileUrl = [info objectForKey:UIImagePickerControllerMediaURL];
    NSString *file = [self moveToLocal:[fileUrl absoluteString]];
    [self mov2mp4:[NSURL fileURLWithPath:file]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)mp4ToMov:(NSURL *)filepath{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:filepath options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    /**
     AVAssetExportPresetMediumQuality 表示视频的转换质量，
     */
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
        
        //转换完成保存的文件路径
        NSString * resultPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.MOV",@"abc"];
        
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        
        //转换的数据是否对网络使用优化
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        //异步处理开始转换
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         
         {
             //转换状态监控
             switch (exportSession.status) {
                 case AVAssetExportSessionStatusUnknown:
                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     break;
                     
                 case AVAssetExportSessionStatusWaiting:
                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     break;
                     
                 case AVAssetExportSessionStatusExporting:
                     NSLog(@"AVAssetExportSessionStatusExporting");
                     break;
                 case AVAssetExportSessionStatusFailed:
                     NSLog(@"AVAssetExportSessionStatusFailed");
                     break;
                 case AVAssetExportSessionStatusCancelled:
                     NSLog(@"AVAssetExportSessionStatusCancelled");
                     break;
                     
                 case AVAssetExportSessionStatusCompleted:
                 {
                     //转换完成
                     NSLog(@"AVAssetExportSessionStatusCompleted");
                     
                     //测试使用，保存在手机相册里面
                     //                     ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
                     //                     [assetLibrary writeVideoAtPathToSavedPhotosAlbum:exportSession.outputURL completionBlock:^(NSURL *assetURL, NSError *error){
                     //                         if (error) {
                     //                             NSLog(@"%@",error);
                     //                         }
                     //                     }];
                     break;
                 }
             }
             
             if(exportSession.error){
                 NSLog(@"exportSession.error=%@",exportSession.error);
             }
             
         }];
        
    }
}

- (void)mov2mp4:(NSURL *)movUrl
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    /**
     AVAssetExportPresetMediumQuality 表示视频的转换质量，
     */
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
        
        //转换完成保存的文件路径
        NSString * resultPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4",@"cvt"];
        
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        
        //要转换的格式，这里使用 MP4
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        //转换的数据是否对网络使用优化
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        //异步处理开始转换
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         
         {
             //转换状态监控
             switch (exportSession.status) {
                 case AVAssetExportSessionStatusUnknown:
                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     break;
                     
                 case AVAssetExportSessionStatusWaiting:
                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     break;
                     
                 case AVAssetExportSessionStatusExporting:
                     NSLog(@"AVAssetExportSessionStatusExporting");
                     break;
                 case AVAssetExportSessionStatusFailed:
                     NSLog(@"AVAssetExportSessionStatusFailed");
                     break;
                 case AVAssetExportSessionStatusCancelled:
                     NSLog(@"AVAssetExportSessionStatusCancelled");
                     break;
                     
                 case AVAssetExportSessionStatusCompleted:
                 {
                     //转换完成
                     NSLog(@"AVAssetExportSessionStatusCompleted");
                     
                     //测试使用，保存在手机相册里面
//                     ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
//                     [assetLibrary writeVideoAtPathToSavedPhotosAlbum:exportSession.outputURL completionBlock:^(NSURL *assetURL, NSError *error){
//                         if (error) {
//                             NSLog(@"%@",error);
//                         }
//                     }];
                     break;
                 }
             }
             
             if(exportSession.error){
                 NSLog(@"exportSession.error=%@",exportSession.error);
             }
             
         }];
        
    }
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    NSLog(@"视频录制取消了...");
    
}

@end
