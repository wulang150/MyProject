//
//  FriendLayout.h
//  ProTableViewTest
//
//  Created by  Tmac on 2018/4/4.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendMode.h"

@interface FriendLayout : NSObject

@property(nonatomic) FriendMode *model;
@property(nonatomic) YYTextLayout *contentLayout;               //内容的layout
@property(nonatomic,strong)NSMutableArray * commentLayoutArr;   //评论的layout
@property(nonatomic,assign)CGFloat commentHeight;               //评论的高度

@property(nonatomic,assign)CGFloat height;          //总的高度

- (id)initWithModel:(FriendMode *)model;
- (void)resetLayout;
@end
