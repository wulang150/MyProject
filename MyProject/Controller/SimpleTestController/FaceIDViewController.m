//
//  FaceIDViewController.m
//  MyProject
//
//  Created by Anker on 2019/9/9.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "FaceIDViewController.h"
#import "SWFingerprintLock.h"

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
    [[SWFingerprintLock shareInstance] logout];
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavWithTitle:@"FaceID" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[SWFingerprintLock shareInstance] unlockWithResultBlock:^(UnlockResult result, NSString * _Nonnull errMsg) {
        
    }];
}

@end
