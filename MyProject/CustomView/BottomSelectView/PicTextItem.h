//
//  PicTextItem.h
//  MyProject
//
//  Created by  Tmac on 2018/8/8.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicTextItem : UIView

//view的大小不需要设置
- (id)initWithImageSize:(CGSize)size;


@property(nonatomic,readonly) UIImageView *topImgView;
@property(nonatomic,readonly) UILabel *bottomLab;
@property(nonatomic) CGFloat gapPadding;      //图片与文字间的间隔
@property(nonatomic) FDLayoutAlign align;
- (void)reloadView;
@end
