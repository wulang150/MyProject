//
//  SimpleViewController.m
//  MyProject
//
//  Created by anker on 2018/12/28.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "SimpleViewController.h"

@interface SimpleViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *itemsArr;
}
@property(nonatomic) UITableView *tableView;
@end

@implementation SimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    ShowFunMsg;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    ShowFunMsg;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    ShowFunMsg;
    BOOL isOut = YES;
    UINavigationController *navCtl = [[UIApplication sharedApplication] rootNavVC];
    if(navCtl){
        for(UIViewController *vc in navCtl.viewControllers){
            if([vc isKindOfClass:[SimpleViewController class]]){
                isOut = NO;
            }
        }
    }
    
    if(isOut){
        NSLog(@"SimpleViewController>>>>>>>>>>is Disappear");
    
    }
}

- (void)setupData{
    itemsArr = @[@"tableView的优化", @"离屏渲染", @"图片解码",@"YYKit",@"udp",@"TcpServer",@"TcpClient",@"新测试",@"视频转换",@"大图片"];
}
- (void)setupUI{
    
    [self setNavWithTitle:@"测试" leftImage:nil leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    [self.view addSubview:self.tableView];
    
//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(30, NavigationBar_HEIGHT+30, 100, 40)];
//    lab.layer.borderWidth = 1;
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        lab.text = @"sdfsdfdsfssssssssssssssssss";
//    });
//    [self.view addSubview:lab];
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_CTM_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return itemsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.text = [itemsArr objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"ProTableViewController"];
        }
            break;
        case 1:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"OffRenderViewController"];
        }
            break;
        case 2:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"DecodedImageViewController"];
        }
            break;
        case 3:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"YYKitTestViewController"];
        }
            break;
        case 4:
        {
//            [[UIApplication sharedApplication] popOrPushToContrl:@"UdpServerViewController"];
            SimpleAlertView *alert = [[SimpleAlertView alloc] initAlertView:@"tip" content:@"sdfdsfdsf" vi:nil btnTilte:nil];
            [alert show];
        }
            break;
        case 5:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"TcpServerViewController"];
        }
            break;
        case 6:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"TcpClientViewController"];
        }
            break;
        case 7:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"TestOneViewController"];
        }
            break;
        case 8:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"VideoConvertViewController"];
        }
            break;
        case 9:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"CAImageTestViewController"];
        }
            break;
            
        default:
            break;
    }
    
}
@end
