//
//  ViewController.m
//  MyProject
//
//  Created by  Tmac on 2017/6/29.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "ViewController.h"
#import "CommonBgView.h"
#import "PanGesture.h"
#import "NSMutableData+Extension.h"
#import "PageSelectView.h"
#import "CommonFun.h"
#import "PublicFunction.h"
#import "BottomSelectView.h"
#import "RightViewController.h"
#import "MyTestViewController.h"
#import "SocialViewController.h"
#import "LifeViewController.h"
#import "UserViewController.h"
#import "SystemStoreManager.h"
#import "MapViewController.h"
#import "TestMakeController.h"

@implementation Student

MJExtensionCodingImplementation
@end

@implementation TestModel


MJExtensionCodingImplementation
//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [self mj_encode:aCoder];
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    if(self = [super init])
//    {
//        [self mj_decode:aDecoder];
//    }
//
//    return self;
//}
@end

@interface ViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource,PanGestureDelegate,BottomSelectViewDelegate,UIScrollViewDelegate>
{
    NSInteger curPage;
    
    PageSelectView *pageView;
    BottomSelectView *bottomView;
    NSArray *_ctlViewArr;
}
@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic) void(^callBack)();
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createView
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavWithTitle:@"更大幅度" leftImage:nil leftTitle:nil leftAction:nil rightImage:nil rightTitle:@"右边" rightAction:@selector(rightAction)];
    
    NSArray *imageArr = @[[UIImage imageNamed:@"icon_bracelet"],[UIImage imageNamed:@"icon_life"],[UIImage imageNamed:@"icon_i"]];
    NSArray *imageSelectArr = @[[UIImage imageNamed:@"icon_bracelet_sel"],[UIImage imageNamed:@"icon_life_sel"],[UIImage imageNamed:@"icon_i_sel"]];
    NSArray *titleArr = @[@"社交",@"生活",@"我"];
    //下面的选择
    bottomView = [[BottomSelectView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50) images:imageArr selectedImages:imageSelectArr titles:titleArr titleColor:[UIColor whiteColor] titleSelectedColor:[UIColor whiteColor]];
    bottomView.delegate = self;
    bottomView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bottomView];
    [bottomView updateView];
    
    _ctlViewArr = @[[SocialViewController new],[LifeViewController new],[UserViewController new]];
    [self.view addSubview:self.scrollView];
    for(NSInteger i=0;i<_ctlViewArr.count;i++)
    {
        UIViewController *vc = _ctlViewArr[i];
        vc.view.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_CTM_HEIGHT-bottomView.height);
        [self addChildViewController:vc];
        [_scrollView addSubview:vc.view];

    }
    
//    [self.view addSubview:self.collectionView];
    
    pageView = [[PageSelectView alloc] initWithCenter:bottomView.top-40 pageCount:_ctlViewArr.count];
    pageView.spaceLeg = 20;
    pageView.imgSize = CGSizeMake(32, pageView.radius*2);
    pageView.selectImg = [UIImage imageNamed:@"home_focus"];
    [self.view addSubview:pageView];
    
    //设置默认选中状态
    [self didSelecedIndex:0];
    
    [self testMode];
}

- (void)testMode
{
    Student *stu = [[Student alloc] init];
    stu.score = @"100";
    Student *stu1 = [[Student alloc] init];
    stu1.score = @"200";
    
    TestModel *mode = [[TestModel alloc] init];
    mode.name = @"xiaoming";
    mode.uid = @"11010";
    mode.ScoreArr = @[stu,stu1];
    
    [SystemStoreManager insertOrUpdate:mode mainKeys:@[@"uid"] StoreName:@"Student"];
}

- (UIScrollView *)scrollView
{
    if(!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_CTM_HEIGHT-bottomView.height)];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*_ctlViewArr.count, _scrollView.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
    }
    return _scrollView;
}

- (UICollectionView *)collectionView
{
    if(!_collectionView)
    {
        //创建一个layout布局类
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        //    layout.minimumInteritemSpacing = 0;
        //设置每个item的大小为100*100
        
        //创建collectionView 通过一个布局策略layout来创建
        UICollectionView * collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_CTM_HEIGHT-bottomView.height) collectionViewLayout:layout];
        
        layout.itemSize = CGSizeMake(collect.bounds.size.width, collect.bounds.size.height);
        
        //代理设置
        collect.delegate=self;
        collect.dataSource=self;
        collect.pagingEnabled = YES;
        collect.showsVerticalScrollIndicator = NO;
        collect.showsHorizontalScrollIndicator = NO;
        collect.bounces = NO;       //取消边际出滑动出现空白的情况
        collect.scrollEnabled = YES;
//        collect.canCancelContentTouches = NO;       //默认是取消了touch事件，现在开启
        //注册item类型 这里使用系统的类型
        [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
        _collectionView = collect;
        
        //加入手势
//        PanGesture *pan = [[PanGesture alloc] init];
//        pan.GesDelegate = self;
//        [_collectionView addGestureRecognizer:pan];
        
    }
    
    return _collectionView;
}


- (CommonBgView *)gainRightView
{
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH-80, SCREEN_HEIGHT)];
    subView.backgroundColor = [UIColor whiteColor];
    UILabel *tLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, subView.bounds.size.width, 40)];
    tLab.text = @"右边页面";
    tLab.textAlignment = NSTextAlignmentCenter;
    [subView addSubview:tLab];
    
    
    //加入蒙版
    CommonBgView *markView = [[CommonBgView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) subView:subView];
    
    return markView;
}


- (void)rightAction
{
    NSLog(@"rightAction");
    
//    MyTestViewController *rc = [MyTestViewController new];
//    [self.navigationController pushViewController:rc animated:YES];
    
//    TestModel *mode = [SystemStoreManager getModel:@"Student" keys:@[@"uid"] vals:@[@"11010"]];
//    NSLog(@">>>>%@ %@",mode.uid,mode.name);
//    for(Student *stu in mode.ScoreArr)
//    {
//        NSLog(@">>>>%@",stu.score);
//    }
    
//    NSArray *arr = [NSArray new];
//    NSLog(@">>>>>>%@",arr[1]);
    
//    MapViewController *vc = [[MapViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    typedef void(^CallBackType)();
    
//    WS(weakSelf);
//    self.callBack = ^{
//      
//        NSLog(@">>>>>>>>callBack in");
//        if(weakSelf.callBack)
//        {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), weakSelf.callBack);
//        }
//    };
//    
//    weakSelf.callBack();
    
//    TestMakeController *vc = [[TestMakeController alloc] initWithNibName:@"TestMakeController" bundle:[NSBundle mainBundle]];
//    [self.navigationController pushViewController:vc animated:YES];
    
    //打开其他的App
//    [self openOtherApp];
    
    //测试扫描设备
    [[UIApplication sharedApplication] popOrPushToContrl:@"TestDevViewController"];
}

//// 用户 按下 按钮********* 请参考 ViewController.m 文件中的代码
- (void)openOtherApp {
    NSLog(@"MyAppOne: You click the button1111.");
    char szbuff[50] = {0};
    sprintf(szbuff, "%s", "AppDemo2://userName=heliang&pwd=20160812");
    /// 1.不带参数的传递方式
    NSURL* urlLocal = [NSURL URLWithString:@"Location://"];
    /// 2.带参数的传递方式
//    NSURL* urlLocal = [NSURL URLWithString:[NSString stringWithUTF8String:szbuff]];
    
    // 判断是否可以启动该 url
    if([[UIApplication sharedApplication] canOpenURL:urlLocal])
    {
        [[UIApplication sharedApplication] openURL:urlLocal];
        NSLog(@"launch AppDemo2 success!");
    }
    else
    {
        NSLog(@"No such url.");
        /// 跳到 appStore 某个 app
        NSURL* urlAppStore = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/tie-lu12306/id564818797?mt=8"];
        [[UIApplication sharedApplication] openURL: urlAppStore];
    }
}

- (void)didSelecedIndex:(NSInteger)index
{
    curPage = index;
   
//    [_scrollView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:curPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [_scrollView setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0) animated:NO];
    pageView.curPage = curPage;
    [pageView updateView];
    [bottomView setSelectedIndex:index];
}

#pragma -mark BottomSelectViewDelegate
- (void)didSelectedBottomSelectView:(BottomSelectView *)selectView index:(NSInteger)index selectedImage:(UIImageView *)selectedImage selectedTitle:(UILabel *)selectedTitle
{
//    curPage = index;
//    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:curPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//    pageView.curPage = curPage;
//    [pageView updateView];
//    NSLog(@"didSelectedBottomSelectView");
    
    [self didSelecedIndex:index];
}

#pragma -mark PanGestureDelegate
- (void)didPanDirection:(PanGesture *)panGesture direction:(NSInteger)direction
{
    NSLog(@"didPanDirection");
    if(curPage==1)
        return;
    
    switch (direction) {
        case PanMoveDirectionLeft:
        {
            if(curPage!=2)
                return;
            [self rightAction];
            break;
        }
        case PanMoveDirectionRight:
            
            break;
            
        default:
            break;
    }
    
}

#pragma -mark scrollViewDidScroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scrollx = %f",scrollView.contentOffset.x);
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x<=0)
    {
        curPage = 0;
    }
    if(scrollView.contentOffset.x==SCREEN_WIDTH)
    {
        curPage = 1;
        
    }
    if(scrollView.contentOffset.x>=SCREEN_WIDTH*2)
    {
        curPage = 2;
        
    }
    pageView.curPage = curPage;
    [pageView updateView];
    
    //改变底部显示
    [bottomView setSelectedIndex:curPage];
}

#pragma -mark UICollectionDelegate
//设置每个item的大小，双数的为50*50 单数的为100*100
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height-80);
//}
//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _ctlViewArr.count;
}
//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    UIViewController *viewCtl = [_ctlViewArr objectAtIndex:indexPath.row];

    [cell.contentView addSubview:viewCtl.view];
    return cell;
}

@end
