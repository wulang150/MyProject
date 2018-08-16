//
//  BarSelectItem.h
//  MyProject
//
//  Created by  Tmac on 2018/8/6.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarSelectItem : UIButton

@property(nonatomic) NSAttributedString *title;
@property(nonatomic) UIColor *titleColor;
@property(nonatomic) UIColor *titleSelectColor;
@property(nonatomic) CGFloat bottomLineH;       //默认为0
@property(nonatomic) UIColor *bottomLineColor;
@property(nonatomic,readonly) CGFloat titleLabH;

- (void)reloadView;

@property(nonatomic) void(^didSelectedItem)(BarSelectItem *item);

@end
