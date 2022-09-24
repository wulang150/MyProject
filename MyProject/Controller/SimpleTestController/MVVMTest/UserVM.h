//
//  UserVM.h
//  MyProject
//
//  Created by anker_alex on 2022/4/27.
//  Copyright © 2022 Tmac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserVM : NSObject

@property(nonatomic) NSString *username;
@property(nonatomic) NSString *pwd;
@property(nonatomic) NSString *headUrl;
@property(nonatomic) RACCommand *loginCommand;
@end

NS_ASSUME_NONNULL_END
