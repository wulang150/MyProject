//
//  moviePlayerViewController.m
//  MyProject
//
//  Created by Anker on 2019/7/2.
//  Copyright © 2019 Tmac. All rights reserved.
//

#import "moviePlayerViewController.h"

@implementation moviePlayerViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)didMoveToParentViewController:(UIViewController *)parent{
    if(parent==nil){
        self.navigationController.navigationBarHidden = YES;
    }
}
@end
