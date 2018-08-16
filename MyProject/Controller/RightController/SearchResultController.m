//
//  SearchResultController.m
//  MyProject
//
//  Created by  Tmac on 2018/8/3.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "SearchResultController.h"

@interface SearchResultController ()
<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *resultArr;
}
@property(nonatomic) UITableView *tableView;
@end

@implementation SearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    resultArr = [NSMutableArray new];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;   //取消tableView上部的空隙
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return resultArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    cell.textLabel.text = [resultArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *inputStr = searchController.searchBar.text;
    if (resultArr.count > 0) {
        [resultArr removeAllObjects];
    }
    for (NSString *str in self.datas) {
        
        if ([str.lowercaseString rangeOfString:inputStr.lowercaseString].location != NSNotFound) {
            
            [resultArr addObject:str];
        }
    }
    
    [self.tableView reloadData];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
   
}

@end
