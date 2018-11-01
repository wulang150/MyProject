//
//  ViewController.h
//  MyProject
//
//  Created by  Tmac on 2017/6/29.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Student : NSObject<NSCoding>

@property(nonatomic) NSString *score;
@end

@interface TestModel : NSObject<NSCoding>

@property(nonatomic) NSString *name;
@property(nonatomic) NSString *uid;

@property(nonatomic) NSArray *ScoreArr;
@end



@interface ViewController : BaseController


@end

