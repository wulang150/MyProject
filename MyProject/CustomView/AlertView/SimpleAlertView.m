//
//  SimpleAlertView.m
//  Runner
//
//  Created by  Tmac on 16/2/29.
//  Copyright © 2016年 Janson. All rights reserved.
//

#import "SimpleAlertView.h"

@interface SimpleAlertView()
{
    NSString *alertTitle;
    NSString *alertContent;
    UIView *vi;
    NSArray *btnTitle;
    CGRect frame;
}
@end

@implementation SimpleAlertView

- (void)dealloc
{

}

- (id)initAlertView:(NSString *)title content:(NSString *)content vi:(UIView *)_vi btnTilte:(NSArray *)_btnTitle
{
    if(self=[super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)])
    {
        alertTitle = title;
        alertContent = content;
        vi = _vi;
        btnTitle = _btnTitle;
    }
    return self;
}


- (UIView *)commondView
{
    int width = (self.alertW==0?280:self.alertW);    //弹出框的宽度
    int headHeight = 50,bottomHeight = 60;
    if(alertTitle==nil)
    {
        headHeight = 15;    //没有标题
    }
    //中部
    UILabel *centerView = [[UILabel alloc] initWithFrame:CGRectMake(0, headHeight, width, 40)];
    centerView.textAlignment = NSTextAlignmentCenter;
    centerView.text = alertContent;
    centerView.numberOfLines = 0;
    [centerView sizeToFit];
    CGRect iframe = centerView.frame;
    iframe.size.height = iframe.size.height + 40;
    iframe.size.width = width;
    iframe.origin.x = 0;
    iframe.origin.y = headHeight;
    centerView.frame = iframe;
    
    int Height = iframe.size.height+headHeight+bottomHeight;
    if(vi!=nil)
    {
        Height = vi.frame.size.height+vi.frame.origin.y + headHeight + bottomHeight+20;
        vi.frame = CGRectMake(vi.frame.origin.x, vi.frame.origin.y + headHeight, width, vi.frame.size.height);
    }
    frame = CGRectMake((SCREEN_WIDTH-width)/2, (SCREEN_HEIGHT-Height)/2, width, Height);
    
    //背景
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    [self addSubview:bgView];
    
    //弹出框背景
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 8;
    [self addSubview:view];
    self.mainView = view;
    if(vi==nil)
    {
        [view addSubview:centerView];   //没有加入view，就使用自定义的view
    }
    else
    {
        [view addSubview:vi];
    }
    
    if(alertTitle!=nil)
    {
        //头部
        UILabel *headLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width-20, headHeight)];
        headLab.text = alertTitle;
        headLab.font = [UIFont fontWithName:@"Arial" size:20];
        headLab.numberOfLines = 0;
        headLab.textAlignment = NSTextAlignmentCenter;
        [view addSubview:headLab];
        
        //下划线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headLab.frame)-1, frame.size.width, 1)];
        lineView.backgroundColor = ColorRGB(221, 221, 221);
        [view addSubview:lineView];
    }
    return view;
}

- (void)createViewWithTitle
{
    //上部
    UIView *view = [self commondView];
    //底部
    
    int wbtn = (frame.size.width - 30)/2;
    int hbtn = 45;
    if(btnTitle==nil)
    {
        UIButton *cancleBtn = [self getBtn:CGRectMake(10, frame.size.height-60, wbtn, hbtn) title:@"取消" tag:1];
        UIButton *okBtn = [self getBtn:CGRectMake(CGRectGetMaxX(cancleBtn.frame)+10, CGRectGetMinY(cancleBtn.frame), wbtn, hbtn) title:@"确定" tag:2];
        [view addSubview:cancleBtn];
        [view addSubview:okBtn];
    }
    else
    {
        if(btnTitle.count==2)
        {
            UIButton *cancleBtn = [self getBtn:CGRectMake(10, frame.size.height-60, wbtn, hbtn) title:[btnTitle objectAtIndex:0] tag:1];
            UIButton *okBtn = [self getBtn:CGRectMake(CGRectGetMaxX(cancleBtn.frame)+10, CGRectGetMinY(cancleBtn.frame), wbtn, hbtn) title:[btnTitle objectAtIndex:1] tag:2];
            [view addSubview:cancleBtn];
            [view addSubview:okBtn];
        }
        else
        {
            wbtn = frame.size.width-40;
            UIButton *okBtn = [self getBtn:CGRectMake(20, frame.size.height-60, wbtn, hbtn) title:[btnTitle objectAtIndex:0] tag:2];
            [view addSubview:okBtn];
            
        }
    }
    
    
}

- (UIButton *)getBtn:(CGRect)_frame title:(NSString *)title tag:(int)tag
{
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame = _frame;
    [btn1 setTitle:title forState:UIControlStateNormal];
    btn1.layer.cornerRadius = 7.0;
    btn1.tag = tag;
    btn1.backgroundColor = ColorRGB(236, 236, 236);
    [btn1 setTintColor:[UIColor blackColor]];
    [btn1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn1;
}

- (void)buttonPressed:(UIButton *)sender
{
    if(self.callBack)
        self.callBack(@"",(int)sender.tag);
    [self removeFromSuperview];
}



- (void)show
{
    //创建view
//    [self createViewWitxhTitle];
    
    // 当前顶层窗口
//    UIWindow *window = [UIApplication sharedApplication].keyWindow ;
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [window addSubview:self];
    
//    [self showAlertAnimation];
    
}


-(void)showAlertAnimation
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.30;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.mainView.layer addAnimation:animation forKey:nil];
}

#pragma -mark keyboard notification

- (void)keyboardDidAppear:(NSNotification *)notification
{
 
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    
    NSDictionary *useInfo = [notification userInfo];
    NSValue *aValue = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    //获取键盘的y轴距离
    float yheight = ([UIScreen mainScreen].bounds.size.height) - keyboardRect.size.height;
    //获取输入控件的y轴距离
    CGRect rect=[self convertRect:self.bounds toView:window];
    float theight = rect.origin.y+rect.size.height;
    if(theight>yheight)
    {
        [UIView beginAnimations:nil context:nil];
        CGRect iframe = self.mainView.frame;
        iframe.origin.y = iframe.origin.y - (theight-yheight>0?theight-yheight+2:0);
        self.mainView.frame = iframe;
        [UIView setAnimationDuration:0.35];
        [UIView commitAnimations];
    }
}

- (void)drawRect:(CGRect)rect{
    [self draw3:rect];
}

- (void)draw2:(CGRect)rect{
    CGContextRef context=UIGraphicsGetCurrentContext ();
    
    
    CGContextDrawPath (context,kCGPathStroke );
    
    
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(M_PI/4));
    
    
    NSString *title = @"我的小狗";
    
    
    UIFont *font = [UIFont systemFontOfSize:28];
    
    
    NSDictionary *attr = @{NSFontAttributeName:font,NSForegroundColorAttributeName: UIColor.whiteColor};

    CGSize size = [title sizeWithAttributes:attr];
    
    
    //水平居中时x轴坐标
    
    
    CGFloat xpos = [[UIScreen mainScreen] bounds].size.width / 2 - size.width / 2;
    
    CGFloat x = xpos / cos(M_PI/4);
    //绘制字符串
    
    
    [title drawAtPoint:CGPointMake(100, 20) withAttributes:attr];
}

- (void)draw1:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    //    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //
    //    // Create the gradient
    //    CGColorRef startColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor;
    //    CGColorRef endColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0].CGColor;
    //    NSArray *colors = [NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];
    //    CGFloat locations[] = { 0.0, 1.0 };
    //    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
    //    CGContextDrawLinearGradient(context, gradient, CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y), CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height), 0);
    
    // Create text
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    NSString *string = @"some test string";
    UIFont *font = [UIFont systemFontOfSize:16.0];
    
    // Rotate the context 90 degrees (convert to radians)
//    CGAffineTransform transform1 = CGAffineTransformMakeRotation(-M_PI_2);
//    CGContextConcatCTM(context, transform1);
    CGContextTranslateCTM(context, +(120 * 0.5), +(32 * 0.5));
    CGContextRotateCTM(context, M_PI_2);
    
    // Move the context back into the view
//    CGContextTranslateCTM(context, -rect.size.height, 0);
    
    NSDictionary *attr = @{NSFontAttributeName:font,NSForegroundColorAttributeName: UIColor.whiteColor};
    
    // Draw the string
//    [string drawInRect:CGRectMake(10, 10, 100, 32) withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
    [string drawAtPoint:CGPointMake(100, 100) withAttributes:attr];
    
    // Clean up
    //    CGGradientRelease(gradient);
    //    CGColorSpaceRelease(colorSpace);
    
    CGContextRestoreGState(context);
}

- (void)draw3:(CGRect)rect{
    
    [UIImage imageWithSize:CGSizeMake(120, 32) drawBlock:^(CGContextRef  _Nonnull context) {
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
        NSString *string = @"some test string";
        UIFont *font = [UIFont systemFontOfSize:16.0];
        NSDictionary *attr = @{NSFontAttributeName:font,NSForegroundColorAttributeName: UIColor.whiteColor};
        [string drawAtPoint:CGPointMake(2, 2) withAttributes:attr];
    }];
}

@end
