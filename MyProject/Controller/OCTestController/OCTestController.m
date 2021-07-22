//
//		File Name:		OCTestController.m
//		Product Name:	MyProject
//		Author:			anker@Tmac
//		Created Date:	2021/5/19 10:12 AM
//		
// * Copyright © 2021 Anker Innovations Technology Limited All Rights Reserved.
// * The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
//		All rights reserved.
//'--------------------------------------------------------------------'
	

#import "OCTestController.h"

@interface OCTestController ()
<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property(nonatomic) UITableView *tableView;
@property(nonatomic) NSArray *dataArr;
@end

@implementation OCTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI{
    [self setNavWithTitle:@"test" leftImage:nil leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    self.dataArr = @[@"method"];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
        make.top.mas_equalTo(NavigationBar_HEIGHT);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [self.dataArr objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"RunTimeViewController"];
        }
            break;
            
        default:
            break;
    }
}

@end
