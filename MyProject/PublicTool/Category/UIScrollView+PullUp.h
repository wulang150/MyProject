//
//  UIScrollView+PullUp.h
//  MyProject
//
//  Created by  Tmac on 2018/7/30.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (PullUp)

//设置顶部view，tableView在顶部下拉时候，这个View会跟着拉升，类似微信朋友圈顶部的图片
@property(nonatomic,weak) UIView *topPullView;
//以下参数都不需要配置
@property(nonatomic,assign) CGFloat topPullViewH;       //头部的高度
@property(nonatomic,assign) BOOL isTopViewDisplay;      //头部是否为展开
@property(nonatomic,assign) CGFloat topViewSPos;        //滑动开始的位置
@property(nonatomic,assign) CGFloat topViewEPos;        //滑动结束的位置

//弹出顶部的View
- (void)displayTopViewWithAnimate:(BOOL)isAnimate;
//收缩回顶部的view
- (void)undisplayTopViewWithAnimate:(BOOL)isAnimate;


//控制display是undisplay的时机，使用下面的方法后，就是采用的我机制
- (void)pullUpscrollViewDidScroll:(UIScrollView *)scrollView;
- (void)pullUpScrollViewWillBeginDragging:(UIScrollView *)scrollView;
//- (void)pullUpScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
//- (void)pullUpScrollViewDidEndDecelerating:(UIScrollView *)scrollView;
@end
