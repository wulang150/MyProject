//
//  SearchResultController.h
//  MyProject
//
//  Created by  Tmac on 2018/8/3.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultController : UIViewController<UISearchResultsUpdating,UISearchBarDelegate>

@property (nonatomic, strong) NSArray *datas;
@end
