//
//  BarSelectView.m
//  MyProject
//
//  Created by  Tmac on 2018/8/6.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "BarSelectView.h"

@interface BarSelectView()
{
    BarSelectItem *currentItem;
    NSMutableArray *mulItemArr;
}
@end

@implementation BarSelectView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {

//        _font = [UIFont systemFontOfSize:14];
        _titleColor = [UIColor lightGrayColor];
        _titleSelectColor = [UIColor orangeColor];
        _bottomLineH = 0;
        _bottomLineColor = [UIColor orangeColor];
        _gapLineColor = [UIColor lightGrayColor];
        _gapLineW = 0.5;
        
        
    }
    
    return self;
}

- (void)setDataArr:(NSArray *)dataArr
{
    for(UIView *subV in self.subviews)
        [subV removeFromSuperview];
    if(dataArr.count<=0)
        return;
    mulItemArr = [NSMutableArray new];
    _dataArr = dataArr;
    CGRect frame = self.frame;
    CGFloat itemW = frame.size.width/dataArr.count;
    
    for(NSInteger i = 0;i<dataArr.count;i++)
    {
        CGFloat x = i*itemW;
        NSMutableAttributedString *title = [[dataArr objectAtIndex:i] mutableCopy];
        if([title isKindOfClass:[NSString class]])
        {
            NSString *tstr = (NSString *)title;
            NSAttributedString *tmp = [[self class] gainAttributedString:tstr color:_titleColor font:[UIFont systemFontOfSize:14]];
            title = [tmp mutableCopy];
        }
        //把每一个attributeString改为_titleColor
        [title addAttribute:NSForegroundColorAttributeName value:_titleColor range:NSMakeRange(0, title.length)];
        //创建每一个item
        BarSelectItem *item = [[BarSelectItem alloc] initWithFrame:CGRectMake(x, 0, itemW, frame.size.height)];
        item.tag = i;
        item.title = title;
        item.titleColor = _titleColor;
        item.titleSelectColor = _titleSelectColor;
        item.bottomLineColor = _bottomLineColor;
        item.bottomLineH = _bottomLineH;
        item.didSelectedItem = ^(BarSelectItem *item) {
            [self didSelectedItem:item];
        };
        [item reloadView];
        [self addSubview:item];
        [mulItemArr addObject:item];
        //加入分割线
        if(_gapLineH<=0)
            _gapLineH = item.titleLabH;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, (item.titleLabH-_gapLineH)/2, _gapLineW, _gapLineH)];
        lineView.centerX = item.right;
        lineView.backgroundColor = _gapLineColor;
        if(i!=dataArr.count-1)
            [self addSubview:lineView];
    }
    
    //选中第一个
    [self selectedTabItem:0 animated:NO];
}

- (void)selectedTabItem:(NSUInteger)index animated:(BOOL)animated
{
    if(index>=mulItemArr.count)
        return;
    BarSelectItem *item = [mulItemArr objectAtIndex:index];
    if(currentItem==item)
        return;
    //上一个取消
    currentItem.selected = NO;
    [self transitionToItem:item animated:animated];
}

- (void)transitionToItem:(BarSelectItem *)item animated:(BOOL)animated
{
    if([self.delegate respondsToSelector:@selector(BarSelectView:didSelectedItem:)])
    {
        [self.delegate BarSelectView:self didSelectedItem:item];
    }
    CAShapeLayer *animatingTabTransitionLayer = [CAShapeLayer layer];
    void (^completionBlock)(void) = ^{
        [animatingTabTransitionLayer removeFromSuperlayer];
        [animatingTabTransitionLayer removeAllAnimations];
        currentItem = item;
        currentItem.selected = YES;
    };
    
    if (!animated) {
        completionBlock();
        return;
    }
    
    animatingTabTransitionLayer.frame = CGRectMake(currentItem.x+12, self.height-_bottomLineH, currentItem.width-24, _bottomLineH);
    animatingTabTransitionLayer.backgroundColor = _bottomLineColor.CGColor;
    
    //加入动画
    /* 移动 */
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    // 动画选项的设定
    animation.duration = 0.2; // 持续时间
    animation.repeatCount = 1; // 重复次数
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    // 起始帧和终了帧的设定
    animation.fromValue = [NSValue valueWithCGPoint:animatingTabTransitionLayer.position]; // 起始帧
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(item.centerX, animatingTabTransitionLayer.position.y)]; // 终了帧
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:completionBlock];
    // 添加动画
    [animatingTabTransitionLayer addAnimation:animation forKey:@"move-layer"];
    [CATransaction commit];
    
    [self.layer addSublayer:animatingTabTransitionLayer];
    
}

- (void)didSelectedItem:(BarSelectItem *)item
{
    
    if(currentItem==item)
        return;
    //上一个取消
    currentItem.selected = NO;
    [self transitionToItem:item animated:YES];
}

//创建attri字符串
+ (NSAttributedString *)gainAttributedString:(NSString *)str color:(UIColor *)color font:(UIFont *)font
{
    NSMutableDictionary *valDic = [[NSMutableDictionary alloc] initWithCapacity:10];
    if(color)
        [valDic setObject:color forKey:NSForegroundColorAttributeName];
    if(font)
        [valDic setObject:font forKey:NSFontAttributeName];
    
    return [[NSAttributedString alloc] initWithString:str attributes:valDic];
}

@end
