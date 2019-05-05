//
//  TestMakeController.m
//  MyProject
//
//  Created by anker on 2018/12/7.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import "TestMakeController.h"

@interface TestMakeController ()

@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@end

@implementation TestMakeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _containView.height = _containView.height+10;
}

@end
