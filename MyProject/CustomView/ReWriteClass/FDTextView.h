//
//  FDTextView.h
//  SimpleTest
//
//  Created by  Tmac on 16/8/26.
//  Copyright © 2016年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FDTextView;

@protocol FDTextViewDelegate <NSObject, UIScrollViewDelegate>

@optional

- (BOOL)FDTextViewShouldBeginEditing:(FDTextView *_Nonnull)textView ;
- (BOOL)FDTextViewShouldEndEditing:(FDTextView *_Nonnull)textView;

- (void)FDTextViewDidBeginEditing:(FDTextView *_Nonnull)textView;
- (void)FDTextViewDidEndEditing:(FDTextView *_Nonnull)textView;

- (BOOL)FDTextView:(FDTextView *_Nonnull)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *_Nullable)text;
- (void)FDTextViewDidChange:(FDTextView *_Nonnull)textView;

//可输入的剩余字符数
- (void)FDTextView:(FDTextView *_Nonnull)textView maxNumLeave:(long)num;
@end

@interface FDTextView : UITextView

@property (nonatomic,strong) UILabel * _Nullable placeholderView;
@property (nonatomic,strong) NSString * _Nullable placeholder;
@property (nonatomic,weak) UIView * _Nullable parentView;
@property (nonatomic,assign) int MaxNum;                //最大限制字符数量
@property (nonatomic,assign) BOOL isOneLine;            //是否只有一行
@property (nonatomic,assign) BOOL isAllowEmotion;       //是否支持表情
@property (nonatomic,assign) BOOL isMask;               //是否有蒙版，不用蒙版的话，自己要注意控制键盘的消失
@property (nullable,nonatomic,weak) id<FDTextViewDelegate> FDdelegate;

//是否自动遮挡上移 superView：自动上移时候，移动的view，如果设置为空，默认是整个window上移
- (void)isAutoUp:(BOOL)isAutoUp superView:(UIView *_Nullable)superView;
//开启自适应大小模式 mx：最大的宽度 my：最大的高度 大于或等于最大，都不会再改变
//如果默认设置的宽度大于mx，那么宽度不变，高度随输入换行变高
- (void)startAdjustWithMX:(NSInteger)mx MY:(NSInteger)my;
- (void)endAdjust;
@end
