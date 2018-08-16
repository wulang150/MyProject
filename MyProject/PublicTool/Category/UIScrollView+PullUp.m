//
//  UIScrollView+PullUp.m
//  MyProject
//
//  Created by  Tmac on 2018/7/30.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "UIScrollView+PullUp.h"

@implementation UIScrollView (PullUp)

- (void)dealloc
{
    //释放监听
    if(self.topPullView)
    {
        @try {
            
            [self removeObserver:self forKeyPath:@"contentOffset" context:nil];
            
        }
        @catch (NSException *exception) {
            
            NSLog(@"多次删除kvo");
            
        }
    }
}

//UIScrollView+SpringHeadView.m的内容
- (void)setTopPullView:(UIView *)topPullView
{
    //    [self willChangeValueForKey:@"SpringHeadView"];
    objc_setAssociatedObject(self, @selector(topPullView),
                             topPullView,
                             OBJC_ASSOCIATION_RETAIN);
    //    [self didChangeValueForKey:@"SpringHeadView"];
    
    UIView *view = topPullView;
    [self addSubview:view];
    self.topPullViewH = topPullView.bounds.size.height;
    view.frame = CGRectMake(0, -self.topPullViewH, view.bounds.size.width, self.topPullViewH);
    [self displayTopView];

    //使用kvo监听scrollView的滚动
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (UIView *)topPullView
{
    return objc_getAssociatedObject(self, @selector(topPullView));
}

- (void)setTopPullViewH:(CGFloat)topPullViewH
{
    objc_setAssociatedObject(self, @selector(topPullViewH),
                             @(topPullViewH),
                             OBJC_ASSOCIATION_RETAIN);
}
- (CGFloat)topPullViewH
{
    NSNumber *num = objc_getAssociatedObject(self, @selector(topPullViewH));
    return [num floatValue];
}
- (void)setIsTopViewDisplay:(BOOL)isTopViewDisplay
{
    objc_setAssociatedObject(self, @selector(isTopViewDisplay),
                             @(isTopViewDisplay),
                             OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)isTopViewDisplay
{
    NSNumber *num = objc_getAssociatedObject(self, @selector(isTopViewDisplay));
    return [num boolValue];
}
- (void)setTopViewSPos:(CGFloat)topViewSPos
{
    objc_setAssociatedObject(self, @selector(topViewSPos),
                             @(topViewSPos),
                             OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)topViewSPos
{
    NSNumber *num = objc_getAssociatedObject(self, @selector(topViewSPos));
    return [num floatValue];
}
- (void)setTopViewEPos:(CGFloat)topViewEPos
{
    objc_setAssociatedObject(self, @selector(topViewEPos),
                             @(topViewEPos),
                             OBJC_ASSOCIATION_RETAIN);
}
- (CGFloat)topViewEPos
{
    NSNumber *num = objc_getAssociatedObject(self, @selector(topViewEPos));
    if(![num isKindOfClass:[NSNumber class]])
        return 0.0;
    return [num floatValue];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self scrollViewDidScroll:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offy = scrollView.contentOffset.y;
    
//    if (offy < 0) {
//        if(offy>=-topPullViewH)
//            self.topPullView.frame = CGRectMake(0, -topPullViewH, self.topPullView.bounds.size.width, topPullViewH);
//        else
//            self.topPullView.frame = CGRectMake(0, offy, self.topPullView.bounds.size.width, -offy);
//    }
    
    if(offy<-self.topPullViewH)
    {
        self.topPullView.frame = CGRectMake(0, offy, self.topPullView.bounds.size.width, -offy);
    }
}


//弹出顶部的View
- (void)displayTopViewWithAnimate:(BOOL)isAnimate
{
//    if(self.isTopViewDisplay)
//        return;
    if(isAnimate)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            [self displayTopView];
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [self displayTopView];
    }
}
//收缩回顶部的view
- (void)undisplayTopViewWithAnimate:(BOOL)isAnimate
{

    
    if(isAnimate)
    {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            
            [self undisplayTopView];
            self.scrollEnabled = NO;
        } completion:^(BOOL finished) {
            self.scrollEnabled = YES;
        }];
    }
    else
    {
        [self undisplayTopView];
    }
    
}
//弹出顶部的View
- (void)displayTopView
{
    self.isTopViewDisplay = YES;
    self.contentInset = UIEdgeInsetsMake(self.topPullViewH, 0, 0, 0);
    self.contentOffset = CGPointMake(0, -self.topPullViewH);
    
    
}
//收缩回顶部的view
- (void)undisplayTopView
{
    self.isTopViewDisplay = NO;
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.contentOffset = CGPointMake(0, 0);
//    self.topPullView.frame = CGRectMake(0, 0, self.topPullView.bounds.size.width, 0);
    
}

//这里加入了恢复的操作，回弹的动画应该在松手之后再操作，暂时不需要回弹吧
- (void)doForScroll
{
    CGFloat dis = self.topViewEPos-self.topViewSPos;
    if(self.topViewEPos>=0)        //大于0就已经是收缩状态了
    {
        self.isTopViewDisplay = NO;
        return;
    }
    if(dis>0)       //向上滑动，这种情况只会产生收缩效果
    {
        if(self.isTopViewDisplay==NO)
            return;
        //以下都是pos小于0的情况
        if(self.topViewEPos>-self.topPullViewH/2)       //上提超过了一半，就自动收缩
        {
            [self undisplayTopViewWithAnimate:YES];
        }
        else            //恢复成展开的样子
        {
            [self displayTopViewWithAnimate:YES];
        }
    }
    else            //向下滑动，这种情况只会产生展开效果
    {
        if(self.isTopViewDisplay)
            return;
        if(self.topViewEPos<-self.topPullViewH/2)       //下拉超过了一半，就自动展开
        {
            [self displayTopViewWithAnimate:YES];
        }
        else
        {
            [self undisplayTopViewWithAnimate:YES];
        }
    }
}

- (void)doForScroll1
{
    CGFloat dis = self.topViewEPos-self.topViewSPos;
    if(self.topViewEPos>=0)        //大于0就已经是收缩状态了
    {
        self.isTopViewDisplay = NO;
        return;
    }
    if(dis>0)       //向上滑动，这种情况只会产生收缩效果
    {
        if(self.isTopViewDisplay==NO)
            return;
        //以下都是pos小于0的情况
        if(self.topViewEPos>-(self.topPullViewH-16))       //上提超过了一半，就自动收缩
        {
            [self undisplayTopViewWithAnimate:YES];
        }
    }
    else            //向下滑动，这种情况只会产生展开效果
    {
        if(self.isTopViewDisplay)
            return;
        if(self.topViewEPos<-(self.topPullViewH/2))       //下拉超过了一半，就自动展开
        {
            [self displayTopViewWithAnimate:YES];
        }
    }
}

- (void)pullUpscrollViewDidScroll:(UIScrollView *)scrollView
{
    self.topViewEPos = scrollView.contentOffset.y;
    [self doForScroll1];
}

- (void)pullUpScrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.topViewSPos = scrollView.contentOffset.y;
    
}
- (void)pullUpScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    self.topViewEPos = scrollView.contentOffset.y;
//    [self doForScroll];
    
}
- (void)pullUpScrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    self.topViewEPos = scrollView.contentOffset.y;
//    [self doForScroll];
}

@end
