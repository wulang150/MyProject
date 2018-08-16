//
//  BaseController.h
//  MyProject
//
//  Created by  Tmac on 2017/6/29.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseController : UIViewController <UINavigationControllerDelegate>

//如果要实现导航栏随tableView的滑动缩小和恢复，就在tableView的对应代理方法下调用以下的方法
- (void)navScrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)navScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)navScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

//正常情况
@property(nonatomic,strong) UIView *NavMainView;        //导航的view
@property(nonatomic,strong) UIButton *NavleftBtn;       //tag 700
@property(nonatomic,strong) UIButton *NavrightBtn;      //tag 702
@property(nonatomic,strong) UILabel *NavtitleLab;       //tag 701

//没有的就传nil
- (UIView *)setNavWithTitle:(NSString *)title
              leftImage:(NSString *)leftImage
              leftTitle:(NSString *)leftTitle
             leftAction:(SEL)leftAction
             rightImage:(NSString *)rightImage
             rightTitle:(NSString *)rightTitle
            rightAction:(SEL)rightAction;

//没有的就传nil
- (UIView *)setNavWithTitle1:(NSString *)title
                  leftImage:(UIImage *)leftImage
                  leftTitle:(NSString *)leftTitle
                 leftAction:(SEL)leftAction
                 rightImage:(UIImage *)rightImage
                 rightTitle:(NSString *)rightTitle
                rightAction:(SEL)rightAction;

//定义加方法，方便没有继承这个类的使用
+ (UIView *)comNavWithTitle:(NSString *)title
                  leftImage:(UIImage *)leftImage
                  leftTitle:(NSString *)leftTitle
                 leftAction:(SEL)leftAction
                 rightImage:(UIImage *)rightImage
                 rightTitle:(NSString *)rightTitle
                rightAction:(SEL)rightAction
                   itemSelf:(id)itemSelf;

//向右的箭头
+ (UIImage *)gainArrowImage:(CGSize)size;

@end
