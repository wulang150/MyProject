//
//  TestReactCocoVC.m
//  MyProject
//
//  Created by anker_alex on 2022/4/26.
//  Copyright © 2022 Tmac. All rights reserved.
//

#import "TestReactCocoVC.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface TestReactCocoVC ()
<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property(nonatomic) UITableView *tableView;
@property(nonatomic) NSArray *dataArr;
@end

@implementation TestReactCocoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ReactiveCocoa";
    
    self.dataArr = @[@"testSignal",@"testSubSignal",@"testCommand"];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
        make.edges.mas_equalTo(0);
    }];
}

- (void)testSignal{
//    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        NSLog(@"signal in");
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [NSThread sleepForTimeInterval:2];
//            [subscriber sendNext:@"1"];
//            [subscriber sendCompleted];
//        });
//
//        return nil;
//    }];
    
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"signal in");
        [NSThread sleepForTimeInterval:2];
        [subscriber sendNext:@"1"];
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            //只要信号取消订阅就会来这里
            //默认一个信号发送完毕就会取消订阅。只要订阅者在，就不会主动取消订阅
            //清空资源
            NSLog(@"disposableWithBlock");
        }];
    }] deliverOn:[RACScheduler scheduler]];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext>>%@ %@",x,[NSThread currentThread]);
    } completed:^{
        NSLog(@"completed");
    }];
}

- (void)testSubSignal{
    RACSubject *subSignal = [[RACSubject alloc] init];
    
    [subSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribeNext>>>%@",x);
    }];
    
    [subSignal sendNext:@"1"];
    [subSignal sendNext:@"2"];
    [subSignal sendNext:@"3"];
}

- (void)testCommand{
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"start"];
            return nil;
        }];
    }];
    
//    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
//        NSLog(@"result>>>%@",x);
//    }];
    
    RACSignal *signal =  [command execute:@"输入命令！"] ;
    [signal subscribeNext:^(id  _Nullable x) {

        NSLog(@"%@",x);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [self.dataArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *title = [self.dataArr objectAtIndex:indexPath.row];
    [self performSelector:NSSelectorFromString(title)];
}

@end
