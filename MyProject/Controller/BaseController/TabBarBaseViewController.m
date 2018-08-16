//
//  TabBarBaseViewController.m
//  Mesh Lamp
//

#import "TabBarBaseViewController.h"
#import "SocialViewController.h"
#import "LifeViewController.h"
#import "UserViewController.h"

@interface TabBarBaseViewController ()<UINavigationBarDelegate,UITabBarControllerDelegate>

@end

@implementation TabBarBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self createSystemTabbar];
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
//    [UITabBar appearance].translucent = NO; //取消系统自带的透明度
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = NO;
//}

//自封装方法
-(UINavigationController*)createNavWithViewController:(UIViewController *)viewController WithTitle:(NSString*)title image:(NSString*)imageName selImage:(NSString *)selImageName
{
    //创建tabBar
    [self setTabBarItem:viewController.tabBarItem title:title titleSize:14.0 titleFontName:@"HeiTi SC" selectedImage:selImageName selectedTitleColor:[UIColor greenColor] normalImage:imageName normalTitleColor:[UIColor whiteColor]];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    viewController.title = title;
    nav.navigationBar.tintColor = [UIColor whiteColor];

//    [nav setNavigationBarHidden:YES];
//    nav.navigationBar.backgroundColor = [UIColor clearColor];
    return nav;
}

//返回非导航的VC
-(UIViewController*)createVcWithViewController:(UIViewController *)viewController WithTitle:(NSString*)title image:(NSString*)imageName selImage:(NSString *)selImageName
{
    //创建tabBar
    [self setTabBarItem:viewController.tabBarItem title:title titleSize:14.0 titleFontName:@"HeiTi SC" selectedImage:selImageName selectedTitleColor:[UIColor greenColor] normalImage:imageName normalTitleColor:[UIColor whiteColor]];
    
    viewController.title = title;
    return viewController;
}

//创建系统tabbar
- (void)createSystemTabbar{
    
    self.hidesBottomBarWhenPushed = YES;
    
    SocialViewController *socialVC = [SocialViewController new];
    LifeViewController *lifeVC = [LifeViewController new];
    UserViewController *userVC = [UserViewController new];
    
    self.viewControllers = @[[self createVcWithViewController:socialVC WithTitle:@"社交" image:@"icon_bracelet" selImage:@"icon_bracelet_sel"],
                             [self createVcWithViewController:lifeVC WithTitle:@"生活" image:@"icon_life" selImage:@"icon_life_sel"],
                             [self createVcWithViewController:userVC WithTitle:@"我" image:@"icon_i" selImage:@"icon_i_sel"]];
    self.delegate = self;
    self.selectedIndex = 1;
    //默认选中第一个
    self.title = self.selectedViewController.title;
    
//    self.viewControllers = @[[self createNavWithViewController:socialVC WithTitle:@"社交" image:@"icon_bracelet" selImage:@"icon_bracelet_sel"],
//                             [self createNavWithViewController:lifeVC WithTitle:@"生活" image:@"icon_life" selImage:@"icon_life_sel"],
//                             [self createNavWithViewController:userVC WithTitle:@"我" image:@"icon_i" selImage:@"icon_i_sel"]];
    
//    socialVC.tabBarItem.badgeValue = @"123";
    
    //绘制选中区域的背景图片
//    CGSize indicatorImageSize = CGSizeMake(self.tabBar.bounds.size.width/self.viewControllers.count, Tabbar_Height);
    
//    self.tabBar.selectionIndicatorImage = [self drawTabBarItemBackgroudImageWithSize:indicatorImageSize];
    //顶部的分割线
    CALayer *lineLayer = [CALayer new];
    lineLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    lineLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.tabBar.layer addSublayer:lineLayer];
    
    CGFloat width = SCREEN_WIDTH/self.viewControllers.count;
    for (int i = 1; i<self.viewControllers.count; i++)
    {
        //绘制item的间隔线
        CALayer *lilayer = [CALayer new];
        lilayer.frame = CGRectMake(i*width, 0, 0.5, Tabbar_Height);
        [lilayer setBackgroundColor:[UIColor whiteColor].CGColor];
        [self.tabBar.layer addSublayer:lilayer];
    }
}

- (void)setTabBarItem:(UITabBarItem *)tabbarItem
                title:(NSString *)title
            titleSize:(CGFloat)size
        titleFontName:(NSString *)fontName
        selectedImage:(NSString *)selectedImage
   selectedTitleColor:(UIColor *)selectColor
          normalImage:(NSString *)unselectedImage
     normalTitleColor:(UIColor *)unselectColor
{
    //设置图片
    tabbarItem = [tabbarItem initWithTitle:title image:[[UIImage imageNamed:unselectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    // S未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateNormal];
    
    // 选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateSelected];
}

- (void)setDefintSelelctItem:(NSUInteger)defintSelelctItem
{
    self.selectedIndex = defintSelelctItem;
}


- (UIImage *)drawTabBarItemBackgroudImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 255/255, 255/255, 255/255, 1);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

//UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    self.title = viewController.title;
}
@end
