//
//  FaceIDViewController.m
//  MyProject
//
//  Created by Anker on 2019/9/9.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "FaceIDViewController.h"
#import "SWFingerprintLock.h"
#import "VDBFingerprintLock.h"

@interface FaceIDViewController ()

@end

@implementation FaceIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)viewDidDisappear:(BOOL)animated{
    NSLog(@"%s",__func__);
    [[VDBFingerprintLock shareInstance] logout];
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavWithTitle:@"FaceID" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [[VDBFingerprintLock shareInstance] unlockWithResultBlock:^(VDBUnlockResult result, NSString * _Nonnull errMsg) {
//
//    }];
    int succ = 0;
//    [[VDBFingerprintLock shareInstance] checkUnlockSupportType1:&succ];
    
    [VDBFingerprintLock checkUnlockSupportType:&succ];
    
    [VDBFingerprintLock unlockWithResultBlock:^(VDBUnlockResult result, NSString * _Nonnull errMsg) {
        NSLog(@"Fingerprint>>>>>>%d",succ);
    }];
    
    NSLog(@"Fingerprint>>>>>>%d",succ);
}

@end
