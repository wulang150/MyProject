//
//  TestMasoryVC.m
//  MyProject
//
//  Created by anker_alex on 2022/5/8.
//  Copyright © 2022 Tmac. All rights reserved.
//

#import "TestMasoryVC.h"

typedef void(^FuncType)(NSString *str);

@implementation MasonryMan

- (void)show:(NSString *)str{
    NSLog(@"masonryMan>>>%@",str);
}

- (void(^)(NSString *))showMan{
    FuncType func = ^void(NSString *str){
        NSLog(@"masonryMan>>>%@",str);
    };
    return func;
//    return ^void(NSString *str){
//        NSLog(@"masonryMan>>>%@",str);
//    };
}

@end

@interface TestMasoryVC ()

@end

@implementation TestMasoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavWithTitle:@"Masory" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    MasonryMan *man = [[MasonryMan alloc] init];
    man.showMan(@"hello");
}

@end
