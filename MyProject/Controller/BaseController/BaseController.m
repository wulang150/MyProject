//
//  BaseController.m
//  MyProject
//
//  Created by  Tmac on 2017/6/29.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "BaseController.h"

@interface BaseController ()
{
    CGFloat _startPos;
    CGFloat _endPos;
    BOOL _isShrink;
}
@property(nonatomic,weak) UIScrollView *navScrollView;          //保存操作的tableView
@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack
{
    NSLog(@"goBack");
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)setNavWithTitle:(NSString *)title
              leftImage:(NSString *)leftImage
              leftTitle:(NSString *)leftTitle
             leftAction:(SEL)leftAction
             rightImage:(NSString *)rightImage
             rightTitle:(NSString *)rightTitle
            rightAction:(SEL)rightAction
{
    
    return [self setNavWithTitle1:title leftImage:[UIImage imageNamed:leftImage] leftTitle:leftTitle leftAction:leftAction rightImage:[UIImage imageNamed:rightImage] rightTitle:rightTitle rightAction:rightAction];
}

//没有的就传nil
- (UIView *)setNavWithTitle1:(NSString *)title
                   leftImage:(UIImage *)leftImage
                   leftTitle:(NSString *)leftTitle
                  leftAction:(SEL)leftAction
                  rightImage:(UIImage *)rightImage
                  rightTitle:(NSString *)rightTitle
                 rightAction:(SEL)rightAction
{
    if(self.navigationController.isNavigationBarHidden)
    {
        UIView *view = [[self class] comNavWithTitle:title leftImage:leftImage leftTitle:leftTitle leftAction:leftAction rightImage:rightImage rightTitle:rightTitle rightAction:rightAction itemSelf:self];
        
        UIButton *leftBtn = [view viewWithTag:700];
        UILabel *titleView = [view viewWithTag:701];
        UIButton *rightBtn = [view viewWithTag:702];
        
        self.NavleftBtn = leftBtn;
        self.NavrightBtn = rightBtn;
        self.NavtitleLab = titleView;
        
        if(!leftAction)
        {
            [leftBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        }
        _NavMainView = view;
        [self.view addSubview:view];
        
        //加入点击事件
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NavTapAction)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [_NavMainView addGestureRecognizer:singleTap];
        return view;
    }
    
    //下面是使用系统的导航条
    self.navigationItem.title = title;
    UIBarButtonItem *leftBtn,*rightBtn;
    if(!leftAction)
        leftAction = @selector(goBack);
    if(leftImage)
    {
        
        leftBtn = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStyleDone target:self action:leftAction];
    }
    else if(leftTitle)
    {
        leftBtn = [[UIBarButtonItem alloc] initWithTitle:leftTitle style:UIBarButtonItemStylePlain target:self action:leftAction];
    }
    
    if(rightImage)
    {
        rightBtn = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:rightAction];
    }
    else if(rightTitle)
    {
        rightBtn = [[UIBarButtonItem alloc] initWithTitle:rightTitle style:UIBarButtonItemStylePlain target:self action:rightAction];
    }
    if(leftBtn)
        self.navigationItem.leftBarButtonItem = leftBtn;
    if(rightBtn)
        self.navigationItem.rightBarButtonItem = rightBtn;
    return nil;
}

- (void)NavTapAction
{
    [self navShrinkOpt:YES];
}

+ (UIView *)comNavWithTitle:(NSString *)title
                  leftImage:(UIImage *)leftImage
                  leftTitle:(NSString *)leftTitle
                 leftAction:(SEL)leftAction
                 rightImage:(UIImage *)rightImage
                 rightTitle:(NSString *)rightTitle
                rightAction:(SEL)rightAction
                   itemSelf:(id)itemSelf
{
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationBar_HEIGHT)];
    navView.backgroundColor = [UIColor grayColor];
    //lx距离左边的距离，lh状态栏的高度
    CGFloat wbtn = 40,lx = 8,lh = StateBar_Height;
    
    //左按钮
    UIButton *leftBtn = [self gainBtn:CGRectMake(lx, lh+(NavigationBar_HEIGHT-wbtn-lh)/2, wbtn, wbtn) title:leftTitle image:leftImage];
    leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    leftBtn.tag = 700;
    if(leftAction)
    {
        [leftBtn addTarget:itemSelf action:leftAction forControlEvents:UIControlEventTouchUpInside];
    }
    
    //标题
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, lh, SCREEN_WIDTH, NavigationBar_HEIGHT-lh)];
    navTitle.font = [UIFont systemFontOfSize:20];
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.textColor = [UIColor whiteColor];
    navTitle.tag = 701;
    navTitle.text = title;
    
    //右按钮
    UIButton *rightBtn = [self gainBtn:CGRectMake(SCREEN_WIDTH-wbtn-lx, lh+(NavigationBar_HEIGHT-wbtn-lh)/2, wbtn, wbtn) title:rightTitle image:rightImage];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    rightBtn.tag = 702;
    if(rightAction)
    {
        [rightBtn addTarget:itemSelf action:rightAction forControlEvents:UIControlEventTouchUpInside];
    }
    
    [navView addSubview:navTitle];
    [navView addSubview:leftBtn];
    [navView addSubview:rightBtn];
    
    return navView;
}

+ (UIButton *)gainBtn:(CGRect)frame title:(NSString *)title image:(UIImage *)image
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.textColor = [UIColor whiteColor];
    
    if(image)
    {
        [btn setImage:image forState:UIControlStateNormal];
    }
    else if(title)
    {
        UILabel *tlab = [[UILabel alloc] initWithFrame:CGRectZero];
        tlab.text = title;
        tlab.font = [UIFont systemFontOfSize:15.0f];
        [tlab sizeToFit];
        
        if(tlab.frame.size.width>frame.size.width)
        {
            
            CGFloat newW = tlab.frame.size.width + 8;
            CGFloat gap = newW - frame.size.width;
            frame.size.width = newW;
            if(frame.origin.x>SCREEN_WIDTH/2)      //说明是右边的按钮
            {
                frame.origin.x -= gap;
            }
        }
        if(tlab.frame.size.height>frame.size.height)
            frame.size.height = tlab.frame.size.height;
        
        [btn setTitle:title forState:UIControlStateNormal];
    }
    else        //既没有图片，也没有标题的，就使用默认图片
    {
//        if(frame.origin.x<SCREEN_WIDTH/2)      //说明是左边的按钮
//        {
//            [btn setImage:[self gainArrowImage] forState:UIControlStateNormal];
//        }
        //那按钮就无效
        btn.enabled = NO;
    }
    
    btn.frame = frame;
    
    return btn;
}

//向右的箭头
+ (UIImage *)gainArrowImage:(CGSize)size;
{
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    //画箭头
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(rect.size.width/3, 0)];
    [path addLineToPoint:CGPointMake(0, rect.size.height/2)];
    [path addLineToPoint:CGPointMake(rect.size.width/3, rect.size.height)];
    [[UIColor whiteColor] setFill];
    [path fill];
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)navScrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _navScrollView = scrollView;
    _startPos = scrollView.contentOffset.y;
}
- (void)navScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _endPos = scrollView.contentOffset.y;
    if(_endPos>_startPos)       //向上滑动
    {
        [self navShrinkOpt:NO];
    }
    else if(_startPos-_endPos>180||_endPos<=0)
    {
        [self navShrinkOpt:YES];
    }
}
- (void)navScrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _endPos = scrollView.contentOffset.y;
    if(_endPos<=0)
    {
        [self navShrinkOpt:YES];
    }
}

- (void)navShrinkOpt:(BOOL)isUp
{
    if(!_navScrollView)
        return;
    if(isUp)
    {
        if(_isShrink==YES)      //收缩状态，准备展开
        {
            _NavleftBtn.hidden = YES;
            _NavrightBtn.hidden = YES;
            [_NavMainView.layer removeAllAnimations];
            [_NavtitleLab.layer removeAllAnimations];
            [UIView animateWithDuration:0.5 animations:^{
                _NavMainView.height = NavigationBar_HEIGHT;
                _NavtitleLab.centerY = StateBar_Height+(_NavMainView.height-StateBar_Height)/2;
                _navScrollView.frame = CGRectMake(_navScrollView.frame.origin.x, _NavMainView.bottom, _navScrollView.width, SCREEN_HEIGHT-_NavMainView.bottom);
            } completion:^(BOOL finished) {
                _NavleftBtn.hidden = NO;
                _NavrightBtn.hidden = NO;
            }];
            //标题的缩放
            CABasicAnimation *aniScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            aniScale.fromValue = @0.6;
            aniScale.toValue = @1.0;
            aniScale.duration = 0.5;
            aniScale.removedOnCompletion = NO;
            aniScale.fillMode = kCAFillModeForwards;
            [_NavtitleLab.layer addAnimation:aniScale forKey:@"babyCoin_scale"];
            _isShrink = NO;
        }
    }
    else
    {
        if(_isShrink==NO) //展开状态，准备收缩
        {
            _NavleftBtn.hidden = YES;
            _NavrightBtn.hidden = YES;
            [_NavMainView.layer removeAllAnimations];
            [_NavtitleLab.layer removeAllAnimations];
            [UIView animateWithDuration:0.5 animations:^{
                _NavMainView.height = NavigationBar_HEIGHT-20;      //高度变短20
                _NavtitleLab.centerY = StateBar_Height+(_NavMainView.height-StateBar_Height)/2;
                _navScrollView.frame = CGRectMake(_navScrollView.frame.origin.x, _NavMainView.bottom, _navScrollView.width, SCREEN_HEIGHT-_NavMainView.bottom);
            } completion:^(BOOL finished) {
                
            }];
            //标题的收缩
            CABasicAnimation *aniScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            aniScale.fromValue = @1.0;
            aniScale.toValue = @0.6;
            aniScale.duration = 0.5;
            aniScale.removedOnCompletion = NO;
            aniScale.fillMode = kCAFillModeForwards;
            [_NavtitleLab.layer addAnimation:aniScale forKey:@"babyCoin_scale"];
            
            _isShrink = YES;
        }
    }
}

@end
