//
//  UIView+LayoutMethods.h
//  UIViewDemo
//
//  Created by lianxingbo on 15/6/8.
//  Copyright (c) 2015年 daboge. All rights reserved.
//


#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SCREEN_WITHOUT_STATUS_HEIGHT (SCREEN_HEIGHT - [[UIApplication sharedApplication] statusBarFrame].size.height)

typedef CGFloat UIScreenType;

static UIScreenType UIScreenType_iPhone5 = 320.0f;
static UIScreenType UIScreenType_iPhone6 = 375.0f;
static UIScreenType UIScreenType_iPhone6P = 414.0f;

typedef NS_ENUM(NSUInteger, FDLayoutAlign) {
    Align_LeftOrTop = 0,
    Align_center,
    Align_RightOrBottom,
};

@interface UIView (LayoutMethods)

// coordinator getters
- (CGFloat)height;
- (CGFloat)width;
- (CGFloat)x;
- (CGFloat)y;
- (CGSize)size;
- (CGPoint)origin;
- (CGFloat)centerX;
- (CGFloat)centerY;

- (CGFloat)left;
- (CGFloat)top;
- (CGFloat)bottom;
- (CGFloat)right;

// size
- (void)setSize:(CGSize)size;
- (void)sizeEqualToView:(UIView *)view;

- (void)setX:(CGFloat)x;
- (void)setLeft:(CGFloat)left;
- (void)setY:(CGFloat)y;
- (void)setTop:(CGFloat)top;

// height
- (void)setHeight:(CGFloat)height;
- (void)heightEqualToView:(UIView *)view;

// width
- (void)setWidth:(CGFloat)width;
- (void)widthEqualToView:(UIView *)view;

// center
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;
- (void)centerXEqualToView:(UIView *)view;
- (void)centerYEqualToView:(UIView *)view;

// top, bottom, left, right
- (void)topEqualToView:(UIView *)view;
- (void)bottomEqualToView:(UIView *)view;
- (void)leftEqualToView:(UIView *)view;
- (void)rightEqualToView:(UIView *)view;

- (void)top:(CGFloat)top FromView:(UIView *)view;
- (void)bottom:(CGFloat)bottom FromView:(UIView *)view;
- (void)left:(CGFloat)left FromView:(UIView *)view;
- (void)right:(CGFloat)right FromView:(UIView *)view;

- (void)topRatio:(CGFloat)top FromView:(UIView *)view screenType:(UIScreenType)screenType;
- (void)bottomRatio:(CGFloat)bottom FromView:(UIView *)view screenType:(UIScreenType)screenType;
- (void)leftRatio:(CGFloat)left FromView:(UIView *)view screenType:(UIScreenType)screenType;
- (void)rightRatio:(CGFloat)right FromView:(UIView *)view screenType:(UIScreenType)screenType;

- (void)topInContainer:(CGFloat)top shouldResize:(BOOL)shouldResize;
- (void)bottomInContainer:(CGFloat)bottom shouldResize:(BOOL)shouldResize;
- (void)leftInContainer:(CGFloat)left shouldResize:(BOOL)shouldResize;
- (void)rightInContainer:(CGFloat)right shouldResize:(BOOL)shouldResize;

- (void)topRatioInContainer:(CGFloat)top shouldResize:(BOOL)shouldResize screenType:(UIScreenType)screenType;
- (void)bottomRatioInContainer:(CGFloat)bottom shouldResize:(BOOL)shouldResize screenType:(UIScreenType)screenType;
- (void)leftRatioInContainer:(CGFloat)left shouldResize:(BOOL)shouldResize screenType:(UIScreenType)screenType;
- (void)rightRatioInContainer:(CGFloat)right shouldResize:(BOOL)shouldResize screenType:(UIScreenType)screenType;

// imbueset fill
- (void)fillWidth;
- (void)fillHeight;
- (void)fill;

//topSupreView
- (UIView *)topSuperView;

//对于布局的调整
//竖向自动布局view， align 0：左对齐 1：居中 2：右对齐
+ (UIView *)gainVerAutoView:(NSArray *)subView viewX:(CGFloat)viewX viewY:(CGFloat)viewY align:(FDLayoutAlign)align;
//横向自动布局view， align 0：上部对齐 1：居中 2：下部对齐
+ (UIView *)gainHorAutoView:(NSArray *)subView viewX:(CGFloat)viewX viewY:(CGFloat)viewY align:(FDLayoutAlign)align;

/*调整自动view到父类，
 看第一个子类View的x和y来控制内部view在父类的位置(如果x==0横向居中，y==0竖向居中)
 后面两个参数控制子类的对齐方式
 isHor：YES横向(内部view的align 0：上部对齐 1：居中 2：下部对齐)  NO竖向(align 0：左对齐 1：居中 2：右对齐)
 */
- (UIView *)fitToViewWithChilds:(NSArray *)childs subAlign:(FDLayoutAlign)subAlign isHor:(BOOL)isHor;

//距离右边距的控件布局，距离右边的有时候不好控制
//看第一个子类View的x和y来控制内部view在父类的位置，（注意）其中的x的相对父类右边距的距离，其他都正常左对齐的思路，只是排序变成了从右向左
- (UIView *)fitToRightWithChilds:(NSArray *)childs align:(FDLayoutAlign)align isHor:(BOOL)isHor;

@end

@protocol LayoutProtocol
@required
// put your layout code here
- (void)calculateLayout;
@end
