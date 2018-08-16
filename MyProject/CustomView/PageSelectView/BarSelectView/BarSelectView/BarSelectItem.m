//
//  BarSelectItem.m
//  MyProject
//
//  Created by  Tmac on 2018/8/6.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "BarSelectItem.h"

@interface BarSelectItem()
{
    UILabel *titleLab;
    UIView *bottomLineView;
    UIView *lineView;
}
@end

@implementation BarSelectItem

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        _titleColor = [UIColor lightGrayColor];
        _titleSelectColor = [UIColor redColor];
        _bottomLineH = 0;
        _bottomLineColor = [UIColor redColor];
        
    }
    
    return self;
}

//- (void)layoutSubviews
//{
//    //很不靠谱的函数
//    NSLog(@">>>>>>>layoutSubviews%@",titleLab.text);
//}

- (void)createView
{
    CGFloat gap = 10;       //字与下面bottomLine的距离
    CGFloat gapLineH = _bottomLineH>0?self.height-_bottomLineH-gap:self.height;
    _titleLabH = gapLineH;
    //标题
    titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, _titleLabH)];
    titleLab.attributedText = _title;
    titleLab.numberOfLines = 0;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.adjustsFontSizeToFitWidth = YES;
    [self addSubview:titleLab];
    
    //下面的导航线
    bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(12, self.height-_bottomLineH, self.width-24, _bottomLineH)];
    bottomLineView.backgroundColor = _bottomLineColor;
    bottomLineView.hidden = YES;
    [self addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bottomLineView];
}

- (void)btnAction:(UIButton *)sender
{
    if(self.didSelectedItem)
        self.didSelectedItem(self);
}

- (void)reloadView
{
    [self createView];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    NSMutableAttributedString *mulStr = [titleLab.attributedText mutableCopy];
    if(selected)
    {
        [mulStr addAttribute:NSForegroundColorAttributeName value:_titleSelectColor range:NSMakeRange(0, mulStr.length)];
        titleLab.attributedText = mulStr;
        bottomLineView.hidden = NO;
    }
    else
    {
        [mulStr addAttribute:NSForegroundColorAttributeName value:_titleColor range:NSMakeRange(0, mulStr.length)];
        titleLab.attributedText = mulStr;
        bottomLineView.hidden = YES;
    }
}


@end
