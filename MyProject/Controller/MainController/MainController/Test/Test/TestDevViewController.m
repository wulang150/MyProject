//
//  TestDevViewController.m
//  MyProject
//
//  Created by anker on 2018/12/10.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "TestDevViewController.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"

#import "ATVDevManager.h"

// udp接收广播端口
#define kUdpSocketPort 12345

@interface TestDevViewController ()
<UITableViewDelegate,UITableViewDataSource,GCDAsyncUdpSocketDelegate>
{
    
}
@property(nonatomic) UIView *headView;
@property(nonatomic) UITableView *tableView;
@property(nonatomic) GCDAsyncUdpSocket *udpSocket;
@end

@implementation TestDevViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createView];
}

- (void)createView
{
    [self setNavWithTitle:@"外设" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_HEIGHT, 60)];
    
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    scanBtn.frame = CGRectMake(20, 0, 100, 40);
    scanBtn.centerY = _headView.height/2;
    [scanBtn setTitle:@"扫描" forState:UIControlStateNormal];
    scanBtn.backgroundColor = [UIColor grayColor];
    [scanBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    scanBtn.tag = 10;
    [_headView addSubview:scanBtn];
    
    [self.view addSubview:_headView];
    [self.view addSubview:self.tableView];
    
//    DevManager *devManager = [[ATVDevManager alloc] init];
    DevManager *devManager = [[NSClassFromString(@"ATVDevManager") alloc] init];
    
    [devManager showName];
}

- (void)btnAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 10:
        {
            //扫描
            [self startScan];
            NSLog(@"start scan");
        }
            break;
            
        default:
            break;
    }
}

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-_headView.bottom)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _tableView;
}

- (GCDAsyncUdpSocket *)udpSocket
{
    if(!_udpSocket)
    {
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    return _udpSocket;
}

- (void)startScan
{
    // 恢复初始数据
//    [self initalize];
    
    NSError * error = nil;
    if (self.udpSocket.isConnected)
    {
        // 如果udp已经连接，则直接开始接收广播
        [self.udpSocket beginReceiving:&error];
    }
    else
    {
        // 如果udp未连接，则先绑定监听端口
        [self.udpSocket bindToPort:kUdpSocketPort error:&error];
        if (error)
        {
            NSLog(@"error:%@",error);
        }
        else
        {
            // 开始接收广播
            [self.udpSocket beginReceiving:&error];
        }
    }
}

#pragma -mark TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
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

#pragma -mark CCDUdpDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(nullable id)filterContext
{
    NSLog(@">>>>%@",data);
}

@end
