//
//  CAImageTestViewController.m
//  MyProject
//
//  Created by Anker on 2019/3/5.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "CAImageTestViewController.h"

@interface CAImageTestViewController ()
{
    
}
@property(nonatomic) UIScrollView *scrollView;
@end

@implementation CAImageTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI{
    [self setNavWithTitle:@"加载大图" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT, SCREEN_WIDTH, SCREEN_CTM_HEIGHT)];
    [self.view addSubview:_scrollView];
    
//    UIImageView *bigImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 3024, 4032)];
//    bigImgV.image = [UIImage imageNamed:@"IMG_0997.JPG"];
//    [_scrollView addSubview:bigImgV];
//
//    _scrollView.contentSize = bigImgV.size;
    UIImage *image = [UIImage imageNamed:@"test2.jpg"];
    CALayer *imgLayer = [CALayer new];
    imgLayer.frame = CGRectMake(100, 300, 240, 160);
    imgLayer.contents = (__bridge id)image.CGImage;
    imgLayer.contentsGravity = kCAGravityResizeAspect;
    imgLayer.backgroundColor = [UIColor yellowColor].CGColor;
//    imgLayer.contentsScale = image.scale;       //属性定义了寄宿图的像素尺寸和视图大小的比例
//    imgLayer.contentsScale = [UIScreen mainScreen].scale;
    imgLayer.contentsCenter = CGRectMake(0.25, 0.25, 0.5, 0.5);
    [self.view.layer addSublayer:imgLayer];
}

@end
