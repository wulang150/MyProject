//
//		File Name:		RunTimeViewController.h
//		Product Name:	MyProject
//		Author:			anker@Tmac
//		Created Date:	2021/5/19 10:08 AM
//		
// * Copyright © 2021 Anker Innovations Technology Limited All Rights Reserved.
// * The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
//		All rights reserved.
//'--------------------------------------------------------------------'
	

#import <UIKit/UIKit.h>
#import "BaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BCTestMode : NSObject

- (void)test;
- (int)showMsg:(int)val;
@end

@interface RunTimeViewController : BaseController

@end

NS_ASSUME_NONNULL_END
