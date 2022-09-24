//
//  TestMasoryVC.h
//  MyProject
//
//  Created by anker_alex on 2022/5/8.
//  Copyright © 2022 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MasonryMan : NSObject

- (void)show:(NSString *)str;
- (void(^)(NSString *))showMan;
@end

@interface TestMasoryVC : BaseController

@end

NS_ASSUME_NONNULL_END
