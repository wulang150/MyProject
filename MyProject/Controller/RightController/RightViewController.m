//
//  RightViewController.m
//  MyProject
//
//  Created by  Tmac on 2017/7/17.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "RightViewController.h"
#import "MJRefresh.h"
#import "SearchResultController.h"
#import "BarSelectView.h"
#import "BottomSelectView.h"

@interface RightViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataArr;
    NSMutableArray *resultArr;
}
@property(nonatomic) UITableView *tableView;
@property(nonatomic, strong) UISearchController *searchController;
@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"右边";
//    UIBarButtonItem *rightBtn1 = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
//    rightBtn1.tag = 10;
//    UIBarButtonItem *rightBtn2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_life_sel"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnAction:)];
//    rightBtn2.tag = 11;
//    self.navigationItem.rightBarButtonItems = @[rightBtn2,rightBtn1];
//
//    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_life_sel"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnAction:)];
//    leftBtn.tag = 12;
//    self.navigationItem.leftBarButtonItem = leftBtn;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavWithTitle:@"右边" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:@"icon_life_sel" rightTitle:nil rightAction:@selector(rightBtnAction:)];
//    self.navigationController.hidesBarsOnSwipe = YES;
    
//    self.automaticallyAdjustsScrollViewInsets = NO;     //是否自动调整insets
//    dataArr = [NSMutableArray new];
//    resultArr = [NSMutableArray new];
//    for(int i=0;i<100;i++)
//    {
//        [dataArr addObject:[NSString stringWithFormat:@"item_%d",i]];
//    }
//    [self.view addSubview:self.tableView];
//
//    self.tableView.tableHeaderView = self.searchController.searchBar;
    
//    [self performSelector:@selector(doForChange) withObject:nil afterDelay:0.5];
    
    [self testBarView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
//    [self doForChange];
}

- (void)testBarView
{
    NSAttributedString *title1 = [BarSelectView gainAttributedString:@"10\n美食" color:nil font:[UIFont systemFontOfSize:18]];
    NSAttributedString *title2 = [BarSelectView gainAttributedString:@"20\n电影" color:nil font:[UIFont systemFontOfSize:18]];
    NSAttributedString *title3 = [BarSelectView gainAttributedString:@"0\n跑步机" color:nil font:[UIFont systemFontOfSize:18]];
    
    BarSelectView *barView = [[BarSelectView alloc] initWithFrame:CGRectMake(10, NavigationBar_HEIGHT+10, SCREEN_WIDTH-20, 40)];
    barView.bottomLineH = 1;
    barView.titleColor = [UIColor lightGrayColor];
    barView.titleSelectColor = [UIColor orangeColor];
    barView.gapLineH = 14;
    barView.dataArr = @[title1,title2,title3];
    [self.view addSubview:barView];
    
    NSArray *imageArr = @[[UIImage imageNamed:@"icon_bracelet"],[UIImage imageNamed:@"icon_life"],[UIImage imageNamed:@"icon_i"],[UIImage imageNamed:@"icon_bracelet"],[UIImage imageNamed:@"icon_bracelet"],[UIImage imageNamed:@"icon_life"],[UIImage imageNamed:@"icon_i"],[UIImage imageNamed:@"icon_bracelet"],[UIImage imageNamed:@"icon_bracelet"],[UIImage imageNamed:@"icon_life"],[UIImage imageNamed:@"icon_i"]];
//    NSArray *imageSelectArr = @[[UIImage imageNamed:@"icon_bracelet_sel"],[UIImage imageNamed:@"icon_life_sel"],[UIImage imageNamed:@"icon_i_sel"]];
    UIFont *font = [UIFont systemFontOfSize:12];

    NSArray *titleArr = @[[self makeStr:@"邀请好友" bottom:@"得8元红包"],[self makeStr:@"签到领礼包" bottom:@"1豆"],[self makeStr:@"优惠券" bottom:@"兑换优惠卷"],[self makeStr:@"红包" bottom:@"总额0元"],[self makeStr:@"邀请好友" bottom:@"得8元红包"],[self makeStr:@"邀请好友" bottom:@"得8元红包"],[self makeStr:@"邀请好友" bottom:@"得8元红包"],[self makeStr:@"邀请好友" bottom:@"得8元红包"],[@"帮助与客服" toAttributedStr:font color:[UIColor redColor]],[self makeStr:@"邀请好友" bottom:@"得8元红包"],[self makeStr:@"邀请好友" bottom:@"得8元红包"]];
    BottomSelectView *listView = [[BottomSelectView alloc] initWithFrame:CGRectMake(10, barView.bottom+20, SCREEN_WIDTH-20, 300) images:imageArr selectedImages:nil titles:titleArr titleColor:nil titleSelectedColor:nil];
    listView.colOfline = 4;
    listView.gapPadding = 6;
    [listView updateView];
    [self.view addSubview:listView];
    
    [listView setBadgeValue:1000 index:3];
}

- (NSAttributedString *)makeStr:(NSString *)top bottom:(NSString *)bottom
{
    return [CommonFun gainSimpleAttrStr:top valAttr:@[[UIFont systemFontOfSize:12],[UIColor blackColor]] unit:[NSString stringWithFormat:@"\n%@",bottom] unitAttr:@[[UIFont systemFontOfSize:12],[UIColor lightGrayColor]]];
}

- (void)doForChange
{
    //如果放到viewDidLoad里面，发现有些控件找不到，估计是没加载那么快，延迟一下后就有了
    UIView *backView = [_searchController.searchBar.subviews firstObject];
    UIView *textField = nil;
    for (UIView *tmp in backView.subviews) {
        
        if ([tmp isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            
            textField = (UIView *)tmp;
            break;
        }
    }
    // 找到这个textField, 就可以按UITextField类来设置了
    if (textField) {
        //继续遍历
        UILabel *titleLab;
        for(UIView *tmp in textField.subviews)
        {
            if ([tmp isKindOfClass:NSClassFromString(@"UISearchBarTextFieldLabel")]) {
                
                titleLab = (UILabel *)tmp;
                break;
            }
        }
        if(titleLab)
        {
            titleLab.textColor = [UIColor redColor];
        }
    }
}

- (UISearchController *)searchController
{
    if(!_searchController)
    {
        //搜索结果界面
        SearchResultController *resultVC = [SearchResultController new];
        resultVC.datas = [dataArr copy];
        //添加搜索栏
        _searchController = [[UISearchController alloc] initWithSearchResultsController:resultVC];
        _searchController.searchResultsUpdater = resultVC;
        _searchController.searchBar.delegate = resultVC;
        _searchController.dimsBackgroundDuringPresentation = YES;
        
        //改变searchBar的取消确定按钮的颜色
        //    _searchController.searchBar.tintColor = [UIColor redColor];
        //    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
        //
        //    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:@"souSuo"];
        
        //修改背景颜色
        _searchController.searchBar.barTintColor = [UIColor greenColor];
        //改变搜索中间的图标
        [_searchController.searchBar setImage:[UIImage imageNamed:@"icon_i_sel"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        // 修改偏移量
//        _searchController.searchBar.searchTextPositionAdjustment = UIOffsetMake(100, 0);
//        _searchController.searchBar.searchFieldBackgroundPositionAdjustment = UIOffsetMake(20, 0);
        
        //修改编辑框
//        _searchController.searchBar.showsCancelButton = YES;
        
        
        
        
        //取消按钮
//        UIButton *cancelButton = nil;
//        for (UIView *sub in backView.subviews) {
//
//            if ([sub isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
//
//                cancelButton = (UIButton*)sub;
//            }
//        }
//
//        if (cancelButton) {
//
//            [cancelButton setTitle:@"取1消" forState:UIControlStateNormal];
//        }
    }
    return _searchController;
}

- (void)rightBtnAction:(UIBarButtonItem *)sender
{
    switch (sender.tag) {
        case 10:
            NSLog(@">>>>设置");
            break;
        case 11:
            NSLog(@">>>>图片");
            break;
        case 12:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        default:
            break;
    }
}

- (void)updateOpt
{
    NSLog(@"updateOpt");
    
    [_tableView.mj_header endRefreshing];
}

- (void)endFoot
{
    NSLog(@"endFoot");
    
    [_tableView.mj_footer endRefreshing];
}

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            NSLog(@"MJRefreshNormalHeader");
            
            [self performSelector:@selector(updateOpt) withObject:nil afterDelay:4];
        }];
        
//        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            
//            NSLog(@"MJRefreshAutoNormalFooter");
//            
//            [self performSelector:@selector(endFoot) withObject:nil afterDelay:4];
//        }];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            NSLog(@"MJRefreshBackNormalFooter");
            
            [self performSelector:@selector(endFoot) withObject:nil afterDelay:4];
        }];
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (self.searchController.active) {
//
//        return resultArr.count ;
//    }
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
//    if (self.searchController.active ) {
//
//        cell.textLabel.text = [resultArr objectAtIndex:indexPath.row];
//    } else {
//
//        cell.textLabel.text = [dataArr objectAtIndex:indexPath.row];
//    }
    

    cell.textLabel.text = [dataArr objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UISearchResultsUpdating
//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//
//    NSString *inputStr = searchController.searchBar.text ;
//    if (resultArr.count > 0) {
//        [resultArr removeAllObjects];
//    }
//    for (NSString *str in dataArr) {
//
//        if ([str.lowercaseString rangeOfString:inputStr.lowercaseString].location != NSNotFound) {
//
//            [resultArr addObject:str];
//        }
//    }
//
//    [self.tableView reloadData];
//}

@end
