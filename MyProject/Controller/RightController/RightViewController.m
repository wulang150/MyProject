//
//  RightViewController.m
//  MyProject
//
//  Created by  Tmac on 2017/7/17.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "RightViewController.h"
#import "MJRefresh.h"

@interface RightViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic) UITableView *tableView;
@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavWithTitle:@"右边" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    [self.view addSubview:self.tableView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBar_HEIGHT)];
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
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    
    return cell;
}

@end
