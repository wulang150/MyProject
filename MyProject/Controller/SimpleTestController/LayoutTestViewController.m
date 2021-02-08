//
//		File Name:		LayoutTestViewController.m
//		Product Name:	MyProject
//		Author:			anker@Tmac
//		Created Date:	2019/12/7 11:14 AM
//		
// * Copyright © 2019 Anker Innovations Technology Limited All Rights Reserved.
// * The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
//		All rights reserved.
//'--------------------------------------------------------------------'
	

#import "LayoutTestViewController.h"

@interface LayoutTestViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataArr;
}
@property(nonatomic) UITableView *tableView;
@end

@implementation LayoutTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI{
//    self.title = @"AutoLayout";
    [self setNavWithTitle:@"Layout" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self testLayout1];
//    [self testLayout3];
//    [self testAutomaticDimension];
//    [self testSpacingHorizontally2];
    [self testStackView5];
}
//间距已知，通过调整item的width来适应分布
- (void)testSpacingHorizontally1{
    UIView *mainView = [[UIView alloc] init];
    mainView.layer.borderWidth = 1;
    [self.view addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.mas_equalTo(120);
        make.height.mas_equalTo(100);
    }];
    UIView *item1 = [[UIView alloc] init];
    item1.backgroundColor = [UIColor redColor];
    
    UIView *item2 = [[UIView alloc] init];
    item2.backgroundColor = [UIColor yellowColor];
    
    UIView *item3 = [[UIView alloc] init];
    item3.backgroundColor = [UIColor greenColor];
    [mainView addSubview:item1];
    [mainView addSubview:item2];
    [mainView addSubview:item3];
    
    NSArray *tolAry = [mainView.subviews copy];
    [tolAry mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:8 leadSpacing:8 tailSpacing:8];
    [tolAry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(80);
    }];
}
//item大小知道，自动调整横向间距，使得横向item等间距分布
- (void)testSpacingHorizontally2{
    UIView *mainView = [[UIView alloc] init];
    mainView.layer.borderWidth = 1;
    [self.view addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.mas_equalTo(120);
        make.height.mas_equalTo(100);
    }];
    UIView *item1 = [[UIView alloc] init];
    item1.backgroundColor = [UIColor redColor];
    
    UIView *item2 = [[UIView alloc] init];
    item2.backgroundColor = [UIColor yellowColor];
    
    UIView *item3 = [[UIView alloc] init];
    item3.backgroundColor = [UIColor greenColor];
    [mainView addSubview:item1];
    [mainView addSubview:item2];
    [mainView addSubview:item3];
    
    NSArray *tolAry = [mainView.subviews copy];
    [tolAry mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:80 leadSpacing:10 tailSpacing:10];
    [tolAry mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(80);
    }];
}
//（item大小知道，自动调整横向间距，使得横向item等间距分布）与2不同的是，这里的横向间距包括左右两边的
- (void)testSpacingHorizontally3{
    //先定义一个mainView，装着每一个item，item有大小和Y向布局。X轴的布局通过传入distributeSpacingHorizontallyWith来得到，实现等间距
    UIView *mainView = [[UIView alloc] init];
    mainView.layer.borderWidth = 1;
    [self.view addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.mas_equalTo(120);
        make.height.mas_equalTo(100);
    }];
    
    UIView *item1 = [[UIView alloc] init];
    item1.backgroundColor = [UIColor redColor];
    
    UIView *item2 = [[UIView alloc] init];
    item2.backgroundColor = [UIColor yellowColor];
    
    UIView *item3 = [[UIView alloc] init];
    item3.backgroundColor = [UIColor greenColor];
    
    UIView *item4 = [[UIView alloc] init];
    item4.backgroundColor = [UIColor blueColor];
    
    [mainView addSubview:item1];
    [mainView addSubview:item2];
    [mainView addSubview:item3];
    [mainView addSubview:item4];
    
    [item1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerY.equalTo(@[item2,item3,item4]);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [item2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    [item3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    [item4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self distributeSpacingHorizontallyWith:mainView.subviews supView:mainView];
    
}
- (void)distributeSpacingHorizontallyWith:(NSArray*)views supView:(UIView *)supView
{
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
    
    for ( int i = 0 ; i < views.count+1 ; ++i )
    {
        UIView *v = [UIView new];
        [spaces addObject:v];
        [supView addSubview:v];
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(v.mas_height);
        }];
    }
    
    UIView *v0 = spaces[0];
    
    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(supView.mas_left);
        make.centerY.equalTo(((UIView*)views[0]).mas_centerY);
    }];
    
    UIView *lastSpace = v0;
    for ( int i = 0 ; i < views.count; ++i )
    {
        UIView *obj = views[i];
        UIView *space = spaces[i+1];
        
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastSpace.mas_right);
        }];
        
        [space mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(obj.mas_right);
            make.centerY.equalTo(obj.mas_centerY);
            make.width.equalTo(v0);
        }];
        
        lastSpace = space;
    }
    
    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(supView.mas_right);
    }];
    
}

//UIStackView的使用
//UIStackViewDistributionFillEqually 平均分配填满横向，如果有spacing，就加上间隔spacing。所以这个item宽度是有UIStackView控制，不需自己设置，设置了也无效
//UIStackView还有个好处，当item高度不等时候，是以最高的作为自己的高度
- (void)testStackView1{
    UIStackView *mainView = [[UIStackView alloc] init];
    mainView.axis = UILayoutConstraintAxisHorizontal;
    mainView.alignment = UIStackViewAlignmentCenter;
    mainView.distribution = UIStackViewDistributionFillEqually;
    mainView.spacing = 10;
    [self.view addSubview:mainView];
    UIView *item1 = [[UIView alloc] init];
    item1.backgroundColor = [UIColor redColor];
    
    UIView *item2 = [[UIView alloc] init];
    item2.backgroundColor = [UIColor yellowColor];
    
    UIView *item3 = [[UIView alloc] init];
    item3.backgroundColor = [UIColor greenColor];
    [mainView addArrangedSubview:item1];
    [mainView addArrangedSubview:item2];
    [mainView addArrangedSubview:item3];
    
    [item1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.height.mas_equalTo(40);
    }];
    [item2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(90, 90));
        make.height.mas_equalTo(90);
    }];
    [item3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.height.mas_equalTo(80);
    }];
    
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.mas_equalTo(120);
    }];
}
//UIStackViewDistributionEqualSpacing，等间距分配，这个就得设置width了
- (void)testStackView2{
    UIStackView *mainView = [[UIStackView alloc] init];
    mainView.axis = UILayoutConstraintAxisHorizontal;
    mainView.alignment = UIStackViewAlignmentCenter;
    mainView.distribution = UIStackViewDistributionEqualSpacing;
    mainView.spacing = 10; //至少
    [self.view addSubview:mainView];
    UIView *item1 = [[UIView alloc] init];
    item1.backgroundColor = [UIColor redColor];
    
    UIView *item2 = [[UIView alloc] init];
    item2.backgroundColor = [UIColor yellowColor];
    
    UIView *item3 = [[UIView alloc] init];
    item3.backgroundColor = [UIColor greenColor];
    [mainView addArrangedSubview:item1];
    [mainView addArrangedSubview:item2];
    [mainView addArrangedSubview:item3];
    
    [item1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [item2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    [item3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.mas_equalTo(120);
    }];
}
//UIStackViewDistributionFill，拉伸或压缩其中一个进行填满
- (void)testStackView3{
    UIStackView *mainView = [[UIStackView alloc] init];
    mainView.axis = UILayoutConstraintAxisHorizontal;
    mainView.alignment = UIStackViewAlignmentCenter;
    mainView.distribution = UIStackViewDistributionFill;
    mainView.spacing = 10;
    [self.view addSubview:mainView];
    UIView *item1 = [[UIView alloc] init];
    item1.backgroundColor = [UIColor redColor];
    
    UIView *item2 = [[UIView alloc] init];
    item2.backgroundColor = [UIColor yellowColor];
    
    UIView *item3 = [[UIView alloc] init];
    item3.backgroundColor = [UIColor greenColor];
    [mainView addArrangedSubview:item1];
    [mainView addArrangedSubview:item2];
    
    [item1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [item2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
//    [item3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(80, 80));
//    }];
    
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.mas_equalTo(120);
    }];
    
}
//UIStackViewDistributionFillProportionally 拉伸或压缩其中一个进行填满
- (void)testStackView4{
    UIStackView *mainView = [[UIStackView alloc] init];
    mainView.axis = UILayoutConstraintAxisHorizontal;
    mainView.alignment = UIStackViewAlignmentCenter;
    mainView.distribution = UIStackViewDistributionFillProportionally;
//    mainView.spacing = 10;
    [self.view addSubview:mainView];
    UIView *item1 = [[UIView alloc] init];
    item1.backgroundColor = [UIColor redColor];
    
    UIView *item2 = [[UIView alloc] init];
    item2.backgroundColor = [UIColor yellowColor];
    
    UIView *item3 = [[UIView alloc] init];
    item3.backgroundColor = [UIColor greenColor];
    [mainView addArrangedSubview:item1];
    [mainView addArrangedSubview:item2];
//    [mainView addArrangedSubview:item3];
    
    [item1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 40));
    }];
    [item2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 90));
    }];
//    [item3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(80, 80));
//    }];
    
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.mas_equalTo(120);
    }];
    
}
//UIStackViewDistributionEqualCentering
- (void)testStackView5{
    UIStackView *mainView = [[UIStackView alloc] init];
    mainView.axis = UILayoutConstraintAxisHorizontal;
    mainView.alignment = UIStackViewAlignmentCenter;
    mainView.distribution = UIStackViewDistributionEqualCentering;
    //    mainView.spacing = 10;
    [self.view addSubview:mainView];
    UIView *item1 = [[UIView alloc] init];
    item1.backgroundColor = [UIColor redColor];
    
    UIView *item2 = [[UIView alloc] init];
    item2.backgroundColor = [UIColor yellowColor];
    
    UIView *item3 = [[UIView alloc] init];
    item3.backgroundColor = [UIColor greenColor];
    UIView *item4 = [[UIView alloc] init];
    item4.backgroundColor = [UIColor blackColor];
    [mainView addArrangedSubview:item1];
    [mainView addArrangedSubview:item2];
    [mainView addArrangedSubview:item3];
    [mainView addArrangedSubview:item4];
    
    [item1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [item2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    [item3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [item4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.mas_equalTo(120);
    }];
    
}
//抗压缩
- (void)testLayout1{
    UILabel *leftLab = [[UILabel alloc] init];
    leftLab.text = @"sssssssssssssssssssssssssssss";
    [self.view addSubview:leftLab];
    
    UILabel *rightLab = [[UILabel alloc] init];
    rightLab.text = @"rrrrrrrrrrrrrrrr";
    [self.view addSubview:rightLab];
    
    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.leading.mas_equalTo(20);
    }];
    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftLab);
        make.trailing.mas_equalTo(-20);
        make.leading.equalTo(leftLab.mas_trailing).offset(12);
    }];
    
    //让left不压缩，就把它的抗压缩增大，默认是750，只要大于750就比右边的大了
    [leftLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}
//抗拉伸
- (void)testLayout2{
    UILabel *leftLab = [[UILabel alloc] init];
    leftLab.text = @"ssssss";
    leftLab.layer.borderWidth = 1;
    [self.view addSubview:leftLab];
    
    UILabel *rightLab = [[UILabel alloc] init];
    rightLab.text = @"rrrrrr";
    rightLab.layer.borderWidth = 1;
    [self.view addSubview:rightLab];
    
    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.leading.mas_equalTo(20);
    }];
    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftLab);
        make.trailing.mas_equalTo(-20);
        make.leading.equalTo(leftLab.mas_trailing).offset(12);
    }];
    //让右边不拉伸 默认为250
    [rightLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
}

- (void)testLayout3{
    //达到效果，属性一张图片（可等比缩放），titleLab（多行），subTitle。竖向排列，当竖向需要压缩的时候，只等比压缩图片
    CGFloat imgW = 200, imgH = 400;
    CGFloat scale = imgW/imgH;
    UIImageView *topImgV = [[UIImageView alloc] init];
    topImgV.backgroundColor = [UIColor redColor];
    [self.view addSubview:topImgV];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss";
    titleLab.numberOfLines = 0;
    [self.view addSubview:titleLab];
    
    UILabel *subTitleLab = [[UILabel alloc] init];
    subTitleLab.text = @"rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr";
    subTitleLab.numberOfLines = 0;
    [self.view addSubview:subTitleLab];
    
    [topImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(200);
        make.centerX.mas_equalTo(0);
        make.height.mas_lessThanOrEqualTo(imgH);
        make.width.equalTo(topImgV.mas_height).multipliedBy(scale);
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgV.mas_bottom).offset(12);
        make.leading.mas_equalTo(30);
        make.trailing.mas_equalTo(-30);
    }];
    
    [subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-100);
        make.leading.trailing.equalTo(titleLab);
        make.top.greaterThanOrEqualTo(titleLab.mas_bottom).offset(12);
    }];
    
    //控制需要压缩时候，先等比压缩图片
    [topImgV setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
}

- (void)testAutomaticDimension{
    _dataArr = @[@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                @"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.leading.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 100;  //ios11以下得写这个
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //自动计算高度，cell得结合自动布局
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UIView *headView = [[UIView alloc] init];
        headView.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:headView];
        
        UIView *contentView1 = [[UIView alloc] init];
        contentView1.layer.borderWidth = 1;
        contentView1.tag = 10;
        [cell.contentView addSubview:contentView1];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.layer.borderWidth = 1;
        titleLab.tag = 100;
        titleLab.numberOfLines = 0;
        [contentView1 addSubview:titleLab];
        
        UIView *contentView2 = [[UIView alloc] init];
//        contentView2.layer.borderWidth = 1;
        contentView2.tag = 11;
        [cell.contentView addSubview:contentView2];
        
        UILabel *titleLab1 = [[UILabel alloc] init];
        titleLab1.layer.borderWidth = 1;
        titleLab1.tag = 100;
        titleLab1.numberOfLines = 0;
        [contentView2 addSubview:titleLab1];
        
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(60);
            make.top.mas_equalTo(4);
            make.leading.mas_equalTo(8);
        }];
        
        [contentView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headView.mas_bottom).offset(4);
            make.leading.equalTo(headView);
            make.trailing.mas_equalTo(-12);
//            make.bottom.mas_equalTo(-8);
        }];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        [contentView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView1.mas_bottom).offset(4);
            make.leading.equalTo(headView);
            make.trailing.mas_equalTo(-12);
            make.bottom.mas_equalTo(-8);
        }];
        [titleLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
//        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(headView.mas_bottom).offset(4);
//            make.leading.equalTo(headView);
//            make.trailing.mas_equalTo(-12);
//            make.bottom.mas_equalTo(-8);
//        }];
    }
    UIView *mainView = [cell.contentView viewWithTag:10];
    UILabel *titleLab = [mainView viewWithTag:100];
    titleLab.text = _dataArr[indexPath.row];
    
    UIView *mainView1 = [cell.contentView viewWithTag:11];
    titleLab = [mainView1 viewWithTag:100];
    titleLab.text = _dataArr[indexPath.row];
    return cell;
}
@end
