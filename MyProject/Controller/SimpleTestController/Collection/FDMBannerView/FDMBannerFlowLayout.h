//
//		File Name:		FDMBannerFlowLayout.h
//		Product Name:	MyProject
//		Author:			anker@Tmac
//		Created Date:	2021/10/14 4:58 PM
//		
// * Copyright © 2021 Anker Innovations Technology Limited All Rights Reserved.
// * The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
//		All rights reserved.
//'--------------------------------------------------------------------'
	

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDMBannerFlowLayout : UICollectionViewFlowLayout

/*初始化部分*/
- (instancetype)initWithSectionInset:(UIEdgeInsets)insets andMiniLineSapce:(CGFloat)miniLineSpace andMiniInterItemSpace:(CGFloat)miniInterItemSpace andItemSize:(CGSize)itemSize;
@end

NS_ASSUME_NONNULL_END
