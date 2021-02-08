//
//		File Name:		IDCPlayItemSelectView.m
//		Product Name:	BatteryCam
//		Author:			anker@oceanwing
//		Created Date:	2019/12/23 4:09 PM
//		
// * Copyright © 2019 Anker Innovations Technology Limited All Rights Reserved.
// * The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
//		All rights reserved.
//'--------------------------------------------------------------------'
	

#import "IDCPlayItemSelectView.h"
#import "MyCollectionLayout.h"

@interface IDCPlayItemSelectView()
<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger _willDisplayIndex;
    NSInteger _currentIndex;
    NSArray *_titleArr;
}
@property(nonatomic) UICollectionView *collectionView;
@end

@implementation IDCPlayItemSelectView

- (instancetype)init{
    if(self = [super init]){
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
//    _titleArr = @[@"",@"PLAYBACK",@"LIVE",@"",@"",@"",@""];
    _titleArr = @[@"PLAYBACK",@"LIVE"];
    [self addSubview:self.collectionView];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
//    }];
    
    [self performSelector:@selector(setDefaultState) withObject:nil afterDelay:0.5];
}

- (void)setDefaultState{
    //默认滑动到的位置
    _currentIndex = 1;
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

- (void)changeCellStyle{
    //改变前一个颜色
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    UILabel *titleLab = [cell.contentView viewWithTag:100];
    [self norItem:titleLab];
    CGFloat itemW = self.collectionView.bounds.size.width/3;
    CGFloat x = self.collectionView.contentOffset.x;
    //根据移动的位置，决定当前居中显示的index
    NSLog(@"changeCellStyle>>>>>>>>>>>>%.1f",x);
    if(x<=0){
        _currentIndex = 1;
    }
    if(x>=itemW&&x<itemW*2){
        _currentIndex = 2;
    }
   //改变现在的颜色
    [self doCallBack];
}

- (void)doCallBack{

    IDCPlayItemTyle type = IDCPlayItemTyle_None;
    if(_currentIndex==1){
        type = IDCPlayItemTyle_PlayBack;
    }
    if(_currentIndex==2){
        type = IDCPlayItemTyle_Live;
    }
    //改变新cell的样式
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    UILabel *titleLab = [cell.contentView viewWithTag:100];
    [self selItem:titleLab];
    if([self.delegate respondsToSelector:@selector(IDCPlayItemSelectView:didSelectedItem:)]){
        [self.delegate IDCPlayItemSelectView:self didSelectedItem:type];
    }
}

- (void)norItem:(UILabel *)titleLab{
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.textColor = [UIColor lightGrayColor];
}

- (void)selItem:(UILabel *)titleLab{
    titleLab.font = [UIFont boldSystemFontOfSize:16];
    titleLab.textColor = [UIColor blackColor];
}

#pragma -mark UICollectionViewDelegate
//设置每个item的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(collectionView.bounds.size.width/3, collectionView.bounds.size.height);

}
//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _titleArr.count;
}
//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    UILabel *titleLab = [cell.contentView viewWithTag:100];
    if(!titleLab){
        titleLab = [[UILabel alloc] init];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.tag = 100;
        [cell.contentView addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(4);
            make.trailing.mas_equalTo(-4);
            make.height.equalTo(cell.contentView);
        }];
        titleLab.layer.borderColor = [UIColor blackColor].CGColor;
        titleLab.layer.borderWidth = 1;
        
        [self norItem:titleLab];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
//    for(UIView *view in cell.contentView.subviews)
//        [view removeFromSuperview];
    UILabel *titleLab = [cell.contentView viewWithTag:100];
    titleLab.text = [_titleArr objectAtIndex:indexPath.row];
    _willDisplayIndex = indexPath.row;

}
//
////滑动后，不显示的的cell，返回的是不显示的indexPath
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
//    if(_willDisplayIndex!=indexPath.row)
//    {
//        //滑动成功
//        _currentIndex = _willDisplayIndex;
//    }
//    UILabel *titleLab = [cell.contentView viewWithTag:100];
//    [self norItem:titleLab];
//    [self doCallBack];
    
    [self changeCellStyle];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    if(indexPath.row==1||indexPath.row==2){
//        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
//    }
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidScroll>>>>>>>%.1f",scrollView.contentOffset.x);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(decelerate){
        return;
    }
    NSLog(@"scrollViewDidEndDragging>>>>>>>%.1f   %.1f",scrollView.contentOffset.x,self.collectionView.bounds.size.width/3);
    [self changeCellStyle];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndDecelerating>>>>>>>%.1f  %.1f",scrollView.contentOffset.x,self.collectionView.bounds.size.width/3);
    [self changeCellStyle];
}

#pragma -mark getting
- (UICollectionView *)collectionView{
    if(!_collectionView){
        //创建一个layout布局类
//        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
//        //设置布局方向布局
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        layout.minimumLineSpacing = 0;
        MyCollectionLayout *layout = [[MyCollectionLayout alloc] init];
        layout.itemSize = CGSizeMake(self.width/3, self.height);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:layout];
//        _collectionView.collectionViewLayout = layout;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
//        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;       //取消边际出滑动出现空白的情况
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
        
//        CGFloat inset = (self.collectionView.frame.size.width - layout.itemSize.width) * 0.5;
//        CGFloat yinset = (self.collectionView.frame.size.height - layout.itemSize.height) * 0.5;
//        // 设置第一个和最后一个默认居中显示
//        //    self.collectionView.contentInset = UIEdgeInsetsMake(yinset, inset, yinset, inset);
//        layout.sectionInset = UIEdgeInsetsMake(yinset, inset, yinset, inset);
        
    }
    return _collectionView;
}
@end
