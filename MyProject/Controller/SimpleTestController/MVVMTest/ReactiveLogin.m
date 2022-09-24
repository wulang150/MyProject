//
//  ReactiveLogin.m
//  MyProject
//
//  Created by anker_alex on 2022/4/27.
//  Copyright © 2022 Tmac. All rights reserved.
//

#import "ReactiveLogin.h"
#import "UserVM.h"

@interface ReactiveLogin ()
<UITextFieldDelegate>
{
    
}

@property(nonatomic) UIImageView *headImgV;
@property(nonatomic) UITextField *usernameTf;
@property(nonatomic) UITextField *pwdTf;
@property(nonatomic) UIButton *loginBtn;

@property(nonatomic) UserVM *userVM;
@end

@implementation ReactiveLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavWithTitle:@"Login" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    [self setupUI];
    [self bindVM];
}

- (void)setupUI{
    [self.view addSubview:self.headImgV];
    [self.view addSubview:self.usernameTf];
    [self.view addSubview:self.pwdTf];
    [self.view addSubview:self.loginBtn];
    
    [self.headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(80);
    }];
    [self.usernameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImgV.mas_bottom).mas_offset(14);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(44);
    }];
    
    [self.pwdTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameTf.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(0);
        make.width.height.equalTo(self.usernameTf);
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwdTf.mas_bottom).mas_offset(14);
        make.centerX.mas_equalTo(0);
        make.width.height.equalTo(self.usernameTf);
    }];
}

- (void)bindVM{
    self.userVM = [[UserVM alloc] init];
    
    @weakify(self)
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"%@",x);
        UITextField *tf = (UITextField *)x[0];
        [tf resignFirstResponder];
    }];
    
    RAC(self.userVM,username) = self.usernameTf.rac_textSignal;
    RAC(self.userVM,pwd) = self.pwdTf.rac_textSignal;
    
    
    [[RACSignal combineLatest:@[self.usernameTf.rac_textSignal, self.pwdTf.rac_textSignal] reduce:^id _Nonnull(NSString *username, NSString *password){
        return @(username.length && password.length);
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"combineLatest>>>%@ %@",x,[NSThread currentThread]);
        BOOL enable = [x boolValue];
        self.loginBtn.enabled = enable;
        if(enable){
            [self.loginBtn setBackgroundColor:[UIColor greenColor]];
        }else{
            [self.loginBtn setBackgroundColor:[UIColor grayColor]];
        }
    }];
    
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.userVM.loginCommand execute:nil];
    }];
    [self.userVM.loginCommand.executing subscribeNext:^(NSNumber * _Nullable x) {
        BOOL ret = [x boolValue];
        ret?[PublicFunction showNoHiddenLoading:@""]:[PublicFunction hiddenHUD];
    }];
    
    [self.userVM.loginCommand.executionSignals subscribeNext:^(RACSignal  *x) {
        
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"login succ>>>%@",x);
        }];
        [x subscribeCompleted:^{
            NSLog(@"login completed");
        }];
        [x subscribeError:^(NSError * _Nullable error) {
            NSLog(@"login errors>>>%@",x);
        }];
        
//        [x subscribeNext:^(id  _Nullable x) {
//            NSLog(@"login succ>>>%@",x);
//        } completed:^{
//            NSLog(@"login completed");
//        }];
        
    }];
    [self.userVM.loginCommand.errors subscribeNext:^(NSError * _Nullable x) {
        NSLog(@"errors>>>%@",x);
    }];
//    [self.userVM.loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
//        NSLog(@"login succ>>>%@",x);
//    } error:^(NSError * _Nullable error) {
//        NSLog(@"login error>>>%@",error);
//    } completed:^{
//        NSLog(@"login completed");
//    }];
//    [self.userVM.loginCommand.executionSignals.switchToLatest subscribeError:^(NSError * _Nullable error) {
//        NSLog(@"login error>>>%@",error);
//    }];
    
    [RACObserve(self.userVM, headUrl) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
//        self.headImgV.image = [UIImage imageNamed:x];
        NSLog(@"headUrl>>>%@",x);
        self.headImgV.backgroundColor = [UIColor redColor];
        if([x isEqualToString:@"blue"]){
            self.headImgV.backgroundColor = [UIColor blueColor];
        }
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self getUserInfo];
}

//使用reactObj实现
- (void)getUserInfo{
    [PublicFunction showNoHiddenLoading:@""];
    //signal 1
    
    [[[[self creatFetchData1Signal] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return [self creatFetchData2Signal:value];
    }]flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return [self creatFetchData3Signal:value];
    }]subscribeNext:^(id  _Nullable x) {
        NSLog(@"ret==%@",x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"error");
        [PublicFunction hiddenHUD];
    } completed:^{
        NSLog(@"completed");
        [PublicFunction hiddenHUD];
    }];
    
    
    
}

- (RACSignal *)creatFetchData1Signal{
    NSLog(@"start fetchData1");
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self fetchData1:^(BOOL ret, NSString *userid) {
            if(ret){
                [subscriber sendNext:userid];
            }else{
                [subscriber sendError:nil];
            }
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (RACSignal *)creatFetchData2Signal:(NSString *)userid{
    NSLog(@"start fetchData2 param>>>>%@",userid);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self fetchData2:userid callBack:^(BOOL ret, NSString *userid) {
            if(ret){
                [subscriber sendNext:userid];
            }else{
                [subscriber sendError:nil];
            }
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (RACSignal *)creatFetchData3Signal:(NSString *)userid{
    NSLog(@"start fetchData3 param>>>>%@",userid);
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self fetchData3:userid callBack:^(BOOL ret) {
            if(ret){
                [subscriber sendNext:@(ret)];
            }else{
                [subscriber sendError:nil];
            }
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

//接口1
- (void)fetchData1:(void(^)(BOOL ret, NSString *userid))callBack{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:2];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(callBack) callBack(YES,@"65432");
        });
    });
}
//接口2依赖接口1返回的userid
- (void)fetchData2:(NSString *)userid callBack:(void(^)(BOOL ret,NSString *userid))callBack{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(callBack) callBack(YES,@"00000");
        });
    });
}

//接口3依赖接口2的结果
- (void)fetchData3:(NSString *)userid callBack:(void(^)(BOOL ret))callBack{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:2];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(callBack) callBack(NO);
        });
    });
}

#pragma -mark getting or setting

- (UIImageView *)headImgV{
    if(!_headImgV){
        _headImgV = [[UIImageView alloc] init];
        _headImgV.backgroundColor = [UIColor redColor];
    }
    return _headImgV;
}

- (UITextField *)usernameTf{
    if(!_usernameTf){
        _usernameTf = [[UITextField alloc] init];
        _usernameTf.layer.borderWidth = 1;
        _usernameTf.delegate = self;
    }
    return _usernameTf;
}

- (UITextField *)pwdTf{
    if(!_pwdTf){
        _pwdTf = [[UITextField alloc] init];
        _pwdTf.layer.borderWidth = 1;
        _pwdTf.delegate = self;
    }
    return _pwdTf;
}

- (UIButton *)loginBtn{
    if(!_loginBtn){
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setBackgroundColor:[UIColor greenColor]];
        [_loginBtn setTitle:@"login" forState:UIControlStateNormal];
    }
    return _loginBtn;
}

@end
