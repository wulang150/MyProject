//
//  FireBaseViewController.m
//  MyProject
//
//  Created by Anker on 2019/3/26.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "FireBaseViewController.h"
#import <FirebaseAnalytics/FIRAnalytics.h>
#import "ZXFireBaseManage.h"

@interface FireBaseViewController ()

@end

@implementation FireBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI{
    [self setNavWithTitle:@"FireBase" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 140, 120, 40);
    [btn setTitle:@"test1" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.tag = 100;
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(100, 220, 120, 40);
    [btn1 setTitle:@"test2" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor lightGrayColor];
    btn1.tag = 101;
    [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    //开启FireBase的调试模式，上传更及时
    
    
}

- (void)btnAction:(UIButton *)sender{
    switch (sender.tag) {
        case 100:
        {
            [FIRAnalytics logEventWithName:kFIREventSelectContent
                                parameters:@{
                                             kFIRParameterItemID:[NSString stringWithFormat:@"id-%@", sender.titleLabel.text],
                                             kFIRParameterItemName:sender.titleLabel.text,
                                             kFIRParameterContentType:@"image"
                                             }];
//            [ZXFireBaseManage reportEvent:@"testBtn1" withParameters:@{
//                                                                       @"name":@"helloBtn",
//                                                                       @"id":@"122222"
//                                                                       }];
        }
            break;
        case 101:
        {
            [FIRAnalytics logEventWithName:@"testBtn"
                                parameters:@{
                                             @"name": @"wulang",
                                             @"full_text": @"hello"
                                             }];
        }
            break;
        default:
            break;
    }
    
}


@end
