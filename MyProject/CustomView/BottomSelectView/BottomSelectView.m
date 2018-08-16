//
//  BottomSelectView.m
//  MyProject
//
//  Created by  Tmac on 2017/7/11.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "BottomSelectView.h"
//#import "CommonFun.h"
#import "PicTextItem.h"

#define topPadding 6;
static double const BABadgeHeight = 18.0;
static double const BABadgePadding = 5.0;
@interface BottomSelectView()
{
    NSArray *imageArr;
    NSArray *imageSelectedArr;
    NSArray *titleArr;
    UIColor *titleColor;
    UIColor *titleSelectedColor;
    
    NSInteger num;
    NSInteger currentIndex;
    
    NSMutableArray *imgVCArr;       //存img的控件
    NSMutableArray *titleVCArr;     //存lab的控件
}
@end

@implementation BottomSelectView

- (id)initWithFrame:(CGRect)frame images:(NSArray *)images selectedImages:(NSArray *)selectedImages
             titles:(NSArray *)titles titleColor:(UIColor *)_titleColor titleSelectedColor:(UIColor *)_titleSelectedColor
{
    if(self = [super initWithFrame:frame])
    {
        imageArr = images;
        imageSelectedArr = selectedImages;
        titleArr = titles;
        titleColor = _titleColor;
        titleSelectedColor = _titleSelectedColor;
        currentIndex = -1;
        num = titleArr.count>images.count?titleArr.count:images.count;
        _gapPadding = 4;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}


- (void)updateView
{
    imgVCArr = [NSMutableArray new];
    titleVCArr = [NSMutableArray new];
    for(UIView *view in self.subviews)
        [view removeFromSuperview];
    
    if(self.colOfline>0)
    {
        [self createMulLineView];       //多行的情况
    }
    else
    {
        [self createSingleLineView];        //单行的情况
    }
}

//在第几个item上设置badgeValue
- (void)setBadgeValue:(NSInteger)val index:(NSInteger)index
{
    if(index>=num)
        return;
    
    UIImageView *imgVC = [_imageViewArr objectAtIndex:index];
    UIButton *btn = [self viewWithTag:index];
    UILabel *badgeLab = [btn viewWithTag:111];
    [badgeLab removeFromSuperview];
    
    NSString *numStr = [NSString stringWithFormat:@"%zi",val];
    if(val>999)
        numStr = @"999+";
    CGFloat strW = [numStr widthWithFont:[UIFont systemFontOfSize:10]]+BABadgePadding*2;
    if(strW<BABadgeHeight)
        strW = BABadgeHeight;
    badgeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, strW, BABadgeHeight)];
    badgeLab.center = CGPointMake(imgVC.right+10, imgVC.top+10);
    badgeLab.textAlignment = NSTextAlignmentCenter;
    badgeLab.text = numStr;
    badgeLab.tag = 111;
    badgeLab.font = [UIFont systemFontOfSize:10];
    badgeLab.backgroundColor = [UIColor redColor];
    badgeLab.layer.cornerRadius = BABadgeHeight/2;
    badgeLab.clipsToBounds = YES;
    badgeLab.textColor = [UIColor whiteColor];
    [btn addSubview:badgeLab];
    
}

//设置选中
- (void)setSelectedIndex:(NSInteger)index
{
    if(index>=num)
        return;
    if(currentIndex==index)
        return;
    
    //全部恢复原始状态
//    int i = 0;
//    for(UIImageView *imageView in _imageViewArr)
//    {
//        if(i>=imageArr.count)
//            break;
//
//        UIImage *image = imageArr[i];
//        if(![image isKindOfClass:[UIImage class]])
//            continue;
//
//        imageView.image = image;
//        i++;
//    }
//
//    for(UILabel *lab in _titleViewArr)
//    {
//        lab.textColor = titleColor;
//    }
    
    //取消前一个的状态
    UIImageView *selectedImageView;
    UILabel *selectedTitleView;
    if(currentIndex>=0)
    {
        selectedImageView = [_imageViewArr objectAtIndex:currentIndex];
        selectedTitleView = [_titleViewArr objectAtIndex:currentIndex];
        if(currentIndex<imageArr.count)
            selectedImageView.image = imageArr[currentIndex];
        if(titleColor)
        {
            NSMutableAttributedString *mulStr = [selectedTitleView.attributedText mutableCopy];
            [mulStr addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, mulStr.length)];
            selectedTitleView.attributedText = mulStr;
        }

    }
    
    //设置选中的状态
    selectedImageView = [_imageViewArr objectAtIndex:index];
    selectedTitleView = [_titleViewArr objectAtIndex:index];
    if(index<imageSelectedArr.count)
        selectedImageView.image = imageSelectedArr[index];
    
    if(titleSelectedColor)
    {
        NSMutableAttributedString *mulStr = [selectedTitleView.attributedText mutableCopy];
        [mulStr addAttribute:NSForegroundColorAttributeName value:titleSelectedColor range:NSMakeRange(0, mulStr.length)];
        selectedTitleView.attributedText = mulStr;
    }
    
    currentIndex = index;
}

//创建每一个button
- (UIButton *)createBtn:(CGRect)frame index:(NSInteger)index isMulLine:(BOOL)isMulLine
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = index;
    btn.frame = frame;
//    btn.layer.borderWidth = 1;
    [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    //每一个Item
    PicTextItem *subItem = [[PicTextItem alloc] initWithImageSize:CGSizeMake(_imgW, _imgH)];
    subItem.userInteractionEnabled = NO;
    subItem.gapPadding = _gapPadding;
    
    //图片
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _imgW, _imgH)];
    UIImageView *imageView = subItem.topImgView;
    if(index>=imageArr.count)
    {
        imageView.frame = CGRectZero;
    }
    else        //有图片的
    {
        UIImage *image = imageArr[index];
        if([image isKindOfClass:[UIImage class]])
            imageView.image = image;
        else
            imageView.frame = CGRectZero;
    }
    imageView.clipsToBounds = YES;
    
    //标题
//    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _gapPadding, 0, 0)];
    UILabel *titleLab = subItem.bottomLab;
    if(index<titleArr.count)
    {
        NSMutableAttributedString *title = [[titleArr objectAtIndex:index] mutableCopy];
        if([title isKindOfClass:[NSString class]])
        {
            NSString *tstr = (NSString *)title;
            NSAttributedString *tmp = [tstr toAttributedStr:[UIFont systemFontOfSize:12] color:nil];
            title = [tmp mutableCopy];
        }
        if(titleColor)
        {
        //把每一个attributeString改为_titleColor
            [title addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, title.length)];
        }
        titleLab.attributedText = title;
    }
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.numberOfLines = 0;
    
    [subItem reloadView];
    
    subItem.center = CGPointMake(btn.width/2, btn.height/2);
    if(isMulLine)
        subItem.y = topPadding;
    [btn addSubview:subItem];
    
//    UIView *view = [CommonFun fitToCenter:btn childs:@[imageView,titleLab] subAlign:1 isHor:NO];
//    view.userInteractionEnabled = NO;
    
    [imgVCArr addObject:imageView];
    [titleVCArr addObject:titleLab];
    
    return btn;
}

- (void)createSingleLineView
{
    if(num<=0)
        return;
    
    CGFloat w = self.bounds.size.width/num;
    CGFloat imgW = w*2/5;
    CGFloat imgH = self.bounds.size.height/2;
    imgW = imgH = imgW>imgH?imgH:imgW;
    
    if(_imgH<=0)
        _imgH = imgH;
    if(_imgW<=0)
        _imgW = imgW;

    for(int i = 0;i<num;i++)
    {
        UIButton *btn = [self createBtn:CGRectMake(i*w, 0, w, self.bounds.size.height) index:i isMulLine:NO];
        
        [self addSubview:btn];
        
    }
    //遇到没有图片或文字的，都会创建一个，免得数量不等
    _imageViewArr = [imgVCArr copy];
    _titleViewArr = [titleVCArr copy];
}
- (void)createMulLineView
{
    if(num<=0)
        return;
    
    CGFloat w = self.bounds.size.width/_colOfline;
    NSInteger line = (num-1)/_colOfline+1;
    CGFloat h = self.bounds.size.height/line;
    CGFloat imgW = w*2/5;
    CGFloat imgH = h*2/5;
    imgW = imgH = imgW>imgH?imgH:imgW;
    
    if(_imgH<=0)
        _imgH = imgH;
    if(_imgW<=0)
        _imgW = imgW;
    
    for(int i=0;i<line;i++)
    {
        for(int j=0;j<_colOfline;j++)
        {
            NSInteger index = i*_colOfline+j;
            if(index>=num)
                break;
            UIButton *btn = [self createBtn:CGRectMake(j*w, i*h, w, h) index:index isMulLine:YES];
            [self addSubview:btn];
        }
    }
    //遇到没有图片或文字的，都会创建一个，免得数量不等
    _imageViewArr = [imgVCArr copy];
    _titleViewArr = [titleVCArr copy];
}


- (void)buttonAction:(UIButton *)sender
{
    
    [self setSelectedIndex:sender.tag];
    
    UIImageView *selectedImageView = [_imageViewArr objectAtIndex:sender.tag];
    UILabel *selectedTitleView = [_titleViewArr objectAtIndex:sender.tag];
    if([self.delegate respondsToSelector:@selector(didSelectedBottomSelectView:index:selectedImage:selectedTitle:)])
    {
        [_delegate didSelectedBottomSelectView:self index:sender.tag selectedImage:selectedImageView selectedTitle:selectedTitleView];
    }
}

@end
