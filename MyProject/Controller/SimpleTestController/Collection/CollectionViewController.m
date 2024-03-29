//
//  CollectionViewController.m
//  SimpleTest
//
//  Created by  Tmac on 2017/6/26.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "CollectionViewController.h"
#import "MyCollectionLayout.h"
#import "MyCollectionView.h"
#import "FdCollectionLayout.h"
#import "CircleCollectionLayout.h"
#import "LiftCollectionLayout.h"
#import "TestCollectionLayout.h"
#import "ThreeDCollectionLayout.h"
#import "MyTestCollectionLayout.h"
#import "FDMBannerFlowLayout.h"

@interface CollectionViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *dataArr;
    CGFloat _startX;
    CGFloat _endX;
    NSInteger num;
}
@property(nonatomic,strong) UICollectionView *collection;
@property(nonatomic) NSInteger currentIndex;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createView
{
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    vv.backgroundColor = [UIColor blueColor];
    [self.view addSubview:vv];
    
//    dataArr = @[@"num1",@"num2",@"num3",@"num4"];
    NSMutableArray *heightArr = [NSMutableArray new];
//    for(int i=0;i<50;i++)
//    {
//        CGFloat hight = arc4random()%150+40;
//        [heightArr addObject:@(hight)];
//    }
    for(int i=0;i<10;i++)
    {
        [heightArr addObject:[NSString stringWithFormat:@"第%d行的信息",i+1]];
    }
    dataArr = [heightArr copy];
    num = 20;
    
//    MyCollectionLayout *layout = [[MyCollectionLayout alloc] init];
//    FdCollectionLayout *layout = [[FdCollectionLayout alloc] init];
//    CircleCollectionLayout *layout = [[CircleCollectionLayout alloc] init];
//    LiftCollectionLayout *layout = [[LiftCollectionLayout alloc] init];
//    TestCollectionLayout *layout = [[TestCollectionLayout alloc] init];
//    layout.dataArr = dataArr;
//    layout.minimumLineSpacing = 10;
//    layout.itemCount = num; 
    //创建一个layout布局类
//    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
//    设置布局方向为横向流布局
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat collectW = self.view.frame.size.width;
    CGFloat collectH = 160;
    CGFloat itemW = 220;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    FDMBannerFlowLayout *layout = [[FDMBannerFlowLayout alloc] initWithSectionInset:sectionInset andMiniLineSapce:10 andMiniInterItemSpace:0 andItemSize:CGSizeMake(itemW, collectH)];
    
    //创建collectionView 通过一个布局策略layout来创建
//    UICollectionView *collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 80, collectW, collectH) collectionViewLayout:layout];
    UICollectionView *collect = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    //代理设置
    collect.delegate = self;
    collect.dataSource = self;
    collect.showsVerticalScrollIndicator = NO;
    collect.showsHorizontalScrollIndicator = NO;
    collect.decelerationRate = UIScrollViewDecelerationRateFast;
//    collect.pagingEnabled = YES;
//    collect.delaysContentTouches = NO;
//    collect.canCancelContentTouches = NO;
//    layout.itemSize = CGSizeMake(collect.frame.size.width-100, collect.frame.size.height);
    //注册item类型 这里使用系统的类型
    [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    
    [self.view addSubview:collect];
    
    [collect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(80);
        make.width.mas_equalTo(collectW);
        make.height.mas_equalTo(collectH);
    }];
    
//    _currentIndex = dataArr.count*500;
    _currentIndex = 0;
    _collection = collect;
//    [collect scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}


//设置每个item的大小，双数的为50*50 单数的为100*100
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
////    if([collectionViewLayout isKindOfClass:[TestCollectionLayout class]])
////    {
////        TestCollectionLayout *layout = (TestCollectionLayout *)collectionViewLayout;
////        float WIDTH = (collectionView.bounds.size.width-layout.sectionInset.left-layout.sectionInset.right-layout.minimumInteritemSpacing)/2;
////        return CGSizeMake(WIDTH, [[dataArr objectAtIndex:indexPath.row] floatValue]);
////    }
////
////    return CGSizeMake(100, 100);
//    return CGSizeMake(135, [[dataArr objectAtIndex:indexPath.row] floatValue]);
//}
//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return dataArr.count*1000;
//    return num;
    return dataArr.count;
}
//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
//    cell.backgroundColor = [UIColor yellowColor];
    NSInteger row = indexPath.row%dataArr.count;
    NSString *str = dataArr[row];
//
    for(UIView *subView in cell.contentView.subviews)
        [subView removeFromSuperview];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, cell.frame.size.width, 30)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = str;
    [cell.contentView addSubview:lab];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@">>>>>>>>>>%zi",indexPath.row);
}

//- (void)fixCellToCenter:(BOOL)decelerate
//{
//    //最小滚动距离
//
//    float dragMiniDistance = 20;
//
//    BOOL toPre = _startX -  _endX >= dragMiniDistance;
//    BOOL toNext = _endX -  _startX >= dragMiniDistance;
//    if (toPre) {
//        _currentIndex--;
//        if(_currentIndex<0){
//            _currentIndex = 0;
//        }
//
//    }else if(toNext){
//        _currentIndex++;
//        if(_currentIndex>=dataArr.count){
//            _currentIndex = dataArr.count-1;
//        }
//    }
//    BOOL animated = decelerate?NO:YES;
//    [_collection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    _startX = scrollView.contentOffset.x;
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
////    if(decelerate){
////        return;
////    }
//    _endX = scrollView.contentOffset.x;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self fixCellToCenter:decelerate];
//    });
//
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    _endX = scrollView.contentOffset.x;
//    dispatch_async(dispatch_get_main_queue(), ^{
////        [self fixCellToCenter];
//    });
//}

@end
