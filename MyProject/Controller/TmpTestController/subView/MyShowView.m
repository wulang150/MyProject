//
//		File Name:		MyShowView.m
//		Product Name:	MyProject
//		Author:			anker@Tmac
//		Created Date:	2019/11/5 8:17 PM
//		
// * Copyright © 2019 Anker Innovations Technology Limited All Rights Reserved.
// * The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
//		All rights reserved.
//'--------------------------------------------------------------------'
	

#import "MyShowView.h"

@implementation MyShowView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init{
    if(self = [super init]){
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.5;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyAction) name:@"myNotify" object:nil];
}

- (void)show{
    UIView *mainView = [UIApplication sharedApplication].keyWindow;
    [mainView addSubview:self];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}

- (void)notifyAction{
    NSLog(@"showView_notify");
}

@end
