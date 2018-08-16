//
//  LifeViewController.m
//  MyProject
//
//  Created by  Tmac on 2018/8/2.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "LifeViewController.h"
#import "RightViewController.h"

@interface LifeViewController ()

@end

@implementation LifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *testLab = [[UILabel alloc] init];
    testLab.text = @"生活界面";
    [testLab sizeToFit];
    testLab.center = self.view.center;
    [self.view addSubview:testLab];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(10, 100, 100, 30);
    btn.layer.borderWidth = 1;
    [btn setTintColor:[UIColor blackColor]];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnAction:(UIButton *)sender
{
    [self.navigationController pushViewController:[RightViewController new] animated:YES];
    
    //    [[[UIApplication sharedApplication] rootNavVC] pushViewController:[RightViewController new] animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
