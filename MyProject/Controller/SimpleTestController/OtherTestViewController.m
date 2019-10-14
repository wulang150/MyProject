//
//  OtherTestViewController.m
//  MyProject
//
//  Created by Anker on 2019/8/27.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "OtherTestViewController.h"

@implementation WaterObj

- (void)setName:(NSString *)name{
    _name = name;
    NSLog(@"watername is:%@",name);
}

@end

@interface OtherTestViewController ()
{
    
}
@property(nonatomic) UISlider *slider;
@end

@implementation OtherTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    
    NSInteger val = 1566940933730;
    NSLog(@">>>>>>>>%zi",val);
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavWithTitle:@"Test" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    //kvc操作也是会走setting方法的
    WaterObj *water = [[WaterObj alloc] init];
    [water setValue:@"eeee" forKey:@"name"];
    
//    self.slider=[[UISlider alloc] init];
//    [self.view addSubview:self.slider];
//    [self.slider setContinuous:YES];
//    [self.slider setMinimumTrackTintColor:[UIColor redColor]];
//    [self.slider setMaximumTrackTintColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.6]];
//    [self.slider setThumbImage:[UIImage imageNamed:@"icon_bracelet_sel"] forState:UIControlStateNormal];
//    [self.slider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
//
//    [self.slider addTarget:self action:@selector(sliderTouchCancel) forControlEvents:UIControlEventTouchCancel];
////    self.slider.enabled=NO;
//    [self.slider addTarget:self action:@selector(onProgChange) forControlEvents:UIControlEventTouchDown];
//    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.mas_equalTo(20);
//        make.trailing.mas_equalTo(-20);
//        make.centerY.mas_equalTo(120);
//        make.height.mas_equalTo(30);
//    }];
    
    [self testStackView];
}

- (void)testStackView{
    UIStackView *stackView = [UIStackView new];
    stackView.backgroundColor = [UIColor lightGrayColor];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    [self.view addSubview:stackView];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).multipliedBy(0.85);
//        make.height.mas_equalTo(100);
        make.center.mas_equalTo(0);
    }];
    
    UIView *view1 = [UIView new];
    view1.backgroundColor = [UIColor redColor];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    [stackView addArrangedSubview:view1];
    
    UIView *view2 = [UIView new];
    view2.backgroundColor = [UIColor yellowColor];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    [stackView addArrangedSubview:view2];
    
    UIView *view3 = [UIView new];
    view3.backgroundColor = [UIColor redColor];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(70);
    }];
    [stackView addArrangedSubview:view3];
    
    UILabel *titleLab = [UILabel new];
    titleLab.text = @"sfdsfsdfsdfdsf";
    titleLab.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(stackView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
    }];
}

-(void)sliderValueChange{
    NSLog(@">>>>>>>>>>%.1f",self.slider.value);
}

-(void)sliderTouchCancel{
    
}

-(void)onProgChange{

//    self.slider.continuous=NO;
}

@end
