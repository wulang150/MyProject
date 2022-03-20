//
//		File Name:		WeakTestModel.m
//		Product Name:	MyProject
//		Author:			anker@Tmac
//		Created Date:	2021/9/8 8:32 PM
//		
// * Copyright © 2021 Anker Innovations Technology Limited All Rights Reserved.
// * The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
//		All rights reserved.
//'--------------------------------------------------------------------'
	

#import "WeakTestModel.h"

@implementation WeakTestModel

- (void)dealloc{
    NSLog(@"WeakTestModel-dealloc");
}

- (void)show{
    NSLog(@"WeakTestModel--show");
}
@end
