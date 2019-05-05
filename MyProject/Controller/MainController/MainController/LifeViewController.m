//
//  LifeViewController.m
//  MyProject
//
//  Created by  Tmac on 2018/8/2.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "LifeViewController.h"
#import "RightViewController.h"
#import "ZYNetworkAccessibity.h"
//#import <Photos/PHPhotoLibrary.h>
//#import <AVFoundation/AVFoundation.h>
#import "WLPhotoManager.h"
#import "MapViewController.h"

@interface LifeViewController ()
<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UILabel *testLab;
}
@end

@implementation LifeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    testLab = [[UILabel alloc] init];
    testLab.text = @"生活界面";
    [testLab sizeToFit];
    testLab.center = self.view.center;
    [self.view addSubview:testLab];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(10, 100, 100, 30);
    btn.layer.borderWidth = 1;
    btn.tag = 1;
    [btn setTintColor:[UIColor blackColor]];
    [btn setTitle:@"相册" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame = CGRectMake(btn.right+10, 100, 100, 30);
    btn1.layer.borderWidth = 1;
    btn1.tag = 2;
    [btn1 setTintColor:[UIColor blackColor]];
    [btn1 setTitle:@"拍照" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    [ZYNetworkAccessibity setStateDidUpdateNotifier:^(ZYNetworkAccessibleState state) {
        
        [self showNetMessage:state];
        
    }];
    
    
    [ZYNetworkAccessibity setAlertEnable:YES];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:ZYNetworkAccessibityChangedNotification object:nil];
    
    [ZYNetworkAccessibity start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)networkChanged:(NSNotification *)notification {
    
    ZYNetworkAccessibleState state = ZYNetworkAccessibity.currentState;
    
    if (state == ZYNetworkRestricted) {
        NSLog(@"网络权限被关闭");
    }
    
    [self showNetMessage:state];
}

- (void)showNetMessage:(ZYNetworkAccessibleState)state
{
    switch (state) {
        case ZYNetworkUnknown:
        {
            NSLog(@">>>>>ZYNetworkUnknown");
        }
            break;
        case ZYNetworkChecking:
        {
            NSLog(@">>>>>ZYNetworkChecking");
        }
            break;
        case ZYNetworkWIFI:
        {
            NSLog(@">>>>>ZYNetworkWIFI");
        }
            break;
        case ZYNetworkWWAN:
        {
            NSLog(@">>>>>ZYNetworkWWAN");
        }
            break;
        case ZYNetworkRestricted:
        {
            NSLog(@">>>>>ZYNetworkRestricted");
        }
            break;
            
        default:
        {
            NSLog(@">>>>>other");
            break;
        }
    }
}


- (BOOL)canInForJob
{
    int a = 10;
    return NO;
}

- (void)btnAction:(UIButton *)sender
{
//    [self.navigationController pushViewController:[RightViewController new] animated:YES];
    
    //    [[[UIApplication sharedApplication] rootNavVC] pushViewController:[RightViewController new] animated:YES];
    
    
    //测试卡顿
//    for(int i=0;i<2;i++)
//    {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"IMG_0549" ofType:@"jpg"];
//        UIImage *image = [UIImage imageWithContentsOfFile:path];
//        [NSThread sleepForTimeInterval:1];
//    }
    
//    BOOL isIn = YES;
//    if([self canInForJob])
//    {
//        NSLog(@">>>>>>YES");
//    }
//    else
//    {
//        NSLog(@">>>>>>NO");
//    }
    
//    for(int i=0;i<100;i++)
//    {
//        NSLog(@">>>>%d",i);
//    }
    
//    [ZYNetworkAccessibity start];
    
//    [self checkPhotoAuthor];
//    [self takePhotoFromCamera];
    
    switch (sender.tag) {
        case 1:
        {
            [WLPhotoManager getPhotoFromLibrary:self];
        }
            break;
        case 2:
        {
            [WLPhotoManager getPhotoFromCamera:self];
        }
            break;
            
        default:
            break;
    }
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@">>>>>%@",[NSThread currentThread]);
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
