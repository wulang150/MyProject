//
//  MyTestViewController.m
//  MyProject
//
//  Created by  Tmac on 2018/7/30.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "MyTestViewController.h"
#import "UIScrollView+PullUp.h"

@interface MyTestViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat sPos,ePos;
}
@property(nonatomic) UIView *headView;
@property(nonatomic) UITableView *tableView;
@end

@implementation MyTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ShowFunMsg;
    // Do any additional setup after loading the view.
    [self createView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ShowFunMsg;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createView
{
    UIImage *leftImg = [[self class] gainArrowImage:CGSizeMake(22, 22)];
    [self setNavWithTitle1:@"测试" leftImage:leftImg leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    self.NavMainView.alpha = 0.3;
    self.view.backgroundColor = [UIColor whiteColor];

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_CTM_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];

//    _headView = [self gainHeightView:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
//    _tableView.topPullView = _headView;
    [self.view addSubview:_tableView];
    
//    UIImageView *topImgVC = [[UIImageView alloc] init];
//    topImgVC.size = CGSizeMake(SCREEN_WIDTH, 200);
//    topImgVC.image = [UIImage imageNamed:@"Rectangle"];
//    _tableView.topPullView = topImgVC;
    _tableView.topPullView = [self gainHeadView];
    
    [_tableView undisplayTopViewWithAnimate:NO];
}

- (UIView *)gainHeadView
{
    UIImageView *topImgVC = [[UIImageView alloc] init];
    topImgVC.size = CGSizeMake(SCREEN_WIDTH, 200);
    topImgVC.image = [UIImage imageNamed:@"Rectangle"];
    
    //使用auto布局，位置会随topImgVC大小改变，自动发生改变
    UIImageView *headImgV = [[UIImageView alloc] init];
    headImgV.layer.cornerRadius = 60/2;
    headImgV.clipsToBounds = YES;
    headImgV.image = [UIImage imageNamed:@"friend_id_big"];
    [topImgVC addSubview:headImgV];

    [headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.center.equalTo(topImgVC);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.text = @"手机用户5544";
    [topImgVC addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImgV.mas_bottom).offset(10);
        make.centerX.equalTo(topImgVC);
    }];
    
    return topImgVC;
}
- (UIView *)gainHeightView
{
//    UIView *view = [[UIView alloc] initWithFrame:frame];
//    view.backgroundColor = [UIColor redColor];
    
    UIImageView *headImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
//    headImgV.center = view.center;
    headImgV.layer.cornerRadius = headImgV.height/2;
    headImgV.clipsToBounds = YES;
    headImgV.image = [UIImage imageNamed:@"myimage"];
//    [view addSubview:headImgV];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 0, 0)];
    titleLab.font = [UIFont boldSystemFontOfSize:16];
    titleLab.text = @"手机用户4456";
    titleLab.textColor = [UIColor whiteColor];
//    [view addSubview:titleLab];
    
    UIView *view = [UIView gainVerAutoView:@[headImgV,titleLab] viewX:0 viewY:0 align:FDLayout_center];
    
    return view;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView pullUpscrollViewDidScroll:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self navScrollViewWillBeginDragging:scrollView];
//    sPos = scrollView.contentOffset.y;
    
    [scrollView pullUpScrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self navScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
//    ePos = scrollView.contentOffset.y;
//    if(ePos>0)
//        return;
//    if(ePos<sPos)       //下拉
//    {
//        [scrollView displayTopViewWithAnimate:YES];
//    }
//    else                //上提
//    {
//        [scrollView undisplayTopViewWithAnimate:YES];
//    }
    
//    [scrollView pullUpScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self navScrollViewDidEndDecelerating:scrollView];
    
//    [scrollView pullUpScrollViewDidEndDecelerating:scrollView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    cell.textLabel.text = [NSString stringWithFormat:@"num-%zi",indexPath.row];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

@end
