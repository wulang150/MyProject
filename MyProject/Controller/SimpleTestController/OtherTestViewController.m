//
//  OtherTestViewController.m
//  MyProject
//
//  Created by Anker on 2019/8/27.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "OtherTestViewController.h"
#import "IDCPlayItemSelectView.h"
//#import <dbMule/dbMuleManager.h>
#import "WeakTestModel.h"

#define SetKey(key,val) key = val

@implementation WaterSuper


@end

@implementation WaterObj

- (void)setName:(NSString *)name{
    _name = name;
    NSLog(@"watername is:%@",name);
}

@end

@interface OtherTestViewController ()
{
    dispatch_semaphore_t _semA;
    dispatch_semaphore_t _semB;
}
@property(nonatomic) IDCPlayItemSelectView *playItemSelectView;
@property(nonatomic) UISlider *slider;
@property(nonatomic,weak) NSString *tmpStr;
@property(nonatomic,weak) WeakTestModel *weakObj;
@property(nonatomic) WeakTestModel *testModel;
@end

@implementation OtherTestViewController

- (void)dealloc{
    NSLog(@"OtherTestViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    
    WaterObj *obj = [[WaterObj alloc] init];
//    [self testSettingName:obj.name val:@"1234"];
    SetKey(obj.name, @"2222");
    
}

- (void)testSettingName:(NSString *)key val:(NSString *)val{
    key = val;
}

- (void)testFirst{
    NSInteger val = 1566940933730;
    NSLog(@">>>>>>>>%zi",val);
//    __weak NSString *weakS;
//    {
//        NSString *aaaa = @"ddsfffffffffffffffffffff";
//        weakS = aaaa;
//        self.tmpStr = weakS;
//    }
//    NSLog(@"dffdf>>>>%@",weakS);
    {
        WeakTestModel *model = [[WeakTestModel alloc] init];
        self.weakObj = model;
    }
    
    self.testModel = [[WeakTestModel alloc] init];
    __weak SendBlock weakBlock;
    @autoreleasepool{
        int a = 10;
        SendBlock block = ^(int blockCode, UInt8 code, id  _Nullable result) {
            NSLog(@"show sendBlock>>>%p val=%d",&a,a);
        };
        self.testModel.block = block;
    }
    if(self.testModel.block)
        self.testModel.block(0,0,nil);
}

- (void)doForA{
    NSLog(@"start work A");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:2];
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_semaphore_signal(_semA);
        });
    });
}
- (void)doForB{
    NSLog(@"start work B");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:4];
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_semaphore_signal(_semB);
        });
    });
}

- (void)doForC{
    NSLog(@"start work C");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_wait(_semB, DISPATCH_TIME_FOREVER);
        NSLog(@"after B");
        dispatch_semaphore_wait(_semA, DISPATCH_TIME_FOREVER);
        NSLog(@"after A");
        
        NSLog(@"do for c");
    });
}

- (void)testSignal{
    _semA = dispatch_semaphore_create(0);
    _semB = dispatch_semaphore_create(0);
    
    [self doForA];
    [self doForB];
    [self doForC];
    
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavWithTitle:@"Test" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    //kvc操作也是会走setting方法的
//    WaterObj *water = [[WaterObj alloc] init];
//    [water setValue:@"eeee" forKey:@"name"];
    
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
    
//    [self testStackView];
    
//    [self testColl];
//    [self testdbMule];
//    [self testSerialQueue];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self testSerialQueue1];
//    });
    
//    [self testTimer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSLog(@"weak>>>%@",self.tmpStr);
//    [self.weakObj show];
    [self testSignal];
}

- (void)testTimer{
    __weak typeof(self) wself = self;
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:[YYWeakProxy proxyWithTarget:self] selector:@selector(timeAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)timeAction{
    NSLog(@"timeAction>>>>>action");
}

- (void)fetchNet:(NSString *)url time:(NSInteger)time block:(void(^)(NSString *name))block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:time];
        if(block) block(url);
    });
}

- (void)testSerialQueue1{
    dispatch_group_t group = dispatch_group_create();
    __block NSString *str = @"";
    dispatch_group_enter(group);
    NSLog(@"before fetch1");
    [self fetchNet:@"123" time:2 block:^(NSString *name) {
        NSLog(@"before fetch1 block");
        str = [NSString stringWithFormat:@"%@%@",str,name];
        dispatch_group_leave(group);
    }];
    
    NSLog(@"before fetch2");
    dispatch_group_enter(group);
    [self fetchNet:@"456" time:3 block:^(NSString *name) {
        NSLog(@"before fetch2 block");
        str = [NSString stringWithFormat:@"%@%@",str,name];
        dispatch_group_leave(group);
    }];
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"result>>>%@",str);
}

//测试串行队列里面是线程的同步处理问题
- (void)testSerialQueue{
    //队列里面的任务是异步的，可以通知信号量或者dispatch_group_enter转为同步
    //这里控制执行顺序为：group1>>>group2>>>group3
    dispatch_group_t group = dispatch_group_create();
//    dispatch_queue_t queue = dispatch_queue_create("com.dispatch.serial", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"group1");
    });
    
    NSLog(@">>>2");
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"group2");
    });
    NSLog(@">>>3");
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"group3");
    });
    
}

- (void)testdbMule{
//    dbMuleManager *obj = [[dbMuleManager alloc] init];
//    [obj show];
}

- (void)testColl{
//    self.playItemSelectView = [[IDCPlayItemSelectView alloc] init];
    self.playItemSelectView = [[IDCPlayItemSelectView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 44)];
//    self.playItemSelectView.delegate = self;
    [self.view addSubview:self.playItemSelectView];
//    [self.playItemSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(100);
//        make.leading.mas_equalTo(0);
//        make.trailing.mas_equalTo(0);
//        make.height.mas_equalTo(44);
//    }];
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
