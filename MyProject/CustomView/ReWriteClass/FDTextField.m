//
//  FDTextField.m
//  MyProject
//
//  Created by Anker on 2019/10/16.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "FDTextField.h"

@interface FDTextField()
<UITextFieldDelegate>
{
    CGRect _superUpRect;
    CGFloat _maxKeyBoardHeight;
}
@property(nonatomic) UIView *bgView;
@property(nonatomic,weak) UIView *superUpView;
@end

@implementation FDTextField

- (void)dealloc{
    NSLog(@"FDTextField dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init{
    if(self = [super init]){
        [self createView];
    }
    return self;
}

- (void)createView{
    self.delegate = self;
    [self addTarget:self action:@selector(textFieldTextDidChange) forControlEvents:UIControlEventEditingChanged];
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.1;
    _bgView.hidden = YES;
    [window addSubview:_bgView];
    
    //点击事件
    UITapGestureRecognizer *singleTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTag)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [_bgView addGestureRecognizer:singleTap];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.mas_equalTo(0);
    }];
}


- (void)isAutoUp:(BOOL)isAutoUp superView:(UIView *)superView
{
    if(isAutoUp)
    {
        _superUpView = superView;
        _superUpRect = superView.frame;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
#pragma -mark Action
- (void)bgTag{
    [self resignFirstResponder];
}


#pragma -mark keyboard notification
- (void)willShow
{
    if(_maxKeyBoardHeight<=0)
        return;
    
    //获取键盘的y轴距离
    float yheight = ([UIScreen mainScreen].bounds.size.height) - _maxKeyBoardHeight;
    //获取输入控件的y轴距离
    UIView * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self convertRect:self.bounds toView:window];
    
    if(_superUpView)
        window = _superUpView;
    float theight = rect.origin.y+rect.size.height;
    if(theight>yheight)
    {
        [UIView beginAnimations:nil context:nil];
        CGRect frame = window.frame;
        frame.origin.y = frame.origin.y - (theight-yheight>0?theight-yheight+2:0);
        window.frame = frame;
        [UIView setAnimationDuration:0.05];
        [UIView commitAnimations];
    }
    
    _bgView.hidden = NO;
}

- (void)keyboardWillAppear:(NSNotification *)notification
{
    //FDLog(@"键盘即将弹出");
    if(!self.isFirstResponder)
    {
        return;
    }
    NSDictionary *useInfo = [notification userInfo];
    NSValue *aValue = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    if(_maxKeyBoardHeight<keyboardRect.size.height)
    {
        _maxKeyBoardHeight = keyboardRect.size.height;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //保证每次只执行一次
    [self performSelector:@selector(willShow) withObject:nil afterDelay:0.3];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    //FDLog(@"键盘即将消失");
    if(!self.isFirstResponder)
    {
        return;
    }
    [UIView beginAnimations:nil context:nil];
    UIView * window=[[[UIApplication sharedApplication] delegate] window];
    CGFloat autoY = 0;
    if(_superUpView)
    {
        window = _superUpView;
        autoY = _superUpRect.origin.y;
    }
    CGRect frame = window.frame;
    frame.origin.y = autoY;
    window.frame = frame;
    [UIView setAnimationDuration:0.35];
    [UIView commitAnimations];
    
    _bgView.hidden = YES;
}

#pragma -mark UITextFieldDelegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    NSLog(@"%s",__FUNCTION__);
//    return YES;
//}
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    NSLog(@"%s",__FUNCTION__);
//}
//
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    NSLog(@"%s",__FUNCTION__);
//    return YES;
//}
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    NSLog(@"%s",__FUNCTION__);
//}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSLog(@"(%zi,%zi)%@",range.location,range.length,string);
//    return YES;
//}

- (void)textFieldTextDidChange{
    NSLog(@"textFieldTextDidChange");
    NSString *nsTextContent = self.text;
    NSInteger existTextNum = nsTextContent.length;
    
    //对中文输入时候，高亮字符的处理
    if ([[[self textInputMode] primaryLanguage] isEqualToString:@"zh-Hans"]) {
        
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        //有高亮部分
        if(position)
            return;
    }
    //处理表情
    if(!self.isAllowEmotion&&existTextNum>1) //过滤掉表情
    {
        self.text = [nsTextContent newfilterEmoji];
    }
    //处理最大的个数
    if(_maxNum>0)
    {
        existTextNum = self.text.length;
        if (existTextNum > _maxNum)
        {
            NSString *tmpStr = [self.text substringToLength:_maxNum];
            [self setText:tmpStr];
        }
    }
}
@end
