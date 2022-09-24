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
    itemsArr = @[@"tableView的优化", @"离屏渲染", @"图片解码",@"算法",@"udp",@"TcpServer",@"TcpClient",@"新测试",@"视频转换",@"大图片",@"otherTest",@"FaceID",@"layout",@"collection",@"YYKit",@"ReactiveCocoa",@"MVVM",@"TestMason"];
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
    }
    cell.textLabel.text = [itemsArr objectAtIndex:indexPath.row];
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
            [[UIApplication sharedApplication] popOrPushToContrl:@"OffRenderViewController1"];
        }
            break;
        case 2:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"DecodedImageViewController"];
        }
            break;
        case 3:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"AlgorithmViewController"];
            
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
        case 10:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"OtherTestViewController"];
        }
            break;
        case 11:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"runLoopController"];
        }
            break;
        case 12:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"LayoutTestViewController"];
        }
            break;
        case 13:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"CollectionViewController"];
        }
            break;
        case 14:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"YYKitTestViewController"];
        }
            break;
        case 15:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"TestReactCocoVC"];
        }
            break;
        case 16:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"ReactiveLogin"];
        }
            break;
        case 17:
        {
            [[UIApplication sharedApplication] popOrPushToContrl:@"TestMasoryVC"];
        }
            break;
            
        default:
            break;
    }
    
}

//int findQuick(int *a,int s,int e,int f){
//    if(s<e){
//        return -1;
//    }
//    int mid = s+(e-s)/2;
//    if(a[mid]==f){
//        return mid;
//    }
//    if(f>a[mid]){
//        findQuick(a, mid+1, e,f);
//    }
//    if(f<a[mid]){
//        findQuick(a, s, mid-1,f);
//    }
//    return -1;
//}
//
//int findQuick1(int *a,int s,int e,int f){
//    while (s<e) {
//        int mid = s+(e-s)/2;
//        if(a[mid]==f){
//            return mid;
//        }
//        if(f>a[mid]){
//            s = mid+1;
//        }
//        if(f<a[mid]){
//            e = mid-1;
//        }
//    }
//    return -1;
//}
//
//int patitionSort(int *a,int s,int e){
//    int m = a[s];
//    while (s<e) {
//        while (s<e&&a[e]>=m) {
//            e--;
//        }
//        int t = a[s]; a[s] = a[e]; a[e] = t;
//        while (s<e&&a[s]<=m) {
//            s++;
//        }
//        t = a[s]; a[s] = a[e]; a[e] = t;
//    }
//    return s;
//}
//void quickSort(int *a,int s,int e){
//    
//    if(s<e){
//        int m = patitionSort(a, s,e);
//        quickSort(a, s,m-1);
//        quickSort(a, m+1, e);
//    }
//}
//
//void splitPartition(int *a,int s,int e){
//    if(s<e){
//        int m = s+(e-s)/2;
//        splitPartition(a, s,m-1);
//        splitPartition(a, m+1,e);
//        mergeSort(a, s, m, e);
//    }
//}
//
//void mergeSort(int *a,int s,int mid,int e){
//    int n = e-s+1,k=0,s1 = s,e1 = mid-1,s2 = mid+1,e2 = e;
//    int tArr[n];
//    while (1) {
//        if(a[s1]>a[s2]){
//            tArr[k++] = a[s2++];
//        }
//        if(a[s1]<=a[s2]){
//            tArr[k++] = a[s1++];
//        }
//        if(s1>e1){
//            while (s2<=e2) {
//                tArr[k++] = a[s2++];
//            }
//            break;
//        }
//        if(s2>e2){
//            while (s1<=e1) {
//                tArr[k++] = a[s1++];
//            }
//            break;
//        }
//    }
//    k = 0;
//    while (s<=e) {
//        a[s++] = tArr[k++];
//    }
//}
//
//void makeHeap(int *a,int n,int j){
//    int p = j;
//    int c = 2*p+1;
//    while (c<n) {
//        if(c+1<n&&a[c]<a[c+1]){
//            c++;
//        }
//        if(a[p]<a[c]){
//            int t = a[p];a[p] = a[c];a[c]=t;
//            p = c;
//            c = 2*p+1;
//        }else{
//            break;
//        }
//    }
//}
//
//void createHeap(int *a,int n){
//    for(int i=(n-1)/2;i>=0;i--){
//        makeHeap(a, n, i);
//    }
//}
//
//void heapSort(int *a,int n){
//    createHeap(a, n);
//    for(int i=n-1;i>=0;i--){
//        int t=a[i];a[i]=a[0];a[0]=t;
//        makeHeap(a, i, 0);
//    }
//}
//
//void selectQuick(int *a,int n){
//    for(int i=0;i<n-1;i++){
//        for(int j=i+1;j<n;j++){
//            if(a[i]>a[j]){
//                //交互
//            }
//        }
//    }
//}
//
//void boxQuick(int *a,int n){
//    for(int i=0;i<n-1;i++){
//        for(int j=0;j<n-i-1;j++){
//            if(a[j]>a[j+1]){
//                //交互
//            }
//        }
//    }
//}
@end
