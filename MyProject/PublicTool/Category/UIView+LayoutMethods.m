//
//  UIView+LayoutMethods.m
//  UIViewDemo
//
//  Created by lianxingbo on 15/6/8.
//  Copyright (c) 2015年 daboge. All rights reserved.
//


#import "UIView+LayoutMethods.h"

@implementation UIView (LayoutMethods)

#pragma mark - setters and getters
- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setY:(CGFloat)y
{
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (CGSize)size
{
    return self.frame.size;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (CGFloat)bottom
{
    return self.frame.size.height + self.frame.origin.y;
}

- (CGFloat)right
{
    return self.frame.size.width + self.frame.origin.x;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    self.x = left;
}

- (void)setTop:(CGFloat)top
{
    self.y = top;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

// height
- (void)setHeight:(CGFloat)height
{
    CGRect newFrame = CGRectMake(self.x, self.y, self.width, height);
    self.frame = newFrame;
}

- (void)heightEqualToView:(UIView *)view
{
    self.height = view.height;
}

// width
- (void)setWidth:(CGFloat)width
{
    CGRect newFrame = CGRectMake(self.x, self.y, width, self.height);
    self.frame = newFrame;
}

- (void)widthEqualToView:(UIView *)view
{
    self.width = view.width;
}

// center
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = CGPointMake(self.centerX, self.centerY);
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = CGPointMake(self.centerX, self.centerY);
    center.y = centerY;
    self.center = center;
}

- (void)centerXEqualToView:(UIView *)view
{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewCenterPoint = [superView convertPoint:view.center toView:self.topSuperView];
    CGPoint centerPoint = [self.topSuperView convertPoint:viewCenterPoint toView:self.superview];
    self.centerX = centerPoint.x;
}

- (void)centerYEqualToView:(UIView *)view
{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewCenterPoint = [superView convertPoint:view.center toView:self.topSuperView];
    CGPoint centerPoint = [self.topSuperView convertPoint:viewCenterPoint toView:self.superview];
    self.centerY = centerPoint.y;
}

// top, bottom, left, right
- (void)top:(CGFloat)top FromView:(UIView *)view
{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.origin toView:self.topSuperView];
    CGPoint newOrigin = [self.topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.y = floorf(newOrigin.y + top + view.height);
}

- (void)bottom:(CGFloat)bottom FromView:(UIView *)view
{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.origin toView:self.topSuperView];
    CGPoint newOrigin = [self.topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.y = newOrigin.y - bottom - self.height;
}

- (void)left:(CGFloat)left FromView:(UIView *)view
{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.origin toView:self.topSuperView];
    CGPoint newOrigin = [self.topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.x = newOrigin.x - left - self.width;
}

- (void)right:(CGFloat)right FromView:(UIView *)view
{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.origin toView:self.topSuperView];
    CGPoint newOrigin = [self.topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.x = newOrigin.x + right + view.width;
}

- (void)topRatio:(CGFloat)top FromView:(UIView *)view screenType:(UIScreenType)screenType
{
    CGFloat topRatio = top / screenType;
    CGFloat topValue = topRatio * self.superview.width;
    [self top:topValue FromView:view];
}

- (void)bottomRatio:(CGFloat)bottom FromView:(UIView *)view screenType:(UIScreenType)screenType
{
    CGFloat bottomRatio = bottom / screenType;
    CGFloat bottomValue = bottomRatio * self.superview.width;
    [self bottom:bottomValue FromView:view];
}

- (void)leftRatio:(CGFloat)left FromView:(UIView *)view screenType:(UIScreenType)screenType
{
    CGFloat leftRatio = left / screenType;
    CGFloat leftValue = leftRatio * self.superview.width;
    [self left:leftValue FromView:view];
}

- (void)rightRatio:(CGFloat)right FromView:(UIView *)view screenType:(UIScreenType)screenType
{
    CGFloat rightRatio = right / screenType;
    CGFloat rightValue = rightRatio * self.superview.width;
    [self right:rightValue FromView:view];
}

- (void)topInContainer:(CGFloat)top shouldResize:(BOOL)shouldResize
{
    if (shouldResize) {
        self.height = self.y - top + self.height;
    }
    self.y = top;
}

- (void)bottomInContainer:(CGFloat)bottom shouldResize:(BOOL)shouldResize
{
    if (shouldResize) {
        self.height = self.superview.height - bottom - self.y;
    } else {
        self.y = self.superview.height - self.height - bottom;
    }
}

- (void)leftInContainer:(CGFloat)left shouldResize:(BOOL)shouldResize
{
    if (shouldResize) {
        self.width = self.x - left + self.superview.width;
    }
    self.x = left;
}

- (void)rightInContainer:(CGFloat)right shouldResize:(BOOL)shouldResize
{
    if (shouldResize) {
        self.width = self.superview.width - right - self.x;
    } else {
        self.x = self.superview.width - self.width - right;
    }
}

- (void)topRatioInContainer:(CGFloat)top shouldResize:(BOOL)shouldResize screenType:(UIScreenType)screenType
{
    CGFloat topRatio = top / screenType;
    CGFloat topValue = topRatio * self.superview.width;
    [self topInContainer:topValue shouldResize:shouldResize];
}

- (void)bottomRatioInContainer:(CGFloat)bottom shouldResize:(BOOL)shouldResize screenType:(UIScreenType)screenType
{
    CGFloat bottomRatio = bottom / screenType;
    CGFloat bottomValue = bottomRatio * self.superview.width;
    [self bottomInContainer:bottomValue shouldResize:shouldResize];
}

- (void)leftRatioInContainer:(CGFloat)left shouldResize:(BOOL)shouldResize screenType:(UIScreenType)screenType
{
    CGFloat leftRatio = left / screenType;
    CGFloat leftValue = leftRatio * self.superview.width;
    [self leftInContainer:leftValue shouldResize:shouldResize];
}

- (void)rightRatioInContainer:(CGFloat)right shouldResize:(BOOL)shouldResize screenType:(UIScreenType)screenType
{
    CGFloat rightRatio = right / screenType;
    CGFloat rightValue = rightRatio * self.superview.width;
    [self rightInContainer:rightValue shouldResize:shouldResize];
}

- (void)topEqualToView:(UIView *)view
{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.origin toView:self.topSuperView];
    CGPoint newOrigin = [self.topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.y = newOrigin.y;
}

- (void)bottomEqualToView:(UIView *)view
{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.origin toView:self.topSuperView];
    CGPoint newOrigin = [self.topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.y = newOrigin.y + view.height - self.height;
}

- (void)leftEqualToView:(UIView *)view
{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.origin toView:self.topSuperView];
    CGPoint newOrigin = [self.topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.x = newOrigin.x;
}

- (void)rightEqualToView:(UIView *)view
{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.origin toView:self.topSuperView];
    CGPoint newOrigin = [self.topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.x = newOrigin.x + view.width - self.width;
}

// size
- (void)setSize:(CGSize)size
{
    self.frame = CGRectMake(self.x, self.y, size.width, size.height);
}

- (void)sizeEqualToView:(UIView *)view
{
    self.frame = CGRectMake(self.x, self.y, view.width, view.height);
}

// imbueset
- (void)fillWidth
{
    self.width = self.superview.width;
}

- (void)fillHeight
{
    self.height = self.superview.height;
}

- (void)fill
{
    self.frame = CGRectMake(0, 0, self.superview.width, self.superview.height);
}

- (UIView *)topSuperView
{
    UIView *topSuperView = self.superview;
    
    if (topSuperView == nil) {
        topSuperView = self;
    } else {
        while (topSuperView.superview) {
            topSuperView = topSuperView.superview;
        }
    }
    
    return topSuperView;
}

+ (UIView *)gainVerAutoView:(NSArray *)subView viewX:(CGFloat)viewX viewY:(CGFloat)viewY align:(FDLayoutAlign)align
{
    CGFloat maxW = 0;
    UIView *preView = [[UIView alloc] initWithFrame:CGRectZero];
    UIView *mainview = [[UIView alloc] initWithFrame:CGRectZero];
    
    for(int i=0;i<subView.count;i++)
    {
        UIView *sview = [subView objectAtIndex:i];
        if([sview isKindOfClass:[UILabel class]])
        {
            UILabel *lab = (UILabel *)sview;
            CGFloat w = lab.frame.size.width;
            [lab sizeToFit];
            //如果是单行的，并且设置宽度比字体宽度小，那么就会通过控制字体大小来适应宽度
            if(lab.numberOfLines==1&&w>10&&w<lab.frame.size.width)
            {
                CGRect iframe = lab.frame;
                iframe.size.width = w;
                lab.frame = iframe;
                lab.adjustsFontSizeToFitWidth = YES;
            }
            
        }
        CGRect tframe = sview.frame;
        
        if(tframe.size.width>maxW)      //找到最大宽度
            maxW = tframe.size.width;
        
        tframe.origin.x = 0;
        if(i==0)
            tframe.origin.y = 0;
        if(tframe.size.height<=0)
            tframe.origin.y = 0;
        tframe.origin.y = CGRectGetMaxY(preView.frame)+tframe.origin.y; //调整每一个的y值
        sview.frame = tframe;
        preView = sview;
        [mainview addSubview:sview];
    }
    
    mainview.frame = CGRectMake(viewX, viewY, maxW, CGRectGetMaxY(preView.frame));
    if(align==FDLayout_center)    //居中对齐
    {
        //横向每个字控件都居中
        for(int i=0;i<subView.count;i++)
        {
            UIView *child = [subView objectAtIndex:i];
            child.center = CGPointMake(maxW/2, child.center.y);
        }
    }
    if(align==FDLayout_RightOrBottom)    //右对齐
    {
        for(int i=0;i<subView.count;i++)
        {
            UIView *child = [subView objectAtIndex:i];
            child.center = CGPointMake(maxW-child.frame.size.width/2, child.center.y);
        }
    }
    
    
    return mainview;
}

+ (UIView *)gainHorAutoView:(NSArray *)subView viewX:(CGFloat)viewX viewY:(CGFloat)viewY align:(FDLayoutAlign)align
{
    CGFloat maxH = 0;
    UIView *preView = [[UIView alloc] initWithFrame:CGRectZero];
    UIView *mainview = [[UIView alloc] initWithFrame:CGRectZero];
    
    for(int i=0;i<subView.count;i++)
    {
        UIView *sview = [subView objectAtIndex:i];
        
        if([sview isKindOfClass:[UILabel class]])
        {
            UILabel *lab = (UILabel *)sview;
            CGFloat w = lab.frame.size.width;
            [lab sizeToFit];
            //如果是单行的，并且设置宽度比字体宽度小，那么就会通过控制字体大小来适应宽度
            if(lab.numberOfLines==1&&w>10&&w<lab.frame.size.width)
            {
                CGRect iframe = lab.frame;
                iframe.size.width = w;
                lab.frame = iframe;
                lab.adjustsFontSizeToFitWidth = YES;
            }
        }
        CGRect tframe = sview.frame;
        if(tframe.size.height>maxH)
            maxH = tframe.size.height;
        
        tframe.origin.y = 0;
        if(i==0)
            tframe.origin.x = 0;
        if(tframe.size.width<=0)
            tframe.origin.x = 0;
        tframe.origin.x = CGRectGetMaxX(preView.frame)+tframe.origin.x;
        sview.frame = tframe;
        preView = sview;
        
        [mainview addSubview:sview];
    }
    
    mainview.frame = CGRectMake(viewX, viewY, CGRectGetMaxX(preView.frame), maxH);
    if(align==FDLayout_center)    //居中对齐
    {
        for(int i=0;i<subView.count;i++)
        {
            UIView *child = [subView objectAtIndex:i];
            child.center = CGPointMake(child.center.x, maxH/2);
        }
    }
    if(align==FDLayout_RightOrBottom)    //下部对齐
    {
        for(int i=0;i<subView.count;i++)
        {
            UIView *child = [subView objectAtIndex:i];
            child.center = CGPointMake(child.center.x, maxH-child.frame.size.height/2);
        }
    }
    
    
    return mainview;
}

- (UIView *)fitToViewWithChilds:(NSArray *)childs subAlign:(FDLayoutAlign)subAlign isHor:(BOOL)isHor
{
    if(childs.count<=0)
        return nil;
    UIView *firstView = [childs objectAtIndex:0];
    if(![firstView isKindOfClass:[UIView class]])
        return nil;
    
    CGFloat x = firstView.frame.origin.x;
    CGFloat y = firstView.frame.origin.y;
    UIView *subView;
    if(isHor)
    {
        subView = [[self class] gainHorAutoView:childs viewX:firstView.frame.origin.x viewY:firstView.frame.origin.y align:subAlign];
    }
    else
    {
        subView = [[self class] gainVerAutoView:childs viewX:firstView.frame.origin.x viewY:firstView.frame.origin.y align:subAlign];
    }
    
    if(x==0) //横向居中
    {
        CGPoint center = subView.center;
        center.x = self.frame.size.width/2;
        subView.center = center;
    }
    if(y==0) //竖向居中
    {
        CGPoint center = subView.center;
        center.y = self.frame.size.height/2;
        subView.center = center;
    }
    [self addSubview:subView];
    return subView;
}

- (UIView *)fitToRightWithChilds:(NSArray *)childs align:(FDLayoutAlign)align isHor:(BOOL)isHor
{
    if(childs.count<=0)
        return nil;
    UIView *firstView = [childs objectAtIndex:0];
    if(![firstView isKindOfClass:[UIView class]])
        return nil;
    
    CGFloat x = firstView.frame.origin.x;
    CGFloat y = firstView.frame.origin.y;
    UIView *subView;
    if(isHor)
    {
        subView = [[self class] gainHorAutoView:childs viewX:x viewY:y align:align];
    }
    else
    {
        subView = [[self class] gainVerAutoView:childs viewX:x viewY:y align:align];
    }
    
    CGRect iframe = subView.frame;
    iframe.origin.x = self.frame.size.width - x - iframe.size.width;
    subView.frame = iframe;
    
    [self addSubview:subView];
    return subView;
}

@end
