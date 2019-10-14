//
//  TestOpt1ViewController.m
//  MyProject
//
//  Created by Anker on 2019/6/27.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "TestOpt1ViewController.h"

@interface TestOpt1ViewController ()

@end

@implementation TestOpt1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI{
    [self setNavWithTitle:@"test1" leftImage:@"arrow" leftTitle:nil leftAction:@selector(backAction) rightImage:nil rightTitle:nil rightAction:nil];
    
//    [self testAutoLayer];
    
    [self testOther];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)testOther{
    NSMutableArray *mulArr = [NSMutableArray new];
    for(int i = 0;i<41;i++){
        [mulArr addObject:@(i)];
    }
    
    NSArray *arr = [mulArr subarrayWithRange:NSMakeRange(mulArr.count-40, 40)];
    NSLog(@"%@",arr);
}

- (void)testLock1{
    NSInteger num = 30;
    while (num--) {
        @synchronized (self) {
            NSLog(@">>>>>>>>begin%zi",num);
//            [NSThread sleepForTimeInterval:1];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSLog(@">>>>>>>>thread begin%zi",num);
//                [NSThread sleepForTimeInterval:0.5];
                dispatch_async(dispatch_get_main_queue(), ^{
//                    @synchronized (self) {
//                        NSLog(@">>>>>>>>thread end%zi",num);
//                    }
                    NSLog(@">>>>>>>>thread end%zi",num);
                });
            });
            NSLog(@">>>>>>>>end%zi",num);
        }
        [NSThread sleepForTimeInterval:1];
    }
}

- (void)testLock2:(NSInteger)num{
    NSLog(@">>>>>>>>begin%zi",num);
    //            [NSThread sleepForTimeInterval:1];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@">>>>>>>>thread begin%zi",num);
        //                [NSThread sleepForTimeInterval:0.5];
        dispatch_async(dispatch_get_main_queue(), ^{
            //                    @synchronized (self) {
            //                        NSLog(@">>>>>>>>thread end%zi",num);
            //                    }
            NSLog(@">>>>>>>>thread end%zi",num);
        });
    });
    NSLog(@">>>>>>>>end%zi",num);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self testLock1];
    
    NSInteger num = 20;
    while (num--) {
        [self testLock2:num];
        [NSThread sleepForTimeInterval:0.5];
    }
}

- (void)testAutoLayer{
    //这里是实现，父类随子类的变化而变化，父类完全包括子类的全部
    UIView *mainView = [[UIView alloc] init];
    mainView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:mainView];
    
    UIView *subView = [[UIView alloc] init];
    [mainView addSubview:subView];
    
    //顶部的
    UILabel *lab1 = [[UILabel alloc] init];
    lab1.text = @"sffdsfdfdfsdfsdfd";
    [mainView addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
    }];
    
    UIImageView *myImgV = [[UIImageView alloc] init];
    myImgV.backgroundColor = [UIColor redColor];
    [mainView addSubview:myImgV];
    [myImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(100);
        make.top.equalTo(lab1.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(0);
    }];
    
    //底部的
    UILabel *lab2 = [[UILabel alloc] init];
    lab2.text = @"kkkkkkkkkkkc,lllllllllll,kkkkkkkkkkkkkk";
    lab2.numberOfLines = 0;
    [mainView addSubview:lab2];
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myImgV.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(200);
        make.left.mas_equalTo(0);
    }];
    
    
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab1);
        make.left.equalTo(lab1);
        make.bottom.equalTo(lab2);
        make.right.equalTo(lab2);
    }];
    
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(200);
        make.centerX.mas_equalTo(0);
        make.width.height.equalTo(subView);
    }];
    
}

@end
