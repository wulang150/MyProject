//
//  TabBarBaseViewController.h
//  Mesh Lamp
//

#import <UIKit/UIKit.h>

@interface TabBarBaseViewController : UITabBarController
@property (nonatomic)NSUInteger defintSelelctItem;
- (void)createSystemTabbar;

- (void)setTabBarItem:(UITabBarItem *)tabbarItem
                title:(NSString *)title
            titleSize:(CGFloat)size
        titleFontName:(NSString *)fontName
        selectedImage:(NSString *)selectedImage
   selectedTitleColor:(UIColor *)selectColor
          normalImage:(NSString *)unselectedImage
     normalTitleColor:(UIColor *)unselectColor;

@end
