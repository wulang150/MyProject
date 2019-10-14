//
//  TmpTestViewController.m
//  MyProject
//
//  Created by Anker on 2019/3/26.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "TmpTestViewController.h"
#import "moviePlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TmpTestViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *itemsArr;
}
@property(nonatomic) UITableView *tableView;
@end

@implementation TmpTestViewController

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
}

- (void)setupData{
    itemsArr = @[@"FireBase", @"testOpt1", @"AVPlayer",@"moviePlayerController",@"ZFPlayer",@"TcpServer",@"TcpClient",@"新测试",@"视频转换",@"大图片"];
}
- (void)setupUI{
    
    [self setNavWithTitle:@"测试" leftImage:nil leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    [self.view addSubview:self.tableView];
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
            [[UIApplication sharedApplication] popOrPushToContrl:@"FireBaseViewController"];
        }
            break;
        case 1:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"TestOpt1ViewController"];
        }
            break;
        case 2:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"AVPlayerTestViewController"];
        }
            break;
        case 3:
        {
            NSString *_documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
            _documentsDirectory = [NSString stringWithFormat:@"%@/movieH264.mp4",_documentsDirectory];
            AVPlayer *player = [[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:_documentsDirectory]];
            moviePlayerViewController *playerVC = [moviePlayerViewController new];
            playerVC.player = player;
            [self.navigationController pushViewController:playerVC animated:YES];
        }
            break;
        case 4:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"ZFPlayerViewController"];
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
