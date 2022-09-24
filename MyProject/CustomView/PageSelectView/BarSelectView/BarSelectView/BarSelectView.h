//
//  BarSelectView.h
//  MyProject
//
//  Created by  Tmac on 2018/8/6.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarSelectItem.h"

@class BarSelectView;

@protocol BarSelectViewDelegate <NSObject>

- (void)barSelectView:(BarSelectView *)barView didSelectedItem:(BarSelectItem *)item;
@end

@interface BarSelectView : UIView

@property(nonatomic) NSArray *dataArr;
@property(nonatomic) UIColor *titleColor;
@property(nonatomic) UIColor *titleSelectColor;
@property(nonatomic) CGFloat bottomLineH;       //默认为0
@property(nonatomic) UIColor *bottomLineColor;
//分割的line
@property(nonatomic) UIColor *gapLineColor;
@property(nonatomic) CGFloat gapLineW;
@property(nonatomic) CGFloat gapLineH;

@property(nonatomic,weak) id<BarSelectViewDelegate> delegate;

- (void)selectedTabItem:(NSUInteger)index animated:(BOOL)animated;

//创建attri字符串
+ (NSAttributedString *)gainAttributedString:(NSString *)str color:(UIColor *)color font:(UIFont *)font;
@end
