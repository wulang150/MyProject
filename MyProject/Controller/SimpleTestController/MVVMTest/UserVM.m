//
//  UserVM.m
//  MyProject
//
//  Created by anker_alex on 2022/4/27.
//  Copyright © 2022 Tmac. All rights reserved.
//

#import "UserVM.h"

@interface UserVM()
{
    BOOL _result;
}
@property(nonatomic) RACSubject *loginSignal;
@end

@implementation UserVM

- (instancetype)init{
    if(self = [super init]){
        [self initParams];
    }
    return self;
}

- (void)initParams{
    self.headUrl = @"red";
//    self.loginSignal = [[RACSubject alloc] init];
//    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//
//        [self loginWithUsername:self.username pwd:self.pwd callback:^(BOOL ret) {
//            if(ret){
//                [self.loginSignal sendNext:@"YES"];
//            }else{
//                [self.loginSignal sendError:nil];
//            }
//            [self.loginSignal sendCompleted];
//        }];
//        return self.loginSignal;
//    }];
    
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"in RACCommand block");
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [self loginWithUsername:self.username pwd:self.pwd callback:^(BOOL ret) {
                if(ret){
                    [subscriber sendNext:@"YES"];
                }else{
                    [subscriber sendError:nil];
                }
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }];
}

//login
- (void)loginWithUsername:(NSString *)username pwd:(NSString *)pwd callback:(void(^)(BOOL ret))callback{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"start login>>%@,%@",username,pwd);
        [NSThread sleepForTimeInterval:2];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _headUrl = @"blue";
            _result = !_result;
            if(callback) callback(_result);
        });
    });
}
@end
