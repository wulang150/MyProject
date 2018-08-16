//
//  BottomSelectView.h
//  MyProject
//
//  Created by  Tmac on 2017/7/11.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BottomSelectView;

@protocol BottomSelectViewDelegate <NSObject>
////图片数组
//- (NSArray *)BottomSelectViewImages:(BottomSelectView *)selectView;
////选中的图片数组
//- (NSArray *)BottomSelectViewSelectedImages:(BottomSelectView *)selectView;
////标题
//- (NSArray *)BottomSelectViewTitles:(BottomSelectView *)selectView;
////一共有多少项
//- (NSInteger)numOfItemInBottomSelectView:(BottomSelectView *)selectView;

//选中
- (void)didSelectedBottomSelectView:(BottomSelectView *)selectView index:(NSInteger)index selectedImage:(UIImageView *)selectedImage selectedTitle:(UILabel *)selectedTitle;
@end

@interface BottomSelectView : UIView
//下面两个值只是记录控件，方便后面修改，不需要传值
@property(nonatomic,readonly) NSArray *imageViewArr;        //图片控件数组
@property(nonatomic,readonly) NSArray *titleViewArr;        //标题控件数组

//titles是属性字符串数组
- (id)initWithFrame:(CGRect)frame images:(NSArray *)images selectedImages:(NSArray *)selectedImages
             titles:(NSArray *)titles titleColor:(UIColor *)titleColor titleSelectedColor:(UIColor *)titleSelectedColor;

- (void)updateView;
//设置选中
- (void)setSelectedIndex:(NSInteger)index;
//在第几个item上设置badgeValue
- (void)setBadgeValue:(NSInteger)val index:(NSInteger)index;

@property(nonatomic) NSInteger colOfline;       //一行有多少项，一般需要分行的才需要配置这个参数
@property(nonatomic,weak) id<BottomSelectViewDelegate> delegate;
@property(nonatomic) CGFloat imgW;
@property(nonatomic) CGFloat imgH;
@property(nonatomic) CGFloat gapPadding;       //图片和文字的间隙
@end
