//
//  TestOpt1ViewController.m
//  MyProject
//
//  Created by Anker on 2019/6/27.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "TestOpt1ViewController.h"
#import "FDTextView.h"
#import "FDTextField.h"
#import "MyShowView.h"
#import <objc/runtime.h>

@interface StudentObj()
@property(nonatomic) NSString *city;
@end

@implementation StudentObj

@synthesize age = _age;
//添加了@synthesize修饰后，就相当了生成了名为_name的实例变量，并且生成了对应的setting与getting方法
@synthesize name = _name;

- (NSString *)age{
    self.city = @"111111";
    return _age;
}
@end


@interface Person()
{
    NSString *name1;
}

@end
@implementation Person

//- (NSString *)getName1{
//    return @"1111";
//}

- (NSString *)name1{
    return @"2222";
}

- (NSString *)isName1{
    return @"3333";
}

- (NSString *)_name1{
    return @"4444";
}

- (void)showName1{
    
}

+ (void)showName2{
    
}

@end

@interface TestOpt1ViewController ()

@end

@implementation TestOpt1ViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI{
    [self setNavWithTitle:@"test1" leftImage:@"arrow" leftTitle:nil leftAction:@selector(backAction) rightImage:nil rightTitle:nil rightAction:nil];
    
//    [self testAutoLayer];
    
//    [self testOther];
    
//    [self testFDTextView];
    
//    [self testFDTextField];
    
//    [self testProy];
    
//    [self testNotification];
    Person *person1 = [[Person alloc] init];
//    person1.name2 = @"xiao";
//
//    Person *person2 = [[Person alloc] init];
//    person2.name2 = @"wulang";
    
    NSString *val = [person1 valueForKey:@"name1"];
    NSLog(@"whidfdfdfdfdfdf>>%@",val);
    
    NSArray *ab = nil;
//    id dddd = objc_getClass(ab);
    if([ab isMemberOfClass:[NSArray class]]){
        NSLog(@"nil is NSArray");
    }else{
        NSLog(@"nil is not NSArray");
    }
    
    NSDictionary *dd = nil;
    if([dd isKindOfClass:[NSDictionary class]]){
        NSLog(@"nil is NSDictionary>>%@",dd[@"key"]);
    }else{
        NSLog(@"nil is not NSDictionary");
    }
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)notifyAction{
    NSLog(@"vc__notify");
}

- (void)testNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyAction) name:@"myNotify" object:nil];
    
    MyShowView *showView = [[MyShowView alloc] init];
//    [showView show];
    [self.view addSubview:showView];
    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(120);
        make.center.mas_equalTo(0);
    }];
}

- (void)testProy{
    StudentObj *stu = [[StudentObj alloc] init];
    stu.name = @"xiaoming";
//    stu.age = @"18";
    stu.score = @"88";
    
    NSLog(@"student=%@, %@, %@, %@",stu.name,stu.age,stu.score,stu.city);

}

- (void)testFDTextView{
    FDTextView *textView = [[FDTextView alloc] initWithFrame:CGRectMake(40, 400, SCREEN_WIDTH-80, 44)];
//    FDTextView *textView = [[FDTextView alloc] init];
    textView.placeholder = @"placeholder";
    textView.MaxNum = 100;
    [textView isAutoUp:YES superView:nil];
    textView.layer.borderWidth = 1;
//    textView.isOneLine = YES;
    textView.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:textView];
//    textView.isMask = NO;
    [textView startAdjustWithMX:0 MY:220];
    
//    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(400);
//        make.centerX.mas_equalTo(0);
//        make.width.equalTo(self.view).multipliedBy(0.65);
//        make.height.mas_equalTo(44);
//    }];
}

- (void)testFDTextField{
    FDTextField *textField = [[FDTextField alloc] init];
    textField.placeholder = @"eeeee";
    [textField isAutoUp:YES superView:nil];
    textField.layer.borderWidth = 1;
    [self.view addSubview:textField];
    textField.maxNum = 10;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(500);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(46);
        make.centerX.mas_equalTo(0);
    }];
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
    
//    NSInteger num = 20;
//    while (num--) {
//        [self testLock2:num];
//        [NSThread sleepForTimeInterval:0.5];
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"myNotify" object:nil];
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
