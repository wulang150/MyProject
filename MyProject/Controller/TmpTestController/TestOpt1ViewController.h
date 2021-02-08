//
//  TestOpt1ViewController.h
//  MyProject
//
//  Created by Anker on 2019/6/27.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol commondMsg <NSObject>
//协议中的属性，相当于只有对应的getter和setter方法，而不是属性
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *age;

@end

@interface StudentObj : NSObject<commondMsg>

@property(nonatomic) NSString *score;
@property(nonatomic,readonly) NSString *city;
@end

@interface TestOpt1ViewController : BaseController

@end

NS_ASSUME_NONNULL_END
