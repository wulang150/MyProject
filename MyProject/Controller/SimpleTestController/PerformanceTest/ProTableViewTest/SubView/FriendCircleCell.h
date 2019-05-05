//
//  FriendCircleCell.h
//  ProTableViewTest
//
//  Created by  Tmac on 2018/4/4.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendMode.h"

@interface FriendCircleCell : UITableViewCell

@property(nonatomic) FriendMode *model;

+ (CGFloat)gainHeight:(FriendMode *)model;
@end
