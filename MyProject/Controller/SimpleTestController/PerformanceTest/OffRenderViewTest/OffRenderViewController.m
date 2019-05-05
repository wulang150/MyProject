//
//  OffRenderViewController.m
//  MyProject
//
//  Created by Anker on 2019/1/5.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "OffRenderViewController.h"
#import "YYFPSLabel.h"

@interface OffRenderViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property(nonatomic) UITableView *tableView;
@end

@implementation OffRenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI{
    
    [self setNavWithTitle:@"渲染" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    [self.view addSubview:self.tableView];
    
    //加入fps测试工具
    YYFPSLabel *FpsLab = [[YYFPSLabel alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT-60, 0, 0)];
    [self.view addSubview:FpsLab];
}

//简单的View重合
- (UIView *)simpleMix{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
    view.backgroundColor = [UIColor redColor];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    view2.backgroundColor = [UIColor greenColor];
    [view addSubview:view2];
//    [view.layer addSublayer:view2.layer];
    return view;
}
//简单的Layer重合
- (UIView *)simpleMixLayer{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
    view.backgroundColor = [UIColor redColor];
    
    CALayer *lay = [CALayer new];
    lay.frame = CGRectMake(5, 5, 30, 30);
    lay.backgroundColor = [UIColor greenColor].CGColor;
    [view.layer addSublayer:lay];
    return view;
}
//作为mask
- (UIView *)simpleMask{
    //会产生离屏渲染
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
    view.backgroundColor = [UIColor redColor];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    view2.backgroundColor = [UIColor greenColor];
    //    view2.layer.opacity = 0.4;
    view.layer.mask = view2.layer;
    return view;
}
//圆角
- (UIView *)circleView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
    view.backgroundColor = [UIColor redColor];
    view.layer.cornerRadius = 20;
    view.layer.masksToBounds = YES;
    return view;
}
//阴影
- (UIView *)shadowView{
    //会产生离屏渲染，会占用很多GPU使用率
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
    view.backgroundColor = [UIColor redColor];
    view.layer.shadowOpacity = 0.8;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(4, 4);
    return view;
}
//透明度
- (UIView *)opacityView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
    view.backgroundColor = [UIColor redColor];
    view.layer.opacity = 0.4;
    return view;
}
//imageView
- (UIImageView *)imgView{
    //如果是图片被裁减了，也会产生离屏渲染
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
    view.backgroundColor = [UIColor redColor];
    view.image = [UIImage imageNamed:@"15bab"];
    view.layer.cornerRadius = 8;
    view.layer.masksToBounds = YES;
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
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_CTM_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10000;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
        UIView *preView;
        //layer重合
        UIView *layMixView = [self simpleMixLayer];
        preView = layMixView;
        [cell.contentView addSubview:preView];
        //mask
        UIView *maskView = [self simpleMask];
        maskView.left = preView.right + 8;
        preView = maskView;
        [cell.contentView addSubview:preView];
        //圆角view
        UIView *circleView = [self circleView];
        circleView.left = preView.right + 8;
        preView = circleView;
        [cell.contentView addSubview:preView];
        //阴影
        UIView *shadowView = [self shadowView];
        shadowView.left = preView.right + 8;
        preView = shadowView;
        [cell.contentView addSubview:preView];
//        preView.layer.shouldRasterize = YES;
//        preView.layer.shadowPath = [UIBezierPath bezierPathWithRect:preView.bounds].CGPath;
        //透明度
        UIView *opacityView = [self opacityView];
        opacityView.left = preView.right + 8;
        preView = opacityView;
        [cell.contentView addSubview:preView];
        //圆角图片
        UIImageView *imgView = [self imgView];
        imgView.left = preView.right + 8;
        preView = imgView;
        [cell.contentView addSubview:preView];
        
    }
    
    //普通圆角
//    UIView *maskView = [self circleView];
//    [cell.contentView addSubview:maskView];
//    for(int i=0;i<6;i++){
//        UIView *currentView = [self circleView];
//        currentView.left = maskView.right+8;
//        maskView = currentView;
//
//        [cell.contentView addSubview:currentView];
//    }
    
    //图片圆角 17%--18%
//    UIView *maskView = [self imgView];
//    [cell.contentView addSubview:maskView];
//    for(int i=0;i<6;i++){
//        UIView *currentView = [self imgView];
//        currentView.left = maskView.right+8;
//        maskView = currentView;
//
//        [cell.contentView addSubview:currentView];
//    }
    //自绘图片圆角
//    UIView *maskView = [self noRenderImageView];
//    [cell.contentView addSubview:maskView];
//    for(int i=0;i<6;i++){
//        UIView *currentView = [self noRenderImageView];
//        currentView.left = maskView.right+8;
//        maskView = currentView;
//
//        [cell.contentView addSubview:currentView];
//    }

    
    //阴影的 86%
//    UIView *maskView = [self shadowView];
//    [cell.contentView addSubview:maskView];
//    for(int i=0;i<6;i++){
//        UIView *currentView = [self shadowView];
//        currentView.left = maskView.right+8;
//        maskView = currentView;
//
//        [cell.contentView addSubview:currentView];
//    }
    
    //作为mask 80%以上
//    UIView *maskView = [self simpleMask];
//    [cell.contentView addSubview:maskView];
//    for(int i=0;i<6;i++){
//        UIView *currentView = [self simpleMask];
//        currentView.left = maskView.right+8;
//        maskView = currentView;
//
//        [cell.contentView addSubview:currentView];
//    }
    
    return cell;
}
@end
