//
//		File Name:		IDCPlayItemSelectView.h
//		Product Name:	BatteryCam
//		Author:			anker@oceanwing
//		Created Date:	2019/12/23 4:09 PM
//		
// * Copyright © 2019 Anker Innovations Technology Limited All Rights Reserved.
// * The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
//		All rights reserved.
//'--------------------------------------------------------------------'
	

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, IDCPlayItemTyle) {
    IDCPlayItemTyle_None,
    IDCPlayItemTyle_Live,
    IDCPlayItemTyle_PlayBack,
};

@class IDCPlayItemSelectView;

@protocol IDCPlayItemSelectViewDelegate <NSObject>

@optional
- (void)IDCPlayItemSelectView:(IDCPlayItemSelectView *)playItemSelectView didSelectedItem:(IDCPlayItemTyle)type;

@end

@interface IDCPlayItemSelectView : UIView

@property(nonatomic,weak) id<IDCPlayItemSelectViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
