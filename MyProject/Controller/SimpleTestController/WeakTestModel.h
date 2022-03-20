//
//		File Name:		WeakTestModel.h
//		Product Name:	MyProject
//		Author:			anker@Tmac
//		Created Date:	2021/9/8 8:32 PM
//		
// * Copyright © 2021 Anker Innovations Technology Limited All Rights Reserved.
// * The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
//		All rights reserved.
//'--------------------------------------------------------------------'
	

#import <Foundation/Foundation.h>

typedef void(^SendBlock)(int blockCode,UInt8 code,id __nullable result);

NS_ASSUME_NONNULL_BEGIN

@interface WeakTestModel : NSObject

@property(nonatomic,weak) SendBlock block;
- (void)show;
@end

NS_ASSUME_NONNULL_END
