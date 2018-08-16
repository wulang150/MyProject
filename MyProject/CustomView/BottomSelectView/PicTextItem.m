//
//  PicTextItem.m
//  MyProject
//
//  Created by  Tmac on 2018/8/8.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "PicTextItem.h"

@implementation PicTextItem

- (id)initWithImageSize:(CGSize)size
{
    if(self = [super initWithFrame:CGRectZero])
    {
        _topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        _topImgView.clipsToBounds = YES;
        
        _bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _bottomLab.numberOfLines = 0;
        
        _align = FDLayout_center;
        
    }
    return self;
}

- (void)reloadView
{
    for(UIView *sub in self.subviews)
        [sub removeFromSuperview];
    
    if(_gapPadding<=0)
        _gapPadding = 4;
    
    _bottomLab.top = _gapPadding;
    
    UIView *mainView = [UIView gainVerAutoView:@[_topImgView,_bottomLab] viewX:0 viewY:0 align:_align];
    [self addSubview:mainView];
    self.size = CGSizeMake(mainView.width, mainView.height);
    
}

@end
