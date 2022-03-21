//
//  OffRenderViewController1.m
//  MyProject
//
//  Created by Anker on 2019/7/29.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "OffRenderViewController1.h"

@interface OffRenderViewController1 ()

@end

@implementation OffRenderViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI{
    [self setNavWithTitle:@"渲染" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    CGFloat width = 180;
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10, NavigationBar_HEIGHT+30, width, 32)];
    lab1.text = @"简单的Layer重合：";
    lab1.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:lab1];
    [self simpleMixLayer:lab1];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab1.frame)+20, width, 32)];
    lab2.text = @"mask：";
    lab2.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:lab2];
    [self simpleMask:lab2];
    
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab2.frame)+20, width, 32)];
    lab3.text = @"UIView的圆角：";
    lab3.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:lab3];
    [self circleView:lab3];
    
    UILabel *lab4 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab3.frame)+20, width, 32)];
    lab4.text = @"UIImageView的圆角：";
    lab4.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:lab4];
    [self imgView:lab4];
    
    UILabel *lab5 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab4.frame)+20, width, 32)];
    lab5.text = @"阴影：";
    lab5.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:lab5];
    [self shadowView:lab5];
    
    UILabel *lab6 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab5.frame)+20, width, 32)];
    lab6.text = @"透明：";
    lab6.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:lab6];
    [self opacityView:lab6];
    
    
    
}

//简单的Layer重合
- (UIView *)simpleMixLayer:(UILabel *)lab{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
    view.backgroundColor = [UIColor redColor];
    
    CALayer *lay = [CALayer new];
    lay.frame = CGRectMake(5, 5, 30, 30);
    lay.backgroundColor = [UIColor blueColor].CGColor;
    [view.layer addSublayer:lay];
    
    view.centerY = lab.centerY;
    view.left = lab.right + 6;
    [self.view addSubview:view];
    return view;
}
//作为mask
- (UIView *)simpleMask:(UILabel *)lab{
    //会产生离屏渲染
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
    view.backgroundColor = [UIColor redColor];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    view2.backgroundColor = [UIColor greenColor];
    //    view2.layer.opacity = 0.4;
    view.layer.mask = view2.layer;
    view.centerY = lab.centerY;
    view.left = lab.right + 6;
    [self.view addSubview:view];
    return view;
}
//圆角
- (UIView *)circleView:(UILabel *)lab{
    //主layer设置了masksToBounds+cornerRadius，并且有subLayer才会产生离屏渲染
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
    view.backgroundColor = [UIColor redColor];
    view.layer.cornerRadius = 20;
    view.layer.masksToBounds = YES;
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    subView.backgroundColor = [UIColor blueColor];
    [view addSubview:subView];
    
    view.centerY = lab.centerY;
    view.left = lab.right + 6;
    [self.view addSubview:view];
    return view;
}
//阴影
- (UIView *)shadowView:(UILabel *)lab{
    //会产生离屏渲染，会占用很多GPU使用率
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
    view.backgroundColor = [UIColor redColor];
    view.layer.shadowOpacity = 0.8;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(4, 4);
    
    //设置 shadowPath ，告诉 Core Animation 投影路径，则不会出现离屏渲染。
//    view.layer.shadowPath = CGPathCreateWithRect(CGRectMake(4, 4, 40, 40), NULL);
    
    view.centerY = lab.centerY;
    view.left = lab.right + 6;
    [self.view addSubview:view];
    return view;
}
//透明度
- (UIView *)opacityView1:(UILabel *)lab{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
    view.backgroundColor = [UIColor redColor];
    
    UIView *opacityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    opacityView.backgroundColor = [UIColor blueColor];
    opacityView.alpha = 0.4;
    [view addSubview:opacityView];
    
    view.centerY = lab.centerY;
    view.left = lab.right + 6;
    [self.view addSubview:view];
    return view;
}
- (UIView *)opacityView:(UILabel *)lab{
    //group opacity，其实从名字就可以猜到，alpha并不是分别应用在每一层之上，而是只有到整个layer树画完之后，再统一加上alpha，最后和底下其他layer的像素进行组合
    //如果开启了 allowsGroupOpacity（默认是开启的），当 layer 的 opacity 小于1.0，且有子 layer 或者背景图，则会触发离屏渲染
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
    view.backgroundColor = [UIColor redColor];
    view.centerY = lab.centerY;
    view.left = lab.right + 6;
    view.alpha = 0.6;
//    view.layer.allowsGroupOpacity = NO;
    
    CALayer *opacityLay = [[CALayer alloc] init];
    opacityLay.frame = CGRectMake(0, 0, 20, 20);
    opacityLay.backgroundColor = [UIColor blueColor].CGColor;
    [view.layer addSublayer:opacityLay];
    
//    UIView *opacityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    opacityView.backgroundColor = [UIColor blueColor];
//    [view addSubview:opacityView];
    
    [self.view addSubview:view];
    return view;
}
//imageView
- (UIImageView *)imgView:(UILabel *)lab{
    //如果是图片被裁减了，也会产生离屏渲染
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
    view.backgroundColor = [UIColor blueColor];
    view.image = [UIImage imageNamed:@"15bab"];
    view.layer.cornerRadius = 8;
    view.layer.masksToBounds = YES;
    view.centerY = lab.centerY;
    view.left = lab.right + 6;
    [self.view addSubview:view];
    return view;
}
//非离屏渲染的ImageView
- (UIImageView *)noRenderImageView{
    //耗CPU，减轻GPU
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
    //    view.backgroundColor = [UIColor greenColor];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [self drawCircleImage:[UIImage imageNamed:@"15bab"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            view.image = image;
        });
    });
    //    view.image = [self drawCircleImage:[UIImage imageNamed:@"15bab"]];
    return view;
}

- (UIImage *)drawCircleImage:(UIImage*)image
{
    CGFloat side = MIN(image.size.width, image.size.height);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(side, side), false, [UIScreen mainScreen].scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, side, side)].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    CGFloat marginX = -(image.size.width - side) * 0.5;
    CGFloat marginY = -(image.size.height - side) * 0.5;
    [image drawInRect:CGRectMake(marginX, marginY, image.size.width, image.size.height)];
    
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
